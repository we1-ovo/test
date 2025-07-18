local M = {}

-- 记录上次使用闪电扑击的时间
local lastDashTime = 0

function M.cb()
    -- 获取自身当前状态
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local myHPPercent = myHP / myMaxHP * 100
    local elapsedTime = NPC_GetElapsedTime()
    
    -- 查找最近的敌人
    local target = NPC_AutoSelectTarget(15)
    
    -- 没有目标时停止执行
    if not target or not NPC_IsAlive(target) then
        return
    end
    
    -- 获取与目标的距离
    local targetPos = NPC_GetPos(target)
    local distance = NPC_Distance(myPos, targetPos)
    
    -- 获取面向目标的方向
    local dir = {
        x = targetPos.x - myPos.x,
        y = 0,
        z = targetPos.z - myPos.z
    }
    
    -- 初始发现玩家，先使用幻影步拉开安全距离
    if elapsedTime < 1000 then
        NPC_CastSkill("幻影步")
        return
    end
    
    -- 血量低于30%时变得更加谨慎
    if myHPPercent < 30 then
        -- 更频繁地使用幻影步保持距离
        if distance < 5 then
            NPC_CastSkill("幻影步")
            return
        end
        
        -- 在安全距离进行远程攻击
        if distance >= 5 and distance <= 8 then
            NPC_CastSkill("紫光能量弹")
            return
        end
        
        -- 距离过远时谨慎追击
        if distance > 8 then
            NPC_Chase(dir, "谨慎追击到攻击距离", target, 6)
            return
        end
    end
    
    -- 正常战斗状态
    
    -- 当玩家距离过近时，优先使用幻影步拉开距离
    if distance < 4 then
        NPC_CastSkill("幻影步")
        return
    end
    
    -- 优先保持5-8米的理想攻击距离，使用紫光能量弹进行远程攻击
    if distance >= 5 and distance <= 8 then
        NPC_CastSkill("紫光能量弹")
        return
    end
    
    -- 如果玩家持续远离或保持距离，每隔8-10秒使用闪电扑击突进攻击一次
    if distance > 8 and distance <= 12 and (elapsedTime - lastDashTime) >= 8000 then
        NPC_CastSkill("闪电扑击")
        lastDashTime = elapsedTime
        return
    end
    
    -- 距离管理
    if distance < 5 then
        -- 后撤到理想距离，计算远离目标方向进行移动
        local retreatDir = {
            x = myPos.x - targetPos.x,
            y = 0,
            z = myPos.z - targetPos.z
        }
        local retreatPos = {
            x = myPos.x + retreatDir.x * 2,
            y = myPos.y,
            z = myPos.z + retreatDir.z * 2
        }
        NPC_MoveToPos(retreatDir, "后撤到理想攻击距离", retreatPos, 2000)
    elseif distance > 8 then
        -- 追击到理想距离
        NPC_Chase(dir, "追击到理想攻击距离", target, 6)
    end
end

return M