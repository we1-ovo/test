local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(0, "设置魔法消耗为0")
    Skill_SetCooldown(2, "设置技能冷却时间为2秒")
    Skill_SetCastRange(2, "设置施法范围为2米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("近距离撕咬或爪击攻击，造成基础攻击力伤害，攻击距离2米，无特殊效果")
end

function M.cb()
    -- 选择主目标
    Skill_CollectMainTarget("选择2米范围内的敌人目标")
    
    -- 模拟前摇动作
    Skill_Sleep(300, "0.3秒前摇动作表现撕咬或爪击的攻击效果")
    
    -- 造成伤害，scale为1表示100%攻击力
    Skill_TargetScaleDamage("damage_physical", 1, "造成等同于自身攻击力的物理伤害")
    
    -- 简单的攻击语音效果
    Skill_Say("呀!", 1)
end

return M