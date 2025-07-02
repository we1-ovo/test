local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "山猿",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "谷口区域的低级妖兽，体型中等，毛色棕褐，力大无穷，行动笨拙但攻击力强大",
    type = "junior", -- 低级妖兽属于junior类型
    attackType = "melee", -- 山猿主要是近战攻击类型
    prefab = "Assets/PolygonFantasyCharacters/Prefabs/FixedScaleCharacters/Character_Male_Baird.prefab", -- 选择一个类似猿类的模型
    avatar = "Assets/Avatars/Assets_PolygonFantasyCharacters_Prefabs_FixedScaleCharacters_Character_Male_Baird.png", -- 对应的头像
    -- prop是NPC的属性参考数值系统
    prop = {
        -- 根据设计文档提供的具体数值
        hpMax = 450, -- 最大生命值，略高于灵狐
        hpGen = 5,   -- 生命回复速度，基于基础数值设定
        mpMax = 100, -- 最大法力值，用于维持基本技能释放
        mpGen = 4,   -- 法力回复速度，基于基础数值设定
        speed = 4.5, -- 速度，低于灵狐，体现其行动笨拙但力量强大的特点
        strength = 25, -- 力量，高于灵狐，体现其力大无穷的设定
        defense = 15, -- 防御，高于灵狐，皮糙肉厚
        agility = 15, -- 敏捷，低于灵狐，移动和反应都较慢
        exp = 150,    -- 经验值，击败后获得的经验值较灵狐略高
    },
    -- skills是NPC的技能，可以使用的技能id列表
    skills = {
        "猿拳",
        "投掷石块",
        "猿啸",
        "猛击地面",
    },
    -- faction表示阵营，山猿是敌对NPC
    faction = 'faction_npc',
    -- aiRoot是NPC的AI行为的根目录
    aiRoot = 'default',
    -- 仇恨范围10米，比灵狐稍大，会主动发现并追击玩家
    hatredRange = 10,
    -- NPC可以移动
    canMove = true,
    -- NPC可以释放技能战斗
    canCastSkill = true,
    -- NPC可以被攻击
    canBeAttack = true,
}
return M