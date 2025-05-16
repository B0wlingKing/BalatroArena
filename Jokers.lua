SMODS.Atlas({
	key = "bowl_of_soup",
	path = "j_bowl_of_soup.png",
	px = 71,
	py = 95,
})

SMODS.Joker ({
	key = "bowl_of_soup",
	atlas = "bowl_of_soup",
	rarity = 3,
	cost = 8,
	loc_txt = {
		name = "Bowl of Soup",
		text = {
			"Each scored Jack gives",
			"{X:mult,C:white}X#1#{} Mult when scored",
		},
},
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { Xmult = 1.5}},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card:get_id() == 11 then
				-- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {
					Xmult = card.ability.extra.Xmult,
					card = context.other_card
				}
			end
		end
	end
})

SMODS.Atlas({
	key = "the_function",
	path = "j_the_function.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "the_function",
	atlas = "the_function",
	rarity = 2,
	cost = 7,
	loc_txt = {
		name = "The Function",
		text = {

			"When round starts",
			"copy a random {C:attention}Jack{}",
			"and add it to the deck"

		}
	},
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.setting_blind then
			G.E_MANAGER:add_event(Event({
				func = function() 
					local jacks = {}
					for k, v in pairs(G.playing_cards) do
						if v:get_id() == 11 then jacks[#jacks + 1] = v end
					end
					local chosen_jack = pseudorandom_element(jacks, pseudoseed('the_function'))
					if #jacks > 0 then
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Pull up' })
						G.E_MANAGER:add_event(Event({func = function()
						local card = copy_card(chosen_jack, nil, nil, G.playing_card)
						card:add_to_deck()
						G.deck.config.card_limit = G.deck.config.card_limit + 1
						table.insert(G.playing_cards, card)
						G.hand:emplace(card)
						SMODS.calculate_context({playing_card_added = true, cards = {card}})
						return true end }))
				return true end
			return true end }))
		end
	end
})

SMODS.Atlas({
    key = "soup_and_stewkin",
    path = "j_soup_and_stewkin.png",
    px = 71,
    py = 95,
})

SMODS.Joker({
    key = "soup_and_stewkin",
    atlas = "soup_and_stewkin",
	loc_txt = {
		name = "Soup and Stewkin",
		text = {

			"If played hand contains",
			"{C:attention} only Jacks{} retrigger",
			"all cards"

		}
	},
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
	pos = { x = 0, y = 0 },
    config = { extra = { repetitions = 1 } },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
                    local jacks = {}
                    for k, v in ipairs(context.scoring_hand) do
                        if v:get_id() == 11 then 
                            jacks[#jacks+1] = v
                        end
                    end
                    if #jacks == #context.scoring_hand then
						return { repetitions = 1 } 
					end
				 end
				end })


SMODS.Atlas({
	key = "potion_collection",
	path = "j_potion_collection.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
    key = "potion_collection",
	atlas = "potion_collection",
    rarity = 3,
	cost = 9,
	loc_txt = {
name = "Giga's Potion Collection",
text = {
	"Every played card permanently gains",
	"{C:mult}+#1#{} Mult when scored"
}
	},
	unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.mult = context.other_card.ability.mult or 0
            context.other_card.ability.mult = context.other_card.ability.mult + card.ability.extra.mult
            return {
            extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
            colour = G.C.MULT,
            card = card
        }
    end
end 
})

SMODS.Atlas({
	key = "dizzy_joker",
	path = "j_dizzy_joker.png",
	px = 71,
	py = 95,
})



SMODS.Joker{
    key = 'dizzy_joker',
    rarity = 2,
	cost = 7,
	loc_txt = {
		name = "Dizzy Joker",
		text = { "This joker has a {C:green}#1# in #2#{} chance",
		"to create a {C:spectral}Spectral{} card whenever",
		"A card of {V:1}#3#{} suit is scored",
		"Suit changes every round.",
		},
	},
	unlocked = true,
    discovered = true,
    atlas = 'dizzy_joker',
    blueprint_compat = true,
    pos = { x = 0, y = 0 },
    config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.odds,
			localize(G.GAME.current_round.dizzy.suit, 'suits_singular'),
			colours = { G.C.SUITS[G.GAME.current_round.dizzy.suit] }
        } }
    end,
    calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        sendDebugMessage(G.GAME.current_round.dizzy.suit)
    if (context.other_card:is_suit(G.GAME.current_round.dizzy.suit)) and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
    if (pseudorandom('dizzy') < G.GAME.probabilities.normal/card.ability.extra.odds) then
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        return {
                extra = {func = function()
                local _card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil)
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                G.GAME.consumeable_buffer = 0
            end},
            message = 'YAY!',
            colour = G.C.SECONDARY_SET.Spectral,
            card = card
            }
        end
    end
end
end
}


local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.current_round.dizzy = { suit = 'Spades' }
    return ret
end


