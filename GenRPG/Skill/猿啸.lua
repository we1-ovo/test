local M = {}

function M.init()
    -- 基础技能属性设置
    Skill_SetMPCost(30, "技能MP消耗30点")
    Skill_SetCooldown(12000, "技能冷却时间12秒")
    Skill_SetCastRange(0, "以自身为中心施放")
    Skill_SetMainTargetType("self", "目标类型为自身")
    Skill_SetDesc("团队增益技能，提升周围友方单位攻击力20%，持续8秒", "攻击力增益技能")
end

function M.cb()
    -- 选择自身作为技能释放中心点
    Skill_CollectMainTarget("选择自身为技能中心")
    
    -- 技能释放时进行短暂停顿，模拟山猿仰天长啸的动作
    Skill_Sleep(500, "山猿仰天长啸动作")
    
    -- 在自身周围创建一个圆形buff区域
    Skill_CreateSelfCircleRegion(5, 8000, "创建5米半径增益光环，持续8秒")
    
    -- 为区域内的友方单位添加攻击力增益
    Region_AddStayBuff('buff_attack', 1, 8000, {20}, 'friend', "为友方单位提升20%攻击力")
    
    -- 技能持续时间
    Skill_Sleep(8000, "维持增益效果持续时间")
end

return M