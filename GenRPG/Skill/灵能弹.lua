local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetCooldown(5, "设置技能冷却时间为5秒，符合设计文档要求")
    Skill_SetCastRange(8, "设置技能施法距离为8米，对应能量球的射程")
    Skill_SetMainTargetType("enemy", "设置技能目标类型为敌人，因为这是一个对敌人使用的攻击技能")
    -- 无魔法消耗，NPC释放技能不考虑MP消耗
    Skill_SetDesc("灵豹的远程攻击技能，从口中发射一颗紫色能量球，射程8米，造成中等伤害。")
end

function M.cb()
    -- 技能释放逻辑部分
    
    -- 先使用Skill_Sleep实现1秒的蓄力时间，模拟灵豹聚集能量的过程
    Skill_Sleep(1000, "灵豹蓄力1秒，口中聚集紫色光芒")
    
    -- 选择主目标敌人
    Skill_CollectMainTarget("选择目标敌人")
    
    -- 创建一个向目标飞行的子物体，代表能量球
    Skill_CreateCVSubObjToTarget(10, "", "创建一个向目标飞行的紫色能量球，速度为10米/秒")
    
    -- 设置子物体的触发类型为碰撞触发，触发次数为1次
    SubObj_SetTriggerType("trigger_collision", 1, "设置能量球为碰撞触发，只触发一次")
    
    -- 设置子物体触发半径为0.5米
    SubObj_SetTriggerRadius(0.5, "设置能量球触发半径为0.5米")
    
    -- 设置子物体触发伤害类型为魔法伤害，伤害值为60
    SubObj_SetTriggerDamage("damage_magic", 60, "设置能量球触发伤害为60点魔法伤害")
    
    -- 子物体命中敌人后消失，完成一次远程攻击
    -- 这一行为由系统自动处理，无需额外代码
end

return M