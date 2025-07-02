local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(80, "设置魔法消耗为80点")
    Skill_SetCooldown(30, "设置技能冷却时间为30秒")
    Skill_SetCastRange(0, "设置施法距离为0（自身）")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("血量降至30%以下时激活的被动技能，鳞片闪耀金光，获得一个能吸收800点伤害的护盾，持续8秒。护盾存在期间物理抗性提升30%。")
end

function M.cb()
    -- 技能释放逻辑部分
    
    -- 检查血量是否低于30%
    local currentHP = Skill_GetSelfHP()
    local maxHP = Skill_GetSelfMaxHP()
    local hpPercent = currentHP / maxHP
    
    -- 如果血量高于30%，取消技能释放
    if hpPercent > 0.3 then
        Skill_Say("血量未达到触发条件", 2)
        Skill_Cancel()
        return
    end
    
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自身为技能目标")
    
    -- 添加护盾buff，护盾值为800，物理护盾类型
    local shieldArgs = {800, 'shield_physical'}
    Skill_SelfAddBuff('buff_shield', 1, 8, shieldArgs, "添加800点物理护盾，持续8秒")
    
    -- 添加物理抗性提升buff（通过减少受到的攻击伤害实现）
    -- 目前API中没有直接增加抗性的buff，使用buff_attack负值来模拟抗性提升
    Skill_SelfAddBuff('buff_attack', 1, 8, {-0.3}, "增加30%物理抗性，持续8秒")
    
    -- 施放技能时发出威严的咆哮
    Skill_Say("龙鳞护体，刀剑难伤！", 3)
    
    -- 在自身周围创建一个金光闪闪的特效区域
    Skill_CreateSelfCircleRegion(2, 8, "创建金光护体特效区域")
    
    -- 注册护盾结束事件
    Skill_RegisterEvent("on_buff_end", function()
        -- 护盾结束时可以添加一些额外效果，如提示信息
        Skill_Say("龙鳞护体效果已消失", 2)
    end)
    
    -- 等待护盾持续时间
    Skill_Sleep(8000, "等待护盾持续时间结束")
end

return M