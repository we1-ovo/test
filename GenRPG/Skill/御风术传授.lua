local M = {}

function M.init()
    -- 设置技能魔法消耗为0，因为老修士作为引导NPC不受魔法限制
    Skill_SetMPCost(0, "设置技能魔法消耗为0")
    -- 设置技能冷却时间为0，因为此技能只在剧情中使用一次
    Skill_SetCooldown(0, "设置技能冷却时间为0")
    -- 设置技能施法范围为8米，确保能够对附近的玩家生效
    Skill_SetCastRange(8, "设置技能施法范围为8米")
    -- 设置目标类型为友方，专门用于对玩家施放
    Skill_SetMainTargetType("friend", "设置目标类型为友方")
    -- 设置技能描述
    Skill_SetDesc("传授御风术，为目标创造一个持续5秒的加速光环，移动速度提升20%")
end

function M.cb()
    -- 选择主目标（玩家）作为技能释放对象
    Skill_CollectMainTarget("选择玩家作为技能目标")
    
    -- 在玩家周围创建一个半径3米的跟随型圆形区域，持续5秒
    Skill_CreateTargetCircleRegion(3, 5, "创建半径3米的加速光环")
    
    -- 区域内的友方单位（玩家）获得加速20%的buff效果，持续5秒
    Region_AddStayBuff('buff_speed', 1, 5, {0.2}, 'friend', "区域内友方单位加速20%")
    
    -- 技能释放过程中老修士会说话，提示玩家已传授御风术
    Skill_Say("我已将御风术传授给你，运用它可助你轻盈如风", 3)
    
    -- 整个技能持续时间为5秒，与光环持续时间一致
    Skill_Sleep(5000, "维持技能释放状态5秒")
end

return M