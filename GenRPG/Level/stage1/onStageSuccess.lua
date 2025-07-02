local M = {}

function M.cb()
    -- 显示胜利旁白，描述获得千年灵草的成就
    LEVEL_ShowDialog("", "千年灵草的灵力涌入丹田，筋脉如甘露滋润，修为瞬间暴涨数个层次！", "neutral", 0.8)
    
    -- 体现修为提升的成就感
    LEVEL_ShowDialog("", "此番灵草谷历练，不仅斩妖除魔，更是悟得仙道真谛。从初入仙途的筑基修士，已然踏上通天大道！", "neutral", 0.8)
    
    -- 仙侠风格的庆祝对话
    LEVEL_ShowDialog("", "山河为证，日月可鉴！今日一战，必将成为修仙路上的传奇佳话！", "happy", 0.8)
    
    -- 最终奖励发放
    LEVEL_Award("千年灵草", 1)
    
    -- 总结性旁白
    LEVEL_ShowDialog("", "灵草谷之行圆满结束，修士带着满载的收获和坚定的道心，踏上更广阔的仙途征程...", "neutral", 0.8)
end

return M