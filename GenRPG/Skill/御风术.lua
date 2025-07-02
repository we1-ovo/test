local M = {}

function M.init()
    -- 根据设计文档设置技能基础属性
    Skill_SetMPCost(60, "设置技能魔法消耗为60点")
    Skill_SetCooldown(15, "设置技能冷却时间为15秒")
    Skill_SetCastRange(0, "设置技能施法范围为0米（自身技能）")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("身法仙术，运用风系灵力大幅提升移动速度，持续一段时间。使用后移动速度提升50%，持续8秒。")
end

function M.cb()
    -- 技能释放逻辑
    -- 选择自己为目标
    Skill_CollectMainTarget("选择自己为目标")
    
    -- 为自己添加移动速度提升buff，提升50%，持续8秒
    Skill_SelfAddBuff("buff_speed", 1, 8, {0.5}, "为自己添加移动速度提升50%的buff，持续8秒")
    
    -- 添加一些视觉反馈
    Skill_Say("风随我行！", 2)
    
    -- 等待buff持续时间结束
    Skill_Sleep(8000, "等待移动速度增益效果持续时间")
end

return M