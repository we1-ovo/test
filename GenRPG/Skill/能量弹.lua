local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(30, "设置魔法消耗为30点")
    Skill_SetCooldown(1500, "设置技能冷却时间为1.5秒")
    Skill_SetCastRange(8, "设置施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置主目标类型为敌人")
    Skill_SetDesc("灵豹发射一颗紫色能量球，朝目标直线飞行，命中造成70点魔法伤害", "远程魔法攻击技能")
end

function M.cb()
    -- 技能释放逻辑部分
    -- 选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主目标")
    
    -- 创建一个向目标移动的子物体，速度为12米/秒
    Skill_CreateCVSubObjToTarget(12, '', "创建紫色能量球子物体")
    
    -- 设置子物体为碰撞触发类型，无限制触发次数
    SubObj_SetTriggerType('trigger_collision', 0, "设置为碰撞触发，无限制触发次数")
    
    -- 设置子物体触发半径为0.25米（直径0.5米）
    SubObj_SetTriggerRadius(0.25, "设置子物体触发半径为0.25米")
    
    -- 设置子物体触发伤害为70点魔法伤害
    SubObj_SetTriggerDamage('damage_magic', 70, "设置子物体触发70点魔法伤害")
    
    -- 设置子物体大小
    SubObj_SetSize('small', "设置能量球为小尺寸")
end

return M