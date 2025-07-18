local M = {}

-- 幻影步：灵豹的闪避技能
function M.init()
    -- 设置技能基本属性
    Skill_SetMPCost(25, "设置魔法消耗为25点")
    Skill_SetCooldown(8000, "设置技能冷却时间为8秒")
    Skill_SetCastRange(0, "设置施法范围为0米，自身技能")
    Skill_SetMainTargetType("self", "设置技能目标类型为自身")
    Skill_SetDesc("迅速后跳3.5米拉开距离，增加移动速度30%持续2秒，并使3秒内第一次紫光能量弹伤害提升50%。", "幻影步描述")
end

function M.cb()
    -- 选择自身作为技能目标
    Skill_CollectMainTarget("选择自身为目标")
    
    -- 快速向后移动3.5米
    Skill_MoveTo(180, 5, 3.5, "向后快速移动3.5米")
    
    -- 在自身位置创建一个静止的子物体作为紫色残影效果
    Skill_CreateStaticSubObjAtSelfPos(1000, "创建紫色残影效果")
    
    -- 为自身添加移动速度提升30%的增益效果，持续2秒
    Skill_SelfAddBuff('buff_speed', 1, 2000, {30}, "增加移动速度30%持续2秒")
    
    -- 注册一个攻击事件监听
    local hasTriggered = false
    local eventId = Skill_RegisterEvent("on_attack", function(targetUUID, damage)
        -- 检查是否是紫光能量弹技能(假设紫光能量弹的伤害类型为魔法伤害)
        -- 这里简化处理，实际上可能需要更复杂的检测逻辑来判断是否是紫光能量弹
        if not hasTriggered then
            -- 增加50%的伤害
            local increasedDamage = damage * 0.5
            Skill_TargetDamage('damage_magic', increasedDamage, "紫光能量弹伤害增加50%")
            
            -- 标记已触发，确保只生效一次
            hasTriggered = true
            
            -- 这里可以添加一些视觉效果来表示伤害提升
        end
    end, "注册攻击事件监听")
    
    -- 等待3秒后移除事件监听
    Skill_Sleep(3000, "等待3秒")
    
    -- 注意：在实际引擎中可能需要显式移除事件监听，但示例代码中没有提供移除API
    -- 假设事件在超时后自动失效
end

return M