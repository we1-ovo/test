local M = {}

function M.init()
    -- 初始化技能参数
    Skill_SetMPCost(20, "设置远程攻击技能魔法消耗为20点")
    Skill_SetCooldown(3000, "设置技能冷却时间为3秒")
    Skill_SetCastRange(6, "设置技能施法范围为6米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("山猿的远程攻击技能，从地面抓起石块并向目标投掷。有0.8秒前摇动作，石块命中后造成物理伤害(攻击力1.5倍)并眩晕目标0.5秒。可通过走位躲避。", "投掷石块技能描述")
end

function M.cb()
    -- 实现0.8秒的前摇动作(举起石块)
    Skill_Sleep(800, "实现0.8秒前摇动作")
    
    -- 选择主要目标(敌人)
    Skill_CollectMainTarget("选择攻击目标")
    
    -- 创建一个向目标方向飞行的子物体(石块)
    Skill_CreateCVSubObjToTarget(8, '', "创建石块子物体，速度8米/秒")
    
    -- 设置子物体的触发类型为碰撞触发
    SubObj_SetTriggerType('trigger_collision', 1, "设置石块为碰撞触发，仅触发一次")
    
    -- 设置子物体触发半径
    SubObj_SetTriggerRadius(0.5, "设置石块触发半径为0.5米")
    
    -- 设置子物体触发伤害(物理伤害，伤害值为自身攻击力的1.5倍)
    SubObj_SetTriggerDamage('damage_physical', 1.5, "设置石块触发物理伤害为攻击力的1.5倍")
    
    -- 添加眩晕效果
    SubObj_SetTriggerBuff('buff_stun', 1, 500, {}, "添加0.5秒眩晕效果")
end

return M