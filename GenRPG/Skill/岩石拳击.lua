local M = {}

function M.init()
    -- 技能初始化设置
    Skill_SetCooldown(4, "设置技能冷却时间为4秒")
    Skill_SetCastRange(2, "设置施法距离为2米，对应石熊的近战攻击范围")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetMPCost(0, "技能不消耗MP值，因为是NPC基础攻击技能")
    Skill_SetDesc("石熊的基础攻击技能，用坚硬如岩石的前爪猛击敌人，造成物理伤害")
end

function M.cb()
    -- 选择当前目标
    Skill_CollectMainTarget("选择当前目标")
    
    -- 石熊攻击时发出吼叫
    Skill_Say("吼！", 1)
    
    -- 造成物理伤害，伤害值为石熊攻击力的100%
    Skill_TargetScaleDamage("damage_physical", 1.0, "造成物理伤害，伤害值为石熊攻击力的100%")
    
    -- 模拟攻击命中时的震动效果
    -- 创建一个小范围的震动效果区域
    Skill_CreateTargetPosCircleRegion(1, 1, "创建震动效果区域")
    
    -- 添加短暂的击退效果来增强打击感
    Skill_CollectMainTarget("再次选择目标用于添加击退效果")
    Skill_TargetEnemyAddBuff("buff_beat_back", 0.8, 0.2, {1}, "80%几率添加小幅击退效果")
end

return M