local M = {}

function M.init()
    -- 根据设计文档设置技能初始化参数
    Skill_SetMPCost(80, "设置技能魔法消耗为80点")
    Skill_SetCooldown(8, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置技能施法范围为0米（自身技能）")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("基础恢复仙术")
end

function M.cb()
    -- 选择自己作为技能目标
    Skill_CollectMainTarget("选择自己作为目标")
    
    -- 对自己造成负伤害实现治疗效果，治疗量为360点（约为最大生命值的30%）
    Skill_SelfDamage("damage_physical", -360, "治疗自己360点生命值（最大生命值的30%）")
    
    -- 添加一个简单的治疗特效提示，显示治疗成功
    Skill_Say("生命恢复！", 1)
end

return M