local M = {}

function M.cb()
    -- 获取自身属性
    local selfPos = NPC_GetPos("")
    local selfHP = NPC_GetHP("")
    local selfMaxHP = NPC_GetMaxHP("")
    local hpPercent = selfHP / selfMaxHP * 100
    local elapsedTime = NPC_GetElapsedTime()
    
    -- 寻找最近的敌人
    local targetNpcUUID = NPC_AutoSelectTarget(10)
    
    -- 如果没有目标，就防守并等待
    if targetNpcUUID == "" or targetNpcUUID == nil then
        NPC_Defend({x=0, y=0, z=1}, "没有目标，防守待命")
        return
    end
    
    -- 获取目标信息
    local targetPos = NPC_GetPos(targetNpcUUID)
    local distanceToTarget = NPC_Distance(selfPos, targetPos)
    
    -- 检查周围友方单位
    local nearbyFriends = NPC_GetNearbyFriends(selfPos, 8)
    local friendsUnderAttack = false
    local friendToHelp = ""
    
    -- 检查是否有友方单位受到攻击
    for i, friendUUID in ipairs(nearbyFriends) do
        if friendUUID ~= "" and NPC_IsAlive(friendUUID) then
            local enemiesNearFriend = NPC_GetNearbyEnemies(NPC_GetPos(friendUUID), 3)
            if #enemiesNearFriend > 0 then
                friendsUnderAttack = true
                friendToHelp = friendUUID
                break
            end
        end
    end
    
    -- AI状态判断和技能释放
    
    -- 1. 优先使用岩石护甲增强防御
    local hasShield, _ = NPC_IsBuffed("", "buff_shield")
    local hasAttackBuff, _ = NPC_IsBuffed("", "buff_attack")
    
    if not hasShield and not hasAttackBuff then
        NPC_CastSkill("岩石护甲")
        return
    end
    
    -- 2. 血量低于40%时，尝试后退与其他单位汇合
    if hpPercent < 40 then
        local retreatPos = NPC_GetRandomPos(selfPos, 5)
        NPC_MoveToPos({x=0, y=0, z=1}, "血量低撤退", retreatPos, 2000)
        return
    end
    
    -- 3. 友方单位受到攻击时，前去保护
    if friendsUnderAttack and friendToHelp ~= "" then
        NPC_Guard({x=0, y=0, z=1}, "保护友军", friendToHelp)
        
        -- 如果在保护过程中接近敌人，使用大地践踏控制
        local enemiesNearby = NPC_GetNearbyEnemies(selfPos, 3)
        if #enemiesNearby > 0 then
            NPC_CastSkill("大地践踏")
        end
        return
    end
    
    -- 4. 追击敌人
    if distanceToTarget > 3 then
        NPC_Chase({x=0, y=0, z=1}, "追击目标", targetNpcUUID, 2)
    else
        -- 5. 在近战距离内，优先使用大地践踏进行群体控制
        local enemiesInAOERange = NPC_GetNearbyEnemyCount(selfPos, 3)
        if enemiesInAOERange >= 1 then
            NPC_CastSkill("大地践踏")
        end
        
        -- 6. 使用石拳重击作为常规攻击
        NPC_CastSkill("石拳重击")
    end
end

return M