--- STEAMODDED HEADER
--- MOD_NAME: Crowns Suit
--- MOD_ID: CrownsSuit
--- MOD_AUTHOR: [Kaishi, itayfeder]
--- MOD_DESCRIPTION: This mod adds a new suit, Crowns ! Huge thanks to itayfeder for letting me using his code. (go check Codex Arcanum it's awesome)

----------------------------------------------
------------MOD CODE -------------------------

local CROWN_SUIT_SYMBOL = nil
local CROWN_SUIT_INDEX = nil
local CROWN_SUIT_VALUE = nil

function SMODS.INIT.CrownsSuit()
    local mod_id = "CrownsSuit"
    local crowns_suit_mod = SMODS.findModByID(mod_id)
    SMODS.Sprite:new(mod_id .. "cards1", crowns_suit_mod.path, '8BitDeck.png', 71, 95, 'asset_atli'):register()
    SMODS.Sprite:new(mod_id .. "cards2", crowns_suit_mod.path, '8BitDeck_opt2.png', 71, 95, 'asset_atli'):register()
    SMODS.Sprite:new(mod_id .. "ui1", crowns_suit_mod.path, 'ui_assets.png', 18, 18, 'asset_atli'):register()
    SMODS.Sprite:new(mod_id .. "ui2", crowns_suit_mod.path, 'ui_assets_opt2.png', 18, 18, 'asset_atli'):register()
    SMODS.Card:new_suit('Crowns', mod_id .. "cards1", mod_id .. "cards2", { y = 0 }, mod_id .. "ui1", mod_id .. "ui2", { x = 0, y = 0 }, 'FFD700', 'FFD700')

    loc_colour("mult", nil)
    G.ARGS.LOC_COLOURS["crowns"] = G.C.SUITS.Crowns

    local index={}
    for k,v in pairs(SMODS.Card.SUIT_LIST) do
       index[v]=k
    end
    CROWN_SUIT_VALUE = "Crowns"
    CROWN_SUIT_INDEX = index["Crowns"]

    for k,v in pairs(G.P_CARDS) do
        if v.suit == "Crowns" then
            CROWN_SUIT_SYMBOL = string.sub(k, 1, 1)
        end
    end
    
    --- Guillotine Blind
    local guillotine_blind_def = {
        ["name"]="The Guillotine",
        ["text"]={
            [1]="All Crown cards",
            [2]="are debuffed"
        },
    }
    local guillotine_blind = SMODS.Blind:new("The Guillotine", "guillotine", guillotine_blind_def, 5, 2, {}, {suit = 'Crowns'}, {x=0, y=0}, {min = 1, max = 10}, HEX('FFD700'), true, mod_id .. "blinds")
    SMODS.Sprite:new(mod_id .. "blinds", crowns_suit_mod.path, 'BlindChips.png', 34, 34, 'animation_atli', 21):register()
    guillotine_blind:register()

    -- Sword Tarot
    local sword_tarot_def = {
        name = "The Sword",
        text = {
            "Converts up to",
            "{C:attention}3{} selected cards",
            "to {C:crowns}Crowns{}"
        }
    }

    local sword_tarot = SMODS.Tarot:new("The Sword", "sword_tarot", {suit_conv = 'Crowns', max_highlighted = 3}, { x = 0, y = 0 }, sword_tarot_def, 3, 1.0, "Suit Conversion", true, true)
    SMODS.Sprite:new("c_sword_tarot", crowns_suit_mod.path, "c_sword_tarot.png", 71, 95, "asset_atli"):register();
    sword_tarot:register()

-- Jealous Joker
    local jealous_joker_def = {
        name = "Jealous Joker",
        text = {
            "Played cards with",
            "{C:crowns}Crown{} suit give",
            "{C:mult}+4{} Mult when scored"
        }
    }

    local jealous_joker = SMODS.Joker:new("Jealous Joker", "jealous_joker", {
        effect = "Suit Mult", extra = {s_mult = 4, suit = 'Crowns'}, blueprint_compat = true, eternal_compat = true
    }, { x = 0, y = 0 }, jealous_joker_def, 1, 5)
    SMODS.Sprite:new("j_jealous_joker", crowns_suit_mod.path, "j_jealous_joker.png", 71, 95, "asset_atli"):register();
    jealous_joker:register()
end
----------------------------------------------
------------MOD CODE END---------------------
