-- 中级灵草物品配置文件

local M = {
    -- id为物品TID（@Terms.ItemTID），是物品类型的唯一标识，与文件名一致
    id = "中级灵草",
    -- desc是物品的描述，会显示在物品信息中，不超过30个字
    desc = "谷中段品质较高的蓝色灵草，可恢复生命与法力",
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Items/SM_Item_Powder_01.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Items_SM_Item_Powder_01.png",
    -- cooldown是物品的使用冷却时间，单位是毫秒,0为无冷却
    cooldown = 3000,
    -- deleteAfterUse是物品使用后是否删除
    deleteAfterUse = true,
    -- stackable是物品是否可以堆叠,堆叠上限默认是999
    stackable = true,
    -- autoUse是物品是否自动使用，设为true使玩家接近即可自动拾取并使用
    autoUse = true,
    -- showInUI是物品是否显示在UI中，自动使用的物品一般不显示在UI中
    showInUI = false,
    -- onGet是物品获得时的回调函数，此物品是消耗品，不需要onGet/onLost
    onGet = nil,
    -- onLost是物品丢失时的回调函数，此物品是消耗品，不需要onGet/onLost
    onLost = nil,
    -- onUse是物品使用时的回调函数，设置恢复HP和MP的效果，并给予经验值
    onUse = function()
        -- 恢复较多HP和MP
        Item_ModHp(350)
        Item_ModMp(180)
        -- 提供修炼经验
        Item_AddExp(120)
        -- 使用时发出提示
        Item_Say("服下中级灵草，顿感灵力涌动，修为小有精进")
    end,
}
return M