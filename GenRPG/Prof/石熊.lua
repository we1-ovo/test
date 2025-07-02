local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "石熊",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "谷中段的中级妖兽，体型庞大，皮肤如岩石般坚硬的防御型敌人",
    type = "junior", -- 根据设计是中级妖兽，对应junior类型
    attackType = "melee", -- 石熊是近战攻击类型
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Props/SM_Prop_Animal_Head_Elephant_01.prefab", -- 选择类似熊的预制体
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Props_SM_Prop_Animal_Head_Elephant_01.png", -- 对应的头像
    -- prop是NPC的属性，参考数值系统中的中级妖兽基础数值并根据石熊特性调整
    prop = {
        -- 根据描述，石熊生命值约1800点
        hpMax = 1800,
        -- 生命回复速度适中
        hpGen = 5,
        -- 法力值适中
        mpMax = 200,
        -- 法力回复速度
        mpGen = 6,
        -- 描述中提到移动速度较慢4米/秒
        speed = 4,
        -- 近战攻击力强，基础攻击120点伤害
        strength = 120,
        -- 描述中提到具备80点护甲值，防御力突出
        defense = 80,
        -- 敏捷度较低，因为是防御型大型敌人
        agility = 20,
        -- 击败后给予的经验值，比普通NPC高
        exp = 300,
    },
    -- skills是NPC的技能列表，根据描述添加四个技能
    skills = {
        "岩石砸击",
        "地裂践踏",
        "岩肤护盾",
        "普通攻击",
    },
    -- 石熊属于敌对NPC阵营
    faction = 'faction_npc',
    -- 使用默认AI行为
    aiRoot = 'default',
    -- 仇恨范围设置为适中值，石熊会在发现玩家时主动攻击
    hatredRange = 10,
    -- 能够移动，但速度较慢
    canMove = true,
    -- 能够释放技能
    canCastSkill = true,
    -- 能够被攻击
    canBeAttack = true,
}
return M