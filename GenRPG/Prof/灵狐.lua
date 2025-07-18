-- NPC属性设置文件：灵狐

local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "灵狐",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "谷口区域的低级妖兽，体型小巧敏捷，银白毛色，双眼幽蓝发光，行动迅速",
    type = "junior", -- 从boss、junior、senior中选择，根据描述这是低级妖兽
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Props/SM_Prop_Animal_Head_PigButcher_01.prefab", -- 选择了最接近灵狐描述的模型
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Props_SM_Prop_Animal_Head_PigButcher_01.png", -- 对应的头像
    -- prop是NPC的属性参考数值系统
    prop = {
        -- hpMax是最大生命值
        hpMax = 280,
        -- hpGen是生命回复速度
        hpGen = 3,
        -- mpMax是最大法力值
        mpMax = 80,
        -- mpGen是法力回复速度
        mpGen = 4,
        -- speed是速度单位米/秒
        speed = 5,
        -- strength是力量
        strength = 45,
        -- defense是防御
        defense = 8,
        -- agility是敏捷
        agility = 30,
        -- exp是NPC死亡时给予player的经验值
        exp = 120,
    },
    -- skills是NPC的技能，即可以使用的技能id列表
    skills = {
        "快速扑击",
        "爪击",
    },
    -- faction表示阵营
    faction = 'faction_npc', -- 敌对NPC，与玩家敌对
    -- aiRoot是NPC的AI行为的根目录
    aiRoot = 'default',
    -- 仇恨范围,单位米, 如果敌对NPC或者Player在范围内，NPC会发起主动攻击
    hatredRange = 8,
    -- NPC的AI行为描述,是否能够释放技能战斗
    canCastSkill = true,
    drops = {
        -- NPC死亡物品掉落列表
        { itemTID = "初级灵草", probability = 80, itemCount = 1 }, -- 掉落初级灵草概率80%
    },
    -- NPC的AI行为描述, 是否能够被攻击
    canBeAttack = true,
}
return M