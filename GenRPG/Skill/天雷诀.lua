local M = {}

function M.init()
    -- 按照设计文档初始化技能参数
    Skill_SetMPCost(150, "设置魔法消耗为150点MP")
    Skill_SetCooldown(12, "设置技能冷却时间为12秒")
    Skill_SetCastRange(10, "设置施法距离为10米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人单体")
    Skill_SetDesc("最强雷系仙术，召唤天雷轰击敌人，造成巨大魔法伤害并有概率造成眩晕。")
end

function M.cb()
    -- 选择主要敌人目标
    Skill_CollectMainTarget("选择主要敌人目标")
    
    -- 创建天雷效果
    -- 在目标位置创建一个静止的子物体，表示天雷从天而降
    Skill_CreateStaticSubObjAtTargetPos(1.5, "创建天雷特效")
    
    -- 等待短暂时间，模拟天雷蓄力过程
    Skill_Sleep(800, "天雷蓄力时间")
    
    -- 造成伤害
    Skill_TargetScaleDamage("damage_magic", 3.0, "造成3倍攻击力的雷电伤害")
    
    -- 添加眩晕效果
    Skill_TargetEnemyAddBuff("buff_stun", 0.3, 2, {}, "30%概率眩晕敌人2秒")
    
    -- 模拟天雷效果结束
    Skill_Sleep(700, "天雷效果结束")
end

return M