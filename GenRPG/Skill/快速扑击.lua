local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(10, "设置魔法消耗为10点")
    Skill_SetCooldown(3, "设置技能冷却时间为3秒")
    Skill_SetCastRange(2, "设置技能施法距离为2米，符合近战技能设计")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("灵狐快速向目标扑去，造成15点物理伤害")
end

function M.cb()
    -- 选择敌方目标
    Skill_CollectMainTarget("选择敌方目标作为主目标")
    
    -- 灵狐快速移动到目标位置
    Skill_MoveToTarget(1.5)
    
    -- 短暂前摇动作
    Skill_Sleep(200, "短暂的前摇动作")
    
    -- 对目标造成物理伤害
    Skill_TargetDamage('damage_physical', 15, "造成15点物理伤害")
end

return M