local M = {}

function M.init()
    -- 根据设计文档设置技能基础属性
    Skill_SetMPCost(30, "设置魔法消耗为30点")
    Skill_SetCooldown(5000, "设置技能冷却时间为5秒")
    Skill_SetCastRange(6, "设置施法范围为6米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("灵豹迅速冲向目标并进行扑击，造成90点物理伤害，有30%概率使目标减速20%，持续3秒。", "闪电扑击技能描述")
end

function M.cb()
    -- 选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主目标")
    
    -- 使用传送技能瞬间移动到目标位置
    Skill_TeleportToTarget("瞬移到目标位置")
    
    -- 造成90点物理伤害(85-95的中间值)
    Skill_TargetDamage("damage_physical", 90, "造成90点物理伤害")
    
    -- 使用API的概率参数实现30%概率减速效果
    Skill_TargetEnemyAddBuff("buff_speed", 0.3, 3000, {-20}, "添加20%减速效果，持续3秒")
end

return M