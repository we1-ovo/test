local M = {}

function M.init()
    -- 按照设计文档初始化技能参数
    Skill_SetMPCost(100, "设置魔法消耗为100点MP")
    Skill_SetCooldown(6, "设置技能冷却时间为6秒")
    Skill_SetCastRange(8, "设置施法距离为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("火系范围攻击仙术，投掷符咒在目标位置产生烈焰爆炸，对半径3米内最多5个敌人造成2倍攻击力的魔法伤害")
end

function M.cb()
    -- 选择主要目标确定投掷方向
    Skill_CollectMainTarget("选择主要目标确定投掷方向")
    
    -- 创建一个向目标飞行的符咒子物体
    Skill_CreateCVSubObjToTarget(10, '', "创建向目标飞行的符咒")
    SubObj_SetTriggerType('trigger_collision', 1, "设置子物体为碰撞触发，只触发一次")
    SubObj_SetTriggerRadius(0.5, "设置子物体触发半径")
    
    -- 注册子物体触发事件，在符咒命中后产生爆炸效果
    Skill_RegisterEvent("on_subobject_trigger", function()
        -- 在命中位置创建静态爆炸效果
        Skill_CreateStaticSubObjAtTargetPos(1, "创建爆炸效果")
        
        -- 选择爆炸范围内的敌人
        Skill_CollectCircleTargets(3, 5, "选择爆炸范围内的敌人")
        
        -- 对选中的敌人造成伤害
        Skill_TargetScaleDamage('damage_magic', 2.0, "造成2倍攻击力的火焰伤害")
    end)
    
    -- 等待技能施放完毕（给足够时间让子物体飞行并触发）
    Skill_Sleep(2000, "等待符咒飞行并爆炸")
end

return M