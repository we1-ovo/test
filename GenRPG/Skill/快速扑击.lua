local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(0, "设置技能消耗为0点魔法值，NPC技能不消耗魔法")
    Skill_SetCooldown(1500, "设置技能冷却时间为1500毫秒，约1.5秒")
    Skill_SetCastRange(2, "设置技能施法距离为2米，符合近战攻击范围")
    Skill_SetMainTargetType("enemy", "设置技能主要目标类型为敌人")
    Skill_SetDesc("快速向敌人扑击造成1.2倍攻击力的物理伤害，攻击后后退1米", "灵狐扑击技能描述")
end

function M.cb()
    -- 技能释放逻辑部分
    -- 选择主目标作为攻击对象
    Skill_CollectMainTarget("选择主要攻击目标")
    
    -- 首先使用Skill_MoveToTarget将灵狐快速移动到目标位置，速度为自身移动速度的1.5倍
    Skill_MoveToTarget(1.5, "以1.5倍速扑向目标")
    
    -- 对目标造成1.2倍攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 1.2, "造成1.2倍攻击力的物理伤害")
    
    -- 通过Skill_Sleep实现技能释放的短暂动画时间
    Skill_Sleep(500, "短暂攻击动画时间")
    
    -- 攻击完成后，使用Skill_MoveTo向后方移动1米，以保持距离
    Skill_MoveTo(180, 1, 1, "攻击后后退1米保持距离")
end

return M