G.ARENA = {}

function G.ARENA.load_mp_file(file)
	local chunk, err = SMODS.load_file(file, "Arena")
	if chunk then
		local ok, func = pcall(chunk)
		if ok then
			return func
		else
			sendWarnMessage("Failed to process file: " .. func, "ARENA")
		end
	else
		sendWarnMessage("Failed to find or compile file: " .. tostring(err), "ARENA")
	end
	return nil
end

local load_mp_file = G.ARENA.load_mp_file

load_mp_file("Jokers.lua")

if SMODS.Mods["VirtualizedMultiplayer"] and SMODS.Mods["VirtualizedMultiplayer"].can_load then --Checks if CiaB can run
	load_mp_file("Multiplayer_Jokers.lua")
else
	sendDebugMessage("Cannot find Multiplayer, either there is an issue with Core.lua or the Multiplayer Mod is missing. Multiplayer Jokers for Arena will be disabled.")
end