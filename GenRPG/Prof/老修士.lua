-- 老修士的NPC属性配置

local M = {
    -- id为NpcTID，是NPC的模板TID
    id = "老修士",
    -- 老修士的描述
    desc = "一位仙风道骨的老修士，能够传授御风术",
    -- 老修士属于中级NPC，不是boss也不是小怪
    type = "senior", 
    -- 选择的模型预制体
    prefab = "Assets/PolygonFantasyCharacters/Prefabs/Character_Male_Wizard_01.prefab",
    -- 选择的头像立绘
    avatar = "Assets/Avatars/Assets_PolygonFantasyCharacters_Prefabs_Character_Male_Wizard_01.png",
    -- 老修士的属性设置，根据attributes_desc提供的数值
    prop = {
        -- 最大生命值
        hpMax = 1000,
        -- 生命回复速度
        hpGen = 5,
        -- 最大法力值
        mpMax = 1000,
        -- 法力回复速度
        mpGen = 8,
        -- 移动速度(米/秒)
        speed = 4.5,
        -- 力量属性
        strength = 10,
        -- 防御属性
        defense = 5,
        -- 敏捷属性
        agility = 15,
        -- 经验值，击败后给予的经验(友方NPC不会被击败，设为0)
        exp = 0,
    },
    -- 老修士的技能列表
    skills = {
        "御风术传授",
        "瞬移离场",
    },
    -- 老修士是友方NPC，设置为友方阵营
    faction = 'faction_friend_npc',
    -- 使用默认AI
    aiRoot = 'default',
    -- 仇恨范围设为0，不会主动攻击任何目标
    hatredRange = 0,
    -- 老修士虽然有技能，但不会用于战斗
    canCastSkill = false,
    -- 老修士没有物品掉落
    drops = {},
    -- 老修士可以被攻击，但不会反击
    canBeAttack = true,
}
return M