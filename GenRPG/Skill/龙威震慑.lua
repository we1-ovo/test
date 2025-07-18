local M = {}

function M.init()
    -- 根据设计文档初始化技能参数
    Skill_SetMPCost(180, "设置魔法消耗为180点")
    Skill_SetCooldown(20000, "设置技能冷却时间为20秒")
    Skill_SetCastRange(6, "设置技能释放范围为6米")
    Skill_SetMainTargetType("enemy", "设置技能主目标类型为敌人")
    Skill_SetDesc("控制技能，释放强大的龙威使周围敌人短暂眩晕", "龙威震慑技能描述")
end

function M.cb()
    -- 模拟龙吟声
    Skill_Say("吼！", 1000, "模拟龙威释放时的龙吟声")
    
    -- 选择范围内的敌人
    Skill_CollectCircleTargets(6, 10, "选择以自身为中心6米半径范围内的敌人")
    
    -- 对选中敌人添加眩晕效果
    Skill_TargetEnemyAddBuff("buff_stun", 1, 1500, {}, "对敌人施加1.5秒眩晕")
    
    -- 创建震荡波特效区域
    Skill_CreateSelfPosCircleRegion(6, 1000, "创建震荡波特效区域")
    
    -- 区域内敌人受到减速效果
    Region_AddStayBuff("buff_speed", 1, 500, {-50}, "enemy", "对区域内敌人施加50%减速")
    
    -- 等待视觉效果完全展现
    Skill_Sleep(1000, "等待震荡波特效完成")
end

return M