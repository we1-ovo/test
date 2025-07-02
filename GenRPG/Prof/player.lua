local M = {
    -- player的id为player，必须填写player
    id = "player",
    -- desc是Player的描述，会显示在Player信息中
    desc = "筑基期修仙者，初入仙途的修士",
    type = "player", -- 所有类型有: boss、junior、senior、player(当前是player类型必须填写player,禁止填其他类型)
    attackType = "ranged", -- 攻击类型有 melee(近战) 和 ranged(远程)，修仙者使用法术攻击，因此为远程
    prefab = "Assets/PolygonFantasyCharacters/Prefabs/Character_Male_Wizard_01.prefab", -- 预制体名称
    avatar = "Assets/Avatars/Assets_PolygonFantasyCharacters_Prefabs_Character_Male_Wizard_01.png", -- 立绘头像
    -- prop是Player的属性，根据设计文档和数值系统设计完成
    prop = {
        -- hpMax是最大生命值
        hpMax = 1200,
        -- hpGen是生命回复速度
        hpGen = 12,
        -- mpMax是最大法力值
        mpMax = 600,
        -- mpGen是法力回复速度
        mpGen = 8,
        -- speed是速度
        speed = 6,
        -- strength是力量
        strength = 60,
        -- defense是防御
        defense = 25,
        -- agility是敏捷
        agility = 40,
        -- exp字段对player无效，固定为0
        exp = 0,
    },
    -- skills是Player的技能，即可以使用的技能id列表,最多六个
    skills = {
        "灵气弹",
        "治疗术",
        "御风术",
        "烈焰符",
        "护体金光",
        "天雷诀",
    },
    -- faction表示阵营，player必须填写 'faction_player'（玩家）
    faction = 'faction_player',
    -- aiRoot是Player的AI行为的根目录。Player的AI行为逻辑，必须填写'default'即可
    aiRoot = 'default',
}

return M