local M = {}

function M.cb()
    -- 设置阶段超时时间
    LEVEL_SetStageTimeout(300)
    
    -- 将Player传送到出生点
    LEVEL_PlayerTeleportTo("locator_player_spawn")
    
    -- 序章剧情：显示旁白介绍灵草谷背景
    LEVEL_ShowDialog("", "筑基期修仙者，踏入神秘的灵草谷。传说谷底有千年灵草，得之可大幅提升修为，然谷中妖兽盘踞，危险重重...", "neutral", 1.2)
    
    -- 召唤老修士NPC进行对话引导
    local elderUUID = LEVEL_SummonWithType("老修士", "locator_valley_entrance_elder")
    LEVEL_BlackboardSet("stage1_elder", elderUUID)
    
    -- 老修士技能传授：通过对话系统让老修士教授玩家'御风术'技能
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "learn_wind_skill",
            desc = "从老修士处学习御风术",
            stageId = 1,
            NpcUUID = elderUUID,
            type = "TaskType.None",
            param = {},
            autoChat = false,
            finishChat = {
                { "老修士", "小友，前方便是灵草谷，谷中妖兽横行，切勿轻敌。老夫传你一门'御风术'，助你闯荡此谷。", "neutral", 0.8 },
                { "Player", "多谢前辈指点。", "happy", 1.0 },
            },
        })
    end, function() return LEVEL_IsTaskFinished("learn_wind_skill") end, 0)
    
    -- 老修士离开场景
    LEVEL_NpcMoveToLocator(elderUUID, "locator_elder_exit", 0.5, 5)
    LEVEL_NpcDie(elderUUID, "")
    
    -- 谷口试炼战斗：在指定位置召唤3只灵狐和2只山猿
    LEVEL_ShowDialog("", "谷口妖兽察觉到修士气息，纷纷现身阻拦...", "neutral", 1.2)
    
    local foxUUIDs = LEVEL_SummonNPCsWithType("灵狐", 3, "locator_valley_entrance_foxes")
    local apeUUIDs = LEVEL_SummonNPCsWithType("山猿", 2, "locator_valley_entrance_apes")
    
    -- 将所有低级妖兽注册为必须击败的目标
    local lowLevelBeasts = {}
    for _, uuid in ipairs(foxUUIDs) do
        table.insert(lowLevelBeasts, uuid)
    end
    for _, uuid in ipairs(apeUUIDs) do
        table.insert(lowLevelBeasts, uuid)
    end
    
    -- 注册低级妖兽为必须击败的目标
    LEVEL_RegisterStageNPCNeedBeat(foxUUIDs[1], foxUUIDs[2], foxUUIDs[3], apeUUIDs[1], apeUUIDs[2])
    
    -- 等待玩家击败所有谷口妖兽
    LEVEL_DoProcess(
        function()
            LEVEL_AddTask({
                id = "defeat_entrance_beasts",
                desc = "击败谷口妖兽(0/5)",
                stageId = 1,
                type = "TaskType.KillMonster",
                param = {"灵狐", 3},
                preChat = {
                    { "", "击败妖兽，获取初级灵草！", "neutral", 1.0 },
                },
            })
        end,
        function() 
            return LEVEL_GetArrayAliveNpcCount(lowLevelBeasts) == 0 
        end,
        0
    )
    
    -- 第一阶段胜利处理：检测妖兽全部死亡后，初级灵草掉落
    for i = 1, 5 do
        LEVEL_DropItem("初级灵草", 1, i <= 3 and "locator_valley_entrance_foxes" or "locator_valley_entrance_apes", true)
    end
    
    -- 玩家升级并学会'烈焰符'技能
    LEVEL_ShowDialog("", "初战告捷，修为有所精进。深谷之中，更大的挑战正在等待...", "neutral", 1.0)
    
    -- 深谷探索准备：在谷中段随机位置生成中级灵草和修炼丹药供玩家收集
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_spawn1", false)
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_spawn2", false)
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_spawn3", false)
    LEVEL_DropItem("修炼丹药", 1, "locator_pills_spawn1", false)
    LEVEL_DropItem("修炼丹药", 1, "locator_pills_spawn2", false)
    
    -- 中级妖兽战斗：召唤灵豹和石熊
    local leopardUUIDs = LEVEL_SummonNPCsWithType("灵豹", 4, "locator_valley_middle_leopards")
    local bearUUIDs = LEVEL_SummonNPCsWithType("石熊", 2, "locator_valley_middle_bears")
    
    -- 注册中级妖兽为必须击败的目标
    LEVEL_RegisterStageNPCNeedBeat(leopardUUIDs[1], leopardUUIDs[2], leopardUUIDs[3], leopardUUIDs[4], bearUUIDs[1], bearUUIDs[2])
    
    -- 将所有中级妖兽添加到监控数组
    local midLevelBeasts = {}
    for _, uuid in ipairs(leopardUUIDs) do
        table.insert(midLevelBeasts, uuid)
    end
    for _, uuid in ipairs(bearUUIDs) do
        table.insert(midLevelBeasts, uuid)
    end
    
    -- 等待玩家击败所有中级妖兽
    LEVEL_DoProcess(
        function()
            LEVEL_AddTask({
                id = "defeat_middle_beasts",
                desc = "击败中级妖兽(0/6)",
                stageId = 1,
                type = "TaskType.KillMonster",
                param = {"灵豹", 4},
                preChat = {
                    { "", "深谷中的妖兽实力更强，小心应对！", "neutral", 1.0 },
                },
            })
        end,
        function() 
            return LEVEL_GetArrayAliveNpcCount(midLevelBeasts) == 0 
        end,
        0
    )
    
    -- 中级妖兽死亡后掉落对应物品
    for i = 1, 4 do
        LEVEL_DropItem("中级灵草", 1, "locator_valley_middle_leopards", false)
    end
    for i = 1, 2 do
        LEVEL_DropItem("修炼丹药", 1, "locator_valley_middle_bears", false)
    end
    
    -- 玩家再次升级学会'天雷诀'
    LEVEL_ShowDialog("", "前路已通，谷底灵雾缭绕，千年灵草的金光隐约可见，然而一股强大的妖气扑面而来...", "neutral", 0.8)
    
    -- Boss战准备：在谷底召唤千年蛟龙Boss
    local bossUUID = LEVEL_SummonWithType("千年蛟龙", "locator_valley_bottom_boss")
    LEVEL_BlackboardSet("stage1_boss", bossUUID)
    
    -- 生成千年灵草道具（但现在不可拾取，击败Boss后才能获得）
    LEVEL_DropItem("千年灵草", 1, "locator_final_herb", true)
    
    -- Boss战对话
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "confront_boss",
            desc = "击败千年蛟龙",
            stageId = 1,
            NpcUUID = bossUUID,
            type = "TaskType.KillMonster",
            param = {"千年蛟龙", 1},
            preChat = {
                { "千年蛟龙", "何方修士，胆敢窥视本座守护的千年灵草！今日便是你的死期！", "angry", 0.7 },
                { "Player", "区区妖兽，也敢阻我修仙之路！", "angry", 1.0 },
            },
            finishChat = {
                { "千年蛟龙", "想不到你这小修士竟有如此实力...千年灵草...便是你的了...", "sad", 0.6 },
            },
        })
    end, function()
        return false -- 不会自然完成，等待Boss被击败
    end, 0)
    
    -- 注册Boss为必须击败的目标
    LEVEL_RegisterStageNPCNeedBeat(bossUUID)
    
    -- 监控Boss血量，实现多阶段战斗
    local bossEnragedFlag = false
    LEVEL_AddTimerAsyncProcess(function()
        -- 检查Boss是否存活
        if not LEVEL_IsNpcAlive(bossUUID) then
            return false -- Boss已死亡，停止监控
        end
        
        -- 这里通过BlackboardGet/Set模拟检测Boss血量，实际游戏中可能有专门API
        -- 当Boss血量低于50%时触发狂暴模式
        local currentHealth = LEVEL_BlackboardGet("boss_health_percentage")
        if not bossEnragedFlag and (currentHealth == "low" or not currentHealth) then
            bossEnragedFlag = true
            LEVEL_BlackboardSet("boss_enraged", "true")
            
            -- Boss进入狂暴状态
            LEVEL_ShowDialog("千年蛟龙", "竟敢伤我至此！尝尝本座真正的力量！", "angry", 0.7)
            
            -- Boss释放强力技能
            LEVEL_NpcCastSkill(bossUUID, "尾击扫荡")
            
            -- 旁白提示玩家Boss进入了新阶段
            LEVEL_ShowDialog("", "千年蛟龙怒火中烧，尾击扫荡横扫四方！", "fearful", 0.8)
        end
        
        return true -- 继续监控
    end, 3, 0) -- 每3秒检查一次
    
    -- 胜利结算：玩家获得千年灵草
    LEVEL_Award("千年灵草", 1)
    
    -- 胜利旁白
    LEVEL_ShowDialog("", "千年灵草入手，修为大进。这次灵草谷之行，不仅获得了珍贵的天材地宝，更是在实战中磨砺了道心。修仙路漫漫，此番历练必将成为日后飞升的重要基石。", "happy", 0.8)
    
    -- 关卡成功完成
    LEVEL_EndStage("成功获得千年灵草")
end

return M