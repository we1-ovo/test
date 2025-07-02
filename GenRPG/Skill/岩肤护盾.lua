local M = {}

function M.init()
    -- 初始化技能参数
    Skill_SetMPCost(80, "设置魔法消耗为80点")
    Skill_SetCooldown(15, "设置技能冷却时间为15秒")
    Skill_SetCastRange(0, "设置施法距离为0（自身）")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("激活体表岩石能量，获得相当于最大生命值20%的护盾，持续5秒。护盾存在期间增加20%的物理抗性。")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 表现施法动作，0.5秒
    Skill_Sleep(500, "石熊施法，全身岩石纹路发光")
    
    -- 计算护盾值，为最大生命值的20%
    local maxHP = Skill_GetSelfMaxHP()
    local shieldValue = maxHP * 0.2
    
    -- 为自己添加一个物理护盾，持续5秒
    local shieldArgs = {shieldValue, 'shield_physical'}
    Skill_SelfAddBuff('buff_shield', 1, 5, shieldArgs, "添加物理护盾，护盾值为最大生命值的20%")
    
    -- 为自己添加物理抗性增加的buff（通过减少受到的攻击实现）
    Skill_SelfAddBuff('buff_attack', 1, 5, {-0.2}, "增加20%物理抗性（降低受到的攻击伤害）")
    
    -- 注册护盾破碎事件
    Skill_RegisterEvent("on_buff_end", function()
        -- 当护盾结束时，物理抗性buff也应该结束
        -- 在引擎实现中，两个buff是同时添加同时结束的，所以不需要额外处理
        -- 这里可以添加护盾破碎的视觉效果或者音效提示
    end)
    
    -- 等待5秒，技能持续时间
    Skill_Sleep(5000, "等待护盾持续时间结束")
end

return M