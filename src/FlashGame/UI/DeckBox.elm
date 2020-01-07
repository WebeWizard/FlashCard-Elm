-- Displays deck information, allows the user to rename or delete the deck
-- Clicking anywhere in the outer box should launch the game
-- Clicking the pencil at the top right should let you edit the deck (manage cards, rename, delete, etc)


module FlashGame.UI.DeckBox exposing (DeckInfo, EditDetails, EditMode(..), Msg(..), deckBox)

import Element exposing (Element, el, rgb255, row, text)
import Element.Events exposing (onLoseFocus)
import Element.Border as Border
import Element.Input as Input exposing (button, labelHidden)


type alias DeckInfo =
    { id : String
    , name : String
    }

type EditMode
    = Editing
    | Uploading

type alias EditDetails =
    {mode: EditMode, id: String, tempName: String}


type Msg
    = EditName String String -- Edit id curName
    | EndEdit
    | Start String


deckBox : (Msg -> msg) -> Maybe EditDetails -> DeckInfo -> Element msg
deckBox toMsg edit info =
    el [ Border.width 1, Border.color (rgb255 0 0 0), Border.rounded 3 ]
        (row []
            [ text info.id
            , case edit of
                Just editDetails ->
                    -- TODO: if in "uploading" mode, then don't allow more edits. show status?
                    if info.id == editDetails.id then
                        Input.text
                        [ onLoseFocus (toMsg EndEdit)]
                        { onChange = \name -> toMsg (EditName info.id name),
                          text = editDetails.tempName,
                          placeholder = Nothing,
                          label = labelHidden "New Name"
                        }
                    else
                         button
                            []
                            { onPress = Just (toMsg (EditName info.id info.name))
                            , label = text info.name
                            }
                Nothing ->
                    button
                        []
                        { onPress = Just (toMsg (EditName info.id info.name))
                        , label = text info.name
                        }
            
                
            ]
        )
