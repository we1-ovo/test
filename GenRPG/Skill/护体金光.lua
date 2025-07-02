local M = {}

function M.init()
    -- 初始化技能参数
    Skill_SetMPCost(120, "设置技能魔法消耗为120点")
    Skill_SetCooldown(20, "设置技能冷却时间为20秒")
    Skill_SetCastRange(0, "设置技能施法范围为0米（自身技能）")
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    Skill_SetDesc("中级防护仙术。在身周形成金色护盾，吸收一定伤害并反弹部分攻击。")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 为自己添加护盾buff
    -- 参数说明: {护盾值, 护盾类型, 摧毁时造成伤害值, 伤害范围}
    local buffArgs = {500, 'shield_all', 200, 4}
    Skill_SelfAddBuff('buff_shield', 1, 15, buffArgs, "添加全属性护盾，护盾值500点，持续15秒，摧毁时造成200点反震伤害")
    
    -- 添加护盾效果提示
    Skill_Say("护体金光，护我无恙！", 2)
    
    -- 注册护盾被摧毁时的事件
    Skill_RegisterEvent("on_buff_end", function()
        -- 当护盾被摧毁时，会自动触发伤害，这里可以添加额外的视觉效果或提示
        Skill_Say("金光护盾，反震敌寇！", 1)
    end)
    
    -- 等待护盾持续时间
    Skill_Sleep(15000, "等待护盾持续时间结束")
end

return M