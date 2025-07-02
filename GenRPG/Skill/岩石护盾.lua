local M = {}

function M.init()
    -- 技能初始化设置
    Skill_SetCooldown(12, "设置技能冷却时间为12秒")
    Skill_SetCastRange(0, "设置施法距离为0米，因为是自身增益技能")
    Skill_SetMainTargetType("self", "设置目标类型为自身")
    Skill_SetMPCost(0, "技能不消耗MP值，为NPC的自我保护技能")
    Skill_SetDesc("石熊激活体表的岩石特性，形成一层临时护盾，吸收一定量的伤害。护盾值为最大生命值的15%，持续5秒。")
end

function M.cb()
    -- 选择自身作为技能目标
    Skill_CollectMainTarget("选择自身作为技能目标")
    
    -- 获取最大生命值并计算护盾值
    local maxHP = Skill_GetSelfMaxHP()
    local shieldValue = maxHP * 0.15 -- 护盾值为最大生命值的15%
    
    -- 添加物理护盾效果，持续5秒
    local buffArgs = {shieldValue, 'shield_physical'}
    Skill_SelfAddBuff('buff_shield', 1, 5, buffArgs, "添加岩石护盾，护盾值为最大生命值的15%")
    
    -- 技能释放时喊话，视觉表现强化
    Skill_Say("岩石护盾！", 2)
    
    -- 创建岩石碎片环绕效果，视觉上强化护盾形成过程
    Skill_CreateSelfCircleRegion(1.5, 1, "创建岩石护盾视觉效果区域")
    
    -- 注册护盾结束事件，当护盾结束时恢复正常外观
    Skill_RegisterEvent("on_buff_end", function()
        -- 护盾结束时的效果，可以在这里添加视觉或音效提示
        Skill_Say("护盾消失了...", 1)
    end)
    
    -- 等待护盾持续时间
    Skill_Sleep(5000, "等待护盾持续时间结束")
end

return M