local M = {}

function M.init()
    -- 技能初始化设置
    Skill_SetMPCost(0, "设置魔法消耗为0点(被动触发型技能)")
    Skill_SetCooldown(15, "设置技能冷却时间为15秒")
    Skill_SetCastRange(0, "设置施法距离为0米(自身技能)")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("灵豹凭借敏捷的身手快速闪避，短时间内大幅提升移动速度。当生命值低于30%时自动触发，提升移动速度50%，持续4秒，冷却时间15秒。")
end

function M.cb()
    -- 检查是否满足触发条件(生命值低于30%)
    local currentHP = Skill_GetSelfHP()
    local maxHP = Skill_GetSelfMaxHP()
    local hpPercent = currentHP / maxHP
    
    if hpPercent > 0.3 then
        -- 生命值高于30%，不触发技能
        Skill_Cancel()
        return
    end
    
    -- 选择自己作为技能目标
    Skill_CollectMainTarget("选择自己为技能目标")
    
    -- 创建速度增益buff，移动速度提升50%，持续4秒
    Skill_SelfAddBuff('buff_speed', 1, 4, {0.5}, "添加50%移动速度增益，持续4秒")
    
    -- 在自身位置创建视觉特效(淡紫色灵气)，持续4秒
    Skill_CreateSelfCircleRegion(0.5, 4, "创建淡紫色灵气特效")
    
    -- 播报技能触发消息
    Skill_Say("灵巧闪避已激活！", 2)
    
    -- 等待技能持续时间结束
    Skill_Sleep(4000, "等待技能持续时间结束")
end

return M