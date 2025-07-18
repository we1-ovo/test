local M = {}

function M.init()
    -- 初始化技能参数
    Skill_SetMPCost(150, "设置魔法消耗为150点")
    Skill_SetCooldown(6000, "设置技能冷却时间为6秒")
    Skill_SetCastRange(12, "设置技能释放范围为12米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("远程单体高伤害技能，向目标发射一道强力雷电", "雷电攻击技能描述")
end

function M.cb()
    -- 1.5秒蓄力时间，模拟雷电聚集的过程
    Skill_Say("雷霆之力凝聚!", 1500, "雷电聚集音效")
    Skill_Sleep(1500, "蓄力1.5秒")
    
    -- 选择主目标
    Skill_CollectMainTarget("选择敌方目标")
    
    -- 创建向目标移动的雷电子物体
    Skill_CreateCVSubObjToTarget(15, '', "创建雷电子物体")
    
    -- 设置子物体的触发类型为碰撞触发，只触发一次
    SubObj_SetTriggerType('trigger_collision', 1, "设置为碰撞触发")
    
    -- 设置子物体触发半径
    SubObj_SetTriggerRadius(0.8, "设置触发半径为0.8米")
    
    -- 设置子物体触发伤害，在250-300之间随机
    local damage = math.random(250, 300)
    SubObj_SetTriggerDamage('damage_magic', damage, "设置雷电伤害为" .. damage .. "点")
end

return M