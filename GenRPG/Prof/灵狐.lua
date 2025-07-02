local M = {
    -- id为NPC的模板TID，与文件名一致
    id = "灵狐",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "体型小巧的银白色妖兽，双眼发出幽蓝光芒，是灵草谷谷口区域常见的低级妖兽",
    -- 灵狐是普通妖兽，选择junior类型
    type = "junior",
    -- 灵狐以扑击和爪击为主，是近战攻击类型
    attackType = "melee",
    -- 选择合适的模型作为预制体
    prefab = "Assets/Toon_RTS/WesternKingdoms/prefabs/WK_Cavalry_Light_B.prefab",
    -- 对应的头像
    avatar = "Assets/Avatars/Assets_Toon_RTS_WesternKingdoms_prefabs_WK_Cavalry_Light_B.png",
    -- 灵狐的属性参数，根据数值系统和灵狐的具体描述设置
    prop = {
        -- 从属性描述中获取生命值
        hpMax = 350,
        -- 从数值系统中的NPC属性获取生命回复速度
        hpGen = 4,
        -- 从属性描述中获取法力值
        mpMax = 100,
        -- 从数值系统中的NPC属性获取法力回复速度
        mpGen = 5,
        -- 从属性描述中获取速度
        speed = 5,
        -- 从属性描述中获取力量（攻击力）
        strength = 30,
        -- 从属性描述中获取防御力
        defense = 15,
        -- 从属性描述中获取敏捷值
        agility = 25,
        -- 从数值系统中的NPC属性获取经验值
        exp = 150
    },
    -- 灵狐的技能列表
    skills = {
        "迅捷扑击",
        "幽光爪",
        "灵气闪避"
    },
    -- 灵狐是敌对NPC，设置为敌对阵营
    faction = 'faction_npc',
    -- 使用默认AI
    aiRoot = 'default',
    -- 根据AI描述，灵狐在玩家进入5米范围内开始攻击，设置仇恨范围为5
    hatredRange = 5,
    -- 灵狐能够移动
    canMove = true,
    -- 灵狐能够释放技能
    canCastSkill = true,
    -- 灵狐能够被攻击
    canBeAttack = true,
}
return M