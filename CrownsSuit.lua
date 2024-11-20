--- STEAMODDED HEADER
--- MOD_NAME: Crowns Suit
--- MOD_ID: CrownsSuit
--- MOD_AUTHOR: [Kaishi, itayfeder]
--- MOD_DESCRIPTION: This mod adds a new suit, Crowns ! Huge thanks to itayfeder for letting me using his code. (go check Codex Arcanum it's awesome)
--- BADGE_COLOUR: FFD700
--- PREFIX: crown

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas { key = 'lc_cards', path = '8BitDeck.png', px = 71, py = 95 }
SMODS.Atlas { key = 'lc_ui', path = 'ui_assets.png', px = 18, py = 18 }

local function allow_suits(self, args)
    if args and args.initial_deck and (SMODS.Mods["SixSuits"] or {}).can_load then
        return SMODS.Mods["SixSuits"].config.allow_all_suits
    end
    return true
end

local crowns = SMODS.Suit {

    key = 'Crowns',
    card_key = 'Ccrown',

    lc_atlas = 'lc_cards',
    lc_ui_atlas = 'lc_ui',

    pos = { y = 0 },
    ui_pos = { x = 0, y = 0 },

    lc_colour = HEX('FFD700'),

    loc_txt = {
        ['en-us'] = {
            singular = 'Crown',
            plural = 'Crowns',
        }
    },
    in_pool = allow_suits
}

SMODS.Atlas { key = 'Blind', path = 'BlindChips.png', px = 34, py = 34, frames = 21, atlas_table = 'ANIMATION_ATLAS' }
SMODS.Blind {
    key = "the_guillotine",
    boss = { min = 1, max = 10 },
    boss_colour = HEX('FFD700'),
    debuff = { suit = crowns.key },
    atlas = 'Blind',
    pos = { x = 0, y = 0 },
    loc_txt = {
        ['en-us'] = {
            name = "The Guillotine",
            text = {
                'All Crown cards',
                'are debuffed',
            }
        }
    },
    in_pool = function(self, args)
        return allow_suits
    end
}

SMODS.Atlas { key = 'Sword', path = 'c_sword_tarot.png', px = 71, py = 95 }
SMODS.Consumable {
    set = 'Tarot',
    key = "sword_tarot",
    config = { suit_conv = crowns.key, max_highlighted = 3 },
    atlas = 'Sword',
    pos = { x = 0, y = 0 },
    loc_txt = {
        ['en-us'] = {
            name = "The Sword",
            text = {
                "Converts up to",
                "{C:attention}3{} selected cards",
                "to {C:crowns}Crowns{}"
            }
        }
    },
    loc_vars = function(self) return {vars = {self.config.max_highlighted}} end,
    use = function(self)
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                G.hand.highlighted[i]:flip()
                play_sound('card1', percent)
                G.hand.highlighted[i]:juice_up(0.3, 0.3)
            return true end }))
        end
        delay(0.2)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                G.hand.highlighted[i]:change_suit(self.config.suit_conv)
            return true end }))
        end
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + ( i - 0.999 ) / ( #G.hand.highlighted - 0.998 ) * 0.3
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                G.hand.highlighted[i]:flip()
                play_sound('tarot2', percent, 0.6)
                G.hand.highlighted[i]:juice_up(0.3, 0.3);
            return true end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            G.hand:unhighlight_all();
        return true end }))
        delay(0.5)
    end,
}

SMODS.Atlas { key = 'Jealous', path = 'j_jealous_joker.png', px = 71, py = 95 }
SMODS.Joker {
    key = 'jealous_joker',
    config = {
        extra = {
            mult = 4,
            suit = crowns.key
        }
    },
    atlas = 'Jealous',
    pos = { x = 0, y = 0 },
    loc_txt = {
        ['en-us'] = {
            name = "Jealous Joker",
            text = {
                "Played cards with",
                "{C:crowns}Crown{} suit give",
                "{C:mult}+4{} Mult when scored"
            }
        }
    },
    rarity = 1,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, localize(card.ability.extra.suit, 'suits_singular') }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit(crowns.key) then
            return {
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { card.ability.extra.mult }
                },
                mult = card.ability.extra.mult,
                card = card,
            }
        end
    end
}

----------------------------------------------
------------MOD CODE END---------------------
