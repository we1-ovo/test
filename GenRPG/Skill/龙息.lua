local M = {}

function M.init()
    -- 初始化技能属性
    Skill_SetMPCost(100, "设置技能消耗为100点魔法值")
    Skill_SetCooldown(3, "设置技能冷却时间为3秒")
    Skill_SetCastRange(8, "设置施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置技能目标类型为敌人")
    Skill_SetDesc("千年蛟龙的主要攻击技能，从口中喷出灼热气息，形成60度扇形范围攻击，射程8米。造成150点魔法伤害，并有30%概率使敌人受到持续灼烧效果，每秒受到20点伤害，持续3秒。")
end

function M.cb()
    -- 技能释放前的1秒蓄力动作
    Skill_Say("蓄力中...", 1)
    Skill_Sleep(1000, "播放1秒蓄力动作")
    
    -- 选择前方60度扇形8米范围内的所有敌人
    Skill_CollectSectorTargets(8, 60, 10, "选择前方60度扇形范围内的敌人")
    
    -- 对选中目标造成150点魔法伤害
    Skill_TargetDamage("damage_magic", 150, "对敌人造成150点魔法伤害")
    
    -- 有30%概率对选中目标施加持续伤害效果，每秒20点，持续3秒
    Skill_TargetEnemyAddBuff("buff_damage_over_time", 0.3, 3, {20}, "30%概率造成每秒20点的持续灼烧伤害，持续3秒")
    
    -- 技能释放完成后的动作表现
    Skill_Say("龙息！", 1)
end

return M