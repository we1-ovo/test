local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "老修士",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "仙风道骨的老修士，身着灰色道袍，须发皆白，形象慈祥",
    type = "senior", -- 从boss、junior、senior中选择，根据描述选择senior最合适
    attackType = "ranged", -- 攻击类型有: melee(近战) 和 ranged(远程)
    prefab = "Assets/PolygonFantasyCharacters/Prefabs/FixedScaleCharacters/Character_Male_Wizard.prefab", -- 预制体名称
    avatar = "Assets/Avatars/Assets_PolygonFantasyCharacters_Prefabs_FixedScaleCharacters_Character_Male_Wizard.png", -- 立绘头像
    -- prop是NPC的属性参考数值系统，包括最大生命值，生命回复速度，最大法力值，法力回复速度，速度，力量，防御，敏捷
    prop = {
        -- hpMax是最大生命值
        hpMax = 500,
        -- hpGen是生命回复速度
        hpGen = 5,
        -- mpMax是最大法力值
        mpMax = 1000,
        -- mpGen是法力回复速度
        mpGen = 10,
        -- speed是速度
        speed = 3,
        -- strength是力量
        strength = 30,
        -- defense是防御
        defense = 20,
        -- agility是敏捷
        agility = 25,
        -- exp是NPC死亡时给予player的经验值
        exp = 0,
    },
    -- skills是NPC的技能，即可以使用的技能id列表
    skills = {
        "御风术",
        "传功术",
    },
    -- faction表示阵营
    faction = 'faction_friend_npc', -- 友方NPC
    -- aiRoot是NPC的AI行为的根目录
    aiRoot = 'default',
    -- 仇恨范围,单位米
    hatredRange = 0, -- 不会主动攻击
    -- NPC的AI行为描述，是否能够移动
    canMove = true,
    -- NPC的AI行为描述,是否能够释放技能战斗
    canCastSkill = true, -- 虽然不会战斗，但会施法传功
    -- NPC的AI行为描述, 是否能够被攻击
    canBeAttack = false, -- 不可被攻击
}
return M