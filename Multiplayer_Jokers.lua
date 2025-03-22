SMODS.Atlas({
	key = "crabs_in_bucket",
	path = "j_crabs_in_bucket.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "crabs_in_bucket",
	atlas = "crabs_in_bucket",
	rarity = 3,
	cost = 10,
	loc_txt = {
		name = "Crabs In A Bucket",
		text = {
			"{C:attention}Add{} your {C:blue}Hands{} and {C:red}Discards{}",
			"together before then {C:attention}dividing{}",
			"by your current lives during the PVP Blind",
			"Sends a copy to opponent",
		},
	}, 
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = { h_size = 0, d_size = 0},
	loc_vars = function(self, info_queue, card)
		add_nemesis_info(info_queue)
		return { vars = {card.ability.h_size, card.ability.d_size,} }
	end,
	add_to_deck = function(self, card, from_debuffed)
		if not from_debuffed and (not card.edition or card.edition.type ~= "mp_phantom") then
			MP.ACTIONS.send_phantom("j_ar_crabs_in_bucket")
		end
	end,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN and G.GAME.skips ~= nil and MP.GAME.enemy.skips ~= nil then
			local balance_diff = (math.floor((G.GAME.round_resets.discards+G.GAME.round_resets.hands) / MP.GAME.lives ))
			card.ability.h_size = (math.floor(balance_diff - G.GAME.round_resets.hands))
			card.ability.d_size = (math.floor(balance_diff - G.GAME.round_resets.discards))
		end
	end,
	calculate = function(self, card, context)
		if context.setting_blind and MP.is_pvp_boss() and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_hands_played(card.ability.h_size)
					ease_discard(card.ability.d_size, nil, true)
					return true
				end,
			}))
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff and (not card.edition or card.edition.type ~= "mp_phantom") then
			MP.ACTIONS.remove_phantom("j_ar_crabs_in_bucket")
		end
	end,
	in_pool = function(self)
		return MP.LOBBY.code and MP.LOBBY.config.multiplayer_jokers
	end,
	
})