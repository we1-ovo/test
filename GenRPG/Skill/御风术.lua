local M = {}

function M.init()
    -- 根据设计文档设置技能的基本属性
    Skill_SetMPCost(60, "设置魔法消耗为60点MP")
    Skill_SetCooldown(15, "设置技能冷却时间为15秒")
    Skill_SetCastRange(0, "设置施法距离为0米（自身技能）")
    Skill_SetMainTargetType("self", "设置目标类型为自身")
    Skill_SetDesc("身法仙术，提升移动速度")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 为自己添加加速buff，移动速度提升50%，持续8秒
    Skill_SelfAddBuff('buff_speed', 1, 8, {0.5}, "增加50%移动速度持续8秒")
    
    -- 可选：添加技能效果的视觉表现
    Skill_Say("御风而行！", 2)
    
    -- 等待buff结束
    Skill_Sleep(8000, "等待加速效果持续时间")
end

return M