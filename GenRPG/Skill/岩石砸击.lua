local M = {}

function M.init()
    -- 初始化技能数值
    Skill_SetMPCost(40, "设置魔法消耗为40点")
    Skill_SetCooldown(6, "设置技能冷却时间为6秒")
    Skill_SetCastRange(3, "设置施法范围为3米")
    Skill_SetMainTargetType("enemy", "设置目标类型为敌人")
    Skill_SetDesc("石熊抬起前肢猛击地面，对面前3米扇形区域内的敌人造成120%攻击力的物理伤害，并有30%几率使目标眩晕1秒")
end

function M.cb()
    -- 模拟石熊抬起前肢的施法动作
    Skill_Sleep(500, "石熊抬起前肢准备猛击地面，施法时间0.5秒")
    
    -- 选择前方扇形区域内的敌人目标
    -- 扇形区域，半径3米，角度90度，最多选择10个目标
    Skill_CollectSectorTargets(3, 90, 10, "选择前方扇形区域内的敌人")
    
    -- 对选中目标造成120%攻击力的物理伤害
    Skill_TargetScaleDamage("damage_physical", 1.2, "造成120%攻击力的物理伤害")
    
    -- 30%几率使目标眩晕1秒
    Skill_TargetEnemyAddBuff("buff_stun", 0.3, 1, {}, "30%几率使目标眩晕1秒")
    
    -- 在目标位置创建一个静止的子物体表现撞击效果
    Skill_CreateStaticSubObjAtTargetPos(1, "创建岩石撞击的视觉特效")
    
    -- 石熊技能释放完成后的喊话
    Skill_Say("大地之力！", 1)
end

return M