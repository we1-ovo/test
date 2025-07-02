local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(100, "设置魔法消耗为100点")
    Skill_SetCooldown(15, "设置技能冷却时间为15秒")
    Skill_SetCastRange(8, "设置施法范围为8米圆形")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("千年蛟龙挥动巨尾，对周围360度范围内的敌人造成强力击退和伤害。范围8米，伤害为攻击力的2.2倍，并将目标击退5米距离。血量低于50%时才会使用。")
end

function M.cb()
    -- 检查血量是否低于50%
    local currentHP = Skill_GetSelfHP()
    local maxHP = Skill_GetSelfMaxHP()
    local hpPercentage = currentHP / maxHP
    
    -- 如果血量高于50%，取消技能释放
    if hpPercentage > 0.5 then
        Skill_Say("血量充足，无需使用尾击", 1)
        Skill_Cancel()
        return
    end
    
    -- 前摇动作，尾巴缓慢抬起并发光
    Skill_Say("吾将以龙尾扫荡尔等蝼蚁！", 2)
    Skill_Sleep(2000, "尾巴抬起发光的前摇动作")
    
    -- 选择周围8米范围内的所有敌人
    Skill_CollectCircleTargets(8, 50, "选择周围8米内的所有敌人")
    
    -- 创建视觉效果区域表示攻击范围
    Skill_CreateSelfPosCircleRegion(8, 1, "创建尾击扫荡的视觉效果区域")
    
    -- 对选中目标造成2.2倍攻击力伤害
    Skill_TargetScaleDamage("damage_physical", 2.2, "造成2.2倍攻击力的物理伤害")
    
    -- 为所有被击中的敌人添加击退效果
    Skill_TargetEnemyAddBuff("buff_beat_back", 1, 1, {5}, "击退敌人5米距离")
end

return M