-- 初级灵草 Item配置文件

local M = {
    -- id为物品TID，是物品类型的唯一标识，与文件名一致
    id = "初级灵草",
    -- desc是物品的描述，会显示在物品信息中
    desc = "谷口区域的基础灵草，呈淡绿色微光",
    -- 选择绿色粉末状模型，最符合淡绿色灵草的描述
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Items/SM_Item_Powder_01.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Items_SM_Item_Powder_01.png",
    -- cooldown是物品的使用冷却时间，单位是毫秒，恢复类道具无冷却
    cooldown = 0,
    -- deleteAfterUse是物品使用后是否删除，药品类一次性使用
    deleteAfterUse = true,
    -- stackable是物品是否可以堆叠
    stackable = true,
    -- autoUse是物品是否自动使用，接近后自动拾取使用
    autoUse = true,
    -- showInUI是物品是否显示在UI中，自动使用不显示
    showInUI = false,
    -- onGet为nil，药品类物品不使用onGet/onLost
    onGet = nil,
    -- onLost为nil，药品类物品不使用onGet/onLost
    onLost = nil,
    -- onUse是物品使用时的回调函数，恢复HP和MP并提供经验
    onUse = function()
        -- 恢复少量HP（基于筑基期修仙者HP1200，恢复约15%）
        Item_ModHp(180)
        -- 恢复少量MP（基于筑基期修仙者MP600，恢复约20%）
        Item_ModMp(120)
        -- 提供基础修炼经验（参考NPC给予150经验，初级灵草给予较少）
        Item_AddExp(50)
    end,
}
return M