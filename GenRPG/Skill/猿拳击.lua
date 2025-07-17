local M = {}

function M.init()
    -- 基础攻击技能不消耗魔法值
    Skill_SetMPCost(0, "基础攻击不消耗魔法")
    -- 设置冷却时间为1.5秒
    Skill_SetCooldown(1500, "冷却时间1.5秒")
    -- 设置攻击距离为2米
    Skill_SetCastRange(2, "近战攻击距离2米")
    -- 设置目标类型为敌人
    Skill_SetMainTargetType("enemy", "攻击敌人")
    -- 设置技能描述
    Skill_SetDesc("近战攻击，对目标造成物理伤害，伤害值为自身攻击力的1.2倍。", "山猿基础攻击")
end

function M.cb()
    -- 选择主要目标(敌人)
    Skill_CollectMainTarget("选择攻击目标")
    
    -- 对目标造成物理伤害，伤害为自身攻击力的1.2倍
    Skill_TargetScaleDamage("damage_physical", 1.2, "造成1.2倍物理伤害")
    
    -- 由于无前摇后摇，技能释放后立即结束
end

return M