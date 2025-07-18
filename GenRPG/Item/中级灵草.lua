-- 物品Item配置文件

local M = {
    -- id为物品TID，是物品类型的唯一标识，与文件名一致
    id = "中级灵草",
    -- desc是物品的描述，会显示在物品信息中
    desc = "谷中段品质较高的灵草，呈蓝色光芒，可恢复较多生命和法力",
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Items/SM_Item_Powder_01.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Items_SM_Item_Powder_01.png",
    -- cooldown是物品的使用冷却时间，单位是毫秒,0为无冷却
    cooldown = 1000,
    -- deleteAfterUse是物品使用后是否删除
    deleteAfterUse = true,
    -- stackable是物品是否可以堆叠,堆叠上限默认是999
    stackable = true,
    -- autoUse是物品是否自动使用，这是一种消耗品，设置为自动使用
    autoUse = true,
    -- showInUI是物品是否显示在UI中
    showInUI = false,
    -- 中级灵草是消耗品，不需要onGet和onLost
    onGet = nil,
    onLost = nil,
    -- onUse是物品使用时的回调函数，用于处理物品使用时的逻辑
    -- 中级灵草使用后恢复较多HP和MP，同时提供修炼经验
    onUse = function()
        -- 恢复较多生命值，约玩家最大生命的25%
        Item_ModHp(250)
        -- 恢复较多法力值，约玩家最大法力的30%
        Item_ModMp(180)
        -- 提供修炼经验
        Item_AddExp(150)
        -- 使用提示
        Item_Say("服用中级灵草，感受仙灵之力涌动，气血、法力与修为同步提升")
    end,
}
return M