function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.current_round.dizzy = { suit = 'Spades' }
    local dizzy = {}
    for k, v in ipairs({'Spades','Hearts','Clubs','Diamonds'}) do
        if v ~= G.GAME.current_round.dizzy.suit then dizzy[#dizzy + 1] = v end
    end
    local dizzy_card = pseudorandom_element(dizzy, pseudoseed('anc'..G.GAME.round_resets.ante))
    G.GAME.current_round.dizzy.suit = dizzy_card
end

SMODS.Atlas({
	key = "royal_decree",
	path = "j_royal_decree.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
	key = "royal_decree",
	atlas = "royal_decree",
	rarity = 1,
	cost = 3,
	loc_txt = {
		name = "Royal Decree",
		text = { "This joker gives {C:chips}+10{} Chips and",
		"has a {C:green}#2# in #3#{} chance",
		"to give {C:money}$#1#{} per numbered card held",
		"in hand",
		}
	},
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = {dollars = 1, odds = 3, chips = 10}},
	loc_vars = function(self, info_queue, card)
		return { vars = {
			card.ability.extra.dollars,
			(G.GAME.probabilities.normal or 1),
            card.ability.extra.odds,
			card.ability.extra.chips
						}
				}
			end,
	calculate = function (self, card, context)
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			if context.other_card:get_id() <= 10 then
				if (pseudorandom('decree') < G.GAME.probabilities.normal/card.ability.extra.odds) then
					if context.other_card.debuff then
						return {
						message = localize('k_debuffed'),
                                colour = G.C.RED,
                                card = card,
					}
					else
					G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
					G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
					return {
						dollars = card.ability.extra.dollars,
						chips = card.ability.extra.chips,
						card = card
					}
					end
			
			end
			return {
				chips = card.ability.extra.chips,
				card = card
			}
			end
		end
	end
})

SMODS.Atlas({
	key = "mouse_bites",
	path = "j_mouse_bites.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
    key = "mouse_bites",
	atlas = "mouse_bites",
    rarity = 3,
	cost = 8,
	loc_txt = {
		name = "Mouse Bites",
		text = {

			"Gains {C:chips}+#2#{} Chips",
			"per scored card less than {C:attention}6{}",
			"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
		}
	},
	unlocked = true,
    discovered = true,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    pos = { x = 0, y = 0 },
    config = { extra = { chips = 0, chip_gain = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.chips, card.ability.extra.chip_gain} }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips} }
			}
		end
		if context.individual and not context.blueprint and context.cardarea == G.play then
			if context.other_card:get_id() < 6 then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
				return {
					extra = {focus = card, message = localize('k_upgrade_ex')},
					card = card,
					colour = G.C.CHIPS
				}
		end
			end
		end 
		})

SMODS.Atlas({
			key = "soup",
			path = "j_soup.png",
			px = 71,
			py = 95,
		})

SMODS.Joker({
	key = "soup",
	atlas = "soup",
    rarity = 4,
	cost = 20,
	loc_txt = {
		name = "Soup",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult",
			"per {C:attention}Jack{} in your deck",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
		}
	},
    discovered = true,
	unlocked = true,
    blueprint_compat = true,
    pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1.03},
    config = { extra = { bonus = 1, xmult = 1, tally = 0} },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            if card.ability.extra.xmult ~= 1 then
                return {
                    Xmult_mod = card.ability.extra.xmult,
                    card = card,
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { card.ability.extra.xmult }
                    }
                }
            end
        end
    end,
	update = function(self, card)
        if G.playing_cards ~= nil then
            card.ability.extra.tally = 0
            for k, v in pairs(G.playing_cards) do
                if v:get_id() == 11 then card.ability.extra.tally = card.ability.extra.tally + 1 end
            end
            card.ability.extra.xmult = 1 + (card.ability.extra.tally * card.ability.extra.bonus)
        end
    end
})

SMODS.Atlas({
	key = "true_self",
	path = "j_true_self.png",
	px = 71,
	py = 95,
})

SMODS.Joker({
    key = "true_self",
	atlas = "true_self",
    rarity = 2,
	cost = 7,
	loc_txt = {
		name = "True Self",
		text = {

			"Gains {X:mult,C:white}X#2#{} Mult",
			"per {C:Tarot}Tarot{} Card used",
			"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
		}
	},
	unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pos = { x = 0, y = 0 },
    config = { extra = { x_mult = 1, bonus = 0.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.x_mult, card.ability.extra.bonus} }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult_mod = card.ability.extra.x_mult
			}
		end
		if context.using_consumeable then
			if context.consumeable.ability.set == 'Tarot' and not context.blueprint then
				card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.bonus
             	return {
					message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
					card = card,
				}

            end
		end
	end
})


SMODS.Atlas({
    key = "higher",
    path = "j_higher.png",
    px = 71,
    py = 95,
})

