module FlashGame.UI.CardEditRow exposing (..)

import Element exposing (Element, alignRight, el, fill, htmlAttribute, link, paddingXY, px, rgb, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onLoseFocus)
import Element.Input as Input exposing (button, labelHidden, placeholder)
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
    | Pos
    | Uploading


type alias EditDetails =
    { mode : EditMode, value : Card }


type Msg
    = Edit EditMode Card
    | End
    | Delete Card


cardDecoder : Decode.Decoder Card
cardDecoder =
    Decode.map5 Card
        (field "id" string)
        (field "deck_id" string)
        (field "question" string)
        (field "answer" string)
        (field "deck_pos" int)


cardEncoder : Card -> Encode.Value
cardEncoder card =
    Encode.object
        [ ( "id", Encode.string card.id )
        , ( "deck_id", Encode.string card.deckId )
        , ( "question", Encode.string card.question )
        , ( "answer", Encode.string card.answer )
        , ( "deck_pos", Encode.int card.pos )
        ]


cardBox : (Msg -> msg) -> Maybe EditDetails -> Card -> Element msg
cardBox toMsg edit cardInfo =
    let
        displayInfo =
            case edit of
                Just editDetails ->
                    if editDetails.value.id == cardInfo.id then
                        editDetails.value

                    else
                        cardInfo

                Nothing ->
                    cardInfo
    in
    let
        cardButton =
            cardButtonBuilder toMsg displayInfo

        cardInput =
            cardInputBuilder toMsg displayInfo
    in
    el [ Border.widthEach { bottom = 0, left = 0, right = 0, top = 1 }, Border.color (rgb255 0 0 0), Border.rounded 3, paddingXY 10 10, width fill ]
        (row [ width fill ]
            [ case edit of
                Just editDetails ->
                    -- TODO: if in "uploading" mode, then don't allow more edits. show status?
                    if cardInfo.id == editDetails.value.id then
                        case editDetails.mode of
                            Pos ->
                                row []
                                    [ cardInput Pos
                                    , cardButton Question
                                    , cardButton Answer
                                    ]

                            Question ->
                                row []
                                    [ cardButton Pos
                                    , cardInput Question
                                    , cardButton Answer
                                    ]

                            Answer ->
                                row []
                                    [ cardButton Pos
                                    , cardButton Question
                                    , cardInput Answer
                                    ]

                            Uploading ->
                                text "uploading"

                    else
                        row []
                            [ cardButton Pos
                            , cardButton Question
                            , cardButton Answer
                            ]

                Nothing ->
                    row [ spacing 10 ]
                        [ cardButton Pos
                        , cardButton Question
                        , cardButton Answer
                        ]
            , button
                [ alignRight ]
                { onPress = Just (toMsg (Delete cardInfo))
                , label = text "Delete"
                }
            ]
        )


cardButtonBuilder : (Msg -> msg) -> Card -> EditMode -> Element msg
cardButtonBuilder toMsg cardInfo mode =
    button
        [ width (px 100), Background.color (rgb 226 226 226) ]
        { onPress = Just (toMsg (Edit mode cardInfo))
        , label =
            text
                (case mode of
                    Pos ->
                        String.fromInt cardInfo.pos

                    Question ->
                        cardInfo.question

                    Answer ->
                        cardInfo.answer

                    Uploading ->
                        "uploading..."
                )
        }


cardInputBuilder : (Msg -> msg) -> Card -> EditMode -> Element msg
cardInputBuilder toMsg displayInfo mode =
    Input.text
        [ htmlAttribute (Attr.id "active_card_edit")
        , onLoseFocus (toMsg End)
        , width (px 100)
        ]
        { onChange =
            \input ->
                case mode of
                    Pos ->
                        case String.toInt input of
                            Just newPos ->
                                toMsg (Edit Pos { displayInfo | pos = newPos })

                            Nothing ->
                                toMsg (Edit Pos displayInfo)

                    Question ->
                        toMsg (Edit Question { displayInfo | question = input })

                    Answer ->
                        toMsg (Edit Answer { displayInfo | answer = input })

                    _ ->
                        toMsg (Edit Uploading displayInfo)
        , text =
            case mode of
                Pos ->
                    String.fromInt displayInfo.pos

                Question ->
                    displayInfo.question

                Answer ->
                    displayInfo.answer

                Uploading ->
                    "uploading.."
        , placeholder =
            let
                placeholderText =
                    case mode of
                        Pos ->
                            "Position"

                        Question ->
                            "Question"

                        Answer ->
                            "Answer"

                        Uploading ->
                            "uploading.."
            in
            Just (placeholder [] (text placeholderText))
        , label =
            labelHidden
                (case mode of
                    Pos ->
                        "Position"

                    Question ->
                        "Question"

                    Answer ->
                        "Answer"

                    Uploading ->
                        "uploading.."
                )
        }
