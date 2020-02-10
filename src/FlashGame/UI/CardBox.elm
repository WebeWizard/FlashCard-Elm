module FlashGame.UI.CardBox exposing (..)

import Element exposing (Element, alignBottom, alignRight, centerX, centerY, column, el, fill, fillPortion, height, paddingXY, rgb255, row, scrollbarY, spaceEvenly, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button)
import FlashGame.UI.CardEditRow exposing (Card)
import FlashGame.Utility exposing (scoreColor)


type Mode
    = Question
    | Answer


type Msg
    = ToggleMode Mode
    | Score Int


cardBox : (Msg -> msg) -> Card -> Mode -> Int -> Element msg
cardBox toMsg cardInfo mode curScore =
    let
        nextMode =
            case mode of
                Question ->
                    Answer

                Answer ->
                    Question
    in
    column
        [ width fill
        , height fill
        , Background.color (rgb255 255 255 255)
        , spacing 10
        ]
        [ -- question/answer
          button
            [ width fill
            , height (fillPortion 8)
            , Border.color (scoreColor curScore)
            , Border.widthEach { bottom = 7, left = 0, right = 0, top = 0 }
            ]
            { onPress = Just (toMsg (ToggleMode nextMode))
            , label =
                el [ centerX, centerY ]
                    (text
                        (case mode of
                            Question ->
                                cardInfo.question

                            Answer ->
                                cardInfo.answer
                        )
                    )
            }
        , row
            [ width fill, alignBottom, height (fillPortion 2) ]
            [ case mode of
                Question ->
                    button [ height fill, width fill, Background.color (scoreColor curScore) ]
                        { onPress = Just (toMsg (ToggleMode nextMode))
                        , label = el [ centerY, centerX, Font.color (rgb255 255 255 255) ] (text "Reveal")
                        }

                Answer ->
                    row [ centerX, width fill, height fill, spaceEvenly ]
                        [ button [ width fill, height fill, Background.color (scoreColor 1) ]
                            { onPress = Just (toMsg (Score 1))
                            , label = el [ centerX, centerY, Font.color (rgb255 255 255 255) ] (text "1")
                            }
                        , button [ width fill, height fill, Background.color (scoreColor 2) ]
                            { onPress = Just (toMsg (Score 2))
                            , label = el [ centerX, centerY, Font.color (rgb255 255 255 255) ] (text "2")
                            }
                        , button [ width fill, height fill, Background.color (scoreColor 3) ]
                            { onPress = Just (toMsg (Score 3))
                            , label = el [ centerX, centerY, Font.color (rgb255 255 255 255) ] (text "3")
                            }
                        , button [ width fill, height fill, Background.color (scoreColor 4) ]
                            { onPress = Just (toMsg (Score 4))
                            , label = el [ centerX, centerY, Font.color (rgb255 255 255 255) ] (text "4")
                            }
                        , button [ width fill, height fill, Background.color (scoreColor 5) ]
                            { onPress = Just (toMsg (Score 5))
                            , label = el [ centerX, centerY, Font.color (rgb255 255 255 255) ] (text "5")
                            }
                        ]
            ]
        ]
