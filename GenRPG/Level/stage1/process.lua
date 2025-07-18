local M = {}

function M.cb()
    -- 设置阶段超时时间为300秒(5分钟)
    LEVEL_SetStageTimeout(300 * 1000)
    
    -- 玩家传送到出生点
    LEVEL_PlayerTeleportTo("locator_player_spawn")
    
    -- 开场旁白
    LEVEL_ShowDialog("", "筑基期修仙者，踏入神秘的灵草谷。传说谷底有千年灵草，得之可大幅提升修为，然谷中妖兽盘踞，危险重重...", "neutral", 1.0)
    
    -- 节点任务1：寻找老修士学习仙术
    local elderUUID = LEVEL_SummonWithType("老修士", "locator_valley_entrance_elder")
    LEVEL_BlackboardSet("elder_uuid", elderUUID)
    
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "find_elder",
            desc = "寻找谷口的老修士，获得仙术指导",
            stageId = 1,
            NpcUUID = elderUUID,
            type = "TaskType.None",
            autoChat = false,
            finishChat = {
                { "老修士", "小友，前方便是灵草谷，谷中妖兽横行，切勿轻敌。老夫传你一门御风术，助你闯荡此谷。", "neutral", 0.8 },
                { "Player", "多谢前辈指点！", "happy", 1.0 },
            },
        })
    end, function()
        return LEVEL_IsTaskFinished("find_elder")
    end, 0)
    
    -- 老修士离场
    LEVEL_NpcMoveToLocator(elderUUID, "locator_elder_exit", 0, 3000)
    LEVEL_ShowDialog("", "老修士传授完御风术后，飘然离去...", "neutral", 1.0)
    
    -- 节点任务2：击败谷口妖兽群
    LEVEL_ShowDialog("", "谷口妖兽察觉到修士气息，纷纷现身阻拦...", "neutral", 1.2)
    
    local foxUUIDs = LEVEL_SummonNPCsWithType("灵狐", 3, "locator_valley_entrance_foxes")
    local apeUUIDs = LEVEL_SummonNPCsWithType("山猿", 2, "locator_valley_entrance_apes")
    
    local entranceEnemies = {}
    for _, uuid in ipairs(foxUUIDs) do
        table.insert(entranceEnemies, uuid)
    end
    for _, uuid in ipairs(apeUUIDs) do
        table.insert(entranceEnemies, uuid)
    end
    
    LEVEL_RegisterStageNPCNeedBeat(entranceEnemies)
    
    -- 激活谷口妖兽主动攻击
    for _, uuid in ipairs(entranceEnemies) do
        LEVEL_NPCBattle(uuid, "Player")
    end
    
    -- 监控妖兽死亡并掉落初级灵草
    local entranceEnemiesAlive = {}
    for _, uuid in ipairs(entranceEnemies) do
        entranceEnemiesAlive[uuid] = true
    end
    
    LEVEL_AddTimerAsyncProcess(function()
        for uuid, alive in pairs(entranceEnemiesAlive) do
            if alive and not LEVEL_IsNpcAlive(uuid) then
                local pos = LEVEL_GetPos("locator_player_spawn") -- 无法直接获取死亡NPC位置，这里使用附近点
                LEVEL_DropItem("初级灵草", 1, "", false) -- 使用随机位置掉落
                entranceEnemiesAlive[uuid] = false
            end
        end
        return true
    end, 1000, 0)
    
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "defeat_entrance_beasts",
            desc = "击败谷口的妖兽群",
            stageId = 1,
            type = "TaskType.None", -- 使用None类型，不指定特定NpcTID
            autoChat = true,
            finishChat = {
                { "", "谷口妖兽已被清除！", "neutral", 1.0 },
            },
        })
    end, function()
        local allDefeated = true
        for _, uuid in ipairs(entranceEnemies) do
            if LEVEL_IsNpcAlive(uuid) then
                allDefeated = false
                break
            end
        end
        return allDefeated
    end, 120 * 1000) -- 设置120秒超时，避免玩家一直无法完成
    
    LEVEL_ShowDialog("", "初战告捷，修为有所精进。深谷之中，更大的挑战正在等待...", "neutral", 1.0)
    
    -- 节点任务3：探索谷中段，收集资源并击败中级妖兽
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_1", true)
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_2", true)
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_3", true)
    LEVEL_DropItem("修炼丹药", 1, "locator_pills_1", true)
    LEVEL_DropItem("修炼丹药", 1, "locator_pills_2", true)
    
    local leopardUUIDs = LEVEL_SummonNPCsWithType("灵豹", 4, "locator_valley_middle_leopards")
    local bearUUIDs = LEVEL_SummonNPCsWithType("石熊", 2, "locator_valley_middle_bears")
    
    local middleEnemies = {}
    for _, uuid in ipairs(leopardUUIDs) do
        table.insert(middleEnemies, uuid)
    end
    for _, uuid in ipairs(bearUUIDs) do
        table.insert(middleEnemies, uuid)
    end
    
    LEVEL_RegisterStageNPCNeedBeat(middleEnemies)
    
    -- 激活中级妖兽主动攻击
    for _, uuid in ipairs(middleEnemies) do
        LEVEL_NPCBattle(uuid, "Player")
    end
    
    -- 监控中级妖兽死亡并掉落物品
    local leopardsAlive = {}
    local bearsAlive = {}
    for _, uuid in ipairs(leopardUUIDs) do
        leopardsAlive[uuid] = true
    end
    for _, uuid in ipairs(bearUUIDs) do
        bearsAlive[uuid] = true
    end
    
    LEVEL_AddTimerAsyncProcess(function()
        for uuid, alive in pairs(leopardsAlive) do
            if alive and not LEVEL_IsNpcAlive(uuid) then
                LEVEL_DropItem("中级灵草", 1, "", false) -- 使用随机位置掉落
                leopardsAlive[uuid] = false
            end
        end
        for uuid, alive in pairs(bearsAlive) do
            if alive and not LEVEL_IsNpcAlive(uuid) then
                LEVEL_DropItem("修炼丹药", 1, "", false) -- 使用随机位置掉落
                bearsAlive[uuid] = false
            end
        end
        return true
    end, 1000, 0)
    
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "explore_middle_valley",
            desc = "深入谷中段，收集灵草资源并击败守护的妖兽",
            stageId = 1,
            type = "TaskType.None", -- 使用None类型，不指定特定NpcTID
            autoChat = true,
            finishChat = {
                { "", "中级妖兽已被击败！", "neutral", 1.0 },
            },
        })
    end, function()
        local allDefeated = true
        for _, uuid in ipairs(middleEnemies) do
            if LEVEL_IsNpcAlive(uuid) then
                allDefeated = false
                break
            end
        end
        return allDefeated
    end, 180 * 1000) -- 设置180秒超时
    
    LEVEL_ShowDialog("", "前路已通，谷底灵雾缭绕，千年灵草的金光隐约可见，然而一股强大的妖气扑面而来...", "neutral", 0.8)
    
    -- 节点任务4：挑战千年蛟龙Boss
    -- 先生成千年灵草但玩家无法直接获取
    LEVEL_DropItem("千年灵草", 1, "locator_final_herb", true)
    
    local dragonUUID = LEVEL_SummonWithType("千年蛟龙", "locator_valley_bottom_boss")
    LEVEL_BlackboardSet("dragon_uuid", dragonUUID)
    LEVEL_RegisterStageNPCNeedBeat({dragonUUID})
    
    LEVEL_ShowDialog("千年蛟龙", "何方修士，胆敢窥视本座守护的千年灵草！今日便是你的死期！", "angry", 0.7)
    
    LEVEL_NPCBattle(dragonUUID, "Player")
    
    -- 监控Boss血量，在血量低于50%时增强攻击
    LEVEL_AddTimerAsyncProcess(function()
        if LEVEL_IsNpcAlive(dragonUUID) then
            local hp = LEVEL_GetHp(dragonUUID)
            local maxHp = LEVEL_GetPropValue(dragonUUID, "hpMax")
            
            if hp <= maxHp * 0.5 then
                -- Boss进入第二阶段
                LEVEL_ShowDialog("千年蛟龙", "小修士竟有此实力，看我全力一击！", "angry", 0.8)
                LEVEL_AddPropValue(dragonUUID, "strength", 50) -- 增强攻击力
                return false -- 只触发一次
            end
        end
        return true
    end, 2000, 0)
    
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "defeat_dragon_boss",
            desc = "挑战谷底的千年蛟龙，夺取千年灵草",
            stageId = 1,
            type = "TaskType.KillMonster",
            param = {"千年蛟龙", 1},
            autoChat = true,
            finishChat = {
                { "千年蛟龙", "想不到你这小修士竟有如此实力...千年灵草...便是你的了...", "neutral", 0.6 },
            },
        })
    end, function()
        return LEVEL_IsTaskFinished("defeat_dragon_boss")
    end, 0)
    
    -- 发放最终奖励
    LEVEL_Award("千年灵草", 1)
    
    LEVEL_ShowDialog("", "千年灵草入手，修为大进。这次灵草谷之行，不仅获得了珍贵的天材地宝，更是在实战中磨砺了道心。修仙路漫漫，此番历练必将成为日后飞升的重要基石。", "neutral", 0.8)
end

return M