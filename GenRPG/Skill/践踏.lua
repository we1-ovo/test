local M = {}

function M.init()
    -- 技能初始化数值部分
    Skill_SetCooldown(10000, "设置技能冷却时间为10秒")
    Skill_SetCastRange(0, "设置施法范围为0米(自身为中心)")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("石熊猛力跺脚，对周围3米范围内的敌人造成力量0.8倍的物理伤害并有30%几率使目标减速20%，持续3秒。", "范围攻击技能")
end

function M.cb()
    -- 选择周围3米范围内的敌人，最多10个
    Skill_CollectCircleTargets(3, 10, "选择3米范围内的敌人")
    
    -- 对选中目标造成0.8倍攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 0.8, "造成0.8倍攻击力的物理伤害")
    
    -- 30%几率使目标减速20%，持续3秒(3000毫秒)
    -- 注意：根据API文档，buff参数需要是{-20,}格式
    Skill_TargetEnemyAddBuff("buff_speed", 0.3, 3000, {-20,}, "30%几率减速20%，持续3秒")
    
    -- 创建视觉效果：在自身位置创建一个静态的子物体代表震动效果
    Skill_CreateStaticSubObjAtSelfPos(1000, "创建地面震动效果")
    
    -- 播放跺脚的动作时间
    Skill_Sleep(500, "播放跺脚动作")
end

return M