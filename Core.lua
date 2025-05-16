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
