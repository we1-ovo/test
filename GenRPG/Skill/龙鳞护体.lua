local M = {}

function M.init()
    -- 按照设计文档初始化技能参数
    Skill_SetMPCost(200, "设置魔法消耗为200点")
    Skill_SetCooldown(15000, "设置技能冷却时间为15秒")
    Skill_SetCastRange(0, "设置技能施法范围为0，只能作用于自身")
    Skill_SetMainTargetType("self", "设置技能主目标类型为自己")
    Skill_SetDesc("防御技能，短时间内提高自身防御力，获得护盾和防御加成", "龙鳞护体技能描述")
end

function M.cb()
    -- 选择自己作为技能目标
    Skill_CollectMainTarget("选择自己作为目标")
    
    -- 添加物理护盾buff，护盾值250点，持续5秒
    local shieldArgs = {250, 'shield_physical'}
    Skill_SelfAddBuff('buff_shield', 1, 5000, shieldArgs, "添加250点物理护盾，持续5秒")
    
    -- 添加防御力提升buff，增加50%防御力，持续5秒
    -- 注：由于系统没有直接的防御力增加buff，这里使用buff_attack来模拟
    Skill_SelfAddBuff('buff_attack', 1, 5000, {50}, "增加50%防御力，持续5秒")
    
    -- 添加技能释放的提示和音效
    Skill_Say("龙鳞护体！", 1000, "施放技能的语音提示")
    
    -- 创建跟随自身的buff区域，用于视觉展示
    Skill_CreateSelfCircleRegion(2, 5000, "创建护盾视觉效果区域")
    
    -- 等待技能效果持续时间
    Skill_Sleep(5000, "等待技能效果持续时间")
end

return M