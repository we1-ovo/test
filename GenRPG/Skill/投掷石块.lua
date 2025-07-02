local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetMPCost(15, "设置魔法消耗为15点，为中等消耗的远程攻击")
    Skill_SetCooldown(4, "设置技能冷却时间为4秒，符合设计文档要求")
    Skill_SetCastRange(8, "设置施法距离为8米，作为远程投掷技能的射程")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人，针对敌方单位")
    Skill_SetDesc("山猿从地上抓起石块，向目标投掷。远程物理攻击，射程8米，伤害为攻击力的0.8倍，有25%几率使目标减速20%，持续2秒。")
end

function M.cb()
    -- 技能释放逻辑部分
    -- 选择目标敌人作为主要攻击对象
    Skill_CollectMainTarget("选择目标敌人作为投掷石块的目标")
    
    -- 创建一个朝目标方向移动的石块子物体
    Skill_CreateCVSubObjToTarget(8, '', "创建一个向目标移动的石块，速度为8米/秒")
    
    -- 设置子物体的触发条件
    SubObj_SetTriggerType('trigger_collision', 1, "设置子物体为碰撞触发，只触发1次")
    SubObj_SetTriggerRadius(0.5, "设置子物体触发半径为0.5米")
    
    -- 设置子物体的触发效果 - 伤害
    SubObj_SetTriggerDamage('damage_physical', 20, "设置子物体触发时造成20点物理伤害(约为攻击力的0.8倍)")
    
    -- 设置子物体的触发效果 - 减速buff
    SubObj_SetTriggerBuff('buff_speed', 0.25, 2, {-0.2}, "25%几率使目标减速20%，持续2秒")
end

return M