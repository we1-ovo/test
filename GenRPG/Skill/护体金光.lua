local M = {}

function M.init()
    -- 初始化技能属性
    Skill_SetMPCost(120, "设置魔法消耗为120点")
    Skill_SetCooldown(20000, "设置技能冷却时间为20秒")
    Skill_SetCastRange(0, "设置施法范围为0")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("中级防护仙术，形成金色护盾吸收伤害并反震敌人。生成500点全伤害护盾，持续15秒，护盾破碎时对4米范围敌人造成200点反震伤害。", "中级防护仙术")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为施法目标")
    
    -- 为自己添加护盾buff
    -- 参数说明：{护盾值, 护盾类型, 破碎时造成伤害, 破碎时伤害范围}
    local buffArgs = {500, 'shield_all', 200, 4}
    Skill_SelfAddBuff('buff_shield', 1, 15000, buffArgs, "添加500点全伤害护盾，持续15秒")
    
    -- 在施法时显示一个简单的特效或提示
    Skill_Say("护体金光！", 1500, "施法提示")
    
    -- 等待护盾持续时间结束
    Skill_Sleep(15000, "护盾持续时间")
end

return M