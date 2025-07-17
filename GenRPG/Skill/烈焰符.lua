local M = {}

function M.init()
    -- 设置技能魔法消耗为100点
    Skill_SetMPCost(100, "设置魔法消耗为100点")
    -- 设置技能冷却时间为6000毫秒(6秒)
    Skill_SetCooldown(6000, "设置冷却时间为6秒")
    -- 设置施法范围为8米
    Skill_SetCastRange(8, "设置施法距离为8米")
    -- 设置主目标类型为敌人
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    -- 设置技能描述为火系范围攻击仙术
    Skill_SetDesc("火系范围攻击仙术。投掷符咒产生烈焰爆炸，造成范围伤害。", "烈焰符")
end

function M.cb()
    -- 使用Skill_CollectMainTarget()选择主要目标确定爆炸中心
    Skill_CollectMainTarget("选择烈焰符爆炸中心点")
    
    -- 使用Skill_CollectCircleTargets(3, 5, '烈焰符范围伤害')选择爆炸半径3米内最多5个敌人
    Skill_CollectCircleTargets(3, 5, "烈焰符范围伤害")
    
    -- 使用Skill_TargetScaleDamage('damage_magic', 2, '烈焰符伤害')对所有选中目标造成2倍攻击力的魔法伤害
    Skill_TargetScaleDamage("damage_magic", 2, "烈焰符伤害")
end

return M