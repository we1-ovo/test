local M = {}

function M.init()
    -- 设置技能消耗为0点魔法值，NPC技能不消耗魔法
    Skill_SetMPCost(0, "NPC技能不消耗魔法")
    
    -- 设置技能冷却时间为2000毫秒，约2秒
    Skill_SetCooldown(2000, "技能冷却时间为2秒")
    
    -- 设置技能施法距离为2米，符合近战攻击范围
    Skill_SetCastRange(2, "近战攻击范围2米")
    
    -- 设置技能主要目标类型为敌人
    Skill_SetMainTargetType("enemy", "目标类型为敌人")
    
    -- 技能描述：使用锋利爪子攻击目标，造成等同于攻击力的物理伤害并有轻微击退效果
    Skill_SetDesc("使用锋利爪子攻击目标，造成等同于攻击力的物理伤害并有轻微击退效果", "爪击攻击技能描述")
end

function M.cb()
    -- 选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主目标")
    
    -- 对目标造成等同于攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 1, "造成1倍攻击力的物理伤害")
    
    -- 为目标添加一个轻微击退效果，击退距离设置为0.5米
    Skill_TargetEnemyAddBuff("buff_beat_back", 1, 100, {0.5}, "添加0.5米击退效果")
    
    -- 通过Skill_Sleep实现技能释放的短暂动画时间，设置为400毫秒
    Skill_Sleep(400, "技能释放动画时间")
end

return M