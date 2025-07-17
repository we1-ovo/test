local M = {}

function M.init()
    -- 技能初始化部分
    Skill_SetMPCost(35, "设置魔法消耗为35点")
    Skill_SetCooldown(8000, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置施法范围为0米（自身技能）")
    Skill_SetMainTargetType("self", "设置主目标类型为自己")
    Skill_SetDesc("短时间内提升移动速度60%，持续3秒，并产生紫色幻影残像。", "自身增益技能")
end

function M.cb()
    -- 技能释放逻辑部分
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 添加速度提升buff
    Skill_SelfAddBuff('buff_speed', 1, 3000, {60}, "添加60%移动速度提升，持续3秒")
    
    -- 创建自身区域效果，模拟幻影效果
    Skill_CreateSelfCircleRegion(0.5, 3000, "创建自身幻影效果区域")
    
    -- 技能释放期间，让角色全身闪烁幽蓝色光芒
    Skill_RegisterEvent("on_prop_change", function(propName, oldValue, newValue)
        if propName == "speed" and newValue > oldValue then
            -- 当速度提升时，说一句台词
            Skill_Say("如风一般!", 1000, "技能台词")
        end
    end, "监听速度变化")
    
    -- 等待技能效果持续时间
    Skill_Sleep(3000, "等待技能效果持续3秒")
end

return M