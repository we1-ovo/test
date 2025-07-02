local M = {}

function M.cb()
    -- 获取老修士自身位置和状态
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local elapsedTime = NPC_GetElapsedTime()
    
    -- 获取玩家位置
    local playerPos = NPC_GetPos("Player")
    local distanceToPlayer = NPC_Distance(myPos, playerPos)
    
    -- 获取当前剧情状态
    local currentState = NPC_BlackboardGet("elder_state") or "waiting"
    
    -- 剧情状态机
    if currentState == "waiting" then
        -- 初始等待状态，展示仙风
        if elapsedTime % 10 < 0.1 then
            -- 每10秒展示一次仙风效果
            NPC_CastSkill("仙风展露")
        end
        
        -- 玩家靠近时，转向面对玩家
        if distanceToPlayer <= 5 then
            -- 计算朝向玩家的方向
            local dir = {
                x = playerPos.x - myPos.x,
                y = playerPos.y - myPos.y,
                z = playerPos.z - myPos.z
            }
            -- 面对玩家并进入对话状态
            NPC_Defend(dir, "面向玩家")
            NPC_BlackboardSet("elder_state", "dialog")
        end
    
    elseif currentState == "dialog" then
        -- 对话状态，保持面向玩家
        local dir = {
            x = playerPos.x - myPos.x,
            y = playerPos.y - myPos.y,
            z = playerPos.z - myPos.z
        }
        NPC_Defend(dir, "对话中")
        
        -- 继续展示仙风效果
        if elapsedTime % 15 < 0.1 then
            NPC_CastSkill("仙风展露")
        end
        
        -- 检查是否需要传授技能
        local shouldTeachSkill = NPC_BlackboardGet("should_teach_skill")
        if shouldTeachSkill == "true" then
            -- 施放技能传授
            NPC_CastSkill("御风术传授")
            -- 标记技能已传授
            NPC_BlackboardSet("skill_taught", "true")
            -- 等待一小段时间再离开
            NPC_BlackboardSet("elder_state", "prepare_leave")
        end
        
    elseif currentState == "prepare_leave" then
        -- 技能传授完毕，准备离开
        if elapsedTime % 5 < 0.1 then
            -- 再次展示一次仙风效果
            NPC_CastSkill("仙风展露")
        end
        
        -- 是否可以离开了
        local canLeave = NPC_BlackboardGet("elder_can_leave")
        if canLeave == "true" then
            NPC_BlackboardSet("elder_state", "leaving")
        end
    
    elseif currentState == "leaving" then
        -- 离开状态，向出口移动
        local exitLocator = "locator_elder_exit"
        
        -- 检查是否已到达出口
        if NPC_IsReached(exitLocator, 2) then
            -- 到达出口，消失
            NPC_Say("吾去也，切记勤加修炼...")
            NPC_Leave()
        else
            -- 移动到出口
            local dir = {x = 0, y = 0, z = 1}  -- 默认朝向
            NPC_MoveToLocator(dir, "老修士离开", exitLocator, 30)
        end
    end
end

return M