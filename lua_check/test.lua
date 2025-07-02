
local M = {}


function M.cb()
    print("run test cb begin")
    NPC_GetSpeed("npc")
	LEVEL_EndStage("end")
	Skill_SetCastRange(10, nil)
    print("run test cb end")
end

return M
