local M = {}

function M.init()
    -- 无魔法消耗，NPC释放技能不考虑MP消耗
    -- 设置技能冷却时间为6秒，符合设计文档要求
    Skill_SetCooldown(6, "设置技能冷却时间为6秒")
    -- 设置技能施法距离为4米，对应猛扑攻击的距离
    Skill_SetCastRange(4, "设置技能施法距离为4米")
    -- 设置技能目标类型为敌人，因为这是一个对敌人使用的攻击技能
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("灵豹向目标猛扑并攻击，造成高额物理伤害并减速目标20%，持续2秒。冷却6秒，攻击距离4米。")
end

function M.cb()
    -- 先使用Skill_Sleep实现0.5秒的准备动作时间，模拟灵豹低伏身体的过程
    Skill_Sleep(500, "灵豹低伏身体，准备猛扑")
    
    -- 选择主目标敌人
    Skill_CollectMainTarget("选择攻击目标")
    
    -- 使用Skill_MoveToTarget快速移动到目标位置，速度设置为灵豹基础速度的1.5倍
    Skill_MoveToTarget(1.5)
    
    -- 到达目标位置后，对目标造成物理伤害，伤害值设为90（高于普通攻击的伤害）
    Skill_TargetDamage("damage_physical", 90, "猛扑攻击造成90点物理伤害")
    
    -- 为被攻击的敌人添加减速效果，减速20%，持续2秒
    Skill_TargetEnemyAddBuff("buff_speed", 1, 2, {-0.2}, "对目标施加20%减速效果，持续2秒")
end

return M