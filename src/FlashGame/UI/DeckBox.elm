-- Displays deck information, allows the user to rename or delete the deck
-- Clicking anywhere in the outer box should launch the game
-- Clicking the pencil at the top right should let you edit the deck (manage cards, rename, delete, etc)


module FlashGame.UI.DeckBox exposing (DeckInfo, Msg(..), deckBox)

import Element exposing (Element, el, rgb255, row, text)
import Element.Border as Border
import Element.Input as Input exposing (button, labelHidden)


type alias DeckInfo =
    { id : String
    , name : String
    }


type Msg
    = Edit String
    | Name String
    | Start String


deckBox : (Msg -> msg) -> String -> DeckInfo -> Element msg
deckBox toMsg editId info =
    el [ Border.width 1, Border.color (rgb255 0 0 0), Border.rounded 3 ]
        (row []
            [ text info.id
            , if editId == info.id then
                Input.text [] { onChange = \name -> toMsg (Name name), text = info.name, placeholder = Nothing, label = labelHidden "New Name" }

              else
                button
                    []
                    { onPress = Just (toMsg (Edit info.id))
                    , label = text info.name
                    }
            ]
        )