SMODS.Joker({
    key = "higher",
    atlas = "higher",
    rarity = 2,
	loc_txt = {
		name = "Higher",
		text = {
			"Retriggers each",
			"played {C:attention}7, 8, 9,{}",
			"or {C:attention}10{}",
		}
	},
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { repetitions = 1 } },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:get_id() > 6 and context.other_card:get_id() <=10 then
				return {
					repetitions = 1,
					card = context.other_card
				}
			end
		end 
	end
})

SMODS.Atlas({
    key = "forward_dash",
    path = "j_forward_dash.png",
    px = 71,
    py = 95,
})

SMODS.Joker({
    key = "forward_dash",
    atlas = "forward_dash",
    rarity = 1,
    cost = 3,
	loc_txt = {

		name = "Forward Dash",
			text = {
				"The first scored {C:attention}6{}",
				"of a hand is triggered an additional",
				"{C:attention}2{} times",
			}
	},
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { repetitions = 2 } },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.cardarea == G.play and context.repetition and not context.repetition_only then
				local first_six = {}
				for i = 1, #context.scoring_hand do
					if context.scoring_hand[i]:get_id() == 6 then first_six = context.scoring_hand[i]; break end
				end
				if context.other_card == first_six then
					return {
						repetitions = 2
					}
				end
			end
		end
	end
	})


SMODS.Atlas({
	key = "623",
	path = "j_623.png",
	px = 71,
	py = 95,
})

SMODS.Joker ({
	key = "623",
	atlas = "623",
	rarity = 3,
	cost = 9,
	loc_txt = {
		name = "623",
			text = {
				"Each scored {C:attention}6{} gives",
				"{C:chips}+#3#{} Chips",
				"{C:mult}+#1#{} Mult",
				"{X:mult,C:white}X#2#{} Mult when scored",
			},
	},
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { mult = 3, Xmult = 2, chips = 6}},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.Xmult, card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card:get_id() == 6 then
				-- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {

					mult = card.ability.extra.mult,
					Xmult = card.ability.extra.Xmult,
					chips = card.ability.extra.chips,
					card = context.other_card
				}
			end
		end
	end
})

SMODS.Atlas({
    key = "censorship",
    path = "j_censorship.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'censorship',
    rarity = 3,
	loc_txt = {
		name = "Censorship",
		text = {"If scored hand contains",
				"an {C:attention}Ace, 9, 8,{} and {C:attention}4{}",
		"{X:mult,C:white}X#1#{} Mult"},
	},
    cost = 8,
	unlocked = true,
    discovered = true,
    atlas = 'censorship',
    blueprint_compat = true,
    pos = { x = 0, y = 0 },
    config = { extra = 20  },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra} }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = {
                ['Ace'] = 0,
                ['Nine'] = 0,
                ['Eight'] = 0,
                ['Four'] = 0
            }
            for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 14 and count["Ace"] == 0 then count["Ace"] = count["Ace"] + 1
                    elseif context.scoring_hand[i]:get_id() == 9 and count["Nine"] == 0 then count["Nine"] = count["Nine"] + 1
                    elseif context.scoring_hand[i]:get_id() == 8 and count["Eight"] == 0 then count["Eight"] = count["Eight"] + 1
                    elseif context.scoring_hand[i]:get_id() == 4 and count["Four"] == 0 then count["Four"] = count["Four"] + 1 end
            end
            if count["Ace"] > 0 and
            count["Nine"] > 0 and
            count["Eight"] > 0 and
            count["Four"] > 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
                    Xmult_mod = card.ability.extra
                }
            end
        end
    end
}

SMODS.Atlas({
    key = "the_jackler",
    path = "j_jackler.png",
    px = 71,
    py = 95,
})
SMODS.Joker{
    key = 'the_jackler',
    rarity = 1,
	loc_txt = {
		name = "The Jackler",
		text = {
			"Each played {C:attention}Jack{}",
			"gives {C:mult}+#1#{} Mult",
			"{C:attention}Jacks of Clubs{} also",
			"give {X:mult,C:white}X#2#{} Mult"
		},
	},
	unlocked = true,
    discovered = true,
    atlas = 'the_jackler',
    blueprint_compat = true,
    pos = { x = 0, y = 0 },
    config = { extra = {mult = 1, Xmult = 2} },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.Xmult} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 11 then
				if context.other_card:is_suit("Clubs") then
					if context.other_card.debuff then
						return {
						message = localize('k_debuffed'),
                                colour = G.C.RED,
                                card = card,
					}
					else
						return {
							mult = card.ability.extra.mult,
							Xmult = card.ability.extra.Xmult,
							card = card
						}
					end 
				end 
				return {
					mult = card.ability.extra.mult,
					card = card
				}

            end
        end
    end
}

SMODS.Atlas ({
	key = "clang",
    path = "j_clang.png",
    px = 71,
    py = 95,
})

