-- Displays deck information, allows the user to rename or delete the deck

-- Clicking anywhere in the outer box should launch the game
-- Clicking the pencil at the top right should let you edit the deck (manage cards, rename, delete, etc)

module UI.DeckBox exposing (DeckInfo, deckBox, Msg)

import Element exposing (Element, el, row, text, rgb255)
import Element.Border as Border

type alias DeckInfo =
    { id : String
    , name : String
    }

type Msg
    = Edit String
    | Start String

deckBox : (a -> msg) -> DeckInfo -> Element msg
deckBox toMsg info =
    el [Border.width 1, Border.color (rgb255 0 0 0), Border.rounded 3]
        (row [] [text info.id, text info.name])
