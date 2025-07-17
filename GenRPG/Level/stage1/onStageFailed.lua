local M = {}

function M.cb()
    -- 显示失败信息
    LEVEL_ShowDialog("", "修仙路充满艰险，此次失败乃是修行路上的磨砺。重新来过，定能成功！", "neutral", 1.0)
    
    -- 给予安慰和鼓励
    LEVEL_ShowDialog("", "千年灵草虽未得手，但此番历练已让你对仙途有了更深的领悟。", "neutral", 1.0)
    
    -- 记录失败原因
    LEVEL_Log("玩家在灵草谷关卡中失败")
end

return M