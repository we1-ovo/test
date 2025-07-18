local M = {}

-- 技能名称：御风术

function M.init()
    Skill_SetMPCost(60, "设置魔法消耗为60点")
    Skill_SetCooldown(5000, "设置技能冷却时间为5000毫秒(5秒)")
    Skill_SetCastRange(0, "设置施法范围为0(自身技能)")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("老修士传授的身法仙术，提升移动速度和位移能力", "身法仙术")
end

function M.cb()
    -- 向前方(角度0)快速移动8米距离，移动速度为9米/秒
    Skill_MoveTo(0, 9, 8, "向前方快速移动8米，速度9米/秒实现1.5倍速度提升")
end

return M