local M = {}

function M.init()
    -- 根据设计文档设置技能基础属性
    Skill_SetMPCost(15, "设置魔法消耗为15点")
    Skill_SetCooldown(5, "设置技能冷却时间为5秒")
    Skill_SetCastRange(2, "设置技能施法距离为2米，符合近战技能设计")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("对目标进行两次连续爪击，每次10点伤害，共20点伤害")
end

function M.cb()
    -- 选择敌方目标作为主目标
    Skill_CollectMainTarget("选择敌方目标作为主目标")
    
    -- 执行第一次爪击
    Skill_TargetDamage("damage_physical", 10, "第一次爪击造成10点物理伤害")
    
    -- 等待0.5秒，实现两次攻击的间隔效果
    Skill_Sleep(500, "等待0.5秒，实现两次攻击的间隔")
    
    -- 执行第二次爪击
    Skill_TargetDamage("damage_physical", 10, "第二次爪击造成10点物理伤害")
    
    -- 技能完成，两次爪击总共造成20点物理伤害
    Skill_Say("爪击连击完成！", 1)
end

return M