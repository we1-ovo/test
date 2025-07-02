local M = {
    -- id为NpcTID，是NPC的模板TID
    id = "灵豹",
    -- desc是NPC的描述
    desc = "谷中段的中级妖兽，体型优雅，毛色深紫，速度极快，是深谷探索阶段的主要对手之一",
    -- NPC类型：boss、junior、senior
    type = "senior",
    -- 攻击类型：melee(近战)或ranged(远程)
    attackType = "ranged",
    -- 预制体名称，选择更接近动物形态的模型
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Props/SM_Prop_Sign_Iron_06.prefab",
    -- 立绘头像
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Props_SM_Prop_Sign_Iron_06.png",
    -- prop是NPC的属性
    prop = {
        -- 最大生命值
        hpMax = 800,
        -- 生命回复速度
        hpGen = 5,
        -- 最大法力值
        mpMax = 200,
        -- 法力回复速度
        mpGen = 5,
        -- 速度
        speed = 8,
        -- 力量
        strength = 45,
        -- 防御
        defense = 25,
        -- 敏捷
        agility = 70,
        -- 死亡时给予player的经验值
        exp = 500,
    },
    -- skills是NPC的技能列表
    skills = {
        "豹影扑击",
        "灵能光弹",
        "灵巧闪避",
    },
    -- faction表示阵营
    faction = 'faction_npc',
    -- aiRoot是NPC的AI行为的根目录
    aiRoot = 'default',
    -- 仇恨范围，单位米
    hatredRange = 15,
    -- 是否能够移动
    canMove = true,
    -- 是否能够释放技能战斗
    canCastSkill = true,
    -- 是否能够被攻击
    canBeAttack = true,
}
return M