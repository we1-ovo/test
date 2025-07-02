local M = {}

-- 技能名称：猿拳
-- 描述：山猿的基础近战攻击，挥动有力的拳头攻击目标，造成物理伤害

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(10, "设置魔法消耗为10点，确保山猿能多次使用")
    Skill_SetCooldown(2, "设置技能冷却时间为2秒")
    Skill_SetCastRange(2, "设置施法距离为2米，作为近战攻击的有效范围")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人，只能对敌方单位使用")
    Skill_SetDesc("山猿的基础近战攻击，挥动有力的拳头攻击目标，造成物理伤害。攻击距离2米，伤害为攻击力的1.2倍。")
end

function M.cb()
    -- 技能释放逻辑部分
    
    -- 选择当前攻击目标作为主要目标
    Skill_CollectMainTarget("选择当前攻击目标")
    
    -- 对目标造成物理伤害，伤害值为自身攻击力的1.2倍
    Skill_TargetScaleDamage("damage_physical", 1.2, "造成自身攻击力1.2倍的物理伤害")
    
    -- 技能释放效果表现，显示攻击动作
    Skill_Say("呀！", 1) -- 简单的攻击音效表现
end

return M