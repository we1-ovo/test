local M = {}

function M.init()
    -- 技能初始化
    Skill_SetMPCost(30, "设置魔法消耗为30点")
    Skill_SetCooldown(8000, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置技能施法距离为0米(以自身为中心)")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("范围践踏攻击，可造成眩晕", "技能描述")
end

function M.cb()
    -- 技能释放逻辑
    -- 1秒技能前摇动作
    Skill_Sleep(1000, "技能前摇动作")
    
    -- 选择自身为中心半径3米范围内的所有敌人目标，最多10个
    Skill_CollectCircleTargets(3, 10, "选择3米内的敌人")
    
    -- 对所有选中目标造成90点物理伤害
    Skill_TargetDamage("damage_physical", 90, "造成90点物理伤害")
    
    -- 对所有选中目标有30%几率添加眩晕效果，持续1.5秒
    Skill_TargetEnemyAddBuff("buff_stun", 0.3, 1500, {}, "30%几率眩晕1.5秒")
    
    -- 在地面创建一个震动效果
    Skill_CreateStaticSubObjAtSelfPos(1000, "创建地面震动效果")
end

return M