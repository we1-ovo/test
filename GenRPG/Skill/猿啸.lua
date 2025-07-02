local M = {}

function M.init()
    -- 根据设计文档初始化技能参数
    Skill_SetMPCost(40, "设置魔法消耗为40点")
    Skill_SetCooldown(20, "设置技能冷却时间为20秒")
    Skill_SetCastRange(0, "设置技能施法范围为0米（自身技能）")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("山猿仰天长啸，增强自身攻击力并吸引周围的妖兽")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 检查当前血量，如果低于40%，理论上应该由AI决定更容易触发此技能
    -- 但这里我们只能在技能已经被触发后记录日志，因为技能触发决策不在技能系统内
    local currentHP = Skill_GetSelfHP()
    local maxHP = Skill_GetSelfMaxHP()
    local hpPercent = currentHP / maxHP
    
    if hpPercent < 0.4 then
        -- 血量低于40%时记录日志
        -- 注：实际触发概率控制应该在AI决策部分，这里只是记录状态
        Skill_Say("吾命休矣，兄弟们速来相助！", 2)
    else
        -- 正常喊话
        Skill_Say("兄弟们，一起上！", 2)
    end
    
    -- 为自身添加攻击力增加20%的buff，持续10秒
    Skill_SelfAddBuff("buff_attack", 1, 10, {0.2}, "为自身添加攻击力增加20%的buff，持续10秒")
    
    -- 创建以自身为中心的5米半径圆形区域，持续3秒
    -- 使用跟随自身的圆形buff区域
    Skill_CreateSelfCircleRegion(5, 3, "创建以自身为中心的5米半径圆形区域，持续3秒")
    
    -- 区域效果会让附近的友方单位（其他山猿和灵狐）提高对玩家的仇恨值
    -- 我们使用一个攻击力buff作为标记，表示这些单位已经被吸引
    -- 实际的仇恨值提高逻辑应该在AI系统中处理
    Region_AddStayBuff("buff_attack", 1, 5, {0.1}, "friend", "标记区域内的友方单位，使它们注意到玩家")
    
    -- 技能释放时的动作和效果展示
    Skill_Sleep(1000, "山猿做出仰天长啸的动作")
    
    -- 等待技能区域效果结束
    Skill_Sleep(2000, "等待技能效果结束")
end

return M