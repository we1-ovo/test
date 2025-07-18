local M = {
    -- player的id为player，必须填写player
    id = "player",
    -- 根据设计文档中的描述，生成一个简要的描述
    desc = "筑基期修仙者，初入仙途的修士，拥有扎实的仙术修为基础和较强的法力储备",
    -- 玩家类型必须填写player
    type = "player",
    -- 预制体名称，选择的是法师模型
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Characters/SM_Chr_Mage_01.prefab",
    -- 立绘头像
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Characters_SM_Chr_Mage_01.png",
    -- prop是Player的属性，根据设计文档和数值系统设计完成
    prop = {
        -- 最大生命值
        hpMax = 1000,
        -- 生命回复速度
        hpGen = 10,
        -- 最大法力值
        mpMax = 600,
        -- 法力回复速度
        mpGen = 8,
        -- 速度
        speed = 6,
        -- 力量
        strength = 75,
        -- 防御
        defense = 20,
        -- 敏捷
        agility = 50,
        -- exp字段对player无效，固定为0
        exp = 0,
    },
    -- skills是Player的技能，即可以使用的技能id列表
    skills = {
        "灵气弹",
        "治疗术",
        "御风术",
        "烈焰符",
        "护体金光",
        "天雷诀",
    },
    -- faction表示阵营，player必须填写 'faction_player'
    faction = 'faction_player',
    -- aiRoot是Player的AI行为的根目录。Player的AI行为逻辑，必须填写'default'
    aiRoot = 'default',
}

return M