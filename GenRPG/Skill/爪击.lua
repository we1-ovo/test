local M = {}

function M.init()
    -- 技能初始化设置
    Skill_SetMPCost(0, "技能不消耗魔法值")
    Skill_SetCooldown(2000, "技能冷却时间为2秒")
    Skill_SetCastRange(2, "近战攻击距离2米")
    Skill_SetMainTargetType("enemy", "目标类型为敌人")
    Skill_SetDesc("灵狐使用锋利的爪子攻击目标，造成物理伤害", "基础攻击技能描述")
end

function M.cb()
    -- 选择主目标进行攻击
    Skill_CollectMainTarget("选择爪击的目标")
    
    -- 对目标造成1.0倍攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 1.0, "造成1.0倍攻击力物理伤害")
    
    -- 可以添加简单的攻击音效或视觉效果（通过子物体实现）
    Skill_CreateStaticSubObjAtTargetPos(500, "创建爪击效果")
end

return M