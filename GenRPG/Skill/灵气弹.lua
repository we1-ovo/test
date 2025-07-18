local M = {}

function M.init()
    -- 技能基础参数设置
    Skill_SetMPCost(50, "设置魔法消耗为50点")
    Skill_SetCooldown(2000, "设置技能冷却时间为2秒")
    Skill_SetCastRange(8, "设置施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("基础远程仙术，凝聚天地灵气形成能量弹投射向目标，造成1.5倍攻击力的魔法伤害。", "基础远程仙术")
end

function M.cb()
    -- 选择敌人目标
    Skill_CollectMainTarget("选择主目标敌人")
    
    -- 直接造成1.5倍攻击力的魔法伤害（瞬发型）
    Skill_TargetScaleDamage('damage_magic', 1.5, "造成1.5倍攻击力的魔法伤害")
end

return M