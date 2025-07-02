local M = {}

function M.cb()
    -- 获取自身基本信息
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local hpPercent = myHP / myMaxHP
    local elapsedTime = NPC_GetElapsedTime()
    
    -- 检测狂暴状态
    local isEnraged = hpPercent <= 0.5
    local isLastStand = hpPercent <= 0.3
    
    -- 获取目标
    local targetUUID = NPC_AutoSelectTarget(15)
    if not targetUUID or not NPC_IsAlive(targetUUID) then
        -- 没有目标或目标已死亡，防守当前位置
        local stateDir = {x = 0, y = 0, z = 1}
        NPC_Defend(stateDir, "无目标，防守")
        return
    end
    
    -- 获取与目标的距离和位置
    local targetPos = NPC_GetPos(targetUUID)
    local distToTarget = NPC_Distance(myPos, targetPos)
    
    -- 方向向量，朝向目标
    local dirToTarget = {
        x = targetPos.x - myPos.x,
        y = 0,
        z = targetPos.z - myPos.z
    }
    
    -- 技能选择和战斗行为
    -- 根据血量状态调整行为模式
    if isLastStand and not NPC_BlackboardGet("shield_activated") then
        -- 血量30%以下，激活龙鳞护体
        NPC_CastSkill("龙鳞护体")
        NPC_BlackboardSet("shield_activated", "true")
        NPC_Say("龙鳞护体，尔等凡人休想伤我!")
    end
    
    -- 狂暴状态下，提高速度
    if isEnraged and NPC_BlackboardGet("enraged") ~= "true" then
        NPC_SetSpeed(9.6)  -- 增加20%速度
        NPC_BlackboardSet("enraged", "true")
        NPC_Say("敢伤吾身，今日必让尔等灰飞烟灭！")
    end
    
    -- 处理技能释放逻辑
    local now = elapsedTime
    local lastTailSwipeTime = tonumber(NPC_BlackboardGet("last_tailswipe_time") or "0")
    local lastLightningTime = tonumber(NPC_BlackboardGet("last_lightning_time") or "0")
    local lastBreathTime = tonumber(NPC_BlackboardGet("last_breath_time") or "0")
    local lastRoarTime = tonumber(NPC_BlackboardGet("last_roar_time") or "0")
    
    -- 计算冷却时间（根据是否狂暴调整）
    local tailSwipeCooldown = isEnraged and 11.25 or 15  -- 减少25%冷却时间
    local lightningCooldown = isEnraged and 7.5 or 10
    local breathCooldown = isEnraged and 5.25 or 7
    local roarCooldown = isEnraged and 15 or 20
    
    -- 根据距离和冷却选择合适的技能
    if isEnraged and (now - lastTailSwipeTime) > tailSwipeCooldown and distToTarget < 8 then
        -- 尾击扫荡 - 血量50%以下才释放，360度范围攻击
        NPC_CastSkill("尾击扫荡")
        NPC_BlackboardSet("last_tailswipe_time", tostring(now))
        NPC_Say("蛟龙摆尾，尔等受死!")
        return
    end
    
    if isEnraged and isLastStand and (now - lastRoarTime) > roarCooldown then
        -- 蛟龙咆哮 - 血量低于50%时使用，降低敌人速度并回复生命
        NPC_CastSkill("蛟龙咆哮")
        NPC_BlackboardSet("last_roar_time", tostring(now))
        NPC_Say("龙吟九天，万物俱静!")
        return
    end
    
    if (now - lastLightningTime) > lightningCooldown and distToTarget < 15 and distToTarget > 5 then
        -- 雷电攻击 - 中距离优先技能
        NPC_CastSkill("雷电攻击")
        NPC_BlackboardSet("last_lightning_time", tostring(now))
        NPC_Say("天雷降!")
        return
    end
    
    if (now - lastBreathTime) > breathCooldown and distToTarget < 10 and distToTarget > 2 then
        -- 龙息 - 近中距离范围攻击
        NPC_CastSkill("龙息")
        NPC_BlackboardSet("last_breath_time", tostring(now))
        NPC_Say("龙炎焚世!")
        return
    end
    
    -- 根据距离决定移动或普通攻击
    if distToTarget <= 2 then
        -- 在攻击范围内，使用普通攻击
        NPC_CastSkill("普通攻击")
        
        -- 非狂暴状态或血量较高时，攻击后拉开距离
        if not isLastStand and math.random() < 0.6 then
            -- 向后方拉开距离到理想战斗范围
            local retreatPos = NPC_GetRandomPos(myPos, 6)
            NPC_MoveToPos(dirToTarget, "拉开距离", retreatPos, 2)
        end
    else
        -- 调整到理想战斗距离
        local idealDistance
        if isEnraged then
            idealDistance = 4  -- 狂暴时更倾向于近距离战斗
        else
            idealDistance = 6  -- 正常状态保持中等距离
        end
        
        if distToTarget > idealDistance + 2 then
            -- 目标太远，追击
            NPC_Chase(dirToTarget, "追击目标", targetUUID, idealDistance)
        elseif distToTarget < idealDistance - 2 then
            -- 目标太近，拉开距离
            local retreatDir = {
                x = myPos.x - targetPos.x,
                y = 0,
                z = myPos.z - targetPos.z
            }
            local retreatPos = NPC_GetRandomPos(myPos, 5)
            NPC_MoveToPos(retreatDir, "拉开距离", retreatPos, 2)
        else
            -- 距离适中，使用普通攻击或者继续调整位置
            if math.random() < 0.7 then
                NPC_CastSkill("普通攻击")
            else
                local repositionPos = NPC_GetRandomPos(myPos, 4)
                NPC_MoveToPos(dirToTarget, "调整位置", repositionPos, 1.5)
            end
        end
    end
end

return M