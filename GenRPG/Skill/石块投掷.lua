local M = {}

function M.init()
    -- 初始化技能属性
    Skill_SetMPCost(15, "设置MP消耗为15点")
    Skill_SetCooldown(4000, "设置冷却时间为4秒")
    Skill_SetCastRange(6, "设置施法距离为6米")
    Skill_SetMainTargetType("enemy", "设置目标为敌人")
    Skill_SetDesc("远程投掷石块攻击，冷却4秒，造成物理伤害，可被躲避", "技能描述")
end

function M.cb()
    -- 技能释放逻辑
    -- 收集主目标
    Skill_CollectMainTarget("选择当前敌方目标")
    
    -- 创建一个向目标方向飞行的子物体，模拟石块投掷
    Skill_CreateCVSubObjToTarget(8, "", "创建飞行石块")
    
    -- 设置子物体为碰撞触发，并设置伤害
    SubObj_SetTriggerType("trigger_collision", 1, "设置为碰撞触发")
    SubObj_SetTriggerRadius(0.5, "设置触发半径为0.5米")
    SubObj_SetTriggerDamage("damage_physical", 55, "设置55点物理伤害")
    
    -- 模拟山猿弯腰捡石块的动作过程
    Skill_Sleep(500, "山猿弯腰捡石块动作时间")
end

return M