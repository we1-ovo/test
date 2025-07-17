local M = {}

function M.init()
    -- 初始化技能基本参数
    Skill_SetMPCost(60, "设置技能魔法消耗为60点")
    Skill_SetCooldown(15000, "设置技能冷却时间为15秒(15000毫秒)")
    Skill_SetCastRange(0, "设置施法范围为0(只能对自己使用)")
    Skill_SetMainTargetType("self", "设置主目标类型为自己")
    Skill_SetDesc("老修士传授的身法仙术，提升移动速度。使用后移动速度提升50%，持续8秒。", "身法提升仙术")
end

function M.cb()
    -- 技能释放逻辑
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己为技能目标")
    
    -- 为自己添加加速buff，持续8秒，移动速度提升50%
    Skill_SelfAddBuff('buff_speed', 1, 8000, {50}, "御风术加速效果")
    
    -- 技能为瞬发buff，立即生效，无需额外等待时间
end

return M