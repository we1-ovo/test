local M = {}

function M.init()
    -- 设置技能基础属性
    Skill_SetMPCost(0, "剧情技能不消耗魔法")
    Skill_SetCooldown(0, "剧情技能无冷却")
    Skill_SetCastRange(3, "设置施法范围为3米")
    Skill_SetMainTargetType("friend", "设置目标类型为友方（玩家）")
    Skill_SetDesc("老修士专用技能，用于向玩家传授仙术。施法时双手结印，一道金色光芒从老修士身上射向目标玩家。")
end

function M.cb()
    -- 选择目标玩家
    Skill_CollectMainTarget("选择目标玩家作为技能目标")
    
    -- 创建从老修士朝向目标玩家移动的金色光芒子物体
    Skill_CreateCVSubObjToTarget(5, '', "创建一个向目标方向匀速移动的金色光芒子物体")
    SubObj_SetSize('normal', "设置子物体大小为标准尺寸")
    SubObj_SetTriggerType('trigger_collision', 1, "设置子物体为碰撞触发，只触发一次")
    SubObj_SetTriggerRadius(0.5, "设置子物体触发半径为0.5米")
    
    -- 子物体不造成伤害，只有视觉效果
    -- 注册子物体触发事件
    Skill_RegisterEvent("on_subobject_trigger", function()
        -- 子物体到达玩家位置时，为玩家添加短暂的金光特效和环绕效果
        -- 使用buff来模拟视觉特效
        Skill_TargetFriendAddBuff('buff_speed', 1, 3, {0}, "添加持续3秒的视觉特效（使用空速度buff仅作视觉表现）")
        
        -- 提示传功成功
        Skill_Say("传功完成，你已学会此仙术", 3)
    end)
    
    -- 技能施法过程中老修士暂停3秒，模拟结印动作
    Skill_Sleep(3000, "老修士结印动作持续3秒")
end

return M