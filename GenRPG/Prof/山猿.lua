-- 山猿NPC属性设置文件

local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "山猿",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "灵草谷谷口的低级妖兽，体型中等，力大无穷。擅长近身攻击和远程投掷。",
    type = "junior", -- 根据数值系统设计文档，山猿属于junior类型
    prefab = "Assets/PolygonFantasyCharacters/Prefabs/FixedScaleCharacters/Character_Male_King.prefab", -- 选择了具有人形特征的模型，最接近猿类身形
    avatar = "Assets/Avatars/Assets_PolygonFantasyCharacters_Prefabs_FixedScaleCharacters_Character_Male_King.png",
    -- prop是NPC的属性参考数值系统
    prop = {
        -- 根据数值系统设计文档中NPC类型的属性设置
        hpMax = 280,
        hpGen = 3,
        mpMax = 80,
        mpGen = 4,
        speed = 5,
        strength = 45,
        defense = 8,
        agility = 30,
        exp = 120,
    },
    -- skills是NPC的技能，即可以使用的技能id列表
    skills = {
        "猿拳",
        "石块投掷",
        "猿啸",
    },
    -- 根据设计文档，山猿属于敌对NPC，与玩家敌对
    faction = 'faction_npc',
    -- 根据AI描述，山猿使用默认AI
    aiRoot = 'default',
    -- 根据AI描述，山猿的仇恨范围为8米
    hatredRange = 8,
    -- NPC的AI行为描述,是否能够释放技能战斗
    canCastSkill = true,
    -- NPC掉落物品列表
    drops = {
        -- 由于设计文档中没有指定掉落物，这里不设置特定掉落
    },
    -- NPC能够被攻击
    canBeAttack = true,
}
return M