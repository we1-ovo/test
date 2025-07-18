local M = {}
function M.cb()
    -- 获取自身位置
    local myPos = NPC_GetPos("")
    -- 获取自身血量和最大血量
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    -- 计算当前血量百分比
    local hpPercent = myHP / myMaxHP * 100
    
    -- 自动选择最近的目标(玩家)
    local targetNpcUUID = NPC_AutoSelectTarget(8)
    
    -- 如果没有目标或者目标已死亡，则在周围巡逻
    if targetNpcUUID == nil or not NPC_IsAlive(targetNpcUUID) then
        -- 检查是否需要巡逻
        local patrolTime = tonumber(NPC_BlackboardGet("patrol_time") or "0")
        local currentTime = NPC_GetElapsedTime()
        
        if currentTime - patrolTime > 3000 then -- 每3秒改变一次巡逻位置
            -- 在原始位置附近获取随机位置进行巡逻
            local randomPos = NPC_GetRandomPos(myPos, 5)
            NPC_MoveToPos({0, 0, 1}, "巡逻中", randomPos, 3000)
            NPC_BlackboardSet("patrol_time", tostring(currentTime))
        end
        return
    end
    
    -- 获取目标位置
    local targetPos = NPC_GetPos(targetNpcUUID)
    -- 计算与目标的距离
    local distance = NPC_Distance(myPos, targetPos)
    
    -- 检查周围的友方单位数量和位置
    local nearbyFriendCount = NPC_GetNearbyFriendCount(myPos, 5)
    local nearbyFriends = NPC_GetNearbyFriends(myPos, 5)
    
    -- 与友方单位保持位置分散
    if nearbyFriendCount > 0 and #nearbyFriends > 0 then
        -- 检查与最近友方单位的距离
        local closestFriendUUID = nearbyFriends[1] -- 数组中第一个是最近的友方
        local closestFriendPos = NPC_GetPos(closestFriendUUID)
        local distanceToFriend = NPC_Distance(myPos, closestFriendPos)
        
        -- 如果与友方距离过近，需要分散位置
        if distanceToFriend < 3 then
            -- 计算远离友方单位的方向
            local disperseDir = {
                myPos.x - closestFriendPos.x,
                myPos.y - closestFriendPos.y,
                myPos.z - closestFriendPos.z
            }
            -- 计算分散位置
            local dispersePos = {
                x = myPos.x + disperseDir[1] * 2,
                y = myPos.y + disperseDir[2] * 2,
                z = myPos.z + disperseDir[3] * 2
            }
            NPC_MoveToPos(disperseDir, "与友方保持分散", dispersePos, 2000)
            return
        end
    end
    
    -- 检查猿啸技能使用时间
    local lastHowlTime = tonumber(NPC_BlackboardGet("last_howl_time") or "0")
    local currentTime = NPC_GetElapsedTime()
    local isLastAlive = (NPC_BlackboardGet("is_last_alive") == "true")
    
    -- 检查是否是战斗中最后一个存活单位
    if not isLastAlive and nearbyFriendCount == 0 then
        NPC_BlackboardSet("is_last_alive", "true")
    end
    
    -- 使用猿啸技能的条件：周围有友方单位，且距离上次使用超过60秒或者是战斗开始
    if nearbyFriendCount > 0 and (currentTime - lastHowlTime > 60000 or lastHowlTime == 0) then
        NPC_CastSkill("猿啸")
        NPC_BlackboardSet("last_howl_time", tostring(currentTime))
    end
    
    -- 根据血量低于30%时的行为变化
    if hpPercent < 30 then
        -- 低血量时尝试拉开距离
        if distance < 4 then
            -- 获取远离玩家的位置
            local retreatDir = {
                myPos.x - targetPos.x,
                myPos.y - targetPos.y,
                myPos.z - targetPos.z
            }
            -- 计算后退位置
            local retreatPos = {
                x = myPos.x + retreatDir[1],
                y = myPos.y + retreatDir[2],
                z = myPos.z + retreatDir[3]
            }
            NPC_MoveToPos(retreatDir, "撤退中", retreatPos, 2000)
            return
        end
        
        -- 尝试使用远程技能
        if distance <= 6 then
            NPC_CastSkill("石块投掷")
        end
    else
        -- 正常血量下的战斗逻辑
        
        -- 根据与玩家距离选择合适的攻击方式
        if distance > 2 and distance <= 6 then
            -- 在远程攻击范围内，使用石块投掷
            NPC_CastSkill("石块投掷")
        elseif distance <= 2 then
            -- 在近战攻击范围内，使用猿拳
            NPC_CastSkill("猿拳")
        else
            -- 超出攻击范围，追击玩家
            NPC_Chase({0, 0, 1}, "追击玩家", targetNpcUUID, 2)
        end
    end
    
    -- 如果是最后一个存活单位，提高攻击频率
    if isLastAlive then
        -- 追击更为激进
        NPC_Chase({0, 0, 1}, "激进追击", targetNpcUUID, 1.5)
    end
end
return M