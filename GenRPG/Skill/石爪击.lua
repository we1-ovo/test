local M = {}

function M.init()
    -- 初始化技能参数
    Skill_SetCooldown(2000, "设置技能冷却时间为2秒")
    Skill_SetCastRange(2, "设置技能施法范围为2米")
    Skill_SetMainTargetType("enemy", "设置主目标类型为敌人")
    Skill_SetDesc("用坚硬如石的爪子猛击前方目标，造成力量1.2倍的物理伤害", "基础近战攻击技能")
end

function M.cb()
    -- 技能释放逻辑
    Skill_CollectMainTarget("选择主目标作为攻击对象")
    
    -- 造成1.2倍攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 1.2, "对选中的敌方目标造成1.2倍攻击力的物理伤害")
    
    -- 释放技能时的效果表现（可选）
    Skill_Say("吼！", 1000, "石熊攻击时的咆哮声")
end

return M