local M = {}

function M.init()
    -- 初始化技能基本属性
    Skill_SetMPCost(120, "设置魔法消耗为120点MP")
    Skill_SetCooldown(20, "设置技能冷却时间为20秒")
    Skill_SetCastRange(0, "设置施法距离为0米（自身技能）")
    Skill_SetMainTargetType("self", "设置目标类型为自身")
    Skill_SetDesc("中级防护仙术。在身周形成金色护盾，吸收一定伤害并反弹部分攻击。")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为目标")
    
    -- 为自己添加护盾buff
    -- 参数说明：{护盾值500, 护盾类型为全护盾, 摧毁时造成200点伤害, 伤害范围4米}
    local buffArgs = {500, 'shield_all', 200, 4}
    Skill_SelfAddBuff('buff_shield', 1, 15, buffArgs, "添加500点全护盾，持续15秒，摧毁时反震200伤害")
    
    -- 技能释放时的音效或视觉效果可以通过API添加
    -- 由于是瞬发防护技能，无需等待时间
end

return M