local M = {
    -- NPC的模板TID
    id = "灵豹",
    -- NPC的描述
    desc = "谷中段中级妖兽，行动敏捷，擅长远程攻击和快速移动",
    -- NPC类型：boss、junior、senior中选择
    type = "junior", 
    -- 预制体名称，根据模型特征选择最合适的
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Props/SM_Prop_Animal_Head_Troll_01.prefab",
    -- 立绘头像
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Props_SM_Prop_Animal_Head_Troll_01.png",
    -- NPC的属性
    prop = {
        -- 最大生命值
        hpMax = 350,
        -- 生命回复速度
        hpGen = 3,
        -- 最大法力值
        mpMax = 100,
        -- 法力回复速度
        mpGen = 4,
        -- 速度(米/秒)
        speed = 7,
        -- 力量(攻击力)
        strength = 50,
        -- 防御
        defense = 10,
        -- 敏捷
        agility = 35,
        -- 死亡给予的经验值
        exp = 120,
    },
    -- NPC可以使用的技能列表
    skills = {
        "紫光能量弹",
        "闪电扑击",
        "幻影步",
    },
    -- 阵营：faction_player(玩家)、faction_neutral_npc(中立)、faction_npc(敌对)、faction_friend_npc(友方)
    faction = 'faction_npc',
    -- AI行为的根目录，使用default表示使用通用AI
    aiRoot = 'default',
    -- 仇恨范围(米)，在此范围内发现敌人会主动攻击
    hatredRange = 8,
    -- 是否能够释放技能战斗
    canCastSkill = true,
    -- 物品掉落列表
    drops = {
        -- 没有指定掉落物品，保留空列表
    },
    -- 是否能够被攻击
    canBeAttack = true,
}
return M