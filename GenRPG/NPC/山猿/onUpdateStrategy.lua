local M = {}

function M.cb()
    -- 获取山猿当前状态
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local hpPercent = myHP / myMaxHP
    local elapsedTime = NPC_GetElapsedTime()
    
    -- 检测附近的敌人
    local nearbyEnemies = NPC_GetNearbyEnemies(myPos, 10)
    local hasEnemyInRange = #nearbyEnemies > 0
    
    -- 当前状态标记获取
    local currentState = NPC_BlackboardGet("currentState") or "patrol"
    local lastSkillTime = tonumber(NPC_BlackboardGet("lastSkillTime") or "0")
    local lastHowlTime = tonumber(NPC_BlackboardGet("lastHowlTime") or "0")
    local patrolLocator = NPC_BlackboardGet("patrolLocator") or "locator_valley_entrance_apes"
    
    -- 创建向前的方向向量
    local forwardDir = {x = 0, y = 0, z = 1}
    
    -- AI决策逻辑
    if not hasEnemyInRange then
        -- 没有敌人时的巡逻行为
        if currentState ~= "patrol" then
            NPC_BlackboardSet("currentState", "patrol")
            NPC_SetSpeed(5)  -- 恢复默认速度
        end
        
        -- 巡逻逻辑：在高地岩石上来回巡逻
        if not NPC_IsReached(patrolLocator, 2) then
            NPC_MoveToLocator(forwardDir, "移动到巡逻点", patrolLocator, 10)
        else
            -- 切换巡逻点
            if patrolLocator == "locator_valley_entrance_apes" then
                NPC_BlackboardSet("patrolLocator", "locator_middle_herbs_spawn3")
            else
                NPC_BlackboardSet("patrolLocator", "locator_valley_entrance_apes")
            end
        end
    else
        -- 有敌人时的战斗行为
        local targetUUID = nearbyEnemies[1]
        local targetPos = NPC_GetPos(targetUUID)
        local distanceToTarget = NPC_Distance(myPos, targetPos)
        
        -- 根据血量状态调整战斗策略
        if hpPercent < 0.3 then
            -- 血量低于30%时撤退到高地
            if currentState ~= "retreat" then
                NPC_BlackboardSet("currentState", "retreat")
                NPC_Say("我要找个高地重整旗鼓！")
                
                -- 选择高地位置撤退
                local retreatLocator = "locator_middle_herbs_spawn3"
                NPC_MoveToLocator(forwardDir, "撤退到高地", retreatLocator, 8)
            end
            
            -- 在撤退位置使用远程投石攻击
            if elapsedTime - lastSkillTime > 5 then
                NPC_CastSkill("投石术")
                NPC_BlackboardSet("lastSkillTime", tostring(elapsedTime))
            end
            
        elseif distanceToTarget > 4 then
            -- 距离大于4米时使用远程攻击
            if currentState ~= "ranged_attack" then
                NPC_BlackboardSet("currentState", "ranged_attack")
            end
            
            -- 优先使用投石术
            if elapsedTime - lastSkillTime > 5 then
                NPC_CastSkill("投石术")
                NPC_BlackboardSet("lastSkillTime", tostring(elapsedTime))
            else
                -- 追击到合适距离
                NPC_Chase(forwardDir, "追击到投石距离", targetUUID, 6)
            end
            
        else
            -- 近战状态
            if currentState ~= "melee_attack" then
                NPC_BlackboardSet("currentState", "melee_attack")
                NPC_Say("看我猿拳的厉害！")
            end
            
            -- 血量低于70%时考虑使用猿啸增强攻击并吸引援助
            if hpPercent < 0.7 and elapsedTime - lastHowlTime > 20 then
                NPC_CastSkill("猿啸")
                NPC_BlackboardSet("lastHowlTime", tostring(elapsedTime))
                NPC_Say("同伴们，一起上！")
            end
            
            -- 使用猿拳击进行攻击
            if elapsedTime - lastSkillTime > 3 then
                NPC_CastSkill("猿拳击")
                NPC_BlackboardSet("lastSkillTime", tostring(elapsedTime))
                
                -- 攻击后短暂后退重整态势
                local randomPos = NPC_GetRandomPos(myPos, 3)
                NPC_MoveToPos(forwardDir, "攻击后重整", randomPos, 1.5)
            end
        end
    end
    
    -- 每次战斗中都尝试评估是否需要使用技能
    -- 距离玩家4米内，且血量在70%以下，并且猿啸技能冷却完毕时，使用猿啸技能
    if hasEnemyInRange and hpPercent < 0.7 and elapsedTime - lastHowlTime > 20 then
        local playerDistance = NPC_Distance(myPos, NPC_GetPos(nearbyEnemies[1]))
        if playerDistance < 4 then
            NPC_CastSkill("猿啸")
            NPC_BlackboardSet("lastHowlTime", tostring(elapsedTime))
            NPC_Say("同伴们，一起上！")
        end
    end
end

return M