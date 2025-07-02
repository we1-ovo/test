local M = {}

function M.init()
    -- 设置技能基本属性
    Skill_SetMPCost(10, "设置魔法消耗为10点，因为是天赋灵气，消耗较低")
    Skill_SetCooldown(8, "设置技能冷却时间为8秒，符合设计文档要求")
    Skill_SetCastRange(0, "设置施法距离为0米，因为是以自身为中心施放的技能")
    Skill_SetMainTargetType("self", "设置目标类型为自己，作为灵狐的保命技能")
    Skill_SetDesc("灵狐施展天赋灵气，快速移动到附近2-4米的随机位置。当自身血量低于40%时，有50%几率在被攻击时触发此技能。")
end

function M.cb()
    -- 选择自己作为技能目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 获取自身当前血量和最大血量
    local currentHP = Skill_GetSelfHP()
    local maxHP = Skill_GetSelfMaxHP()
    
    -- 注册被攻击事件，当被攻击时可能触发闪避
    Skill_RegisterEvent("on_be_attack", function()
        -- 再次获取当前血量以确保使用最新数据
        local hp = Skill_GetSelfHP()
        local maxhp = Skill_GetSelfMaxHP()
        local hpPercent = hp / maxhp
        
        -- 检查是否满足触发条件：血量低于40%且50%触发几率
        if hpPercent < 0.4 and math.random() < 0.5 then
            -- 随机选择一个方向角度（0-360度）
            local randomAngle = math.random(0, 360)
            
            -- 随机选择一个距离（2-4米）
            local randomDistance = math.random() * 2 + 2
            
            -- 以两倍速度向随机方向闪避
            Skill_MoveTo(randomAngle, 2.0, randomDistance)
            
            -- 显示技能触发效果
            Skill_Say("灵气闪避！", 1)
        end
    end)
    
    -- 技能释放完成
    -- 注意：闪避效果实际是在被攻击事件中触发的
end

return M