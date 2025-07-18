-- 物品Item配置文件

local M = {
    -- id为物品TID，是物品类型的唯一标识，与文件名一致
    id = "千年灵草",
    -- desc是物品的描述，会显示在物品信息中
    desc = "千载一遇的仙草，通体金光灿灿，蕴含浩瀚灵力",
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Props/SM_Prop_PlanterBox_Small_Preset_04.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Props_SM_Prop_PlanterBox_Small_Preset_04.png",
    -- cooldown是物品的使用冷却时间，单位是毫秒,0为无冷却
    cooldown = 0,
    -- deleteAfterUse是物品使用后是否删除
    deleteAfterUse = true,
    -- stackable是物品是否可以堆叠,堆叠上限默认是999
    stackable = false,
    -- autoUse是物品是否自动使用，大部分物品都是自动使用
    autoUse = false,
    -- showInUI是物品是否显示在UI中，作为重要物品需要在UI中展示
    showInUI = true,
    -- onGet是物品获得时的回调函数
    -- 千年灵草作为游戏最终目标物品，获得后不会立即生效，需要玩家主动使用
    onGet = function()
        -- 获得千年灵草时不产生即时效果
    end,
    -- onLost是物品丢失时的回调函数
    onLost = function()
        -- 千年灵草丢失时不需要特殊处理
    end,
    -- onUse是物品使用时的回调函数
    -- 使用千年灵草将大幅提升修仙者的各项属性
    onUse = function()
        -- 使用千年灵草时，角色发出感叹
        Item_Say("千年灵草入体，顿觉灵力澎湃，修为大进！")
        
        -- 大幅提升所有基础属性
        Item_AddProp("strength", 50)  -- 提升力量
        Item_AddProp("defense", 30)   -- 提升防御
        Item_AddProp("agility", 40)   -- 提升敏捷
        
        -- 恢复并提升生命值与法力值
        local currentHp = Item_GetHp()
        local hpMax = Item_GetProp("hpMax")
        Item_ModHp(hpMax - currentHp)  -- 恢复满血
        
        local currentMp = Item_GetMp()
        local mpMax = Item_GetProp("mpMax")
        Item_ModMp(mpMax - currentMp)  -- 恢复满蓝
        
        -- 提供大量经验值，代表修为提升
        Item_AddExp(1000)
        
        -- 释放特效技能，展示修为提升的特效
        Item_CastSkill("灵光护体", false)
    end,
}
return M