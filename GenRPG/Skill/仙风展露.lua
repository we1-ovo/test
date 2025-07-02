local M = {}

function M.init()
    -- 设置技能魔法消耗为0，因为这是被动展示效果
    Skill_SetMPCost(0, "设置魔法消耗为0，因为这是被动展示效果")
    -- 设置技能冷却时间为30秒，控制展示频率
    Skill_SetCooldown(30, "设置技能冷却时间为30秒，控制展示频率")
    -- 设置技能施法范围为0，因为是自身效果
    Skill_SetCastRange(0, "设置技能施法范围为0，因为是自身效果")
    -- 设置目标类型为自己，只对自身产生视觉效果
    Skill_SetMainTargetType("self", "设置目标类型为自己，只对自身产生视觉效果")
    -- 设置技能描述
    Skill_SetDesc("老修士展示的气场效果，周身产生淡淡的白色仙气和光点，营造出仙人氛围。")
end

function M.cb()
    -- 选择自己作为技能目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 在自身位置创建一个半径2米的静止圆形区域，持续8秒
    Skill_CreateSelfPosCircleRegion(2, 8, "创建仙气效果区域，半径2米，持续8秒")
    
    -- 技能释放期间老修士保持站立姿态
    Skill_Say("", 8) -- 不显示文字，只是为了保持角色的站立状态
    
    -- 使用Skill_Sleep等待8秒，确保仙气效果完整展示
    Skill_Sleep(8000, "展示仙气效果，持续8秒")
    
    -- 注意：这里区域没有添加任何buff效果，纯粹是视觉表现
    -- 游戏引擎会根据区域的存在自动渲染视觉效果
end

return M