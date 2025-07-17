local M = {}

function M.init()
    -- 按照设计文档进行技能初始化
    Skill_SetMPCost(50, "设置技能魔法消耗为50点")
    Skill_SetCooldown(2000, "设置技能冷却时间为2000毫秒(2秒)")
    Skill_SetCastRange(8, "设置施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置主目标类型为敌人")
    Skill_SetDesc("基础远程仙术攻击", "灵气弹技能描述")
end

function M.cb()
    -- 实现技能释放逻辑
    -- 选择主要攻击目标
    Skill_CollectMainTarget("选择灵气弹攻击目标")
    
    -- 对目标造成1.5倍攻击力的魔法伤害
    Skill_TargetScaleDamage('damage_magic', 1.5, "灵气弹伤害")
    
    -- 技能为瞬发技能，无需额外等待时间
end

return M