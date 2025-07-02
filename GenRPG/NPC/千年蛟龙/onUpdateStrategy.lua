local M = {}

function M.cb()
    -- 获取蛟龙当前状态
    local myPos = NPC_GetPos("")
    local myHP = NPC_GetHP("")
    local myMaxHP = NPC_GetMaxHP("")
    local hpPercent = myHP / myMaxHP
    local elapsedTime = NPC_GetElapsedTime()
    
    -- 检测是否已进入狂暴状态
    local isEnraged = false
    if hpPercent <= 0.5 then
        isEnraged = true
    end
    
    -- 从黑板获取狂暴状态切换标记
    local enrageTriggered = NPC_BlackboardGet("enrage_triggered")
    
    -- 首次进入狂暴状态的处理
    if isEnraged and enrageTriggered ~= "true" then
        NPC_Say("吾乃千年蛟龙，竟被你逼到这般地步！感受我真正的愤怒吧！")
        NPC_BlackboardSet("enrage_triggered", "true")
        -- 立即释放尾击扫荡作为狂暴开场技能
        NPC_CastSkill("尾击扫荡")
        return
    end
    
    -- 选择目标
    local targetUUID = NPC_AutoSelectTarget(15)
    if targetUUID == nil or targetUUID == "" then
        -- 没有目标时，防守当前位置
        local stateDir = {x = 0, y = 0, z = 1}
        NPC_Defend(stateDir, "无目标防守")
        return
    end
    
    -- 获取与目标的距离
    local targetPos = NPC_GetPos(targetUUID)
    local distanceToTarget = NPC_Distance(myPos, targetPos)
    
    -- 生命值较低时的特殊处理
    if hpPercent < 0.3 and NPC_GetElapsedTime() % 15 < 0.1 then
        -- 低生命时更频繁使用护盾
        NPC_CastSkill("鳞甲护体")
        return
    end
    
    -- 根据与目标的距离选择行为
    if distanceToTarget > 10 then
        -- 距离太远，追击目标
        local stateDir = {x = targetPos.x - myPos.x, y = 0, z = targetPos.z - myPos.z}
        NPC_Chase(stateDir, "追击目标", targetUUID, 8)
    else
        -- 根据血量和距离选择不同的技能策略
        if distanceToTarget <= 3 then
            -- 目标过近，使用龙影闪拉开距离
            if (elapsedTime % 10) < 0.1 then  -- 约10秒一次，模拟冷却时间
                NPC_CastSkill("龙影闪")
                return
            end
        end
        
        -- 选择攻击技能
        local skillChoice = elapsedTime % 10  -- 用时间来分配技能释放顺序
        
        if isEnraged then
            -- 狂暴状态下的技能选择
            if skillChoice < 2 and (elapsedTime % 20) < 0.1 then  -- 尾击扫荡约20秒一次
                NPC_CastSkill("尾击扫荡")
            elseif skillChoice < 5 then  -- 狂暴状态下更频繁使用龙息
                NPC_CastSkill("龙息")
            elseif skillChoice < 7 then  -- 雷电攻击
                NPC_CastSkill("雷电攻击")
            elseif skillChoice < 8 and hpPercent < 0.7 then  -- 血量低于70%时使用护盾
                NPC_CastSkill("鳞甲护体")
            else  -- 默认使用普通攻击
                NPC_CastSkill("普通攻击")
            end
        else
            -- 正常状态下的技能选择
            if skillChoice < 3 then  -- 龙息
                NPC_CastSkill("龙息")
            elseif skillChoice < 6 then  -- 雷电攻击
                NPC_CastSkill("雷电攻击")
            elseif skillChoice < 7 and hpPercent < 0.7 then  -- 血量低于70%时使用护盾
                NPC_CastSkill("鳞甲护体")
            else  -- 默认使用普通攻击
                NPC_CastSkill("普通攻击")
            end
        end
        
        -- 战场位置调整
        if (elapsedTime % 15) < 0.1 then
            -- 每隔约15秒，调整位置避免被困在角落
            local randomPos = NPC_GetRandomPos(myPos, 5)
            local stateDir = {x = targetPos.x - myPos.x, y = 0, z = targetPos.z - myPos.z}
            NPC_MoveToPos(stateDir, "调整位置", randomPos, 3)
        end
    end
end

return M