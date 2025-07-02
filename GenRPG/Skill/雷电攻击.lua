local M = {}

-- 雷电攻击技能初始化
function M.init()
    -- 根据设计文档设置技能基本参数
    Skill_SetMPCost(150, "设置技能消耗为150点魔法值")
    Skill_SetCooldown(5, "设置技能冷却时间为5秒")
    Skill_SetCastRange(15, "设置施法范围为15米")
    Skill_SetMainTargetType("enemy", "设置技能目标类型为敌人")
    Skill_SetDesc("千年蛟龙的远程单体技能，召唤一道雷电从天而降击中目标，造成250点魔法伤害，并有25%概率使敌人眩晕1秒")
end

-- 雷电攻击技能释放回调
function M.cb()
    -- 选择主要敌人目标
    Skill_CollectMainTarget("选择攻击目标")
    
    -- 在目标位置创建雷电预警特效
    Skill_CreateTargetPosCircleRegion(2, 1.5, "创建雷电预警区域")
    
    -- 等待1.5秒蓄力时间
    Skill_Sleep(1500, "蓄力时间1.5秒")
    
    -- 在目标位置创建静止子物体作为雷电
    Skill_CreateStaticSubObjAtTargetPos(0.5, "创建雷电特效")
    
    -- 对目标造成250点魔法伤害
    Skill_TargetDamage("damage_magic", 250, "造成250点魔法伤害")
    
    -- 有25%的概率使目标眩晕1秒
    Skill_TargetEnemyAddBuff("buff_stun", 0.25, 1, {}, "25%概率眩晕1秒")
    
    -- 技能释放完毕，可以在这里添加额外的效果或日志
    Skill_Say("雷电已降临!", 1)
end

return M