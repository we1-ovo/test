local M = {
    -- id为千年蛟龙，是NPC的模板TID，与文件名一致
    id = "千年蛟龙",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "灵草谷的最终BOSS，守护着千年灵草的珍贵妖兽，拥有强大的攻击和防御能力",
    type = "boss", -- 千年蛟龙是BOSS级别的NPC
    attackType = "melee", -- 虽然有远程技能，但蛟龙本身为近战单位
    prefab = "Assets/Toon_RTS/WesternKingdoms/prefabs/WK_Cavalry_Mage_B.prefab", -- 从提供的模型列表中选择
    avatar = "Assets/Avatars/Assets_Toon_RTS_WesternKingdoms_prefabs_WK_Cavalry_Mage_B.png", -- 对应的头像
    -- prop是NPC的属性，参考数值系统中Boss的属性设计
    prop = {
        -- hpMax是最大生命值
        hpMax = 7000,
        -- hpGen是生命回复速度
        hpGen = 35,
        -- mpMax是最大法力值
        mpMax = 1800,
        -- mpGen是法力回复速度
        mpGen = 18,
        -- speed是速度
        speed = 7,
        -- strength是力量
        strength = 150,
        -- defense是防御
        defense = 70,
        -- agility是敏捷
        agility = 50,
        -- exp是NPC死亡时给予player的经验值
        exp = 4000,
    },
    -- skills是NPC的技能列表，包含所有可以使用的技能ID
    skills = {
        "龙息",
        "雷电攻击",
        "鳞甲护体",
        "龙影闪",
        "尾击扫荡"
    },
    -- 千年蛟龙属于敌对NPC阵营
    faction = 'faction_npc',
    -- 使用自定义AI行为
    aiRoot = '千年蛟龙',
    -- 仇恨范围为15米，在此范围内发现玩家会主动攻击
    hatredRange = 15,
    -- 千年蛟龙可以移动
    canMove = true,
    -- 千年蛟龙可以释放技能
    canCastSkill = true,
    -- 千年蛟龙可以被攻击
    canBeAttack = true,
}
return M