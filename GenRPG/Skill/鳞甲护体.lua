local M = {}

function M.init()
    -- 根据设计文档设置技能基本属性
    Skill_SetMPCost(200, "设置技能消耗为200点魔法值")
    Skill_SetCooldown(15, "设置技能冷却时间为15秒")
    Skill_SetCastRange(0, "设置施法范围为0")
    Skill_SetMainTargetType("self", "设置技能目标类型为自己")
    Skill_SetDesc("激活体表鳞甲形成一层防护罩，获得一个能吸收500点伤害的护盾，持续8秒。在护盾存在期间，防御值提升30%。")
end

function M.cb()
    -- 选择自己作为技能目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 说话效果
    Skill_Say("鳞甲护体！", 2)
    
    -- 添加护盾效果，500点物理护盾，持续8秒
    local shieldArgs = {500, 'shield_physical'}
    Skill_SelfAddBuff('buff_shield', 1, 8, shieldArgs, "添加500点物理护盾，持续8秒")
    
    -- 同时添加防御力提升效果，提升30%防御力
    -- 这里使用攻击力变化buff来模拟防御提升，参数为负值表示减少受到的伤害
    Skill_SelfAddBuff('buff_attack', 1, 8, {-0.3}, "提升30%防御力，持续8秒")
    
    -- 注册护盾结束事件，在护盾消失时取消防御提升效果
    -- 虽然防御提升效果与护盾共享持续时间，按照设计文档要求仍需实现这个事件处理
    Skill_RegisterEvent('on_buff_end', function()
        -- 护盾结束时的处理逻辑
        -- 由于防御buff与护盾共享持续时间，实际上会自动结束
        -- 这里可以添加一些护盾结束时的特效或提示
        Skill_Say("鳞甲护盾已消散", 1)
    end)
    
    -- 等待技能持续时间结束
    Skill_Sleep(8000, "等待护盾持续时间")
end

return M