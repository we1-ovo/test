local M = {}

function M.init()
    -- 根据设计文档设置技能基础属性
    Skill_SetMPCost(50, "设置技能魔法消耗为50点")
    Skill_SetCooldown(2, "设置技能冷却时间为2秒")
    Skill_SetCastRange(8, "设置技能施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("基础远程攻击仙术")
end

function M.cb()
    -- 选择主目标敌人作为攻击对象
    Skill_CollectMainTarget("选择敌人目标")
    
    -- 对选中的敌人目标造成魔法伤害，伤害值为攻击力的1.5倍（约90点）
    Skill_TargetScaleDamage("damage_magic", 1.5, "造成1.5倍攻击力的魔法伤害")
    
    -- 创建一个向目标飞行的灵气弹视觉效果
    Skill_CreateCVSubObjToTarget(10, "", "创建灵气弹飞向目标")
end

return M