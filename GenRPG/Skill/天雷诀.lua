local M = {}

function M.init()
    -- 初始化技能基础参数
    Skill_SetMPCost(150, "设置魔法消耗为150点")
    Skill_SetCooldown(8000, "设置技能冷却时间为8秒")
    Skill_SetCastRange(10, "设置施法范围为10米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("最终解锁的强力雷系仙术，召唤天雷轰击敌人，造成高额魔法伤害，有一定概率眩晕敌人。", "强力雷系仙术")
end

function M.cb()
    -- 选择主要目标
    Skill_CollectMainTarget("选择主目标敌人")
    
    -- 创建天雷特效
    Skill_CreateStaticSubObjAtTargetPos(1000, "在目标位置创建天雷特效")
    
    -- 造成伤害，伤害为攻击力的3倍
    Skill_TargetScaleDamage("damage_magic", 3, "造成3倍攻击力的魔法伤害")
    
    -- 30%概率眩晕目标2秒
    Skill_TargetEnemyAddBuff("buff_stun", 0.3, 2000, {}, "30%概率眩晕目标2秒")
    
    -- 释放技能时的喊话效果
    Skill_Say("天雷诀！", 1000, "施放技能喊话")
end

return M