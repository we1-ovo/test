local M = {}

function M.init()
    -- 初始化技能参数
    Skill_SetMPCost(80, "设置魔法消耗为80点MP")
    Skill_SetCooldown(8, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置施法距离为0米（自身技能）")
    Skill_SetMainTargetType("self", "设置目标类型为自身")
    Skill_SetDesc("基础恢复仙术")
end

function M.cb()
    -- 技能释放逻辑
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为治疗目标")
    
    -- 治疗自己360点生命值（使用负数表示治疗）
    Skill_SelfDamage('damage_physical', -360, "治疗自己360点生命值")
    
    -- 显示治疗效果提示
    Skill_Say("生命灵气恢复！", 1)
end

return M