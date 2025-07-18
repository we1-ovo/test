local M = {}

function M.cb()
    -- 获取自身位置
    local myPos = NPC_GetPos("")
    
    -- 获取自身属性
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local myHPPercent = myHP / myMaxHP * 100
    
    -- 检测附近敌人
    local enemies = NPC_GetNearbyEnemies(myPos, 8)
    local enemyCount = #enemies
    
    -- 检测附近友军
    local friendCount = NPC_GetNearbyFriendCount(myPos, 3)
    
    -- AI状态控制
    local targetEnemy = nil
    local targetPos = nil
    local targetDist = 999
    
    -- 寻找目标
    if enemyCount > 0 then
        targetEnemy = enemies[1] -- 取距离最近的敌人作为目标
        targetPos = NPC_GetPos(targetEnemy)
        targetDist = NPC_Distance(myPos, targetPos)
    end
    
    -- 战术决策
    if targetEnemy then
        -- 低血量战术撤退逻辑
        if myHPPercent < 30 then
            -- 计算撤退位置（远离目标方向）
            local retreatPos = NPC_GetRandomPos(myPos, 5)
            NPC_MoveToPos({0, 0, 0}, "战术撤退", retreatPos, 2000)
            return
        end
        
        -- 攻击策略
        if targetDist > 4 then
            -- 距离较远，使用快速扑击接近目标
            NPC_CastSkill("快速扑击")
            
            -- 继续接近目标以保持攻击范围
            NPC_Chase({0, 0, 0}, "追击目标", targetEnemy, 2.5)
        else
            -- 距离较近，使用基本爪击
            NPC_CastSkill("爪击")
            
            -- 群体战术：有多个灵狐时增加快速扑击频率形成围攻
            if friendCount >= 2 and math.random() < 0.4 then
                NPC_CastSkill("快速扑击")
            end
            
            -- 每隔2-3秒随机改变位置，展现灵活走位特性
            if math.random() < 0.1 then
                -- 计算目标周围的随机位置
                local randomOffset = math.random(2, 3)
                local randomAngle = math.random() * 6.28 -- 0-2π
                local moveX = targetPos.x + math.cos(randomAngle) * randomOffset
                local moveZ = targetPos.z + math.sin(randomAngle) * randomOffset
                local newPos = {x = moveX, y = 0, z = moveZ}
                
                NPC_MoveToPos({0, 0, 0}, "灵活走位", newPos, 1000)
            end
        end
    else
        -- 无敌人时保持待机状态
        NPC_Defend({0, 0, 0}, "警戒待机")
    end
    
    -- 单狐存活策略：当只剩1只灵狐时提高生存性
    if friendCount == 0 and math.random() < 0.2 then
        local safePos = NPC_GetRandomPos(myPos, 4)
        NPC_MoveToPos({0, 0, 0}, "保持距离", safePos, 1500)
    end
end

return M