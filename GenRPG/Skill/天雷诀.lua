local M = {}

function M.init()
    -- 按照设计文档初始化技能参数
    Skill_SetMPCost(150, "设置技能魔法消耗为150点")
    Skill_SetCooldown(12000, "设置技能冷却时间为12秒")
    Skill_SetCastRange(10, "设置施法范围为10米")
    Skill_SetMainTargetType("enemy", "设置主目标类型为敌人")
    Skill_SetDesc("最终解锁的强力雷系仙术，召唤天雷轰击敌人。造成攻击力3倍的魔法伤害，30%概率眩晕敌人2秒。", "强力雷系仙术")
end

function M.cb()
    -- 选择主要攻击目标
    Skill_CollectMainTarget("选择天雷诀的目标")
    
    -- 创建天雷效果(可选)
    Skill_CreateStaticSubObjAtTargetPos(1000, "在目标位置创建天雷视觉效果")
    
    -- 造成3倍攻击力的魔法伤害
    Skill_TargetScaleDamage("damage_magic", 3, "天雷诀造成3倍攻击力的魔法伤害")
    
    -- 30%概率眩晕敌人2秒
    Skill_TargetEnemyAddBuff("buff_stun", 0.3, 2000, {}, "天雷诀30%概率眩晕敌人2秒")
    
    -- 技能释放完毕
    Skill_Say("天雷法术，万物显形！", 1500, "施法者喊话")
end

return M