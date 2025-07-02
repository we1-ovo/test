local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(30, "设置魔法消耗为30点，作为山猿最强力的范围攻击技能")
    Skill_SetCooldown(10, "设置技能冷却时间为10秒，符合设计文档要求")
    Skill_SetCastRange(0, "设置施法距离为0米，因为是以自身为中心的范围技能")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人，只对敌方单位造成伤害和击退效果")
    Skill_SetDesc("山猿用力击打地面，对周围3米内敌人造成1.5倍攻击力的物理伤害并击退1.5米")
end

function M.cb()
    -- 技能释放前摇动作
    Skill_Sleep(500, "山猿猛击地面的前摇动作，持续0.5秒")
    
    -- 选择范围内的敌人
    Skill_CollectCircleTargets(3, 20, "选择自身周围3米范围内的所有敌人")
    
    -- 在地面创建震动效果
    Skill_CreateSelfPosCircleRegion(3, 1, "创建地面震动效果区域")
    
    -- 对选中敌人造成伤害
    Skill_TargetScaleDamage("damage_physical", 1.5, "对敌人造成1.5倍攻击力的物理伤害")
    
    -- 对选中敌人添加击退效果
    Skill_TargetEnemyAddBuff("buff_beat_back", 1, 0.5, {1.5}, "将敌人击退1.5米")
    
    -- 山猿击打地面的喊话效果，增强表现力
    Skill_Say("吃我一击！", 1)
end

return M