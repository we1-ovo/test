local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(0, "技能不消耗魔法值")
    Skill_SetCooldown(4000, "技能冷却时间为4秒")
    Skill_SetCastRange(2, "技能施法范围为2米，近战攻击距离")
    Skill_SetMainTargetType("enemy", "技能主目标类型为敌人")
    Skill_SetDesc("灵狐迅速向目标扑去，造成物理伤害", "描述快速扑击技能效果")
end

function M.cb()
    -- 技能释放逻辑部分
    
    -- 向目标方向快速移动6米，速度为自身基础速度的1.5倍
    Skill_MoveTo(0, 7.5, 6, "向目标方向快速扑击移动")
    
    -- 移动完成后，选择主目标进行攻击
    Skill_CollectMainTarget("选择扑击目标")
    
    -- 对目标造成0.8倍攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 0.8, "造成0.8倍攻击力物理伤害")
end

return M