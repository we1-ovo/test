-- 物品Item配置文件完整示例与参数要求

local M = {
    -- id为物品TID（@Terms.ItemTID），是物品类型的唯一标识，与文件名一致
    id = "黑皇杖",
    -- desc是物品的描述，会显示在物品信息中
    desc = "黑皇杖\n 如今，我已无人能挡",
    prefab = "", -- 预制体名称。
    avatar = "", -- 物品图标。
    -- cooldown是物品的使用冷却时间，单位是毫秒,0为无冷却
    cooldown = 5000,
    -- deleteAfterUse是物品使用后是否删除
    deleteAfterUse = true,
    -- stackable是物品是否可以堆叠,堆叠上限默认是999
    stackable = true,
    -- autoUse是物品是否自动使用，大部分物品都是自动使用
    autoUse = false,
    -- showInUI是物品是否显示在UI中，大部分物品自动使用，不会显示在UI中
    showInUI = true,
    -- onGet是物品获得时的回调函数，用于处理物品获得时的逻辑,可以为nil。注意: onGet/onLost一般是装备类型物品，获取就能改变属性
    -- 药品类物品一般使用onUse函数，autoUse=true, deleteAfterUse=true
    -- 函数中只能调用Item_系统的API,一般用来当做装备或者宝物使用，获得立即对玩家属性进行修改。
    -- 非常重要:onGet给获得者增加的属性必须在onLost中扣除，否则会导致获得者累加属性作弊!!!!。
    -- 一般使用的函数有Item_AddProp,改变装备者属性。例如：获得黑皇杖时，力量增加10
    onGet = function()
         Item_AddProp("strength", 10)
    end,
    -- onLost是物品丢失时的回调函数，用于处理物品取下、丢下时的逻辑,可以为nil
    -- 函数中只能调用Item_系统的API。
    -- 一般使用的函数有Item_AddProp,改变装备者属性。例如：丢失黑皇杖时，力量减少10
    onLost = function()
        Item_AddProp("strength", -10)
    end,
    -- onUse是物品使用时的回调函数，用于处理物品使用时的逻辑,可以为nil
    -- 药品类物品一般使用onUse函数，autoUse=true, deleteAfterUse=true
    -- 函数中只能调用Item_系统的API。
    -- 例如：使用黑皇杖时，进行喊话，释放变形技能
    onUse = function()
        Item_Say("黑皇杖\n 如今，我已无人能挡")
        Item_CastSkill("变形")
    end,
}
return M
