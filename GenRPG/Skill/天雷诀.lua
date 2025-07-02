local M = {}

function M.init()
    -- 按照设计文档初始化技能属性
    Skill_SetMPCost(150, "设置技能魔法消耗为150点")
    Skill_SetCooldown(12, "设置技能冷却时间为12秒")
    Skill_SetCastRange(10, "设置技能施法范围为10米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("强力雷系仙术，召唤天雷轰击敌人，造成攻击力3倍的雷电伤害，30%概率眩晕敌人2秒")
end

function M.cb()
    -- 选择主目标敌人作为攻击对象
    Skill_CollectMainTarget("选择主目标敌人")
    
    -- 创建天雷特效（从天而降的闪电）
    Skill_CreateStaticSubObjAtTargetPos(1, "创建天雷特效")
    
    -- 释放技能时喊话
    Skill_Say("天雷诀！", 1)
    
    -- 施法短暂延迟，模拟召唤天雷的过程
    Skill_Sleep(500, "天雷召唤时间")
    
    -- 对选中的敌人造成魔法伤害，伤害值为攻击力的3倍（约180点）
    Skill_TargetScaleDamage("damage_magic", 3, "造成3倍攻击力的魔法伤害")
    
    -- 有30%概率为敌人添加眩晕buff，持续2秒
    Skill_TargetEnemyAddBuff("buff_stun", 0.3, 2, {}, "30%概率眩晕敌人2秒")
end

return M