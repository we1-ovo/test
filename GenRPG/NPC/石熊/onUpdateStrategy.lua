local M = {}

function M.cb()
    -- 获取自身信息
    local selfPos = NPC_GetPos("")
    local currentHP = NPC_GetHP("")
    local maxHP = NPC_GetMaxHP("")
    local hpPercent = currentHP / maxHP
    
    -- 检测自身状态，低于40%生命值且岩石护盾可用时优先使用
    if hpPercent < 0.4 then
        local buffed, isNegative = NPC_IsBuffed("", "岩石护盾")
        if not buffed then
            NPC_CastSkill("岩石护盾")
            return
        end
    end
    
    -- 获取附近敌人
    local nearbyEnemies = NPC_GetNearbyEnemies(selfPos, 10)
    local enemyCount = #nearbyEnemies
    
    -- 没有敌人时，返回防守位置
    if enemyCount == 0 then
        local guardX = NPC_BlackboardGet("guard_x")
        local guardY = NPC_BlackboardGet("guard_y") 
        local guardZ = NPC_BlackboardGet("guard_z")
        
        if guardX and guardX ~= "" then
            local guardPosObj = {x=tonumber(guardX), y=tonumber(guardY), z=tonumber(guardZ)}
            if NPC_Distance(selfPos, guardPosObj) > 2 then
                NPC_MoveToPos({x=0,y=0,z=1}, "返回守卫位置", guardPosObj, 15)
                return
            else
                NPC_Defend({x=0,y=0,z=1}, "守卫位置")
                return
            end
        else
            -- 如果没有守卫位置记录，默认守卫石桥位置
            NPC_MoveToLocator({x=0,y=0,z=1}, "移动到石桥", "locator_valley_middle_bears", 15)
            -- 记录当前位置为守卫位置
            NPC_BlackboardSet("guard_x", tostring(selfPos.x))
            NPC_BlackboardSet("guard_y", tostring(selfPos.y))
            NPC_BlackboardSet("guard_z", tostring(selfPos.z))
            return
        end
    end
    
    -- 有敌人时开始追击并战斗
    if enemyCount > 0 then
        local targetUUID = nearbyEnemies[1]
        local targetPos = NPC_GetPos(targetUUID)
        local distance = NPC_Distance(selfPos, targetPos)
        
        -- 检查是否有友军，实现包围战术
        local nearbyFriends = NPC_GetNearbyFriends(selfPos, 15)
        local friendCount = #nearbyFriends
        
        -- 如果有友军，尝试包围战术
        if friendCount > 0 then
            -- 检查友军位置，判断是否需要调整自己的位置来形成包围
            local friendPos = NPC_GetPos(nearbyFriends[1])
            local friendToTargetDistance = NPC_Distance(friendPos, targetPos)
            
            -- 如果友军距离目标较近，石熊尝试从另一侧接近
            if friendToTargetDistance <= 5 and distance > 3 then
                -- 计算包围位置：目标的相对位置
                local dirToTarget = {
                    x = (targetPos.x - selfPos.x),
                    y = 0,
                    z = (targetPos.z - selfPos.z)
                }
                -- 移动到目标侧面形成包围
                local surroundPos = {
                    x = targetPos.x + dirToTarget.z * 0.5,
                    y = targetPos.y,
                    z = targetPos.z - dirToTarget.x * 0.5
                }
                NPC_MoveToPos({x=0,y=0,z=1}, "包围战术移动", surroundPos, 8)
                return
            end
        end
        
        -- 如果目标距离超过15米，返回防守位置
        if distance > 15 then
            local guardX = NPC_BlackboardGet("guard_x")
            local guardY = NPC_BlackboardGet("guard_y")
            local guardZ = NPC_BlackboardGet("guard_z")
            
            if guardX and guardX ~= "" then
                local guardPosObj = {x=tonumber(guardX), y=tonumber(guardY), z=tonumber(guardZ)}
                NPC_MoveToPos({x=0,y=0,z=1}, "返回守卫位置", guardPosObj, 15)
                return
            else
                NPC_MoveToLocator({x=0,y=0,z=1}, "移动到石桥", "locator_valley_middle_bears", 15)
                return
            end
        end
        
        -- 如果周围有2个及以上敌人且在攻击范围内，优先使用大地践踏
        local nearbyCloseEnemies = NPC_GetNearbyEnemies(selfPos, 3)
        if #nearbyCloseEnemies >= 2 then
            NPC_CastSkill("大地践踏")
            return
        end
        
        -- 如果目标距离小于2米，使用岩石拳击进行基础攻击
        if distance <= 2 then
            NPC_CastSkill("岩石拳击")
            return
        else
            -- 追击目标
            NPC_Chase({x=0,y=0,z=1}, "追击敌人", targetUUID, 2)
            return
        end
    end
end

return M