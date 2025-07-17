local M = {}

function M.init()
    -- 按照设计文档设置技能初始化参数
    Skill_SetMPCost(80, "设置技能魔法消耗为80点")
    Skill_SetCooldown(8000, "设置技能冷却时间为8秒(8000毫秒)")
    Skill_SetCastRange(0, "设置施法范围为0(只能对自己使用)")
    Skill_SetMainTargetType("self", "设置主目标类型为自己")
    Skill_SetDesc("基础治疗仙术，运用生命灵气为自身疗伤。瞬间恢复360点生命值(最大生命的30%)。", "基础治疗仙术")
end

function M.cb()
    -- 实现技能释放逻辑
    Skill_CollectMainTarget("选择自己作为目标")
    
    -- 使用伤害API进行治疗(负数代表治疗)
    Skill_SelfDamage("damage_physical", -360, "治疗术恢复360点生命值")
end

return M