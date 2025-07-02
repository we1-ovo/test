local M = {}

function M.cb()
    -- 获取当前位置和状态信息
    local selfPos = NPC_GetPos("")
    local currentHP = NPC_GetHP("")
    local maxHP = NPC_GetMaxHP("")
    local hpPercent = currentHP / maxHP * 100
    
    -- 自动选择目标，检测12米范围内的敌人
    local targetUUID = NPC_AutoSelectTarget(12)
    
    -- 如果没有目标，则进行巡逻或待机
    if not targetUUID or not NPC_IsAlive(targetUUID) then
        -- 随机选择一个附近点进行移动
        local randomPos = NPC_GetRandomPos(selfPos, 10)
        local moveDir = {x = 0, y = 0, z = 1}
        NPC_MoveToPos(moveDir, "巡逻移动", randomPos, 3)
        return
    end
    
    -- 获取与目标的距离和目标位置
    local targetPos = NPC_GetPos(targetUUID)
    local distanceToTarget = NPC_Distance(selfPos, targetPos)
    
    -- 计算朝向目标的方向
    local dir = {
        x = targetPos.x - selfPos.x,
        y = 0,
        z = targetPos.z - selfPos.z
    }
    
    -- 检查周围友军数量，判断是否处于被包围状态
    local nearbyEnemyCount = NPC_GetNearbyEnemyCount(selfPos, 10)
    local nearbyFriendCount = NPC_GetNearbyFriendCount(selfPos, 10)
    local isSurrounded = nearbyEnemyCount >= 3 and nearbyFriendCount <= 1
    
    -- 血量低于30%时采取保守策略
    local isLowHealth = hpPercent < 30
    
    -- AI决策逻辑
    
    -- 1. 如果被多个敌人包围或血量较低，尝试使用豹影闪脱离
    if (isSurrounded or isLowHealth) and distanceToTarget < 5 then
        -- 计算远离目标的位置
        local escapeDir = {
            x = selfPos.x - targetPos.x,
            y = 0,
            z = selfPos.z - targetPos.z
        }
        NPC_CastSkill("豹影闪")
        -- 向远离敌人的方向移动
        local escapePos = NPC_GetRandomPos(selfPos, 8)
        NPC_MoveToPos(escapeDir, "脱离战斗", escapePos, 2)
        return
    end
    
    -- 2. 保持中距离策略 (6-8米)
    if distanceToTarget > 8 then
        -- 距离过远，接近目标
        NPC_Chase(dir, "接近目标", targetUUID, 7)
    elseif distanceToTarget < 6 and not isLowHealth then
        -- 距离过近，拉开距离，除非血量低且想接近攻击
        NPC_CastSkill("豹影闪")
        local retreatPos = NPC_GetRandomPos(selfPos, 5)
        NPC_MoveToPos(dir, "拉开距离", retreatPos, 2)
    else
        -- 保持理想攻击距离
        NPC_Defend(dir, "保持距离")
    end
    
    -- 3. 技能选择逻辑
    local elapsedTime = NPC_GetElapsedTime()
    
    -- 近战攻击条件：距离合适且不是低血量状态
    if distanceToTarget <= 4 and not isLowHealth then
        NPC_CastSkill("猛扑击")
    end
    
    -- 远程攻击条件：保持在理想攻击距离
    if distanceToTarget >= 5 and distanceToTarget <= 8 then
        NPC_CastSkill("灵能弹")
    end
    
    -- 机动技能条件：用于调整位置或逃离
    if (distanceToTarget < 4 or distanceToTarget > 9) and not isLowHealth then
        NPC_CastSkill("豹影闪")
    end
    
    -- 4. 群体战术调整：多只灵豹时尝试从不同方向包围
    if nearbyFriendCount > 1 and not isSurrounded then
        -- 获取周围友军，尝试分散位置
        local friendUUIDs = NPC_GetNearbyFriends(selfPos, 8)
        if #friendUUIDs > 1 then
            -- 选择一个不同于其他友军的角度进行包围
            local angle = (elapsedTime % 6) * 60  -- 0, 60, 120, 180, 240, 300度
            local radius = 7  -- 包围半径
            local surroundX = targetPos.x + math.cos(math.rad(angle)) * radius
            local surroundZ = targetPos.z + math.sin(math.rad(angle)) * radius
            local surroundPos = {x = surroundX, y = 0, z = surroundZ}
            NPC_MoveToPos(dir, "战术位移", surroundPos, 3)
        end
    end
end

return M