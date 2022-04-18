if not gadgetHandler:IsSyncedCode() then
	return false
end

local gadgetEnabled = false
if Spring.GetModOptions().disable_fogofwar then
	gadgetEnabled = true
end

function gadget:GetInfo()
    return {
      name      = "FogOfWarRemover",
      desc      = "123",
      author    = "Damgam",
      date      = "2021",
      layer     = -100,
      enabled   = gadgetEnabled,
    }
end

local spGetTeamList = Spring.GetTeamList
local spGetAllyTeamList= Spring.GetAllyTeamList

function gadget:GameFrame(n)
    if n%1800 == 10 then
        local teams = spGetTeamList()
        local allyteams = spGetAllyTeamList()
        for i = 1,#allyteams do
            local allyTeamID = allyteams[i]
            Spring.SetGlobalLos(allyTeamID, true)
        end
    end
end