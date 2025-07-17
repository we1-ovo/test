local M = {}

function M.init()
    -- 设置为被动技能，没有MP消耗
    Skill_SetMPCost(0, "被动技能无MP消耗")
    
    -- 无冷却时间
    Skill_SetCooldown(0, "被动技能无冷却时间")
    
    -- 施法距离设置为0，只能作用于自身
    Skill_SetCastRange(0, "只能对自身释放")
    
    -- 目标类型设置为自身
    Skill_SetMainTargetType("self", "目标类型为自己")
    
    -- 技能描述
    Skill_SetDesc("老修士生成一个保护性质的仙气屏障，使自己处于无敌状态，免疫一切伤害。", "仙气屏障被动技能")
end

function M.cb()
    -- 选择自身为目标
    Skill_CollectMainTarget("选择自身作为目标")
    
    -- 给自身添加一个持续时间极长的无敌buff
    -- 设置持续时间为3600000毫秒（1小时），相当于整个关卡持续时间
    Skill_SelfAddBuff('buff_invincible', 1, 3600000, {}, "添加无敌状态，持续1小时")
end

return M