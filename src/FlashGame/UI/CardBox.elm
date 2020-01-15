module FlashGame.UI.CardBox exposing (..)

import Element exposing (Element, alignRight, el, fill, htmlAttribute, link, paddingXY, rgb255, row, spacing, text, width)
import Element.Border as Border
import Element.Events exposing (onLoseFocus)
import Element.Input as Input exposing (button, labelHidden)
import Html.Attributes as Attr
import Json.Decode as Decode exposing (field, int, string)


type alias Card =
    { id : String
    , question : String
    , answer : String
    , pos : Int
    }


type EditMode
    = Question
    | Answer
    | Uploading


type alias EditDetails =
    { mode : EditMode, id : String, tempValue : String }


type Msg
    = Edit String EditMode String -- id mode value
    | End
    | Delete Card


cardDecoder : Decode.Decoder Card
cardDecoder =
    Decode.map4 Card
        (field "id" string)
        (field "question" string)
        (field "answer" string)
        (field "pos" int)


cardBox : (Msg -> msg) -> Maybe EditDetails -> Card -> Element msg
cardBox toMsg edit info =
    el [ Border.widthEach { bottom = 0, left = 0, right = 0, top = 1 }, Border.color (rgb255 0 0 0), Border.rounded 3, paddingXY 10 10, width fill ]
        (row [ width fill ]
            [ case edit of
                Just editDetails ->
                    -- TODO: if in "uploading" mode, then don't allow more edits. show status?
                    if info.id == editDetails.id then
                        case editDetails.mode of
                            Question ->
                                row []
                                    [ Input.text
                                        [ htmlAttribute (Attr.id "active_card_edit")
                                        , onLoseFocus (toMsg End)
                                        ]
                                        { onChange = \newQuestion -> toMsg (Edit info.id Question newQuestion)
                                        , text = editDetails.tempValue
                                        , placeholder = Nothing
                                        , label = labelHidden "Question"
                                        }
                                    , button []
                                        { onPress = Just (toMsg (Edit info.id Answer info.answer))
                                        , label = text info.answer
                                        }
                                    ]

                            Answer ->
                                row []
                                    [ button []
                                        { onPress = Just (toMsg (Edit info.id Question info.question))
                                        , label = text info.question
                                        }
                                    , Input.text
                                        [ htmlAttribute (Attr.id "active_card_edit")
                                        , onLoseFocus (toMsg End)
                                        ]
                                        { onChange = \newAnswer -> toMsg (Edit info.id Answer newAnswer)
                                        , text = editDetails.tempValue
                                        , placeholder = Nothing
                                        , label = labelHidden "Question"
                                        }
                                    ]

                            Uploading ->
                                text "uploading"

                    else
                        row []
                            [ button
                                []
                                { onPress = Just (toMsg (Edit info.id Question info.question))
                                , label = text info.question
                                }
                            , button
                                []
                                { onPress = Just (toMsg (Edit info.id Answer info.answer))
                                , label = text info.answer
                                }
                            ]

                Nothing ->
                    row []
                        [ button
                            []
                            { onPress = Just (toMsg (Edit info.id Question info.question))
                            , label = text info.question
                            }
                        , button
                            []
                            { onPress = Just (toMsg (Edit info.id Answer info.answer))
                            , label = text info.answer
                            }
                        ]
            , button
                [ alignRight ]
                { onPress = Just (toMsg (Delete info))
                , label = text "Delete"
                }
            ]
        )
