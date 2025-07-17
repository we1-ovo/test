local M = {}

function M.cb()
    -- 显示阶段成功的祝贺信息
    LEVEL_ShowDialog("", "恭喜！成功闯荡灵草谷，获得千年灵草，修为大幅提升！", "happy", 1.0)
    
    -- 给玩家发放额外奖励
    LEVEL_Award("修炼丹药", 3)
    
    -- 显示结束语
    LEVEL_ShowDialog("", "你已完成仙踪觅宝之旅，愿此番历练助你在修仙路上更进一步！", "neutral", 1.0)
    
    -- 记录成功完成关卡
    LEVEL_Log("玩家成功完成灵草谷关卡，获得千年灵草")
end

return M