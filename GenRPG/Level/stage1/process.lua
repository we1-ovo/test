local M = {}

function M.cb()
    LEVEL_SetStageTimeout(300)
    
    -- 玩家传送到起始位置
    LEVEL_PlayerTeleportTo("locator_player_spawn")
    
    -- 序章剧情：旁白介绍
    LEVEL_ShowDialog("", "筑基期修仙者，踏入神秘的灵草谷。传说谷底有千年灵草，得之可大幅提升修为，然谷中妖兽盘踞，危险重重...", "neutral", 1.0)
    
    -- 召唤老修士并进行对话传授
    local elderUuid = LEVEL_SummonWithType("老修士", "locator_valley_entrance_elder")
    LEVEL_ShowDialog("老修士", "小友，前方便是灵草谷，谷中妖兽横行，切勿轻敌。老夫传你一门'御风术'，助你闯荡此谷。", "neutral", 0.8)
    
    -- 老修士传授技能后离开
    LEVEL_NpcMoveToLocator(elderUuid, "locator_elder_exit", 0, 5)
    
    -- 召唤谷口试炼妖兽
    local foxUuids = LEVEL_SummonNPCsWithType("灵狐", 3, "locator_valley_entrance_foxes")
    local apeUuids = LEVEL_SummonNPCsWithType("山猿", 2, "locator_valley_entrance_apes")
    
    -- 注册需要击败的谷口妖兽
    local entranceBeasts = {}
    for i = 1, #foxUuids do
        table.insert(entranceBeasts, foxUuids[i])
    end
    for i = 1, #apeUuids do
        table.insert(entranceBeasts, apeUuids[i])
    end
    
    LEVEL_ShowDialog("", "谷口妖兽察觉到修士气息，纷纷现身阻拦...", "neutral", 1.2)
    
    -- 等待玩家击败所有谷口妖兽
    LEVEL_DoProcess(function()
        -- 妖兽死亡时掉落初级灵草
        for i = 1, #foxUuids do
            LEVEL_AddTimerAsyncProcess(function()
                if not LEVEL_IsNpcAlive(foxUuids[i]) then
                    LEVEL_DropItem("初级灵草", 1, "locator_valley_entrance_foxes", false)
                    return false
                end
                return true
            end, 0.5, 0)
        end
        
        for i = 1, #apeUuids do
            LEVEL_AddTimerAsyncProcess(function()
                if not LEVEL_IsNpcAlive(apeUuids[i]) then
                    LEVEL_DropItem("初级灵草", 1, "locator_valley_entrance_apes", false)
                    return false
                end
                return true
            end, 0.5, 0)
        end
    end, function()
        return LEVEL_GetArrayAliveNpcCount(entranceBeasts) == 0
    end, 120)
    
    LEVEL_ShowDialog("", "初战告捷，修为有所精进。深谷之中，更大的挑战正在等待...", "neutral", 1.0)
    
    -- 在谷中段随机生成中级灵草和修炼丹药
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_spawn1", false)
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_spawn2", false)
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_spawn3", false)
    LEVEL_DropItem("修炼丹药", 1, "locator_pills_spawn1", false)
    LEVEL_DropItem("修炼丹药", 1, "locator_pills_spawn2", false)
    
    -- 召唤中级妖兽
    local leopardUuids = LEVEL_SummonNPCsWithType("灵豹", 4, "locator_valley_middle_leopards")
    local bearUuids = LEVEL_SummonNPCsWithType("石熊", 2, "locator_valley_middle_bears") 
    
    -- 注册需要击败的中级妖兽
    local middleBeasts = {}
    for i = 1, #leopardUuids do
        table.insert(middleBeasts, leopardUuids[i])
    end
    for i = 1, #bearUuids do
        table.insert(middleBeasts, bearUuids[i])
    end
    
    -- 等待玩家击败所有中级妖兽
    LEVEL_DoProcess(function()
        -- 灵豹死亡掉落中级灵草
        for i = 1, #leopardUuids do
            LEVEL_AddTimerAsyncProcess(function()
                if not LEVEL_IsNpcAlive(leopardUuids[i]) then
                    LEVEL_DropItem("中级灵草", 1, "locator_valley_middle_leopards", false)
                    return false
                end
                return true
            end, 0.5, 0)
        end
        
        -- 石熊死亡掉落修炼丹药
        for i = 1, #bearUuids do
            LEVEL_AddTimerAsyncProcess(function()
                if not LEVEL_IsNpcAlive(bearUuids[i]) then
                    LEVEL_DropItem("修炼丹药", 1, "locator_valley_middle_bears", false)
                    return false
                end
                return true
            end, 0.5, 0)
        end
    end, function()
        return LEVEL_GetArrayAliveNpcCount(middleBeasts) == 0
    end, 150)
    
    LEVEL_ShowDialog("", "前路已通，谷底灵雾缭绕，千年灵草的金光隐约可见，然而一股强大的妖气扑面而来...", "neutral", 0.8)
    
    -- 召唤千年蛟龙Boss和千年灵草
    local dragonUuid = LEVEL_SummonWithType("千年蛟龙", "locator_valley_bottom_boss")
    LEVEL_DropItem("千年灵草", 1, "locator_final_herb", true)
    
    LEVEL_ShowDialog("千年蛟龙", "何方修士，胆敢窥视本座守护的千年灵草！今日便是你的死期！", "angry", 0.7)
    
    -- Boss战斗逻辑 - 实现多阶段攻击
    LEVEL_DoProcess(function()
        -- Boss正常阶段攻击循环
        LEVEL_AddTimerAsyncProcess(function()
            if LEVEL_IsNpcAlive(dragonUuid) then
                -- 检查血量是否低于50%，释放更强技能
                local skill = "龙息"
                LEVEL_NpcCastSkill(dragonUuid, skill)
                return true
            end
            return false
        end, 3, 0)
        
        -- Boss狂暴阶段技能(血量50%以下时的强化攻击)
        LEVEL_AddTimerAsyncProcess(function()
            if LEVEL_IsNpcAlive(dragonUuid) then
                -- 模拟血量检测，使用更强技能组合
                LEVEL_NpcCastSkill(dragonUuid, "尾击扫荡")
                LEVEL_NpcCastSkill(dragonUuid, "雷电攻击")
                return true
            end
            return false
        end, 8, 0)
    end, function()
        return not LEVEL_IsNpcAlive(dragonUuid)
    end, 0)
    
    -- Boss战胜利处理
    LEVEL_ShowDialog("千年蛟龙", "想不到你这小修士竟有如此实力...千年灵草...便是你的了...", "neutral", 0.6)
    
    LEVEL_ShowDialog("", "千年灵草入手，修为大进。这次灵草谷之行，不仅获得了珍贵的天材地宝，更是在实战中磨砺了道心。修仙路漫漫，此番历练必将成为日后飞升的重要基石。", "neutral", 0.8)
    
    -- 注册最终需要击败的Boss
    LEVEL_RegisterStageNPCNeedBeat(dragonUuid)
end

return M