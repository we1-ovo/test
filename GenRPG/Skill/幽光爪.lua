local M = {}

function M.init()
    -- 设置魔法消耗为20点，因为是灵狐的特殊技能
    Skill_SetMPCost(20, "设置魔法消耗为20点")
    -- 设置技能冷却时间为4秒，符合设计文档要求
    Skill_SetCooldown(4, "设置技能冷却时间为4秒")
    -- 设置施法距离为2米，为近战控制技能
    Skill_SetCastRange(2, "设置施法距离为2米")
    -- 设置目标类型为敌人，作为灵狐的特殊控制技能
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    -- 设置技能描述
    Skill_SetDesc("灵狐前爪凝聚幽蓝灵气，对目标造成其攻击力0.8倍的魔法伤害，并有30%几率使目标减速20%，持续3秒。")
end

function M.cb()
    -- 首先选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主目标作为攻击对象")
    
    -- 对选中目标造成魔法伤害，伤害值为灵狐攻击力的0.8倍
    Skill_TargetScaleDamage("damage_magic", 0.8, "造成0.8倍攻击力的魔法伤害")
    
    -- 为目标添加减速状态，概率为30%，减速效果为20%，持续3秒
    Skill_TargetEnemyAddBuff("buff_speed", 0.3, 3, {-0.2}, "30%几率使目标减速20%，持续3秒")
    
    -- 添加技能释放效果，让灵狐在施放技能时说出技能台词
    Skill_Say("幽光爪击！", 1)
end

return M