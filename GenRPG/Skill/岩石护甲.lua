local M = {}

function M.init()
    -- 设置技能的基本属性
    Skill_SetMPCost(50, "设置魔法消耗为50点")
    Skill_SetCooldown(15000, "设置冷却时间为15秒")
    Skill_SetCastRange(0, "设置技能只能作用于自己")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("增加自身护盾和攻击力，护盾破碎时造成范围伤害", "岩石护甲效果描述")
end

function M.cb()
    -- 选择自己作为技能目标
    Skill_CollectMainTarget("选择自己为技能目标")
    
    -- 添加物理护盾，护盾值200点，破碎时对3米范围内敌人造成50点伤害
    local shieldArgs = {200, 'shield_physical', 50, 3}
    Skill_SelfAddBuff('buff_shield', 1, 8000, shieldArgs, "添加200点物理护盾，破碎时造成范围伤害")
    
    -- 增加攻击力30%，持续8秒
    local attackArgs = {30}
    Skill_SelfAddBuff('buff_attack', 1, 8000, attackArgs, "提升攻击力30%，持续8秒")
    
    -- 说出技能使用语音
    Skill_Say("岩石护甲，守护我！", 2000, "技能释放语音")
end

return M