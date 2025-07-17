-- NPC属性设置文件的完整示例与参数

local M = {
    -- id为@Terms.NpcTID，是NPC的模板TID，与文件名一致
    id = "无敌BOSS",
    -- desc是NPC的描述，会显示在NPC信息中
    desc = "第一阶段boss",
    type = "boss", -- 所有类型有: boss、junior、senior、player(当前是NPC类型,禁止选择player,只能从boss、junior、senior中选择)
    prefab = "", -- 预制体名称,框架会选择合适的预制体url
    avatar = "", -- 立绘头像,框架会选择合适的url
    -- prop是NPC的属性参考数值系统，包括最大生命值，生命回复速度，最大法力值，法力回复速度，速度，力量，防御，敏捷
    prop = {
        -- hpMax是最大生命值
        hpMax = 1000,
        -- hpGen是生命回复速度
        hpGen = 1,
        -- mpMax是最大法力值
        mpMax = 100,
        -- mpGen是法力回复速度
        mpGen = 1,
        -- speed是速度单位米/秒。如果speed为0，NPC无法移动, 属于木桩怪或者堡垒怪。
        speed = 5,
        -- strength是力量
        strength = 50,
        -- defense是防御
        defense = 10,
        -- agility是敏捷
        agility = 100,
        -- exp是NPC死亡时给予player的经验值
        exp = 1,
    },
    -- skills是NPC的技能，即可以使用的技能id列表
    skills = {
        "攻击",
        "变形",
    },
    -- faction表示阵营，根据设计文档分析NPC的阵营信息。包括'faction_player'、'faction_neutral_npc'、'faction_npc'和'faction_friend_npc'，详细说明如下：
    -- 'faction_player' 表示玩家
    -- 'faction_neutral_npc' 表示中立NPC，不参与任何战斗，玩家、敌对NPC和友方NPC都不可以攻击它
    -- 'faction_npc' 表示敌对NPC，与玩家faction_player和友方NPC:faction_friend_npc敌对，会互相攻击
    -- 'faction_friend_npc' 表示友方NPC，与玩家一个阵营，与敌对NPC:faction_npc敌对，会互相攻击
    faction = 'faction_npc',
    -- aiRoot是NPC的AI行为的根目录,需要根据NPC设计文档的'ai_desc'部分决策，当NPC有自定义AI行为时填写@Terms.NpcTID,优先级高于下面的hatredRange、speed(=0无法移动)、canCastSkill、canBeAttack，通用AI填default，主要靠hatredRange、speed(=0无法移动)、canCastSkill、canBeAttack进行调整。
    aiRoot = 'default',
    -- 仇恨范围,单位米, 如果敌对NPC或者Player在范围内，NPC会发起主动攻击.比如：被动怪:0, 大范围主动怪:100
    hatredRange=        0,
    -- NPC的AI行为描述,是否能够释放技能战斗,如果NPC无法战斗属于木桩怪。
    canCastSkill = true,
    drops = {
        -- NPC死亡物品掉落列表, 每个物品掉落包含itemTID(物品模板TID), probability(掉落概率百分比[0-100]), itemCount(每次掉落数量)
        { itemTID = "初级药水", probability = 50, itemCount=1 }, -- 掉落初级药水概率50%
    },
    -- NPC的AI行为描述, 是否能够被攻击，如果无法被攻击可能是友方无敌NPC或者装饰用。
    canBeAttack = true,
}
return M