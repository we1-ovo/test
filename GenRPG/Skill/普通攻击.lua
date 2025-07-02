local M = {}

function M.init()
    -- 根据设计文档初始化技能参数
    Skill_SetMPCost(0, "设置魔法消耗为0点")
    Skill_SetCooldown(0, "设置技能冷却时间为0秒")
    Skill_SetCastRange(2, "设置施法范围为2米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("石熊挥动巨爪进行基础攻击，对单一目标造成100%攻击力的物理伤害")
end

function M.cb()
    -- 选择主目标（单一目标）
    Skill_CollectMainTarget("选择攻击目标")
    
    -- 技能释放过程中的攻击动作时间
    Skill_Sleep(300, "石熊挥动巨爪的攻击动作时间")
    
    -- 对目标造成100%攻击力的物理伤害
    Skill_TargetScaleDamage('damage_physical', 1.0, "造成100%攻击力的物理伤害")
end

return M