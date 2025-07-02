local M = {}

function M.cb()
    -- 获取玩家位置和自身位置
    local playerUUID = "player"
    local playerPos = NPC_GetPos(playerUUID)
    local selfPos = NPC_GetPos("")
    local selfHP = NPC_GetHP("")
    local selfMaxHP = NPC_GetMaxHP("")
    local hpPercent = selfHP / selfMaxHP * 100
    
    -- 计算与玩家的距离
    local distanceToPlayer = NPC_Distance(selfPos, playerPos)
    
    -- 检查玩家是否还活着
    local playerAlive = NPC_IsAlive(playerUUID)
    if not playerAlive then
        -- 如果玩家已死亡，保持防守状态
        local stateDir = {x = 0, y = 0, z = 1} -- 面向前方
        NPC_Defend(stateDir, "玩家已死亡，保持防守")
        return
    end
    
    -- 战斗策略基于血量百分比
    if hpPercent > 60 then
        -- 血量充足时，主动攻击
        if distanceToPlayer <= 5 then
            -- 进入攻击范围，开始进攻
            local targetUUID = playerUUID
            
            -- 选择技能进行攻击
            if math.random() < 0.6 then
                -- 60%几率使用基础攻击技能
                NPC_CastSkill("迅捷扑击")
            else
                -- 40%几率使用控制技能
                NPC_CastSkill("幽光爪")
            end
            
            -- 战斗中靠近目标
            if distanceToPlayer > 2 then
                local stateDir = {x = playerPos.x - selfPos.x, y = 0, z = playerPos.z - selfPos.z}
                NPC_Chase(stateDir, "追击玩家", targetUUID, 2)
            end
        elseif distanceToPlayer <= 8 then
            -- 在观察距离内但未进入攻击范围，保持观察状态
            local stateDir = {x = playerPos.x - selfPos.x, y = 0, z = playerPos.z - selfPos.z}
            NPC_Defend(stateDir, "观察玩家")
        else
            -- 玩家不在感知范围内，进入巡逻状态
            local randomPos = NPC_GetRandomPos(selfPos, 5)
            local stateDir = {x = randomPos.x - selfPos.x, y = 0, z = randomPos.z - selfPos.z}
            NPC_MoveToPos(stateDir, "巡逻", randomPos, 3)
        end
    elseif hpPercent > 30 then
        -- 血量中等时，保持距离战术
        if distanceToPlayer <= 7 then
            -- 尝试与玩家保持2-3米的安全距离
            if distanceToPlayer < 2 then
                -- 太近了，后退
                local moveAwayPos = NPC_GetRandomPos(selfPos, 3)
                local moveDir = {x = moveAwayPos.x - selfPos.x, y = 0, z = moveAwayPos.z - selfPos.z}
                NPC_MoveToPos(moveDir, "拉开距离", moveAwayPos, 1)
            elseif distanceToPlayer > 3 then
                -- 太远了，无法攻击，靠近一点
                local stateDir = {x = playerPos.x - selfPos.x, y = 0, z = playerPos.z - selfPos.z}
                NPC_Chase(stateDir, "谨慎接近", playerUUID, 3)
            else
                -- 在理想距离，使用技能
                if math.random() < 0.7 then
                    -- 优先使用幽光爪进行减速控制
                    NPC_CastSkill("幽光爪")
                else
                    NPC_CastSkill("迅捷扑击")
                end
            end
        else
            -- 玩家不在感知范围内，保持防守
            local stateDir = {x = 0, y = 0, z = 1}
            NPC_Defend(stateDir, "谨慎防守")
        end
    else
        -- 血量低，尝试逃跑
        if hpPercent <= 20 and math.random() < 0.5 then
            -- 血量危险且有50%几率触发闪避技能
            NPC_CastSkill("灵气闪避")
            
            -- 获取远离玩家的位置
            local escapeDir = {x = selfPos.x - playerPos.x, y = 0, z = selfPos.z - playerPos.z}
            local escapePos = {
                x = selfPos.x + escapeDir.x * 2,
                y = selfPos.y,
                z = selfPos.z + escapeDir.z * 2
            }
            NPC_MoveToPos(escapeDir, "紧急逃跑", escapePos, 3)
        else
            -- 普通逃跑
            local escapeDir = {x = selfPos.x - playerPos.x, y = 0, z = selfPos.z - playerPos.z}
            local escapePos = {
                x = selfPos.x + escapeDir.x * 3,
                y = selfPos.y,
                z = selfPos.z + escapeDir.z * 3
            }
            NPC_MoveToPos(escapeDir, "逃跑", escapePos, 2)
            
            -- 如果玩家追得太近，尝试使用控制技能减速玩家
            if distanceToPlayer <= 3 then
                NPC_CastSkill("幽光爪")
            end
        end
    end
    
    -- 检查周围是否有其他灵狐或山猿被攻击，如果有则加入战斗
    if distanceToPlayer > 10 then
        local nearbyEnemies = NPC_GetNearbyEnemies(selfPos, 10)
        for _, enemyUUID in ipairs(nearbyEnemies) do
            if enemyUUID ~= playerUUID and NPC_IsAlive(enemyUUID) then
                local enemyPos = NPC_GetPos(enemyUUID)
                if NPC_Distance(enemyPos, playerPos) < 5 and math.random() < 0.7 then
                    -- 70%概率加入战斗
                    local stateDir = {x = playerPos.x - selfPos.x, y = 0, z = playerPos.z - selfPos.z}
                    NPC_Chase(stateDir, "支援同伴", playerUUID, 2)
                    NPC_Say("发现入侵者！同伴们，一起上！")
                    break
                end
            end
        end
    end
end

return M