local M = {}

function M.init()
    -- 设置为剧情技能，没有MP消耗，冷却时间为0
    Skill_SetMPCost(0, "剧情技能无消耗")
    Skill_SetCooldown(0, "剧情技能无冷却")
    -- 目标类型设置为'self'，只作用于自身
    Skill_SetMainTargetType("self", "仅作用于自身")
    -- 施法距离设置为0，表示只能作用于自身
    Skill_SetCastRange(0, "仅能对自己施法")
    Skill_SetDesc("老修士完成引导任务后的离场技能。施法时身体逐渐变为半透明，随后消失不见。", "剧情离场技能")
end

function M.cb()
    -- 选择自身为目标
    Skill_CollectMainTarget("选择自身为目标")
    
    -- 技能施法开始时的对白
    Skill_Say("我的使命已经完成，是时候离开这里了。", 1000, "老修士离场前对白")
    
    -- 技能施法时间为0.5秒，使用Skill_Sleep实现
    Skill_Sleep(500, "施法时间0.5秒，此时角色变为半透明")
    
    -- 临别对白
    Skill_Say("愿智慧之光指引你前行的道路...", 1500, "老修士最后的祝福")
    
    -- 使用Skill_TeleportToTarget实现瞬移效果
    -- 注意：实际的NPC移除需要在Level系统中实现，这里只做视觉表现
    Skill_TeleportToTarget("瞬间移动效果实现")
    
    -- 注：实际的NPC移除是在Level系统中通过事件触发完成的
    -- 此技能只负责表现效果
end

return M