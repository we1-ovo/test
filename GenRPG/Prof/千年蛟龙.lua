-- 千年蛟龙Boss属性配置文件

local M = {
    -- NPC模板ID
    id = "千年蛟龙",
    -- NPC描述信息
    desc = "盘踞灵草谷底守护千年灵草的强大妖兽，经过千年修炼积累了深厚的妖力修为。金光鳞片覆盖全身，双眼如灯笼明亮发光。",
    -- NPC类型：boss、junior、senior中选择
    type = "boss",
    -- 预制体名称，根据外观描述选择龙型生物模型
    prefab = "Assets/PolygonNature/Prefabs/Plants/SM_Plant_01.prefab",
    -- 头像图片URL
    avatar = "Assets/Avatars/Assets_PolygonNature_Prefabs_Plants_SM_Plant_01.png",
    -- 基础属性配置，参考数值系统中Boss的数值
    prop = {
        -- 最大生命值
        hpMax = 4500,
        -- 生命回复速度(每秒)
        hpGen = 25,
        -- 最大法力值
        mpMax = 1500,
        -- 法力回复速度(每秒)
        mpGen = 15,
        -- 移动速度(米/秒)
        speed = 7,
        -- 力量属性
        strength = 120,
        -- 防御属性
        defense = 45,
        -- 敏捷属性
        agility = 60,
        -- 击败后给予玩家的经验值
        exp = 3500,
    },
    -- 技能列表
    skills = {
        "龙息",
        "雷电攻击",
        "尾击扫荡",
        "龙鳞护体",
        "龙威震慑"
    },
    -- 阵营设置：敌对NPC，与玩家敌对
    faction = 'faction_npc',
    -- AI行为根目录，设置为自定义AI
    aiRoot = "千年蛟龙",
    -- 仇恨范围(米)，超出范围不会主动攻击
    hatredRange = 15,
    -- 是否能释放技能
    canCastSkill = true,
    -- 掉落物品列表
    drops = {
        { itemTID = "千年灵草", probability = 100, itemCount = 1 }, -- 必定掉落千年灵草
        { itemTID = "龙鳞", probability = 75, itemCount = 2 }, -- 75%概率掉落2片龙鳞
        { itemTID = "高级恢复丹", probability = 50, itemCount = 1 }, -- 50%概率掉落高级恢复丹
    },
    -- 是否可被攻击
    canBeAttack = true,
}

return M