local M = {}

function M.init()
    -- 按照设计文档初始化技能参数
    Skill_SetMPCost(45, "设置魔法消耗为45点")
    Skill_SetCooldown(3000, "设置技能冷却时间为3秒(3000毫秒)")
    Skill_SetCastRange(4, "设置施法范围为4米")
    Skill_SetMainTargetType("enemy", "设置主目标类型为敌人")
    Skill_SetDesc("灵豹迅速冲向目标，造成80点物理伤害并击退目标1米。", "近战冲锋攻击技能")
end

function M.cb()
    -- 选择主目标作为冲击对象
    Skill_CollectMainTarget("选择主目标作为冲击对象")
    
    -- 为自己添加移动速度提升50%的buff，持续1000毫秒（冲锋过程中的速度提升）
    Skill_SelfAddBuff('buff_speed', 1, 1000, {50}, "添加50%移动速度提升")
    
    -- 使用移动到目标API，速度缩放比例1.5（体现50%速度提升）
    Skill_MoveToTarget(1.5, "以1.5倍速冲向目标")
    
    -- 选择主目标造成80点物理伤害
    Skill_CollectMainTarget("再次选择主目标")
    Skill_TargetDamage('damage_physical', 80, "造成80点物理伤害")
    
    -- 为目标添加击退1米的buff，概率100%
    Skill_TargetEnemyAddBuff('buff_beat_back', 1, 0, {1}, "击退目标1米")
end

return M