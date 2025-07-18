local M = {}

function M.init()
    -- 设置魔法消耗为20点
    Skill_SetMPCost(20, "设置魔法消耗为20点")
    -- 设置技能冷却时间为2000毫秒(2秒)
    Skill_SetCooldown(2000, "设置技能冷却时间为2秒")
    -- 设置施法范围为8米，符合设计文档中的射程要求
    Skill_SetCastRange(8, "设置施法范围为8米")
    -- 设置技能目标类型为敌人
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    -- 设置技能描述说明
    Skill_SetDesc("灵豹从口中凝聚一团紫色能量发射向目标，造成65点魔法伤害。射程8米，冷却2秒，消耗20魔法值。", "紫光能量弹技能描述")
end

function M.cb()
    -- 首先选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主目标")
    
    -- 创建一个向目标方向移动的子物体，代表紫色能量弹，设置速度为8米/秒
    Skill_CreateCVSubObjToTarget(8, '', "创建紫色能量弹子物体")
    
    -- 设置子物体为碰撞触发类型，可触发1次
    SubObj_SetTriggerType('trigger_collision', 1, "设置碰撞触发，仅触发1次")
    
    -- 设置子物体的触发半径为0.5米，确保命中精度
    SubObj_SetTriggerRadius(0.5, "设置触发半径为0.5米")
    
    -- 设置子物体触发时造成65点魔法伤害(取设计文档中60-70点的中间值)
    SubObj_SetTriggerDamage('damage_magic', 65, "设置65点魔法伤害")
end

return M