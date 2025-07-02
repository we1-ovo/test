local M = {
    -- NPC的模板TID，与文件名一致
    id = "山猿",
    -- NPC的描述
    desc = "强壮的中等体型猿类妖兽，毛色棕褐，肌肉发达，力大无穷",
    -- NPC类型: boss、junior、senior
    type = "junior",
    -- 攻击类型: melee(近战) 或 ranged(远程)
    attackType = "ranged",
    -- 预制体路径
    prefab = "Assets/PolygonFantasyCharacters/Prefabs/Character_Male_Baird_01.prefab",
    -- 头像立绘路径
    avatar = "Assets/Avatars/Assets_PolygonFantasyCharacters_Prefabs_Character_Male_Baird_01.png",
    -- NPC的属性参数
    prop = {
        -- 最大生命值
        hpMax = 350,
        -- 生命回复速度
        hpGen = 4,
        -- 最大法力值
        mpMax = 100,
        -- 法力回复速度
        mpGen = 5,
        -- 移动速度
        speed = 5,
        -- 力量属性
        strength = 30,
        -- 防御属性
        defense = 15,
        -- 敏捷属性
        agility = 25,
        -- 击败后给予的经验值
        exp = 150,
    },
    -- NPC可使用的技能列表
    skills = {
        "猿拳击",
        "投石术",
        "猿啸",
    },
    -- 阵营设置: faction_player(玩家)、faction_neutral_npc(中立)、faction_npc(敌对)、faction_friend_npc(友方)
    faction = 'faction_npc',
    -- AI行为根目录，使用default表示使用通用AI
    aiRoot = 'default',
    -- 仇恨范围(单位米)，发现敌对目标会主动攻击
    hatredRange = 10,
    -- 是否可以移动
    canMove = true,
    -- 是否可以释放技能战斗
    canCastSkill = true,
    -- 是否可以被攻击
    canBeAttack = true,
}
return M