local M = {
    -- 基础信息
    id = "老修士",
    desc = "仙风道骨的长者，灵草谷的守护者，负责引导修行者",
    type = "senior", -- 根据老修士的定位，设置为高级NPC类型
    attackType = "melee", -- 虽不战斗，但需设置攻击类型
    prefab = "Assets/PolygonFantasyCharacters/Prefabs/Character_Male_Wizard_01.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyCharacters_Prefabs_Character_Male_Wizard_01.png",
    
    -- 属性设置，基于不参与战斗的老者形象
    prop = {
        -- 虽然设计文档提到血量和防御仅为形式，但仍需设置一定数值
        hpMax = 1000,
        hpGen = 0, -- 不需要生命恢复
        mpMax = 500,
        mpGen = 0, -- 不需要法力恢复
        speed = 4, -- 适中的移动速度，符合年迈仙人形象
        strength = 0, -- 不参与战斗，攻击力为0
        defense = 999, -- 高防御确保不会受伤
        agility = 20, -- 较低的敏捷度，符合老者形象
        exp = 0, -- 不掉落经验
    },
    
    -- 技能列表
    skills = {
        "御风术传授",
        "仙风展露"
    },
    
    -- 阵营设置为中立NPC，不参与战斗
    faction = 'faction_neutral_npc',
    
    -- AI行为设置
    aiRoot = 'default', -- 使用默认AI行为
    hatredRange = 0, -- 不主动攻击任何单位
    canMove = true, -- 可以移动
    canCastSkill = true, -- 可以施法(用于剧情技能)
    canBeAttack = false, -- 不可被攻击
}

return M