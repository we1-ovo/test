local M = {}

-- 技能名称：雷电攻击
-- 千年蛟龙召唤雷电，对目标区域造成范围电击伤害

function M.init()
    -- 初始化技能参数
    Skill_SetMPCost(70, "设置魔法消耗为70点")
    Skill_SetCooldown(10, "设置技能冷却时间为10秒")
    Skill_SetCastRange(8, "设置施法范围为8米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("千年蛟龙召唤雷电，对目标区域造成范围电击伤害。先在目标位置形成电气光效，1.5秒后落下雷击，圆形范围3米半径，造成攻击力1.5倍的伤害并附加0.5秒眩晕效果。冷却时间10秒。")
end

function M.cb()
    -- 选择主目标位置作为雷电的落点
    Skill_CollectMainTarget("选择主目标位置作为雷电落点")
    
    -- 在目标位置创建静止的子物体作为标记，提示雷电即将降临
    Skill_CreateStaticSubObjAtTargetPos(2, "在目标位置创建雷电标记")
    
    -- 设置子物体为延迟触发，延迟时间1500毫秒
    SubObj_SetTriggerType('trigger_delay', 1500, "设置雷电延迟降临时间为1.5秒")
    SubObj_SetTriggerRadius(3.5, "设置雷电影响范围为3.5米半径")
    
    -- 注册子物体触发事件
    Skill_RegisterEvent("on_subobject_trigger", function()
        -- 选择3.5米半径范围内的所有敌人
        Skill_CollectCircleTargets(3.5, 20, "选择雷电影响范围内的所有敌人")
        
        -- 对选中目标造成1.5倍攻击力的魔法伤害
        Skill_TargetScaleDamage('damage_magic', 1.5, "造成1.5倍攻击力的雷电魔法伤害")
        
        -- 为所有被击中的敌人添加0.5秒的眩晕效果
        Skill_TargetEnemyAddBuff('buff_stun', 1, 0.5, {}, "为被击中的敌人添加0.5秒眩晕效果")
    end)
    
    -- 等待技能完全执行完毕
    Skill_Sleep(2000, "等待雷电攻击完全结束")
end

return M