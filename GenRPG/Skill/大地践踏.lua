local M = {}

function M.init()
    -- 技能初始化设置
    Skill_SetCooldown(8, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置施法距离为0米，因为是以自身为中心的范围技能")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetMPCost(0, "技能不消耗MP值，为NPC的区域控制技能")
    Skill_SetDesc("石熊双脚猛踏地面，对周围3米范围内的敌人造成物理伤害并产生短暂眩晕效果。冷却时间8秒，伤害为攻击力的80%，眩晕效果持续1.5秒。")
end

function M.cb()
    -- 石熊发出怒吼，增强技能气势
    Skill_Say("吼！！", 1.5)
    
    -- 创建地面震动效果
    Skill_CreateSelfPosCircleRegion(3, 0.5, "创建震动范围效果，显示踏地产生的冲击波")
    
    -- 选择3米范围内的敌人目标
    Skill_CollectCircleTargets(3, 10, "选择以自身为中心3米范围内的敌人")
    
    -- 对所有选中目标造成物理伤害，伤害值为石熊攻击力的80%
    Skill_TargetScaleDamage("damage_physical", 0.8, "造成石熊攻击力80%的物理伤害")
    
    -- 对所有选中目标添加眩晕效果，持续1.5秒
    Skill_TargetEnemyAddBuff("buff_stun", 1, 1.5, {}, "添加1.5秒的眩晕效果")
end

return M