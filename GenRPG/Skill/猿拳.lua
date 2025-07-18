local M = {}

function M.init()
    -- 初始化技能属性
    Skill_SetMPCost(10, "设置MP消耗为10点")
    Skill_SetCooldown(2000, "设置冷却时间为2秒")
    Skill_SetCastRange(2, "设置施法距离为2米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("山猿的基础近战攻击，冷却2秒，造成物理伤害", "基础近战物理攻击")
end

function M.cb()
    -- 技能释放逻辑
    Skill_CollectMainTarget("选择当前目标")
    
    -- 直接对目标造成物理伤害
    Skill_TargetDamage('damage_physical', 45, "造成45点基础物理伤害")
    
    -- 山猿挥拳攻击的效果通过游戏动画系统实现，技能逻辑中无需处理
end

return M