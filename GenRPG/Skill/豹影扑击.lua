local M = {}
-- 技能名称：豹影扑击

function M.init()
    -- 按照设计文档中的init_desc设置技能初始化参数
    Skill_SetMPCost(15, "设置魔法消耗为15点")
    Skill_SetCooldown(6, "设置技能冷却时间为6秒")
    Skill_SetCastRange(6, "设置施法距离为6米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("灵豹向目标敌人发起迅猛的扑击，造成物理伤害(攻击力的1.2倍)并有25%几率使目标减速20%，持续3秒。冷却时间6秒，施法距离6米。")
end

function M.cb()
    -- 按照设计文档中的cast_desc实现技能释放逻辑
    
    -- 选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主目标")
    
    -- 使用Skill_MoveToTarget移动到目标位置，移动速度为正常速度的1.5倍
    Skill_MoveToTarget(1.5)
    
    -- 对目标造成物理伤害，伤害值为灵豹攻击力的1.2倍(约54点伤害)
    Skill_TargetScaleDamage("damage_physical", 1.2, "造成攻击力1.2倍的物理伤害")
    
    -- 有25%的几率使目标减速20%，减速效果持续3秒
    Skill_TargetEnemyAddBuff("buff_speed", 0.25, 3, {-0.2}, "25%几率使目标减速20%，持续3秒")
    
    -- 技能释放完成后可以添加一个简短的延迟，表示动作完成
    Skill_Sleep(500, "技能动作完成延迟")
end

return M