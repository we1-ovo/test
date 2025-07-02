local M = {}

function M.init()
    -- 被动技能无魔法消耗
    Skill_SetMPCost(0, "设置魔法消耗为0点，因为是被动技能")
    -- 设置闪避技能冷却时间为2秒
    Skill_SetCooldown(2, "设置技能冷却时间为2秒，符合设计文档中的闪避冷却时间")
    -- 被动技能不需要施法距离
    Skill_SetCastRange(0, "设置技能施法距离为0")
    -- 被动技能作用于自身
    Skill_SetMainTargetType("self", "设置目标类型为自己")
    -- 设置技能描述
    Skill_SetDesc("被攻击时有20%几率闪避伤害并移动到敌人侧面2-3米处")
end

function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget()
    
    -- 注册被攻击事件处理函数
    Skill_RegisterEvent("on_be_attack", function()
        -- 20%概率触发闪避
        if math.random() <= 0.2 then
            -- 进入无敌状态以闪避伤害
            Skill_Invincible(true, "进入无敌状态闪避伤害")
            
            -- 获取敌人位置
            local enemyPos = Skill_GetEnemyPos()
            -- 获取自身位置
            local selfPos = Skill_GetSelfPos()
            -- 获取自身朝向
            local selfDir = Skill_GetSelfDir()
            
            -- 随机决定向左或向右闪避（90度或270度）
            local moveAngle = math.random() < 0.5 and 90 or 270
            -- 随机决定闪避距离(2-3米)
            local moveDistance = 2 + math.random()
            
            -- 以高速闪避到敌人侧面
            Skill_MoveTo(moveAngle, 8, moveDistance)
            
            -- 闪避完成后解除无敌状态
            Skill_Invincible(false, "闪避完成，解除无敌状态")
            
            -- 可以添加闪避成功的提示（可选）
            Skill_Say("闪避成功！", 1)
        end
    end)
    
    -- 被动技能，无需额外的执行逻辑
end

return M