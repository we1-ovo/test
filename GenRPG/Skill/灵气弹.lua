local M = {}

function M.init()
    -- 根据设计文档设置技能基础参数
    Skill_SetMPCost(50, "设置魔法消耗为50点MP")
    Skill_SetCooldown(2, "设置技能冷却时间为2秒")
    Skill_SetCastRange(8, "设置施法距离为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("基础远程攻击仙术，凝聚天地灵气形成能量弹投射向敌人，造成魔法伤害")
end

function M.cb()
    -- 选择敌方目标
    Skill_CollectMainTarget("选择主要敌人目标")
    
    -- 对目标造成伤害，伤害值为攻击力的1.5倍
    Skill_TargetScaleDamage('damage_magic', 1.5, "造成1.5倍攻击力的魔法伤害")
end

return M