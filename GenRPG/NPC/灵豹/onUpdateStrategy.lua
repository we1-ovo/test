local M = {}

function M.cb()
    -- 获取自身信息
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local myHPPercent = myHP / myMaxHP * 100
    
    -- 获取玩家信息
    local playerUUID = "Player"
    if not NPC_IsAlive(playerUUID) then
        -- 如果玩家不在场景中或已死亡，就待机
        NPC_Defend({x=0, y=0, z=1}, "玩家不存在，待机")
        return
    end
    
    local playerPos = NPC_GetPos(playerUUID)
    local distanceToPlayer = NPC_Distance(myPos, playerPos)
    
    -- 检查生命值是否低于30%，触发灵巧闪避技能
    if myHPPercent < 30 then
        NPC_CastSkill("灵巧闪避")
        
        -- 低血量时尝试拉开距离
        local retreatPos = NPC_GetRandomPos(myPos, 10)
        NPC_MoveToPos({x=0, y=0, z=1}, "低血量撤退", retreatPos, 4)
        return
    end
    
    -- 检查附近友军数量，如果有多个友军则采用协同作战策略
    local nearbyFriends = NPC_GetNearbyFriends(myPos, 15)
    local hasTeammates = #nearbyFriends > 1
    
    -- 基于距离和队友情况选择不同战术
    if distanceToPlayer <= 5 then
        -- 玩家太近，使用豹影扑击后拉开距离
        NPC_CastSkill("豹影扑击")
        
        -- 扑击后尝试拉开距离
        local retreatPos = NPC_GetRandomPos(myPos, 8)
        NPC_MoveToPos({x=0, y=0, z=1}, "扑击后撤退", retreatPos, 2)
    elseif distanceToPlayer <= 8 then
        -- 中等距离，使用灵能光弹远程攻击
        NPC_CastSkill("灵能光弹")
        
        -- 如果有队友协同，尝试从不同角度攻击
        if hasTeammates then
            local flankPos = NPC_GetRandomPos(playerPos, 7)
            NPC_MoveToPos({x=0, y=0, z=1}, "协同侧翼", flankPos, 2)
        else
            -- 单独作战时随机移动保持距离
            local movePos = NPC_GetRandomPos(myPos, 3)
            NPC_MoveToPos({x=0, y=0, z=1}, "保持距离", movePos, 1)
        end
    elseif distanceToPlayer <= 15 then
        -- 玩家在追击范围内，接近玩家但保持理想攻击距离
        NPC_Chase({x=0, y=0, z=1}, "追击到理想距离", playerUUID, 7)
    else
        -- 玩家超出追击范围，返回巡逻区域
        NPC_MoveToLocator({x=0, y=0, z=1}, "返回巡逻点", "locator_valley_middle_leopards", 10)
    end
end

return M