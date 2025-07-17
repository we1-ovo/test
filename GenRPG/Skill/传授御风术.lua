local M = {}

function M.init()
    -- 设置为剧情技能，没有MP消耗，冷却时间为0
    Skill_SetMPCost(0, "剧情技能无消耗")
    Skill_SetCooldown(0, "剧情技能无冷却")
    -- 目标类型设置为'friend'，只能对友方目标释放
    Skill_SetMainTargetType("friend", "只能对友方使用")
    -- 施法距离设置为2米，需要玩家靠近才能施法
    Skill_SetCastRange(2, "近距离施法范围")
    -- 设置技能描述
    Skill_SetDesc("老修士向你传授移动技能'御风术'，使你获得短距离快速位移能力", "传授御风术")
end

function M.cb()
    -- 选择玩家为目标
    Skill_CollectMainTarget("选择玩家作为传授对象")
    
    -- 老修士释放技能时会播放动画（通过Skill_Say表现浮空盘坐动作）
    Skill_Say("【盘坐浮空，双手结印，周身泛起柔和白光】", 1000, "展示老修士传授技能的动作")
    
    -- 技能施法时间为1秒，使用Skill_Sleep实现
    Skill_Sleep(1000, "技能传授施法时间")
    
    -- 技能结束时通过对话提示玩家已获得'御风术'技能
    Skill_Say("我已将御风术的要诀传授给你。此术可让你瞬息千里，轻盈如风。去吧，善用此术。", 3000, "传授完成的提示")
    
    -- 为玩家添加一个短暂的加速效果，象征性地展示获得了御风术的能力
    Skill_TargetFriendAddBuff('buff_speed', 1, 2000, {50}, "象征性地展示御风术效果")
    
    -- 在玩家周围创建一个风的效果区域
    Skill_CreateTargetCircleRegion(1, 2000, "创建风效果区域")
    Region_AddStayBuff('buff_speed', 1, 2000, {30}, 'friend', "区域内友方加速30%")
end

return M