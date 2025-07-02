local M = {}

function M.cb()
    -- 检查自身存在
    if not NPC_IsAlive("") then
        return
    end

    -- 获取自身位置和状态信息
    local selfPos = NPC_GetPos("")
    local elapsedTime = NPC_GetElapsedTime()
    local playerUUID = "player"
    
    -- 检查是否需要离开场景
    local shouldLeave = NPC_BlackboardGet("老修士_should_leave")
    if shouldLeave == "true" then
        -- 向出口移动后离开场景
        local exitLocator = "locator_elder_exit"
        if NPC_IsReached(exitLocator, 1) then
            NPC_Say("贫道告辞了。记住用心修炼，悟道之路无捷径可走。")
            NPC_Leave()
        else
            NPC_MoveToLocator({x=0, y=0, z=-1}, "向出口移动", exitLocator, 20)
        end
        return
    end
    
    -- 检查玩家是否在附近
    if NPC_IsAlive(playerUUID) then
        local playerPos = NPC_GetPos(playerUUID)
        local distance = NPC_Distance(selfPos, playerPos)
        
        -- 如果玩家在5米内，面向玩家
        if distance <= 5 then
            -- 计算朝向玩家的方向
            local dir = {
                x = playerPos.x - selfPos.x,
                y = 0,
                z = playerPos.z - selfPos.z
            }
            -- 站立并面向玩家
            NPC_Defend(dir, "面向玩家")
            
            -- 检查是否需要传授技能
            local shouldTeachSkill = NPC_BlackboardGet("老修士_should_teach")
            if shouldTeachSkill == "true" then
                -- 使用传功术传授技能
                NPC_Say("老夫将毕生所学御风术传授于你，此术可助你在险境中脱身。")
                NPC_CastSkill("传功术")
                -- 标记已经教授过技能
                NPC_BlackboardSet("老修士_should_teach", "false")
                NPC_BlackboardSet("老修士_taught_skill", "true")
            end
            
            -- 检查是否已经传授完技能，准备离开
            local taughtSkill = NPC_BlackboardGet("老修士_taught_skill")
            if taughtSkill == "true" and elapsedTime > 5 then
                NPC_Say("贫道已将修炼之法传授于你，接下来的路要靠你自己了。灵草谷内危机四伏，小心前行。")
                NPC_BlackboardSet("老修士_should_leave", "true")
            end
        else
            -- 玩家不在附近，保持原地等待
            NPC_Defend({x=0, y=0, z=1}, "等待玩家靠近")
            
            -- 如果玩家很久没靠近，可以偶尔说话引导
            if elapsedTime > 10 and math.floor(elapsedTime) % 30 == 0 then
                NPC_Say("这位小友，老夫在此等候多时，可有兴趣学习仙家御风之术？")
            end
        end
    else
        -- 玩家不存在或不在场景中，保持原地等待
        NPC_Defend({x=0, y=0, z=1}, "等待玩家出现")
    end
end

return M