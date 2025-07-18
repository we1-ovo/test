local M = {}

function M.init()
    -- 按照设计文档初始化技能参数
    Skill_SetMPCost(15, "设置魔法消耗为15点")
    Skill_SetCooldown(3000, "设置冷却时间为3秒")
    Skill_SetCastRange(2, "设置攻击距离为2米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("石熊将前爪变为坚硬的石块，对目标造成单体重击。", "单体重击，造成物理伤害")
end

function M.cb()
    -- 技能释放逻辑
    -- 选择主目标作为攻击对象
    Skill_CollectMainTarget("选择单一攻击目标")
    
    -- 对目标造成物理伤害
    Skill_TargetDamage("damage_physical", 120, "造成120点物理伤害")
    
    -- 石块碎裂特效（通过创建短暂存在的静态子物体来表现）
    Skill_CreateStaticSubObjAtTargetPos(500, "创建石块碎裂特效")
end

return M