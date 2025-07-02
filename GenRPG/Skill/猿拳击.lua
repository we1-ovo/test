local M = {}

function M.init()
    -- 按照设计文档的init_desc部分设置技能基础属性
    Skill_SetMPCost(15, "设置魔法消耗为15点")
    Skill_SetCooldown(3, "设置技能冷却时间为3秒")
    Skill_SetCastRange(2, "设置技能施法范围为2米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("山猿挥动强壮的手臂进行近身拳击攻击，造成物理伤害")
end

function M.cb()
    -- 实现蓄力动作，持续0.5秒
    Skill_Sleep(500, "山猿蓄力0.5秒，挥动手臂准备攻击")
    
    -- 选择前方扇形区域内的敌人目标
    -- 扇形半径2米，角度60度，最多选择3个目标
    Skill_CollectSectorTargets(2, 60, 3, "选择前方扇形区域内最多3个敌人")
    
    -- 对选中的目标造成物理伤害，伤害值为自身攻击力的1.2倍
    Skill_TargetScaleDamage("damage_physical", 1.2, "造成1.2倍攻击力的物理伤害")
    
    -- 释放技能结束
    Skill_Say("呃啊！", 1)
end

return M