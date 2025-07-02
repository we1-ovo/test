local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "灵豹",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "灵草谷深处的中级妖兽，速度极快，善于远程能量弹攻击和近身扑击",
    type = "junior", -- 中级妖兽，选择junior类型
    attackType = "ranged", -- 攻击类型选择ranged，因为有远程技能"灵能弹"
    prefab = "Assets/Toon_RTS/WesternKingdoms/prefabs/WK_Cavalry_Light_A.prefab", -- 选择适合的预制体
    avatar = "Assets/Avatars/Assets_Toon_RTS_WesternKingdoms_prefabs_WK_Cavalry_Light_A.png", -- 对应的头像
    -- prop是NPC的属性
    prop = {
        -- hpMax是最大生命值，根据设计为600
        hpMax = 600,
        -- hpGen是生命回复速度，参考NPC基础值
        hpGen = 6,
        -- mpMax是最大法力值
        mpMax = 200,
        -- mpGen是法力回复速度
        mpGen = 7,
        -- speed是速度，灵豹特点是速度快，设定为8.5
        speed = 8.5,
        -- strength是力量，代表攻击力
        strength = 60,
        -- defense是防御，设定为25
        defense = 25,
        -- agility是敏捷
        agility = 70,
        -- exp是NPC死亡时给予player的经验值，中级妖兽给予的经验值应高于普通妖兽
        exp = 300,
    },
    -- skills是NPC的技能列表
    skills = {
        "豹影闪",
        "灵能弹",
        "猛扑击",
    },
    -- faction表示阵营，灵豹是敌对NPC
    faction = 'faction_npc',
    -- aiRoot是NPC的AI行为的根目录
    aiRoot = 'default',
    -- 仇恨范围较大，主动发现并攻击玩家
    hatredRange = 12,
    -- NPC可以移动
    canMove = true,
    -- NPC可以释放技能战斗
    canCastSkill = true,
    -- NPC可以被攻击
    canBeAttack = true,
}
return M