SMODS.Joker ({
	key = "clang",
	atlas = "clang",
	rarity = 1,
	cost = 3,
	loc_txt = {
name = "Clang!",
text = {"Played {C:attention}Steel Cards{}",
		"give {X:mult,C:white}X#1#{} Mult",
		"when scored."
},
	},
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { Xmult = 1.5}},
	enhancement_gate = 'm_steel',
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card.ability.name == 'Steel Card' then
				-- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {
					Xmult = card.ability.extra.Xmult,
					card = context.other_card,
					message = 'CLANG!'
				}
			end
		end
	end
})

SMODS.Atlas ({
	key = "four_leaf_clover",
    path = "j_four_leaf_clover.png",
    px = 71,
    py = 95,
})


SMODS.Joker ({

	key = "four_leaf_clover",
	atlas = "four_leaf_clover",
	rarity = 2,
	cost = 5,
	loc_txt = {
		name = "Four Leaf Clover",
		text = { "All played {C:attention}Clubs{}",
			"become {C:attention}lucky{}",
			"when scored"
	}
	},
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	calculate = function(self, card, context)
	if context.cardarea == G.play and not context.blueprint then
		local clubs = {}
		for k, v in ipairs(context.scoring_hand) do
			if v:is_suit('Clubs') then 
				clubs[#clubs+1] = v
				v:set_ability(G.P_CENTERS.m_lucky, nil, true)
				G.E_MANAGER:add_event(Event({
					func = function()
						v:juice_up()
						return true
					end
				})) 
			end
		end
		if #clubs > 0 then 
			return {
				message = 'Lucky!',
				colour = G.C.MONEY,
				card = card
			}
		end
	end
end
	
})


SMODS.Atlas ({
	key = "iou",
    path = "j_iou.png",
    px = 71,
    py = 95,
})


SMODS.Joker{
    key = 'iou',
    rarity = 3,
	cost = 9,
	unlocked = true,
    discovered = true,
    atlas = 'iou',
	loc_txt = {
		name = "I.O.U",
		text = {
			"Sell this card after",
			"{C:attention}#1#{} rounds",
			"to create a random {C:tarot}",
			"Legendary{} Joker",
			"{C:inactive}(Currently {C:attention}#2#/#1#{C:inactive} Rounds)"
		},
	},
    blueprint_compat = false,
    pos = { x = 0, y = 0 },
    config = { extra = {bonus = 6, iou_rounds = 0} },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.bonus, card.ability.extra.iou_rounds} }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if context.end_of_round then 
				card.ability.extra.iou_rounds = card.ability.extra.iou_rounds + 1
                    if card.ability.extra.iou_rounds == card.ability.extra.bonus then 
                        local eval = function(card) return not card.REMOVED end
                    end
                    return {
                        message = (card.ability.extra.iou_rounds < card.ability.extra.bonus) and (card.ability.extra.iou_rounds..'/'..card.ability.extra.bonus) or localize('k_active_ex'),
                        colour = G.C.FILTER
                    }
                end

            end
			if context.selling_self and card.ability.extra.iou_rounds == 6 then
				if #G.jokers.cards <= G.jokers.config.card_limit then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
						play_sound('timpani')
						local card = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'all')
						card:add_to_deck()
						G.jokers:emplace(card)
						card:juice_up(0.3, 0.5)
						return true end }))
					delay(0.6)
				else
					card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_no_room_ex')})
				end
			end
        end
}



SMODS.Atlas({
    key = "aces_high",
    path = "j_aces_high.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'aces_high',
    rarity = 2,
	unlocked = true,
    discovered = true,
    atlas = 'aces_high',
    cost = 7,
	loc_txt ={

		name = "Aces High",
		text = {
			"Earn {C:money}$#4#{} for every Ace in deck",
			"Has a {C:green}#2# in #3#{} chance",
			"of being destroyed at the end of round",
		},
	},
    blueprint_compat = false,
    eternal_compat = false,
    pos = { x = 0, y = 0 },
    config = { extra = {tally = '0', money = '2', odds = '6'} },
	no_pool_flag = 'man_down',
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.tally,(G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.money} }
    end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if pseudorandom('aces') < G.GAME.probabilities.normal/card.ability.extra.odds then 
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Mayday!' })
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end}))
							G.GAME.pool_flags.man_down = true
						return true
					end
				})) 
			end
		end
	end,
	update = function(self, card)
		if G.STAGE == G.STAGES.RUN then
			card.ability.extra.tally = 0
            	for k, v in pairs(G.playing_cards) do
                	if v:get_id() == 14 then card.ability.extra.tally = card.ability.extra.tally + 1 end
            	end
			end
		end,
    calc_dollar_bonus = function(self, card)
		if card.ability.extra.tally > 0 then
			return card.ability.extra.tally*(card.ability.extra.money)
		end
	end
}

