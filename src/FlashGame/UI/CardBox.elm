module FlashGame.UI.CardBox exposing (..)

import Element exposing (Element, alignRight, el, fill, htmlAttribute, link, paddingXY, px, rgb255, row, spacing, text, width)
import Element.Border as Border
import Element.Events exposing (onLoseFocus)
import Element.Input as Input exposing (button, labelHidden)
import Html.Attributes as Attr
import Json.Decode as Decode exposing (field, int, string)
import Json.Encode as Encode


type alias Card =
    { id : String
    , deckId : String
    , question : String
    , answer : String
    , pos : Int
    }


type EditMode
    = Question
    | Answer
    | Uploading


type alias EditDetails =
    { mode : EditMode, value : Card }


type Msg
    = Edit EditMode Card -- id mode (temp card details)
    | End
    | Delete Card


cardDecoder : Decode.Decoder Card
cardDecoder =
    Decode.map5 Card
        (field "id" string)
        (field "deck_id" string)
        (field "question" string)
        (field "answer" string)
        (field "pos" int)


cardEncoder : Card -> Encode.Value
cardEncoder card =
    Encode.object
        [ ( "id", Encode.string card.id )
        , ( "deck_id", Encode.string card.deckId )
        , ( "question", Encode.string card.question )
        , ( "answer", Encode.string card.answer )
        , ( "pos", Encode.int card.pos )
        ]


cardBox : (Msg -> msg) -> Maybe EditDetails -> Card -> Element msg
cardBox toMsg edit info =
    el [ Border.widthEach { bottom = 0, left = 0, right = 0, top = 1 }, Border.color (rgb255 0 0 0), Border.rounded 3, paddingXY 10 10, width fill ]
        (row [ width fill ]
            [ case edit of
                Just editDetails ->
                    -- TODO: if in "uploading" mode, then don't allow more edits. show status?
                    if info.id == editDetails.value.id then
                        case editDetails.mode of
                            Question ->
                                row []
                                    [ Input.text
                                        [ htmlAttribute (Attr.id "active_card_edit")
                                        , onLoseFocus (toMsg End)
                                        , width (px 100)
                                        ]
                                        { onChange =
                                            \newQuestion ->
                                                let
                                                    oldValue =
                                                        editDetails.value
                                                in
                                                toMsg (Edit Question { oldValue | question = newQuestion })
                                        , text = editDetails.value.question
                                        , placeholder = Nothing
                                        , label = labelHidden "Question"
                                        }
                                    , button []
                                        { onPress = Just (toMsg (Edit Answer editDetails.value))
                                        , label = text info.answer
                                        }
                                    ]

                            Answer ->
                                row []
                                    [ button []
                                        { onPress = Just (toMsg (Edit Question editDetails.value))
                                        , label = text info.question
                                        }
                                    , Input.text
                                        [ htmlAttribute (Attr.id "active_card_edit")
                                        , onLoseFocus (toMsg End)
                                        , width (px 100)
                                        ]
                                        { onChange =
                                            \newAnswer ->
                                                let
                                                    oldValue =
                                                        editDetails.value
                                                in
                                                toMsg (Edit Answer { oldValue | answer = newAnswer })
                                        , text = editDetails.value.answer
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
                                { onPress = Just (toMsg (Edit Question editDetails.value))
                                , label = text info.question
                                }
                            , button
                                []
                                { onPress = Just (toMsg (Edit Answer editDetails.value))
                                , label = text info.answer
                                }
                            ]

                Nothing ->
                    row []
                        [ button
                            []
                            { onPress = Just (toMsg (Edit Question info))
                            , label = text info.question
                            }
                        , button
                            []
                            { onPress = Just (toMsg (Edit Answer info))
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
