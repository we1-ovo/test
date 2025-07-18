local M = {}

-- 初始化技能基础属性
function M.init()
    -- 设置魔法消耗为100点，符合设计文档要求
    Skill_SetMPCost(100, "剧情离场消耗魔法值")
    -- 设置冷却时间为0毫秒，一次性使用的剧情技能
    Skill_SetCooldown(0, "一次性使用的剧情技能")
    -- 设置施法范围为0，只能对自己使用
    Skill_SetCastRange(0, "只作用于自身")
    -- 设置目标类型为自己，瞬移技能作用于施法者本身
    Skill_SetMainTargetType("self", "技能作用于施法者")
    -- 设置技能描述为仙人离场的瞬移仙术
    Skill_SetDesc("仙人离场的瞬移仙术", "剧情表现技能")
end

-- 技能释放逻辑
function M.cb()
    -- 选择自己作为目标
    Skill_CollectMainTarget("选择自己作为技能目标")
    
    -- 老修士说话2秒，告别玩家的仙人台词
    Skill_Say("我的使命已完成，是时候回归仙境了。愿你在修行之路上一帆风顺。", 2000, "老修士告别台词")
    
    -- 为自己添加3秒的无敌状态，防止离场过程中受到干扰
    Skill_SelfAddBuff("buff_invincible", 1, 3000, {}, "添加无敌状态防止干扰")
    
    -- 在自己位置创建持续3秒的静态子物体，表现白色光点飘散的视觉效果
    Skill_CreateStaticSubObjAtSelfPos(3000, "创建白色光点特效")
    
    -- 子物体设置为延迟触发，3000毫秒后触发消失效果
    SubObj_SetTriggerType("trigger_delay", 3000, "设置延迟触发消失")
    
    -- 等待3秒让光效完全展示
    Skill_Sleep(3000, "等待特效完全展示")
    
    -- 注意：技能系统无法直接调用Level系统API移除NPC
    -- 这部分逻辑需要在Level系统的process.lua中通过事件机制实现
    -- 这里我们只负责技能表现部分
end

return M