local M = {}

function M.init()
    -- 初始化技能基本属性
    Skill_SetMPCost(60, "设置魔法消耗为60点")
    Skill_SetCooldown(8, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置施法范围为0（以自身为中心）")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("石熊用力踏地，对周围4米范围内的所有敌人造成100%攻击力的物理伤害，并使地面产生短暂震动效果，减速范围内敌人30%持续2秒。")
end

function M.cb()
    -- 技能施法动作时间
    Skill_Sleep(700, "石熊抬起前肢然后重重踏地的施法动作，持续0.7秒")
    
    -- 对周围敌人造成伤害
    Skill_CollectCircleTargets(4, 20, "选择4米圆形区域内的所有敌人")
    Skill_TargetScaleDamage("damage_physical", 1.0, "对选中敌人造成100%攻击力的物理伤害")
    
    -- 对所有被击中的敌人施加减速效果
    Skill_TargetEnemyAddBuff("buff_speed", 1.0, 2, {-0.3}, "为所有被击中的敌人添加减速30%，持续2秒")
    
    -- 创建地面裂纹和轻微震动的区域效果
    Skill_CreateSelfPosCircleRegion(4, 3, "在地面创建一个持续3秒的圆形区域效果，表现为地面裂纹和轻微震动")
    
    -- 区域内的敌人受到减速效果
    Region_AddStayBuff("buff_speed", 1.0, 2, {-0.3}, "enemy", "区域内敌人减速30%，持续2秒")
    
    -- 技能释放完成
    Skill_Say("大地的力量！", 2)
end

return M