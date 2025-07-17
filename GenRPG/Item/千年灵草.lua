-- 物品Item配置文件: 千年灵草

local M = {
    -- id为物品TID（@Terms.ItemTID），是物品类型的唯一标识，与文件名一致
    id = "千年灵草",
    -- desc是物品的描述，会显示在物品信息中
    desc = "传说中的珍贵灵草，通体金光闪耀，蕴含庞大灵力",
    -- 选择了低多边形风格的植物模型，最符合千年灵草的仙侠风格外观
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Props/SM_Prop_PlanterBox_Small_Preset_04.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Props_SM_Prop_PlanterBox_Small_Preset_04.png",
    -- 设置冷却时间为0，因为这是游戏的最终奖励物品，只能获得一次
    cooldown = 0,
    -- 使用后删除，因为是一次性消耗品
    deleteAfterUse = true,
    -- 不可堆叠，因为是珍贵的唯一物品
    stackable = false,
    -- 不自动使用，让玩家可以选择使用时机
    autoUse = false,
    -- 显示在UI中，作为重要物品可以查看
    showInUI = true,
    -- 千年灵草没有获得时的特殊效果，仅作为重要物品收集
    onGet = nil,
    -- 没有失去时的特殊效果
    onLost = nil,
    -- 使用后大幅提升所有属性，代表修仙路上的重要成就
    onUse = function()
        -- 提升修为等级对应的属性加成
        Item_AddProp("strength", 50)  -- 增加力量
        Item_AddProp("defense", 25)   -- 增加防御
        Item_AddProp("agility", 20)   -- 增加敏捷
        -- 恢复并提升生命值和法力值
        Item_ModHp(500)  -- 立即恢复大量生命值
        Item_ModMp(300)  -- 立即恢复大量法力值
        -- 增加经验值，提升修为境界
        Item_AddExp(1000)
        -- 使用时喊话，表达成就感
        Item_Say("得此千年灵草，吾修为大进，道行精进!")
        -- 使用后释放特效技能，体现修为突破的场景效果
        Item_CastSkill("仙灵突破", false)
    end,
}
return M