local M = {}

function M.init()
    -- 根据设计文档初始化技能参数
    Skill_SetMPCost(300, "设置技能消耗为300点魔法值")
    Skill_SetCooldown(20, "设置技能冷却时间为20秒")
    Skill_SetCastRange(6, "设置施法范围为6米")
    Skill_SetMainTargetType("enemy", "设置技能目标类型为敌人")
    Skill_SetDesc("千年蛟龙的终极技能，仅在血量低于50%时使用。蛟龙旋转身体，以自身为中心进行360度范围攻击，半径6米，造成300点物理伤害并击退所有敌人3米。")
end

function M.cb()
    -- 技能开始时发出警告
    Skill_Say("吾将unleash我的尾击扫荡！速速退避！", 3)
    
    -- 等待3秒蓄力时间，模拟抬起尾巴的前摇动作
    Skill_Sleep(3000, "等待3秒蓄力时间，模拟抬起尾巴的前摇动作")
    
    -- 创建以自身为中心的视觉效果区域
    Skill_CreateSelfPosCircleRegion(6, 1, "创建以自身为中心的圆形视觉效果，表现360度攻击范围")
    
    -- 选择自身周围6米范围内的所有敌人
    Skill_CollectCircleTargets(6, 20, "选择自身周围6米范围内的所有敌人")
    
    -- 对选中的敌人造成300点物理伤害
    Skill_TargetDamage("damage_physical", 300, "对选中的敌人造成300点物理伤害")
    
    -- 对选中的敌人施加击退效果，将其击退3米
    Skill_TargetEnemyAddBuff("buff_beat_back", 1, 1, {3}, "对选中的敌人施加击退效果，将其击退3米")
end

return M