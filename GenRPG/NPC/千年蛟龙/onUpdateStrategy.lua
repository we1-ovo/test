local M = {}

function M.cb()
    -- 获取自身基本状态信息
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local myMP = NPC_GetMP("")
    local hpPercent = myHP / myMaxHP * 100
    local elapsedTime = NPC_GetElapsedTime()
    
    -- 获取玩家信息
    local playerUUID = NPC_AutoSelectTarget(15)
    
    -- 如果没有目标或目标不存在，就防守原地
    if playerUUID == nil or not NPC_IsAlive(playerUUID) then
        NPC_Defend({x=0, y=0, z=1}, "防守原地等待玩家")
        return
    end
    
    -- 获取与玩家相关的信息
    local playerPos = NPC_GetPos(playerUUID)
    local playerHP = NPC_GetHP(playerUUID)
    local playerMaxHP = NPC_GetMaxHP(playerUUID)
    local distToPlayer = NPC_Distance(myPos, playerPos)
    local playerHpPercent = playerHP / playerMaxHP * 100
    
    -- 战斗阶段判断：正常阶段(100%-50%血量)和狂暴阶段(50%以下血量)
    local isRageMode = hpPercent <= 50
    
    -- 根据玩家距离决定行动
    if distToPlayer > 12 then
        -- 玩家距离过远，靠近玩家
        NPC_Chase({x=0, y=0, z=1}, "接近玩家", playerUUID, 7)
        return
    elseif distToPlayer < 4 then
        -- 玩家距离过近，拉开距离
        local escapePos = NPC_GetRandomPos(myPos, 5)
        NPC_MoveToPos({x=0, y=0, z=1}, "与玩家拉开距离", escapePos, 1000)
        return
    end
    
    -- 技能选择逻辑 - 根据血量和状态选择不同技能
    
    -- 血量低于30%时优先使用龙鳞护体
    if hpPercent <= 30 and myMP >= 200 then
        local hasShield, _ = NPC_IsBuffed("", "buff_shield")
        if not hasShield then
            NPC_CastSkill("龙鳞护体")
            NPC_Say("龙鳞护体，万法不侵！")
            return
        end
    end
    
    -- 血量低于40%时考虑使用龙威震慑
    if hpPercent <= 40 and myMP >= 180 and distToPlayer <= 6 then
        -- 检查是否已经冷却完毕(假设通过时间判断)
        if (elapsedTime % 20000) < 1000 then  -- 假设每20秒可以使用一次
            NPC_CastSkill("龙威震慑")
            NPC_Say("龙威震慑，颤抖吧！")
            return
        end
    end
    
    -- 狂暴阶段(血量50%以下)使用尾击扫荡
    if isRageMode and myMP >= 250 and distToPlayer <= 8 then
        -- 检查是否已经冷却完毕(假设通过时间判断)
        if (elapsedTime % 10000) < 1000 then  -- 假设每10秒可以使用一次
            NPC_CastSkill("尾击扫荡")
            NPC_Say("尝尝我的龙尾之威！")
            return
        end
    end
    
    -- 常规技能选择：龙息和雷电攻击交替使用
    
    -- 玩家生命值低于20%时优先使用雷电攻击
    if playerHpPercent < 20 and myMP >= 150 and distToPlayer <= 12 then
        -- 检查是否已经冷却完毕(假设通过时间判断)
        if (elapsedTime % 6000) < 1000 then  -- 假设每6秒可以使用一次
            NPC_CastSkill("雷电攻击")
            NPC_Say("天雷降世，灭你修行！")
            return
        end
    end
    
    -- 使用龙息(主要攻击技能)
    if myMP >= 100 and distToPlayer <= 10 then
        -- 检查是否已经冷却完毕(假设通过时间判断)
        if (elapsedTime % 4000) < 1000 then  -- 假设每4秒可以使用一次
            NPC_CastSkill("龙息")
            return
        end
    end
    
    -- 使用雷电攻击(远程单体高伤害)
    if myMP >= 150 and distToPlayer <= 12 then
        -- 检查是否已经冷却完毕(假设通过时间判断)
        if (elapsedTime % 6000) < 1000 then  -- 假设每6秒可以使用一次
            NPC_CastSkill("雷电攻击")
            return
        end
    end
    
    -- 如果所有技能都在冷却中，则进行基本移动和普通攻击
    
    -- 每10-15秒调整一次位置，避免被固定在一个位置
    if (elapsedTime % 12000) < 1000 then
        local newPos = NPC_GetRandomPos(myPos, 5)
        NPC_MoveToPos({x=0, y=0, z=1}, "调整战斗位置", newPos, 2000)
        return
    end
    
    -- 保持适当距离，释放普通攻击
    if distToPlayer <= 8 then
        NPC_CastSkill("普通攻击")
    else
        -- 调整到适合释放技能的距离
        NPC_Chase({x=0, y=0, z=1}, "调整攻击距离", playerUUID, 7)
    end
    
    -- 狂暴状态下的特殊表现
    if isRageMode and (elapsedTime % 8000) < 1000 then
        NPC_Say("吾乃千年蛟龙，岂容蝼蚁放肆！")
    end
end

return M