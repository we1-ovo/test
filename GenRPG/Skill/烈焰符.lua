local M = {}

function M.init()
    -- 初始化技能基础参数
    Skill_SetMPCost(100, "设置魔法消耗为100点")
    Skill_SetCooldown(3000, "设置技能冷却时间为3秒")
    Skill_SetCastRange(8, "设置施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("击败谷口妖兽后解锁的火系攻击仙术。投掷符咒产生烈焰爆炸，造成范围伤害。", "火系攻击仙术")
end

function M.cb()
    -- 选择目标位置周围的敌人
    Skill_CollectMainTarget("选择主目标")
    
    -- 创建一个在目标位置的静态子物体，表示符咒爆炸效果
    Skill_CreateStaticSubObjAtTargetPos(2000, "创建烈焰爆炸效果")
    
    -- 选择爆炸范围内的敌人目标
    Skill_CollectCircleTargets(3, 5, "选择爆炸半径3米内最多5个敌人")
    
    -- 对选中的所有敌人造成魔法伤害，伤害为攻击力的2倍
    Skill_TargetScaleDamage("damage_magic", 2, "造成攻击力2倍的魔法伤害")
end

return M