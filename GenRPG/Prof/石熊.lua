local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "石熊",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "谷中段的中级妖兽，体型庞大，皮肤如岩石般坚硬。具有极高的防御力和生命值，但移动速度较慢。",
    type = "senior", -- 根据设计，石熊是谷中段的中级妖兽，所以选择senior类型
    attackType = "melee", -- 根据设计，石熊以近战物理攻击为主
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Props/SM_Prop_Animal_Head_Troll_01.prefab", -- 选择了类似熊头的模型
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Props_SM_Prop_Animal_Head_Troll_01.png",
    -- prop是NPC的属性参考数值系统
    prop = {
        -- 根据设计文档，石熊生命值1200
        hpMax = 1200,
        -- 生命回复速度设置为中等值
        hpGen = 8,
        -- 设置适中的法力值以支持技能释放
        mpMax = 300,
        -- 法力回复速度
        mpGen = 6,
        -- 根据设计文档，石熊速度4
        speed = 4,
        -- 根据设计文档，石熊攻击力120
        strength = 120,
        -- 根据设计文档，石熊防御力60
        defense = 60,
        -- 敏捷度较低，与速度慢相符
        agility = 25,
        -- 作为中级妖兽，提供中等经验值
        exp = 600,
    },
    -- skills是NPC的技能，根据设计文档中的技能列表
    skills = {
        "岩石拳击",
        "大地践踏",
        "岩石护盾",
    },
    -- 石熊属于敌对NPC，与玩家敌对
    faction = 'faction_npc',
    -- 使用默认AI行为
    aiRoot = 'default',
    -- 根据AI描述，石熊在玩家进入10米范围内时会发现并追击
    hatredRange = 10,
    -- 石熊能够移动，虽然速度较慢
    canMove = true,
    -- 石熊可以释放技能战斗
    canCastSkill = true,
    -- 石熊可以被攻击
    canBeAttack = true,
}
return M