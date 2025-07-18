local M = {}

function M.cb()
    -- 显示阶段成功的祝贺信息
    LEVEL_ShowDialog("", "恭喜！成功闯荡灵草谷，获得千年灵草，修为大幅提升！", "neutral", 1.0)
    
    -- 给玩家发放额外成功奖励
    LEVEL_Award("修炼丹药", 3)
    
    -- 结束语
    LEVEL_ShowDialog("", "本次修炼让你道行精进，望能早日踏上仙途巅峰！", "happy", 1.0)
end

return M