SMODS.Atlas({
    key = "aces_bias",
    path = "j_aces_bias.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'aces_bias',
    rarity = 2,
	unlocked = true,
    discovered = true,
    atlas = 'aces_bias',
    cost = 7,
	loc_txt = {

		name = "Aces' Bias",
		text = {
			"Gain {C:money}$#3#{} per Ace in Deck",
			"If an Ace is scored this round, gains {C:mult}+#2#{} Mult",
			"{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)"
		},
	},
    blueprint_compat = true,
    eternal_compat = true,
    pos = { x = 0, y = 0 },
    config = { extra = {tally = '0', money = '2', mult_mod = '4', mult = '0'} },
	yes_pool_flag = 'man_down',
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.tally, card.ability.extra.mult_mod, card.ability.extra.money, card.ability.extra.mult} }
    end,
	calculate = function(self, card, context)
		if context.before then
			if context.cardarea == G.jokers and not context.blueprint then
				local ace = false
				for i = 1, #context.scoring_hand do
					if context.scoring_hand[i]:get_id() == 14 then ace = true
				end
				if ace then
					card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
					sendDebugMessage(card.ability.extra.mult)
					return {
					extra = {focus = card, message = localize('k_upgrade_ex')},
					colour = G.C.MULT
					}
					end
				end
			end
		end
		if context.joker_main then
			return {
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
				mult_mod = card.ability.extra.mult
			}
		end
	end,
	update = function(self, card)
		if G.STAGE == G.STAGES.RUN then
			card.ability.extra.tally = 0
            	for k, v in pairs(G.playing_cards) do
                	if v:get_id() == 14 then card.ability.extra.tally = card.ability.extra.tally + 1 end
            	end
			end
		end,
    calc_dollar_bonus = function(self, card)
		if card.ability.extra.tally > 0 then
			return card.ability.extra.tally*(card.ability.extra.money)
		end
	end
}

SMODS.Atlas({
    key = "broken_record",
    path = "j_broken_record.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'broken_record',
    rarity = 2,
	unlocked = true,
    discovered = false,
    atlas = 'broken_record',
	loc_txt = {
		name = "Broken Record",
		text = {
			"Retriggers all played {C:attention}Aces{}",
			"Has a {C:green}#2# in #3#{} chance of",
			"being destroyed at the end of round"
		},
	},
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    pos = { x = 0, y = 0 },
    config = { extra = {repetitions = '1', odds = '6'} },
	no_pool_flag = 'scratched',
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.repetitions, (G.GAME.probabilities.normal or 1), card.ability.extra.odds} }
    end,
	calculate = function(self, card, context)
		if context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 14 then
				return {
					message = 'Repeat!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		end
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if pseudorandom('record') < G.GAME.probabilities.normal/card.ability.extra.odds then 
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Broken!' })
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end}))
							G.GAME.pool_flags.scratched = true
						return true
					end
				})) 
			end
		end
	end
}

SMODS.Atlas({
    key = "bootleg",
    path = "j_bootleg.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'bootleg',
    rarity = 2,
	unlocked = true,
    discovered = false,
    atlas = 'bootleg',
    cost = 6,
	loc_txt = {
		name = "Bootleg",
		text = {
			"Turns all {C:attention}scored cards{} into the first",
			"scored Ace of Diamonds after scoring",
			"Retriggers all {C:attention}Aces{}",
			"Has a {C:green}#2# in #3#{} chance of",
			"being destroyed at the end of round"
		},
	},
    blueprint_compat = true,
    eternal_compat = true,
    pos = { x = 0, y = 0 },
    config = { extra = {repetitions = '1', odds = '9'} },
	yes_pool_flag = 'scratched',
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.repetitions, (G.GAME.probabilities.normal or 1), card.ability.extra.odds} }
    end,
	set_ability = function(self, card, initial, delay_sprites)
		local W,H = card.T.w, card.T.h
		local scale = 1
		card.children.center.scale.y = card.children.center.scale.x
		H=W
		card.T.h = H*scale
		card.T.w = W*scale
	end,
	calculate = function(self, card, context)
		if context.after and context.cardarea == G.jokers and not context.blueprint then
			if context.scoring_hand[1]:get_id() == 14 and context.scoring_hand[1]:is_suit('Diamonds') then
				local copy = context.scoring_hand[1]
				if not copy.debuff and not copy.vampired then 
					for i=1, #context.scoring_hand do
                   		G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
								context.scoring_hand[i]:flip()
								play_sound('card1', percent)
								context.scoring_hand[i]:juice_up(0.3, 0.3)
						return true end }))
					end
						delay(0.2)
					for i=1, #context.scoring_hand do
						G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1, func = function()
							context.scoring_hand[i]:flip()
							play_sound('card1', percent)
							context.scoring_hand[i]:juice_up(0.3, 0.3)
							if context.scoring_hand[i] ~= copy then
								copy_card(copy, context.scoring_hand[i])
							end
						return true end }))
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Copied!' })
                	end
					delay(1.0)
				end
			end
		end
		if context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 14 then
				return {
					message = 'Repeat!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		end
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if pseudorandom('bootleg') < G.GAME.probabilities.normal/card.ability.extra.odds then 
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Broken!' })
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end}))
							G.GAME.pool_flags.scratched = true
						return true
					end
				})) 
			end
		end
	end
}

