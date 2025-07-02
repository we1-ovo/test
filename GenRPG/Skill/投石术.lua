local M = {}

function M.init()
    -- 根据设计文档设置技能基础属性
    Skill_SetMPCost(20, "设置魔法消耗为20点")
    Skill_SetCooldown(5, "设置技能冷却时间为5秒")
    Skill_SetCastRange(8, "设置技能施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("山猿从地上捡起一块石头投掷向目标，造成物理伤害")
end

function M.cb()
    -- 选择目标
    Skill_CollectMainTarget("选择一个敌方目标")
    
    -- 创建石块子物体，以5米/秒的速度飞行
    Skill_CreateCVSubObjToTarget(5, '', "创建一个石块朝目标飞行")
    
    -- 设置子物体属性
    SubObj_SetSize("normal", "设置石块大小为正常尺寸")
    SubObj_SetTriggerType('trigger_collision', 1, "设置子物体为碰撞触发，只触发一次")
    SubObj_SetTriggerRadius(0.5, "设置石块触发半径为0.5米")
    
    -- 设置触发伤害为攻击力的1.5倍
    -- 使用Skill_TargetScaleDamage而不是直接设置固定伤害值，以便根据施法者攻击力动态计算
    SubObj_SetTriggerDamage('damage_physical', 1.5, "设置子物体触发物理伤害为攻击力的1.5倍")
    
    -- 注册石块命中时的效果
    Skill_RegisterEvent("on_subobject_trigger", function()
        -- 石块命中后不需要额外效果，伤害已经在触发设置中定义
        Skill_Say("命中！", 1)
    end)
end

return M