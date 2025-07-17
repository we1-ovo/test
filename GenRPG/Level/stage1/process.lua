local M = {}

function M.cb()
    -- 设置阶段超时时间为300秒
    LEVEL_SetStageTimeout(300000)
    
    -- 将玩家传送到出生点
    LEVEL_PlayerTeleportTo("locator_player_spawn")
    
    -- 显示开场旁白
    LEVEL_ShowDialog("", "筑基期修仙者，踏入神秘的灵草谷。传说谷底有千年灵草，得之可大幅提升修为，然谷中妖兽盘踞，危险重重...", "neutral", 1.0)
    
    -- 召唤老修士
    local elderUUID = LEVEL_SummonWithType("老修士", "locator_valley_entrance_elder")
    LEVEL_BlackboardSet("stage1_elder_uuid", elderUUID)
    
    -- 节点任务1：与老修士对话学习御风术
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "stage1_learn_skill",
            desc = "寻找老修士学习仙术",
            stageId = 1,
            NpcUUID = elderUUID,
            type = "TaskType.None",
            param = {},
            autoChat = false,
            preChat = {
                { "老修士", "小友，前方便是灵草谷，谷中妖兽横行，切勿轻敌。老夫传你一门御风术，助你闯荡此谷。", "neutral", 0.8 },
            },
            finishChat = {
                { "老修士", "此术已传授于你，好自为之。", "neutral", 1.0 },
            },
            reward = {},
        })
    end, function()
        return LEVEL_IsTaskFinished("stage1_learn_skill")
    end, 0)
    
    -- 老修士离场
    LEVEL_TeleportTo(elderUUID, "locator_elder_exit")
    
    -- 显示谷口妖兽出现提示
    LEVEL_ShowDialog("", "谷口妖兽察觉到修士气息，纷纷现身阻拦...", "neutral", 1.2)
    
    -- 召唤谷口妖兽群
    local foxUUIDs = LEVEL_SummonNPCsWithType("灵狐", 3, "locator_valley_entrance_foxes")
    local apeUUIDs = LEVEL_SummonNPCsWithType("山猿", 2, "locator_valley_entrance_apes")
    local allEntranceBeasts = {}
    for i = 1, #foxUUIDs do
        table.insert(allEntranceBeasts, foxUUIDs[i])
    end
    for i = 1, #apeUUIDs do
        table.insert(allEntranceBeasts, apeUUIDs[i])
    end
    
    LEVEL_RegisterStageNPCNeedBeat(allEntranceBeasts)
    
    -- 激活谷口妖兽主动攻击
    for i = 1, #allEntranceBeasts do
        LEVEL_NPCBattle(allEntranceBeasts[i], "Player")
    end
    
    -- 节点任务2：击败谷口妖兽群
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "stage1_defeat_entrance_beasts",
            desc = "击败谷口妖兽群，为深入谷内做准备",
            stageId = 1,
            type = "TaskType.KillMonster",
            param = {"灵狐", 5},
            autoChat = true,
            finishChat = {
                { "", "谷口妖兽已被击败！", "neutral", 1.0 },
            },
        })
    end, function()
        return LEVEL_GetArrayAliveNpcCount(allEntranceBeasts) == 0
    end, 120000)
    
    -- 显示阶段过渡
    LEVEL_ShowDialog("", "初战告捷，修为有所精进。深谷之中，更大的挑战正在等待...", "neutral", 1.0)
    
    -- 投放谷中段资源
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_1", true)
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_2", true)
    LEVEL_DropItem("中级灵草", 1, "locator_middle_herbs_3", true)
    LEVEL_DropItem("修炼丹药", 1, "locator_pills_1", true)
    LEVEL_DropItem("修炼丹药", 1, "locator_pills_2", true)
    
    -- 召唤中级妖兽群
    local leopardUUIDs = LEVEL_SummonNPCsWithType("灵豹", 4, "locator_valley_middle_leopards")
    local bearUUIDs = LEVEL_SummonNPCsWithType("石熊", 2, "locator_valley_middle_bears")
    local allMiddleBeasts = {}
    for i = 1, #leopardUUIDs do
        table.insert(allMiddleBeasts, leopardUUIDs[i])
    end
    for i = 1, #bearUUIDs do
        table.insert(allMiddleBeasts, bearUUIDs[i])
    end
    
    LEVEL_RegisterStageNPCNeedBeat(allMiddleBeasts)
    
    -- 激活中级妖兽主动攻击
    for i = 1, #allMiddleBeasts do
        LEVEL_NPCBattle(allMiddleBeasts[i], "Player")
    end
    
    -- 节点任务3：击败中级妖兽群
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "stage1_defeat_middle_beasts",
            desc = "击败谷中段妖兽，收集修炼资源",
            stageId = 1,
            type = "TaskType.KillMonster",
            param = {"灵豹", 6},
            autoChat = true,
            finishChat = {
                { "", "中级妖兽已被击败，修为再次精进！", "neutral", 1.0 },
            },
        })
    end, function()
        return LEVEL_GetArrayAliveNpcCount(allMiddleBeasts) == 0
    end, 180000)
    
    -- 显示Boss战前置
    LEVEL_ShowDialog("", "前路已通，谷底灵雾缭绕，千年灵草的金光隐约可见，然而一股强大的妖气扑面而来...", "neutral", 0.8)
    
    -- 召唤千年蛟龙Boss和千年灵草
    local dragonUUID = LEVEL_SummonWithType("千年蛟龙", "locator_valley_bottom_boss")
    LEVEL_DropItem("千年灵草", 1, "locator_final_herb", true)
    LEVEL_RegisterStageNPCNeedBeat({dragonUUID})
    
    -- Boss开场对话
    LEVEL_ShowDialog("千年蛟龙", "何方修士，胆敢窥视本座守护的千年灵草！今日便是你的死期！", "angry", 0.7)
    
    -- 激活Boss主动攻击
    LEVEL_NPCBattle(dragonUUID, "Player")
    
    -- 节点任务4：击败千年蛟龙Boss
    LEVEL_DoProcess(function()
        LEVEL_AddTask({
            id = "stage1_defeat_dragon_boss",
            desc = "击败千年蛟龙，获得千年灵草",
            stageId = 1,
            type = "TaskType.KillMonster",
            param = {"千年蛟龙", 1},
            autoChat = true,
            preChat = {
                { "", "最终的挑战来临，千年蛟龙盘踞在千年灵草旁边！", "neutral", 1.0 },
            },
            finishChat = {
                { "千年蛟龙", "想不到你这小修士竟有如此实力...千年灵草...便是你的了...", "neutral", 0.6 },
            },
        })
    end, function()
        return not LEVEL_IsNpcAlive(dragonUUID)
    end, 240000)
    
    -- Boss死亡后玩家自动获得千年灵草
    LEVEL_Award("千年灵草", 1)
    
    -- 显示胜利结语
    LEVEL_ShowDialog("", "千年灵草入手，修为大进。这次灵草谷之行，不仅获得了珍贵的天材地宝，更是在实战中磨砺了道心。修仙路漫漫，此番历练必将成为日后飞升的重要基石。", "neutral", 0.8)
end

return M