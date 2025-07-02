local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(10, "设置魔法消耗为10点")
    Skill_SetCooldown(4, "设置技能冷却时间为4秒")
    Skill_SetCastRange(8, "设置技能施法距离为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("灵豹从口中发射一枚紫色能量弹，对目标造成魔法伤害。伤害为攻击力的1.0倍，施法距离8米，冷却时间4秒。能量弹击中后产生小范围的紫色能量爆炸效果。")
end

function M.cb()
    -- 技能释放逻辑部分
    
    -- 选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主要目标")
    
    -- 创建一个向目标方向移动的子物体(紫色能量弹)
    Skill_CreateCVSubObjToTarget(10, '', "创建一个向目标方向移动的紫色能量弹")
    
    -- 设置子物体的触发条件
    SubObj_SetTriggerType('trigger_collision', 1, "设置子物体为碰撞触发，只能触发一次")
    SubObj_SetTriggerRadius(0.5, "设置子物体触发半径为0.5米")
    
    -- 设置子物体的伤害效果（攻击力的1.0倍，约45点伤害）
    SubObj_SetTriggerDamage('damage_magic', 45, "设置子物体触发伤害为魔法伤害，为灵豹攻击力的1.0倍")
    
    -- 注册子物体触发时的事件
    Skill_RegisterEvent("on_subobject_trigger", function()
        -- 子物体碰撞后在命中位置创建一个小范围爆炸效果
        Skill_CreateTargetPosCircleRegion(1, 1, "创建1米半径的紫色能量爆炸区域，持续1秒")
    end)
end

return M