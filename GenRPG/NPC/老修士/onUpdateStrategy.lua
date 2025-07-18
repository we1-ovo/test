local M = {}

function M.cb()
    -- 获取自身信息
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myElapsedTime = NPC_GetElapsedTime()
    
    -- 检查是否有玩家在附近
    local nearbyPlayers = NPC_GetNearbyEnemies(myPos, 5) -- 5米范围内检测玩家
    local playerNearby = #nearbyPlayers > 0
    
    -- 如果玩家在附近，转向面对玩家
    if playerNearby then
        local playerPos = NPC_GetPos(nearbyPlayers[1])
        local direction = {
            x = playerPos.x - myPos.x,
            y = 0,
            z = playerPos.z - myPos.z
        }
        NPC_Defend(direction, "面向靠近的玩家")
    end
    
    -- 检查是否已完成对话任务
    local taskCompleted = NPC_BlackboardGet("elder_task_completed")
    
    -- 如果对话任务已完成，使用瞬移离场技能
    if taskCompleted == "true" then
        -- 只执行一次瞬移离场
        if NPC_BlackboardGet("elder_leaving") ~= "true" then
            NPC_BlackboardSet("elder_leaving", "true")
            NPC_Say("贫道传授已毕，小友好自为之。")
            
            -- 添加短暂无敌状态保护离场过程
            NPC_Invincible(true)
            
            -- 使用瞬移离场技能
            NPC_CastSkill("瞬移离场")
            
            -- 3秒后完全离开场景
            local leaveTime = myElapsedTime + 3000 -- 3秒后
            NPC_BlackboardSet("leave_time", tostring(leaveTime))
        else
            -- 检查是否到达离场时间
            local leaveTime = tonumber(NPC_BlackboardGet("leave_time") or "0")
            if myElapsedTime >= leaveTime then
                NPC_Leave() -- 从场景中移除
            end
        end
    else
        -- 默认待机状态，偶尔做一些小动作增加生动感
        -- 每5秒做一次随机待机动作
        if (myElapsedTime % 5000) < 100 then -- 每5秒在100ms内触发一次
            local randomAction = math.random(1, 3)
            if randomAction == 1 then
                NPC_Say("修行之道，贵在坚持...")
            elseif randomAction == 2 then
                NPC_Say("天地之道，生生不息...")
            end
        end
    end
    
    -- 即使被攻击也保持超脱形象，不反击
    -- 如果血量低于原始血量的50%，表现出一些反应但仍不反击
    local myMaxHP = NPC_GetMaxHP("")
    if myHP < myMaxHP * 0.5 and NPC_BlackboardGet("low_hp_response") ~= "true" then
        NPC_BlackboardSet("low_hp_response", "true")
        NPC_Say("贫道已看破生死，何惧一击之伤...")
    end
end

return M