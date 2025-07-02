local M = {}

function M.cb()
    -- 获取自身状态信息
    local selfPos = NPC_GetPos("")
    local selfHP = NPC_GetHP("")
    local selfMaxHP = NPC_GetMaxHP("")
    local hpPercent = selfHP / selfMaxHP
    
    -- 获取出生位置信息（从黑板存储中获取，如果没有则使用当前位置）
    local spawnPos = NPC_BlackboardGet("spawn_pos")
    if spawnPos == "" then
        spawnPos = selfPos.x .. "," .. selfPos.y .. "," .. selfPos.z
        NPC_BlackboardSet("spawn_pos", spawnPos)
    end
    
    -- 尝试获取目标
    local targetUUID = NPC_BlackboardGet("target_uuid")
    if targetUUID ~= "" then
        -- 检查目标是否还活着
        if not NPC_IsAlive(targetUUID) then
            targetUUID = ""
            NPC_BlackboardSet("target_uuid", "")
        end
    end
    
    -- 如果没有目标，尝试选择一个新目标
    if targetUUID == "" then
        targetUUID = NPC_AutoSelectTarget(8) -- 感知范围为8米
        if targetUUID ~= "" then
            NPC_BlackboardSet("target_uuid", targetUUID)
            -- 发现目标时，发出警告
            NPC_Say("呜~")
        end
    end
    
    -- 如果有目标，执行战斗逻辑
    if targetUUID ~= "" then
        -- 获取目标位置
        local targetPos = NPC_GetPos(targetUUID)
        local distanceToTarget = NPC_Distance(selfPos, targetPos)
        
        -- 超出追击范围，放弃目标返回出生点
        if distanceToTarget > 12 then
            targetUUID = ""
            NPC_BlackboardSet("target_uuid", "")
            
            -- 解析出生点坐标
            local x, y, z = string.match(spawnPos, "([^,]+),([^,]+),([^,]+)")
            local spawnPosTable = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
            
            -- 返回出生点
            NPC_MoveToPos({x=0, y=0, z=1}, "返回出生点", spawnPosTable, 20)
            return
        end
        
        -- 当血量低于20%时，有50%几率尝试逃跑
        if hpPercent < 0.2 and math.random() < 0.5 then
            -- 解析出生点坐标
            local x, y, z = string.match(spawnPos, "([^,]+),([^,]+),([^,]+)")
            local spawnPosTable = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
            
            -- 逃向出生点
            NPC_SetSpeed(6) -- 逃跑时速度稍快
            NPC_MoveToPos({x=0, y=0, z=1}, "逃跑", spawnPosTable, 5)
            return
        end
        
        -- 当血量低于50%时，尝试后撤拉开距离
        if hpPercent < 0.5 and distanceToTarget < 3 then
            -- 计算后撤方向（远离目标）
            local retreatDir = {
                x = selfPos.x - targetPos.x,
                y = 0,
                z = selfPos.z - targetPos.z
            }
            
            -- 计算后撤目标位置（后撤2-3米）
            local retreatDistance = 2 + math.random()
            local retreatPos = {
                x = selfPos.x + retreatDir.x * retreatDistance / NPC_Distance(selfPos, targetPos),
                y = selfPos.y,
                z = selfPos.z + retreatDir.z * retreatDistance / NPC_Distance(selfPos, targetPos)
            }
            
            -- 后撤
            NPC_MoveToPos({x=retreatDir.x, y=0, z=retreatDir.z}, "后撤", retreatPos, 2)
            return
        end
        
        -- 战斗逻辑
        if distanceToTarget <= 2 then
            -- 在近战范围内优先使用爪击
            NPC_CastSkill("爪击")
        elseif distanceToTarget <= 5 then
            -- 在中距离使用快速扑击
            NPC_CastSkill("快速扑击")
        else
            -- 接近目标
            local approachDir = {
                x = targetPos.x - selfPos.x,
                y = 0,
                z = targetPos.z - selfPos.z
            }
            
            -- 不是直线接近，而是尝试从侧面接近目标
            local sideApproachAngle = math.random() * 40 - 20 -- -20到20度的随机偏移
            local rad = math.rad(sideApproachAngle)
            local cosVal = math.cos(rad)
            local sinVal = math.sin(rad)
            
            -- 计算侧面接近的方向
            local sideApproachDir = {
                x = approachDir.x * cosVal - approachDir.z * sinVal,
                y = 0,
                z = approachDir.x * sinVal + approachDir.z * cosVal
            }
            
            -- 确定目标位置
            local targetDistance = math.min(distanceToTarget - 1, 4) -- 不要完全接近，留一点距离
            local moveToPos = {
                x = selfPos.x + sideApproachDir.x * targetDistance / distanceToTarget,
                y = selfPos.y,
                z = selfPos.z + sideApproachDir.z * targetDistance / distanceToTarget
            }
            
            -- 移动接近目标
            NPC_MoveToPos(approachDir, "接近目标", moveToPos, 3)
        end
    else
        -- 无目标时巡逻或待机
        local elapsedTime = NPC_GetElapsedTime()
        local patrolTime = tonumber(NPC_BlackboardGet("patrol_time") or "0")
        
        -- 每10秒更新一次巡逻状态
        if elapsedTime > patrolTime + 10 then
            NPC_BlackboardSet("patrol_time", tostring(elapsedTime))
            
            -- 解析出生点坐标
            local x, y, z = string.match(spawnPos, "([^,]+),([^,]+),([^,]+)")
            local spawnPosTable = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
            
            -- 在出生点附近随机选择一个巡逻点
            local patrolPos = NPC_GetRandomPos(spawnPosTable, 3)
            
            -- 移动到巡逻点
            local patrolDir = {
                x = patrolPos.x - selfPos.x,
                y = 0,
                z = patrolPos.z - selfPos.z
            }
            NPC_MoveToPos(patrolDir, "巡逻", patrolPos, 5)
        end
    end
end

return M