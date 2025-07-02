local M = {}

function M.init()
    -- 根据设计文档初始化技能属性
    Skill_SetMPCost(100, "设置技能魔法消耗为100点")
    Skill_SetCooldown(6, "设置技能冷却时间为6秒")
    Skill_SetCastRange(8, "设置技能施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("火系攻击仙术，投掷符咒产生烈焰爆炸，对范围内敌人造成魔法伤害。")
end

function M.cb()
    -- 选择主目标位置
    Skill_CollectMainTarget("选择目标位置")
    
    -- 创建向目标位置飞行的子物体(符咒)
    Skill_CreateCVSubObjToTarget(10, '', "创建飞行的符咒")
    SubObj_SetTriggerType('trigger_collision', 1, "设置符咒为碰撞触发，只触发一次")
    SubObj_SetTriggerRadius(0.5, "设置符咒触发半径")
    
    -- 注册子物体碰撞触发事件
    Skill_RegisterEvent("on_subobject_trigger", function()
        -- 在符咒碰撞位置创建爆炸效果
        Skill_CreateTargetPosCircleRegion(3, 1, "创建爆炸范围")
        
        -- 选择爆炸范围内的敌人，最多5个
        Skill_CollectCircleTargets(3, 5, "选择爆炸范围内最多5个敌人")
        
        -- 对选中的敌人造成2倍攻击力的魔法伤害
        Skill_TargetScaleDamage('damage_magic', 2, "造成2倍攻击力的魔法伤害")
        
        -- 说出技能台词
        Skill_Say("烈焰焚尽妖邪！", 2)
    end)
end

return M