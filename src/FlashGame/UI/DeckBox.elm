-- Displays deck information, allows the user to rename or delete the deck
-- Clicking anywhere in the outer box should launch the game
-- Clicking the pencil at the top right should let you edit the deck (manage cards, rename, delete, etc)


module FlashGame.UI.DeckBox exposing (DeckInfo, EditDetails, EditMode(..), Msg(..), deckBox)

import Element exposing (Element, alignRight, el, fill, htmlAttribute, link, paddingXY, rgb255, row, spacing, text, width)
import Element.Border as Border
import Element.Events exposing (onLoseFocus)
import Element.Input as Input exposing (button, labelHidden)
import Html.Attributes as Attr
import Json.Decode as Decode exposing (field, string)


type alias DeckInfo =
    { id : String
    , name : String
    }


deckInfoDecoder : Decode.Decoder DeckInfo
deckInfoDecoder =
    Decode.map2 DeckInfo
        (field "id" string)
        (field "name" string)

type EditMode
    = Editing
    | Uploading


type alias EditDetails =
    { mode : EditMode, id : String, tempName : String }


type Msg
    = EditName String String -- Edit id curName
    | EndName -- Ends renaming
    | Start String
    | Delete DeckInfo


deckBox : (Msg -> msg) -> Maybe EditDetails -> DeckInfo -> Element msg
deckBox toMsg edit info =
    el [ Border.widthEach { bottom = 0, left = 0, right = 0, top = 1 }, Border.color (rgb255 0 0 0), Border.rounded 3, paddingXY 10 10, width fill ]
        (row [ width fill ]
            [ case edit of
                Just editDetails ->
                    -- TODO: if in "uploading" mode, then don't allow more edits. show status?
                    if info.id == editDetails.id then
                        Input.text
                            [ htmlAttribute (Attr.id "active_deck_edit")
                            , onLoseFocus (toMsg EndName)
                            ]
                            { onChange = \name -> toMsg (EditName info.id name)
                            , text = editDetails.tempName
                            , placeholder = Nothing
                            , label = labelHidden "New Name"
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
            , link
                [ alignRight ]
                { url = "/flash/deck/edit/" ++ info.id
                , label = text "Edit"
                }
            , button
                [ alignRight ]
                { onPress = Just (toMsg (Delete info))
                , label = text "Delete"
                }
            ]
        )