SMODS.Atlas({
    key = "raise",
    path = "j_raise.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "raise",
    path = "j_raise.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'raise',
    rarity = 3,
	unlocked = true,
    discovered = false,
    atlas = 'raise',
    cost = 6,
	loc_txt = {
		name = "Raise",
		text = {

			"Gives {X:mult,C:white}X#1#{} Mult",
			"Gains {X:mult,C:white}X#2#{} Mult per round",
			"{C:green}#4# in #3#{} chance to be destroyed",
			"Odds of destruction increase after each round",
			"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
		},
	},
    blueprint_compat = true,
    eternal_compat = false,
    pos = { x = 0, y = 0 },
    config = { extra = {xmult = '3', xmult_mod = '0.25', odds = '10'} },
no_pool_flag = 'raise',
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult, card.ability.extra.xmult_mod, card.ability.extra.odds, (G.GAME.probabilities.normal or 1)} }
    end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.xmult,
                card = card,
                message = localize {
                type = 'variable',
                key = 'a_xmult',
                vars = { card.ability.extra.xmult }
                }
            }
        end
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if pseudorandom('raise') < G.GAME.probabilities.normal/card.ability.extra.odds then 
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'NOOOOOOOO!' })
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end}))
							G.GAME.pool_flags.raise = true
						return true
					end
				}))
			else
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
				card.ability.extra.odds = card.ability.extra.odds - 1
				return {
					extra = {message = 'RAISE!!!', colour = G.C.MULT},
					colour = G.C.MULT,
					card = card
				}
			end
		end
		if context.skip_blind and not context.blueprint then
			if card.ability.extra.odds > 1 then
				card.ability.extra.odds = card.ability.extra.odds - 1
				return true
			end
			return {
				extra = {message = 'NEXT!!!', colour = G.C.MULT},
				colour = G.C.MULT,
				card = card
			}
		end
    end,
}

SMODS.Atlas({
    key = "all_in",
    path = "j_all_in.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'all_in',
    rarity = 3,
	unlocked = true,
    discovered = true,
    atlas = 'all_in',
    cost = 8,
	loc_txt = {
		name = "All In",
		text = {
			"Sell this card for $25",
			"Gain a random {C:tarot}Legendary{} Joker"
		},
	},
    blueprint_compat = false,
    eternal_compat = false,
    pos = { x = 0, y = 0 },
    config = { extra = {loss = '29'} },
	yes_pool_flag = 'raise',
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra_value = card.ability.extra_value - card.ability.extra.loss
		card:set_cost()
	end,
	calculate = function(self, card, context)
		if context.selling_self then
			if #G.jokers.cards <= G.jokers.config.card_limit then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					play_sound('timpani')
					local card = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'all')
					card:add_to_deck()
					G.jokers:emplace(card)
					card:juice_up(0.3, 0.5)
					return true end }))
				delay(0.6)
			else
				card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_no_room_ex')})
			end
		end
    end,
}

SMODS.Atlas({
    key = "slumbering_dragon",
    path = "j_sleeb.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'slumbering_dragon',
    rarity = 4,
	unlocked = true,
    discovered = true,
    atlas = 'slumbering_dragon',
	loc_txt = {
		name = "Slumbering Dragon",
		text = {
			"Makes {C:attention}first{} played card in hand {C:dark_edition}Negative{}",
			"{C:green}#1# in #2#{} chance of waking up after each round"
		},
	},
    cost = 20,
    blueprint_compat = false,
    eternal_compat = false,
    pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1.03},
    config = { extra = { odds = '10' } },
	no_pool_flag = 'sleeb',
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds} }
    end,
	calculate = function(self, card, context)
		if context.after and context.cardarea == G.jokers then
			if context.scoring_hand[1].edition == nil then
				G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.1,func = function()
					context.scoring_hand[1]:flip()
					play_sound('card1', percent)
					context.scoring_hand[1]:juice_up(0.3, 0.3)
				return true end }))
				delay(0.2)
				G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1, func = function()
					context.scoring_hand[1]:flip()
					play_sound('card1', percent)
					context.scoring_hand[1]:juice_up(0.3, 0.3)
					delay(0.1)
					context.scoring_hand[1]:set_edition('e_negative', true)
				return true end }))
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Pretty...'})
			end
		end
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if pseudorandom('awake') < G.GAME.probabilities.normal/card.ability.extra.odds then 
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'One sec...' })
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end}))
							G.GAME.pool_flags.sleeb = true
						return true
					end
				}))
			end
		end
	end
}

