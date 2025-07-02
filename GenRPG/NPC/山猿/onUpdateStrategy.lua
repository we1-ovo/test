local M = {}

function M.cb()
    -- 获取自身状态信息
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local hpPercent = myHP / myMaxHP
    
    -- 获取周围敌人和友军信息
    local nearbyEnemies = NPC_GetNearbyEnemies(myPos, 10)
    local nearbyFriends = NPC_GetNearbyFriends(myPos, 15)
    
    -- 如果血量低于30%，尝试撤退到友军身边
    if hpPercent < 0.3 and #nearbyFriends > 0 then
        local friendUUID = nearbyFriends[1]
        NPC_Follow({x=0, y=0, z=1}, "撤退到友军身边", friendUUID)
        return
    end
    
    -- 如果有敌人在仇恨范围内
    if #nearbyEnemies > 0 then
        local targetUUID = nearbyEnemies[1]
        local targetPos = NPC_GetPos(targetUUID)
        local distanceToTarget = NPC_Distance(myPos, targetPos)
        local targetHP = NPC_GetHP(targetUUID)
        local targetMaxHP = NPC_GetMaxHP(targetUUID)
        local targetHPPercent = targetHP / targetMaxHP
        
        -- 判断是否被多个敌人包围或血量低于50%，优先使用猛击地面
        if (#nearbyEnemies >= 2 or hpPercent < 0.5) and distanceToTarget <= 3 then
            NPC_CastSkill("猛击地面")
            return
        end
        
        -- 远程攻击：投掷石块（射程8米内）
        if distanceToTarget <= 8 and distanceToTarget > 3 then
            NPC_CastSkill("投掷石块")
            return
        end
        
        -- 中距离技能：猿啸（5米内减弱敌人战斗力）
        if distanceToTarget <= 5 and distanceToTarget > 2 then
            NPC_CastSkill("猿啸")
            return
        end
        
        -- 近身攻击：猿拳（2米内）
        if distanceToTarget <= 2 then
            -- 如果目标血量低于20%，更加激进地攻击
            if targetHPPercent < 0.2 then
                NPC_CastSkill("猿拳")
            else
                NPC_CastSkill("猿拳")
            end
            return
        end
        
        -- 追击目标
        if distanceToTarget > 2 then
            NPC_Chase({x=0, y=0, z=1}, "追击敌人", targetUUID, 1.5)
            return
        end
    else
        -- 没有敌人时进行巡逻
        -- 在高地和低地之间移动，利用地形优势
        local elapsedTime = NPC_GetElapsedTime()
        local patrolCycle = elapsedTime % 20 -- 20秒一个巡逻周期
        
        if patrolCycle < 10 then
            -- 前10秒移动到高地位置
            local highGroundPos = {x = myPos.x + 5, y = myPos.y + 2, z = myPos.z + 3}
            NPC_MoveToPos({x=0, y=0, z=1}, "巡逻到高地", highGroundPos, 10)
        else
            -- 后10秒移动到低地位置
            local lowGroundPos = {x = myPos.x - 3, y = myPos.y, z = myPos.z - 2}
            NPC_MoveToPos({x=0, y=0, z=1}, "巡逻到低地", lowGroundPos, 10)
        end
    end
end

return M