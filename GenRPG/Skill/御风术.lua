local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(50, "设置魔法消耗值为50点")
    Skill_SetCooldown(10, "设置技能冷却时间为10秒")
    Skill_SetCastRange(0, "设置施法范围为0（自身施法）")
    Skill_SetMainTargetType("self", "设置目标类型为自身")
    Skill_SetDesc("老修士传授的轻功身法，使用后5秒内提升移动速度30%。消耗50点魔法值，冷却时间10秒。")
end

function M.cb()
    -- 选择自身作为技能目标
    Skill_CollectMainTarget("选择自身作为目标")
    
    -- 在自身位置创建白色气流效果（使用静态子物体实现）
    -- 创建一个围绕自身旋转的子物体，模拟白色气流环绕效果
    Skill_CreateSelfCircleSubObj(120, 5, 1, 0, 0, "创建围绕自身旋转的白色气流效果")
    SubObj_SetSize("normal", "设置气流效果大小")
    
    -- 创建第二层气流，增强视觉效果
    Skill_CreateSelfCircleSubObj(90, 5, 0.5, 180, 0, "创建第二层白色气流效果")
    SubObj_SetSize("small", "设置第二层气流效果大小")
    
    -- 播放技能施法音效/台词
    Skill_Say("驭风而行，轻如鸿毛", 2)
    
    -- 为自身添加加速buff，提升移动速度30%，持续5秒
    Skill_SelfAddBuff("buff_speed", 1, 5, {0.3}, "添加30%移动速度加成，持续5秒")
    
    -- 技能持续时间
    Skill_Sleep(5000, "技能持续5秒")
end

return M