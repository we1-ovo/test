local M = {}

function M.cb()
    -- 显示失败信息
    LEVEL_ShowDialog("", "修仙路充满艰险，此次失败乃是修行路上的磨砺。重新来过，定能成功！", "neutral", 1.0)
    
    -- 鼓励性的结语
    LEVEL_ShowDialog("", "失败是成功之母，每一次的挫折都是前进的垫脚石。调整心态，再次挑战灵草谷吧！", "neutral", 1.0)
end

return M