SMODS.Atlas({
    key = "vyse_the_dreadwyrm",
    path = "j_vyse.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
    key = 'vyse_the_dreadwyrm',
    rarity = 4,
	unlocked = true,
    discovered = true,
    atlas = 'vyse_the_dreadwyrm',
    cost = 20,
    blueprint_compat = true,
    eternal_compat = false,
	loc_txt = {

		name = "Vyse The Dreadwyrm",
		text = {
			"Makes {C:attention}first{} played card in hand {C:dark_edition}Negative{}",
			"All {C:dark_edition}Negative{} Jokers, scored cards, and cards held in hand",
			"Give {X:mult,C:white}X#1#{} Mult"
		},
	},
    pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1.03},
    config = { extra = { Xmult = '1.5'} },
	yes_pool_flag = 'sleeb',
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.Xmult} }
    end,
	in_pool = function(self)
		return true
	end,
	calculate = function(self, card, context)
		if context.after and context.cardarea == G.jokers and not context.blueprint then
			if context.scoring_hand[1].edition == nil then
				G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.1,func = function()
					context.scoring_hand[1]:flip()
					play_sound('card1', percent)
					context.scoring_hand[1]:juice_up(0.3, 0.3)
				return true end }))
				delay(0.2)
				G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1, func = function()
					context.scoring_hand[1]:flip()
					play_sound('card1', percent)
					context.scoring_hand[1]:juice_up(0.3, 0.3)
					delay(0.1)
					context.scoring_hand[1]:set_edition('e_negative', true)
				return true end }))
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'More!'})
			end
		end
		if context.individual and context.cardarea == G.play then
			if context.other_card.edition and context.other_card.edition.key == "e_negative" then
				return{
					message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
					Xmult_mod = card.ability.extra.Xmult,
					card = card
				}
			end
		end
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
		if context.other_card.edition and context.other_card.edition.key == "e_negative" then
			if context.other_card.debuff then
			return {
				message = localize("k_debuffed"),
				colour = G.C.RED,
				card = card,
			}
			else
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
				Xmult_mod = card.ability.extra.Xmult,
				card = card
			}
			end
		end
	end
	if context.other_joker and context.other_joker.edition and context.other_joker.edition.negative == true and card ~= context.other_joker then		
		return {
			message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
			Xmult_mod = card.ability.extra.Xmult
			}
		end
	end
}

SMODS.Atlas({
    key = "j_hans_baron",
    path = "sircmod_atlas.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
	key = "j_hans_baron",
	atlas = 'j_hans_baron',
	config = {
		extra = {
			money_earned = 4,
			denominator = 6
		}
	},
	loc_txt = {
		name = "Baron Hans",
		text = {
			"Earn {C:money}$#1#{} at",
			"end of round",
			"{C:green}#3# in #2#{} chance this",
			"card is destroyed",
			"at end of round"
		},
	},
	pos = {x = 3,y = 0},
	rarity = 1,
	cost = 6,
	no_pool_flag = "sir_hams_bacon",
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	cost_mult = 1.0,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money_earned, card.ability.extra.denominator, G.GAME.probabilities.normal} }
	end,
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.money_earned
		if bonus > 0 then return bonus end
	end,
	calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.repetition and context.game_over == false and not context.blueprint then
			local myrandom = pseudorandom(card.ability.name)
			sendDebugMessage(card.ability.name .. ":: Running " .. G.GAME.probabilities.normal .. " in " .. card.ability.extra.denominator .. " odds")
			sendDebugMessage(card.ability.name .. ":: " .. myrandom .. " < " .. G.GAME.probabilities.normal / card.ability.extra.denominator .. " = " .. tostring(myrandom < G.GAME.probabilities.normal / card.ability.extra.denominator))
			if myrandom < G.GAME.probabilities.normal / card.ability.extra.denominator then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				-- Sets the pool flag to true, meaning Baron Hans doesn't spawn, and Bacon Hams does.
				G.GAME.pool_flags.sir_hams_bacon = true
				return {
					message = localize('k_extinct_ex')
				}
			else
				return {
					message = localize('k_safe_ex')
				}
			end
        end
	end
}

SMODS.Atlas({
    key = "j_hams_bacon",
    path = "sircmod_atlas.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
	key = "j_hams_bacon",
	atlas = 'j_hams_bacon',
	config = {
		extra = {
			money_earned = 4,
			extra_money_earned_amount = 2,
			extra_money_earned_per = 10,
			denominator = 1000
		}
	},
	loc_txt = {
		name = "Bacon Hams",
		text = {
			"Earn {C:money}$#2# per $#3#{}",
			"owned + {C:money}$#1#{} at end of round",
			"{C:green}#5# in #4#{} chance this",
			"card is destroyed",
			"at end of round"
		},
	},
	pos = {x = 4,y = 0},
	rarity = 1,
	cost = 5,
	yes_pool_flag = "sir_hams_bacon",
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	cost_mult = 1.0,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money_earned, card.ability.extra.extra_money_earned_amount, card.ability.extra.extra_money_earned_per, card.ability.extra.denominator, G.GAME.probabilities.normal} }
	end,
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.money_earned + (math.floor(G.GAME.dollars / card.ability.extra.extra_money_earned_per) * card.ability.extra.extra_money_earned_amount)
		if bonus > 0 then return bonus end
	end,
	calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.repetition and context.game_over == false and not context.blueprint then
			local myrandom = pseudorandom(card.ability.name)
			if pseudorandom(card.ability.name) < G.GAME.probabilities.normal / card.ability.extra.denominator then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				-- Sets the pool flag to true, meaning Baron Hans doesn't spawn, and Bacon Hams does.
				G.GAME.pool_flags.sir_hams_bacon = true
				return {
					message = localize('k_extinct_ex')
				}
			else
				return {
					message = localize('k_safe_ex')
				}
			end
        end
    end
}

