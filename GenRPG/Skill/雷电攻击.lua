local M = {}

function M.init()
    -- 按照设计文档初始化技能参数
    Skill_SetMPCost(60, "设置技能消耗魔法值60点")
    Skill_SetCooldown(6000, "设置技能冷却时间6秒")
    Skill_SetCastRange(10, "设置技能施法范围为10米")
    Skill_SetMainTargetType("enemy", "设置技能主目标类型为敌人")
    Skill_SetDesc("召唤雷电从天而降击中目标，造成攻击力1.6倍的魔法伤害，20%几率眩晕2秒", "雷电攻击技能描述")
end

function M.cb()
    -- 首先选择主目标作为雷电的攻击目标
    Skill_CollectMainTarget("选择雷电攻击的主目标")
    
    -- 使用Skill_Sleep函数等待1500毫秒(1.5秒)实现蓄力时间，模拟雷电聚集特效
    Skill_Sleep(1500, "雷电蓄力时间1.5秒")
    
    -- 在目标位置创建一个静止的子物体，表示雷电从天而降的效果
    Skill_CreateStaticSubObjAtTargetPos(1000, "创建雷电子物体持续1秒")
    
    -- 设置子物体的触发类型为延迟触发，延迟时间为200毫秒
    SubObj_SetTriggerType('trigger_delay', 200, "设置雷电延迟触发200毫秒")
    
    -- 设置子物体的触发半径为2米，覆盖雷电打击的区域
    SubObj_SetTriggerRadius(2, "设置雷电攻击半径为2米")
    
    -- 使用Skill_TargetScaleDamage实现基础攻击力1.6倍的魔法伤害
    -- 先收集目标，然后再造成伤害
    Skill_CollectCircleTargets(2, 10, "收集雷电攻击范围内的目标")
    Skill_TargetScaleDamage('damage_magic', 1.6, "造成1.6倍基础攻击力的魔法伤害")
    
    -- 设置有20%几率对命中目标施加2000毫秒(2秒)的眩晕效果
    Skill_TargetEnemyAddBuff('buff_stun', 0.2, 2000, {}, "设置雷电20%几率眩晕2秒")
end

return M