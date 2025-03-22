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
	add_to_deck = function(self, card, from_debuff)
		if card.edition and card.edition.type ~= "e_mp_phantom" then
			return
		end
		G.MULTIPLAYER.send_phantom("j_ar_crabs_in_bucket")
	end,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN and G.GAME.skips ~= nil and G.MULTIPLAYER_GAME.enemy.skips ~= nil then
			local balance_diff = (math.floor((G.GAME.round_resets.discards+G.GAME.round_resets.hands) / G.MULTIPLAYER_GAME.lives ))
			card.ability.h_size = (math.floor(balance_diff - G.GAME.round_resets.hands))
			card.ability.d_size = (math.floor(balance_diff - G.GAME.round_resets.discards))
		end
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.setting_blind and is_pvp_boss() and not context.blueprint then
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
		if card.edition and card.edition.type ~= "e_mp_phantom" then
			return
		end
		G.MULTIPLAYER.remove_phantom("j_ar_crabs_in_bucket")
	end,
	in_pool = function(self)
		return G.LOBBY.code and G.LOBBY.config.multiplayer_jokers
	end,
	
})