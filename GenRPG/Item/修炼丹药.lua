-- 修炼丹药的属性配置文件

local M = {
    -- id为物品TID，是物品类型的唯一标识，与文件名一致
    id = "修炼丹药",
    -- desc是物品的描述，会显示在物品信息中
    desc = "灵草炼制的丹红色丹药，大幅恢复生命法力",
    -- 选择粉末状物体模型作为丹药的表现
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Items/SM_Item_Powder_01.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Items_SM_Item_Powder_01.png",
    -- 使用冷却时间为15秒(15000毫秒)，合理控制使用频率
    cooldown = 15000,
    -- 使用后物品消失
    deleteAfterUse = true,
    -- 可以堆叠，允许玩家携带多个
    stackable = true,
    -- 接近后自动使用，符合快节奏战斗需求
    autoUse = true,
    -- 自动使用物品不在UI中显示
    showInUI = false,
    -- 获得物品时不触发效果
    onGet = nil,
    -- 丢弃物品时不触发效果
    onLost = nil,
    -- 使用物品时触发效果：大幅恢复HP和MP
    onUse = function()
        -- 根据数值系统设计，玩家最大生命值1000，最大法力值600
        -- 恢复50%的最大生命值和法力值，确保大幅恢复效果
        local hpRecovery = 500  -- 恢复500点生命值
        local mpRecovery = 300  -- 恢复300点法力值
        
        -- 应用生命和法力恢复
        Item_ModHp(hpRecovery)
        Item_ModMp(mpRecovery)
        
        -- 使用后提示
        Item_Say("服用修炼丹药，气血充盈，法力充沛！")
    end,
}
return M