local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(80, "设置魔法消耗为80点")
    Skill_SetCooldown(8000, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置施法范围为0(只能对自己使用)")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("基础治疗仙术，运用生命灵气为自身疗伤。瞬间恢复300点生命值(最大生命的30%)。", "基础治疗仙术")
end

function M.cb()
    -- 技能释放逻辑部分
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为治疗目标")
    
    -- 直接使用固定值300作为治疗量
    Skill_SelfDamage("damage_physical", -300, "治疗自身生命值300点")
end

return M