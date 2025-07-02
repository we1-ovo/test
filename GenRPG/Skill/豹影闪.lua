local M = {}

function M.init()
    -- 根据设计文档初始化技能参数
    Skill_SetCooldown(8, "设置技能冷却时间为8秒")
    Skill_SetCastRange(6, "设置技能施法距离为6米，对应灵豹的短距离冲刺范围")
    Skill_SetMainTargetType("self", "设置技能目标类型为自己，因为这是一个自身位移技能")
    -- 无魔法消耗，NPC释放技能不考虑MP消耗
    Skill_SetDesc("灵豹短距离位移技能，迅速向前冲刺6米，闪避攻击并重新定位。技能释放时灵豹身体周围会出现淡紫色残影，表现其极速移动效果。")
end

function M.cb()
    -- 选择自身作为技能目标
    Skill_CollectMainTarget("选择自身作为技能目标")
    
    -- 为自己添加速度提升buff，提升40%移动速度，持续1秒
    Skill_SelfAddBuff('buff_speed', 1, 1, {0.4}, "添加40%速度提升，持续1秒，增强闪避效果")
    
    -- 使用Skill_MoveTo实现向前冲刺位移效果
    -- 角度为0表示正前方，速度为灵豹基础速度的2倍，距离为6米
    Skill_MoveTo(0, 2, 6)
    
    -- 技能释放完成时说话，模拟技能效果声音
    Skill_Say("影随风动", 1)
end

return M