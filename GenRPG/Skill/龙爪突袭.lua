local M = {}

function M.init()
    -- 根据设计文档初始化技能属性
    Skill_SetMPCost(50, "设置魔法消耗为50点")
    Skill_SetCooldown(5000, "设置冷却时间为5秒")
    Skill_SetCastRange(5, "设置突袭最大距离为5米")
    Skill_SetMainTargetType("enemy", "设置目标为敌人")
    Skill_SetDesc("千年蛟龙的近战突袭技能，迅速向前方目标冲刺并挥动锋利龙爪。突袭距离5米，造成基础攻击力1.4倍的物理伤害，并击退目标2米。冲刺过程中不可被打断，但有0.5秒的前摇时间。冷却时间5秒。", "龙爪突袭技能描述")
end

function M.cb()
    -- 选择主目标作为突袭对象
    Skill_CollectMainTarget("选择突袭目标")
    
    -- 技能前摇时间0.5秒
    Skill_Sleep(500, "技能前摇0.5秒")
    
    -- 以2倍速度冲向目标，实现突袭效果
    Skill_MoveToTarget(2, "以2倍速度冲向目标")
    
    -- 造成1.4倍攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 1.4, "造成1.4倍攻击力的物理伤害")
    
    -- 击退目标2米
    Skill_TargetEnemyAddBuff("buff_beat_back", 1, 500, {2}, "击退目标2米")
end

return M