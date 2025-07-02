local M = {}

function M.cb()
    -- 获取自身信息
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local mySpeed = NPC_GetSpeed("")
    local HPPercent = myHP / myMaxHP * 100
    
    -- 获取目标信息
    local targetUUID = NPC_BlackboardGet("targetUUID") or ""
    if targetUUID == "" or not NPC_IsAlive(targetUUID) then
        -- 自动选择新目标
        targetUUID = NPC_AutoSelectTarget(10)
        if targetUUID ~= "" then
            NPC_BlackboardSet("targetUUID", targetUUID)
        end
    end
    
    -- 检查是否处于战斗状态
    local inCombat = targetUUID ~= ""
    
    -- 检查是否进入狂暴状态(血量低于30%)
    local isEnraged = HPPercent <= 30
    if isEnraged and NPC_BlackboardGet("isEnraged") ~= "true" then
        NPC_BlackboardSet("isEnraged", "true")
        -- 狂暴状态提升攻击力(通过移动速度和技能频率表现)
        NPC_SetSpeed(mySpeed * 0.8) -- 移动更慢但攻击更频繁
        NPC_Say("吼！！！")
    end
    
    -- 处理战斗状态
    if inCombat then
        local targetPos = NPC_GetPos(targetUUID)
        local distToTarget = NPC_Distance(myPos, targetPos)
        local skillCastTime = tonumber(NPC_BlackboardGet("lastSkillCastTime") or "0")
        local currentTime = NPC_GetElapsedTime()
        
        -- 战斗逻辑
        if distToTarget <= 8 then -- 在战斗范围内
            -- 血量低于50%时优先使用护盾技能
            if HPPercent <= 50 and currentTime - skillCastTime > 15 then -- 岩肤护盾冷却15秒
                NPC_CastSkill("岩肤护盾")
                NPC_BlackboardSet("lastSkillCastTime", tostring(currentTime))
                NPC_Say("岩石为盾！")
            -- 当有2个以上敌人在附近时使用群体技能
            elseif NPC_GetNearbyEnemyCount(myPos, 4) >= 2 and currentTime - skillCastTime > 8 then -- 地裂践踏冷却8秒
                NPC_CastSkill("地裂践踏")
                NPC_BlackboardSet("lastSkillCastTime", tostring(currentTime))
                NPC_Say("大地震颤！")
            -- 优先使用主要输出技能
            elseif distToTarget <= 3 and currentTime - skillCastTime > (isEnraged and 4.8 or 6) then -- 岩石砸击冷却6秒(狂暴时缩短20%)
                NPC_CastSkill("岩石砸击")
                NPC_BlackboardSet("lastSkillCastTime", tostring(currentTime))
                NPC_Say("粉碎！")
            -- 当技能都在冷却中时使用普通攻击
            elseif distToTarget <= 2 and currentTime - skillCastTime > (isEnraged and 1.6 or 2) then -- 普通攻击间隔约2秒(狂暴时缩短20%)
                NPC_CastSkill("普通攻击")
                NPC_BlackboardSet("lastSkillCastTime", tostring(currentTime))
            end
            
            -- 追击目标但保持在技能攻击范围内
            if distToTarget > 3 then
                NPC_Chase({x=0, y=0, z=1}, "chasing_target", targetUUID, 2)
            else
                -- 已经在攻击范围内，尝试将目标逼向石桥或其他石熊
                local bridgePos = NPC_GetPos(NPC_BlackboardGet("otherBearUUID") or "")
                if NPC_BlackboardGet("otherBearUUID") and NPC_IsAlive(NPC_BlackboardGet("otherBearUUID")) then
                    -- 如果有其他石熊活着，尝试将目标逼向它
                    local dirToOther = {
                        x = bridgePos.x - myPos.x,
                        y = 0,
                        z = bridgePos.z - myPos.z
                    }
                    NPC_Defend(dirToOther, "coordinating_with_other_bear")
                else
                    -- 否则尝试将目标逼向石桥
                    local locatorPos = {}
                    if NPC_IsReached("locator_valley_middle_bears", 5) then
                        locatorPos = NPC_GetPos("") -- 如果已经在石桥附近，就原地防守
                    else
                        -- 尝试回到石桥防守点
                        NPC_MoveToLocator({x=0, y=0, z=1}, "returning_to_bridge", "locator_valley_middle_bears", 15)
                        return
                    end
                    NPC_Defend({x=0, y=0, z=1}, "defending_bridge")
                end
            end
        else -- 目标太远，无法立即接近
            -- 如果被远程攻击且无法立即接近目标，回到石桥防守
            if not NPC_IsReached("locator_valley_middle_bears", 10) then
                NPC_MoveToLocator({x=0, y=0, z=1}, "returning_to_bridge", "locator_valley_middle_bears", 15)
            else
                -- 在石桥附近巡逻并等待敌人接近
                if not NPC_BlackboardGet("patrolDirection") then
                    NPC_BlackboardSet("patrolDirection", "1")
                end
                
                local patrolDirection = NPC_BlackboardGet("patrolDirection")
                if patrolDirection == "1" then
                    -- 向石桥一端巡逻
                    local patrolPos = {
                        x = myPos.x + 5, 
                        y = myPos.y, 
                        z = myPos.z
                    }
                    NPC_MoveToPos({x=1, y=0, z=0}, "patrolling_bridge_side_1", patrolPos, 5)
                    NPC_BlackboardSet("patrolDirection", "2")
                else
                    -- 向石桥另一端巡逻
                    local patrolPos = {
                        x = myPos.x - 5, 
                        y = myPos.y, 
                        z = myPos.z
                    }
                    NPC_MoveToPos({x=-1, y=0, z=0}, "patrolling_bridge_side_2", patrolPos, 5)
                    NPC_BlackboardSet("patrolDirection", "1")
                end
            end
        end
    else -- 非战斗状态
        -- 检测其他石熊
        local otherBears = NPC_GetNearbyFriends(myPos, 20)
        local foundOtherBear = false
        for _, bearUUID in ipairs(otherBears) do
            if bearUUID ~= NPC_BlackboardGet("selfUUID") and NPC_IsAlive(bearUUID) then
                NPC_BlackboardSet("otherBearUUID", bearUUID)
                foundOtherBear = true
                break
            end
        end
        
        -- 如果没有找到其他石熊，记录自己的UUID
        if not foundOtherBear and not NPC_BlackboardGet("selfUUID") then
            -- 生成一个唯一标识用于自身识别
            local uniqueID = tostring(NPC_GetElapsedTime())
            NPC_BlackboardSet("selfUUID", uniqueID)
        end
        
        -- 在石桥两端巡逻
        if not NPC_IsReached("locator_valley_middle_bears", 15) then
            -- 如果不在石桥附近，先回到石桥
            NPC_MoveToLocator({x=0, y=0, z=1}, "returning_to_bridge", "locator_valley_middle_bears", 10)
        else
            -- 在石桥附近巡逻
            if not NPC_BlackboardGet("patrolDirection") then
                NPC_BlackboardSet("patrolDirection", "1")
            end
            
            local patrolDirection = NPC_BlackboardGet("patrolDirection")
            if patrolDirection == "1" then
                -- 向石桥一端巡逻
                local patrolPos = {
                    x = myPos.x + 5, 
                    y = myPos.y, 
                    z = myPos.z
                }
                NPC_MoveToPos({x=1, y=0, z=0}, "patrolling_bridge_side_1", patrolPos, 5)
                NPC_BlackboardSet("patrolDirection", "2")
            else
                -- 向石桥另一端巡逻
                local patrolPos = {
                    x = myPos.x - 5, 
                    y = myPos.y, 
                    z = myPos.z
                }
                NPC_MoveToPos({x=-1, y=0, z=0}, "patrolling_bridge_side_2", patrolPos, 5)
                NPC_BlackboardSet("patrolDirection", "1")
            end
        end
    end
end

return M