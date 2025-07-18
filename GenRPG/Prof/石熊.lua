-- 石熊NPC属性设置文件

local M = {
    -- id为NpcTID，是NPC的模板TID，与文件名一致
    id = "石熊",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "深谷中的中级妖兽，拥有坚硬如石的外皮，防御力极高但移动较慢",
    type = "junior", -- 从boss、junior、senior中选择
    -- 选择合适的预制体模型 - 选择类似熊形态且具有石头质感的模型
    prefab = "Assets/PolygonFantasyKingdom/Prefabs/Props/SM_Prop_Animal_Head_PigButcher_01.prefab",
    avatar = "Assets/Avatars/Assets_PolygonFantasyKingdom_Prefabs_Props_SM_Prop_Animal_Head_PigButcher_01.png",
    -- prop是NPC的属性参考数值系统
    prop = {
        -- hpMax是最大生命值
        hpMax = 550,
        -- hpGen是生命回复速度
        hpGen = 5,
        -- mpMax是最大法力值
        mpMax = 100,
        -- mpGen是法力回复速度
        mpGen = 5,
        -- speed是速度单位米/秒。如果speed为0，NPC无法移动
        speed = 3.5,
        -- strength是力量
        strength = 60,
        -- defense是防御
        defense = 35,
        -- agility是敏捷
        agility = 20,
        -- exp是NPC死亡时给予player的经验值
        exp = 180,
    },
    -- skills是NPC的技能，即可以使用的技能id列表
    skills = {
        "石拳重击",
        "大地践踏",
        "岩石护甲",
    },
    -- faction表示阵营
    -- 'faction_player' 表示玩家
    -- 'faction_neutral_npc' 表示中立NPC，不参与任何战斗
    -- 'faction_npc' 表示敌对NPC，与玩家和友方NPC敌对
    -- 'faction_friend_npc' 表示友方NPC，与玩家一个阵营
    faction = 'faction_npc',
    -- aiRoot是NPC的AI行为的根目录
    aiRoot = 'default',
    -- 仇恨范围,单位米, 如果敌对NPC或者Player在范围内，NPC会发起主动攻击
    hatredRange = 8,
    -- NPC的AI行为描述,是否能够释放技能战斗
    canCastSkill = true,
    drops = {
        -- NPC死亡物品掉落列表
        { itemTID = "石材碎片", probability = 70, itemCount = 1 }, -- 掉落石材碎片概率70%
        { itemTID = "熊皮", probability = 40, itemCount = 1 }, -- 掉落熊皮概率40%
        { itemTID = "中级灵石", probability = 20, itemCount = 1 }, -- 掉落中级灵石概率20%
    },
    -- NPC的AI行为描述, 是否能够被攻击
    canBeAttack = true,
}
return M