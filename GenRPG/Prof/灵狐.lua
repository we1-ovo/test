local M = {
    -- id为NPC的模板TID，与文件名一致
    id = "灵狐",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "谷口区域的低级妖兽，体型小巧，毛色银白，双眼发出幽蓝光芒，速度极快但攻击力较弱",
    type = "junior", -- 从boss、junior、senior中选择，灵狐是低级妖兽，选择junior
    attackType = "melee", -- 灵狐是近战攻击类型
    prefab = "Assets/PolygonApocalypse/Prefabs/Characters/Chr_Attach/SM_Chr_Attach_Zombie_Female_Hair_02.prefab", -- 预制体名称
    avatar = "Assets/Avatars/Assets_PolygonApocalypse_Prefabs_Characters_Chr_Attach_SM_Chr_Attach_Zombie_Female_Hair_02.png", -- 立绘头像
    -- prop是NPC的属性参考数值系统
    prop = {
        -- hpMax是最大生命值
        hpMax = 300,
        -- hpGen是生命回复速度
        hpGen = 3,
        -- mpMax是最大法力值
        mpMax = 80,
        -- mpGen是法力回复速度
        mpGen = 4,
        -- speed是速度，灵狐速度快
        speed = 5,
        -- strength是力量，攻击力中低
        strength = 15,
        -- defense是防御，灵狐防御力低
        defense = 5,
        -- agility是敏捷，灵狐敏捷度高
        agility = 20,
        -- exp是NPC死亡时给予player的经验值
        exp = 120,
    },
    -- skills是NPC的技能，即可以使用的技能id列表
    skills = {
        "快速扑击",
        "爪击",
        "敏捷闪避",
    },
    -- faction表示阵营，灵狐是敌对NPC，选择faction_npc
    faction = 'faction_npc',
    -- aiRoot是NPC的AI行为的根目录
    aiRoot = 'default',
    -- 仇恨范围8米，根据AI描述中的感知范围
    hatredRange = 8,
    -- 灵狐可以移动
    canMove = true,
    -- 灵狐可以释放技能
    canCastSkill = true,
    -- 灵狐可以被攻击
    canBeAttack = true,
}
return M