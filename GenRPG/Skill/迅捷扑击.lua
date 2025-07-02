local M = {}

function M.init()
    -- 设置魔法消耗为15点，因为灵狐法力值较低
    Skill_SetMPCost(15, "设置魔法消耗为15点")
    
    -- 设置技能冷却时间为2秒，符合设计文档要求
    Skill_SetCooldown(2, "设置技能冷却时间为2秒")
    
    -- 设置施法距离为2米，为近战攻击技能
    Skill_SetCastRange(2, "设置施法距离为2米")
    
    -- 设置目标类型为敌人，作为灵狐的基础攻击技能
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    
    -- 设置技能描述
    Skill_SetDesc("灵狐快速向目标扑去并进行爪击，对单一目标造成其攻击力1.2倍的物理伤害。")
end

function M.cb()
    -- 首先选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主要攻击目标")
    
    -- 使用移动API瞬移到目标位置，模拟灵狐快速扑击的动作
    Skill_TeleportToTarget()
    
    -- 添加技能释放效果，让灵狐在扑击时说出攻击台词
    Skill_Say("嗷呜！", 1)
    
    -- 对选中目标造成物理伤害，伤害值为灵狐攻击力的1.2倍
    Skill_TargetScaleDamage("damage_physical", 1.2, "造成1.2倍攻击力的物理伤害")
    
    -- 短暂延迟，表示攻击动作持续时间
    Skill_Sleep(500, "攻击动作持续时间")
end

return M