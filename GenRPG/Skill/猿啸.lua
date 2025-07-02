local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(20, "设置技能魔法消耗为20点")
    Skill_SetCooldown(8, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置施法距离为0米，因为是以自身为中心的范围技能")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人，只影响敌方单位")
    Skill_SetDesc("山猿发出震天怒吼，减弱周围敌人战斗力。范围5米内的目标攻击力降低15%，持续3秒。生命值低于40%时效果更强。")
end

function M.cb()
    -- 技能释放逻辑部分
    
    -- 获取自身血量百分比，判断是否处于低血量状态
    local currentHP = Skill_GetSelfHP()
    local maxHP = Skill_GetSelfMaxHP()
    local hpPercent = currentHP / maxHP
    local isLowHP = hpPercent < 0.4
    
    -- 选取范围内的敌人目标
    Skill_CollectCircleTargets(5, 10, "选择半径5米范围内的所有敌人目标")
    
    -- 根据血量状态决定buff参数
    local attackDebuff = -0.15  -- 默认减益15%
    local duration = 3          -- 默认持续3秒
    
    -- 当生命值低于40%时，增强技能效果（减益效果提高到20%，持续时间延长到4秒）
    if isLowHP then
        attackDebuff = -0.2
        duration = 4
        Skill_Say("吼！！！", 1.5)  -- 低血量时怒吼更响亮，持续更久
    else
        Skill_Say("吼！", 1)  -- 正常怒吼
    end
    
    -- 为选中的敌人添加攻击力降低的buff
    Skill_TargetEnemyAddBuff('buff_attack', 1, duration, {attackDebuff}, 
                           isLowHP and "生命值低于40%，为敌人添加攻击力降低20%的减益效果，持续4秒" 
                                    or "为敌人添加攻击力降低15%的减益效果，持续3秒")
    
    -- 山猿怒吼动作表现，短暂定身效果
    Skill_Sleep(500, "山猿怒吼动作表现，短暂定身0.5秒")
end

return M