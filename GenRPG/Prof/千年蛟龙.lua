local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "千年蛟龙",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "盘踞在灵草谷谷底守护千年灵草的强大妖兽，通体鳞片闪烁金光，双眼如灯笼般发光",
    type = "boss", -- 千年蛟龙作为最终Boss，类型为boss
    attackType = "melee", -- 攻击类型为近战
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Characters/SM_Chr_Mage_01.prefab", -- 选择了一个合适的角色模型
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Characters_SM_Chr_Mage_01.png", -- 对应的头像
    -- prop是NPC的属性，参考数值系统中Boss的设计
    prop = {
        -- hpMax是最大生命值
        hpMax = 6000,
        -- hpGen是生命回复速度
        hpGen = 30,
        -- mpMax是最大法力值
        mpMax = 1500,
        -- mpGen是法力回复速度
        mpGen = 15,
        -- speed是速度
        speed = 8,
        -- strength是力量
        strength = 180,
        -- defense是防御
        defense = 80,
        -- agility是敏捷
        agility = 60,
        -- exp是NPC死亡时给予player的经验值
        exp = 3000,
    },
    -- skills是NPC的技能，即可以使用的技能id列表
    skills = {
        "龙息",
        "雷电攻击",
        "尾击扫荡",
        "龙鳞护体",
        "蛟龙咆哮",
        "普通攻击"
    },
    -- faction表示阵营，千年蛟龙是敌对NPC
    faction = 'faction_npc',
    -- aiRoot是NPC的AI行为的根目录，设置为自定义的千年蛟龙AI
    aiRoot = '千年蛟龙',
    -- 仇恨范围15米，Boss会主动攻击进入范围的玩家
    hatredRange = 15,
    -- NPC可以移动
    canMove = true,
    -- NPC可以释放技能战斗
    canCastSkill = true,
    -- NPC可以被攻击
    canBeAttack = true,
}
return M