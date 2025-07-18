-- 初级灵草Item配置文件

local M = {
    -- id为物品TID，是物品类型的唯一标识，与文件名一致
    id = "初级灵草",
    -- desc是物品的描述，会显示在物品信息中
    desc = "谷口区域的基础灵草，呈淡绿色微光",
    -- 选择绿色粉末状模型，最符合淡绿色微光灵草的描述
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Items/SM_Item_Powder_01.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Items_SM_Item_Powder_01.png",
    -- cooldown是物品的使用冷却时间，单位是毫秒，恢复药品无冷却
    cooldown = 0,
    -- deleteAfterUse是物品使用后是否删除，恢复药品使用后删除
    deleteAfterUse = true,
    -- stackable是物品是否可以堆叠，药品类物品可以堆叠
    stackable = true,
    -- autoUse是物品是否自动使用，恢复药品自动使用
    autoUse = true,
    -- showInUI是物品是否显示在UI中，自动使用的药品不显示在UI中
    showInUI = false,
    -- onGet函数为nil，恢复药品不需要获得时的处理
    onGet = nil,
    -- onLost函数为nil，恢复药品不需要丢失时的处理
    onLost = nil,
    -- onUse是物品使用时的回调函数，恢复HP和MP并提供经验
    onUse = function()
        -- 恢复少量HP，约为玩家最大HP的8%
        Item_ModHp(80)
        -- 恢复少量MP，约为玩家最大MP的10%
        Item_ModMp(60)
        -- 提供基础修炼经验
        Item_AddExp(50)
    end,
}
return M