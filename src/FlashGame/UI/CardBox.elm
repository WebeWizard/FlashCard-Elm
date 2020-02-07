module FlashGame.UI.CardBox exposing (..)

import Element exposing (Element, alignRight, column, fill, height, paddingXY, row, scrollbarY, spacing, text, width)
import Element.Input as Input exposing (button)

import FlashGame.UI.CardEditRow exposing (Card)

type Mode
    = Question
    | Answer

type Msg
    = ToggleMode Mode
    | Score Int

cardBox : (Msg -> msg) -> Card -> Mode -> Element msg
cardBox toMsg cardInfo mode =
    let
        nextMode = case mode of
            Question -> Answer
            Answer -> Question
    in
        column
            []
            [
                -- question/answer
                button [] {
                    onPress = Just (toMsg (ToggleMode nextMode))
                    , label = text (case mode of
                        Question -> cardInfo.question
                        Answer -> cardInfo.answer
                    )
                } 
                , row
                    []
                    [
                    case mode of
                        Question ->
                            button [] {
                                onPress = Just (toMsg (ToggleMode nextMode))
                                , label = text "Reveal"
                            }
                        Answer -> 
                            row [] [
                                button [] {
                                    onPress = Just (toMsg (Score 1))
                                    , label = text "1"
                                },
                                button [] {
                                    onPress = Just (toMsg (Score 2))
                                    , label = text "2"
                                },
                                button [] {
                                    onPress = Just (toMsg (Score 3))
                                    , label = text "3"
                                },
                                button [] {
                                    onPress = Just (toMsg (Score 4))
                                    , label = text "4"
                                },
                                button [] {
                                    onPress = Just (toMsg (Score 5))
                                    , label = text "5"
                                }
                            ]
                    ]
            ]