SMODS.Atlas({
    key = "j_chrysopoeia_crisis",
    path = "sircmod_atlas.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
	key = "j_chrysopoeia_crisis",
	atlas = "j_chrysopoeia_crisis",
	config = {
		extra = {
			mult_gained = 6,
			mult = 0
		}
	},
	loc_txt = {
		name = "Chrysopoeia Crisis",
		text = {
			"This Joker gains {C:mult}+#1#{} Mult",
			"whenever it converts a scored",
			"{C:attention}Gold{} card to a {C:attention}Steel{} card",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}"
		},
	},
	pos = {x = 5,y = 0},
	rarity = 2,
	cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	cost_mult = 1.0,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult_gained, card.ability.extra.mult} }
	end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.jokers and not context.blueprint then
			local transmuted = false
			for k, v in ipairs(context.scoring_hand) do
				if v.label == "Gold Card" then 
					transmuted = true
					v:set_ability(G.P_CENTERS.m_steel, nil, true)
					card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gained
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end
					})) 
				end
			end
			if transmuted then 
				return {
					message = 'Transmuted!',
					colour = G.C.MONEY,
					card = card
				}
			end
		end
        if context.joker_main and context.cardarea == G.jokers then
            if card.ability.extra.mult ~= 0 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_mult',
                        vars = { card.ability.extra.mult }
                    },
                    mult_mod = card.ability.extra.mult
                }
            end
        end
    end
}

SMODS.Atlas({
    key = "j_401k",
    path = "sircmod_atlas.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
	key = "j_401k",
	atlas = "j_401k",
	config = {
		extra = {
			money_earned = 1,
			interest = 10
		}
	},
	loc_txt = {
		name = "401k",
		text = {
			"Gains {C:money}$#1#{} of {C:attention}sell value{}",
			"for every card {C:attention}sold{}",
			"{C:attention}Sell value{} increases by",
			"{C:attention}#2#%{} at end of round"
		},
	},
	pos = {x = 2,y = 0},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	cost_mult = 1.0,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money_earned, card.ability.extra.interest} }
	end,
	calculate = function(self, card, context)
        if context.selling_card and not context.repetition and not context.blueprint then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.money_earned
            card:set_cost()
            ease_dollars(-1 * card.ability.extra.money_earned);
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize("k_val_up"), colour = G.C.MONEY})
        end
	end
}

SMODS.Atlas({
    key = "j_vanda",
    path = "sircmod_atlas.png",
    px = 71,
    py = 95,
})

SMODS.Joker{
	key = "j_vanda",
	atlas = "j_vanda",
	config = {
		extra = {
			money_mod = 1,
			Xmult_mod = .1,
			max_money_mod = 10,
			current_Xmult = 1
		}
	},
	loc_txt = {
		name = "Vanda",
		text = {
			"Converts {C:money}$#1#{} into {X:mult,C:white}X#2#{} Mult",
			"at the end of the {C:money}shop{}",
			"(up to {C:money}$#3#{})",
			"{C:inactive}(Currently {X:mult,C:white} X#4# {C:inactive} Mult){}"
		},
	},
	pos = {x = 0,y = 0},
	soul_pos = {x = 1, y = 0},
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	cost_mult = 1.0,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.money_mod, card.ability.extra.Xmult_mod, card.ability.extra.max_money_mod, card.ability.extra.current_Xmult} }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers then
			if context.ending_shop and not context.repetition and not context.blueprint then
				local take_money = 0
				if G.GAME.dollars < 0 then
					return true
				end
				if  G.GAME.dollars >= card.ability.extra.max_money_mod then
					take_money = card.ability.extra.max_money_mod
				else
					take_money = G.GAME.dollars
				end
				if take_money > 0 then
					card.ability.extra.current_Xmult = card.ability.extra.current_Xmult + (take_money * card.ability.extra.Xmult_mod)
					ease_dollars(-1 * take_money, true)	
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize("k_upgrade_ex"), colour = G.C.RED})
					play_sound("generic1")
				end
			end
		end
		if context.joker_main and context.cardarea == G.jokers then
            if card.ability.extra.current_Xmult ~= 1 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { card.ability.extra.current_Xmult }
                    },
                    Xmult_mod = card.ability.extra.current_Xmult
                }
            end
        end
	end,
}