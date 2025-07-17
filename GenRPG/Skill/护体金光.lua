local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(120, "魔法消耗120点")
    Skill_SetCooldown(20000, "技能冷却时间20秒")
    Skill_SetCastRange(0, "只能对自己使用")
    Skill_SetMainTargetType("self", "目标类型为自己")
    Skill_SetDesc("中级防护仙术，形成金色护盾吸收伤害并反震敌人", "技能描述")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 为自己添加护盾buff
    -- 参数说明: {护盾值500, 全伤害护盾类型, 破碎伤害200, 破碎伤害范围4米}
    local buffArgs = {500, 'shield_all', 200, 4}
    Skill_SelfAddBuff('buff_shield', 1, 15000, buffArgs, "护体金光护盾")
    
    -- 技能为瞬发防护技能，无需等待
end

return M