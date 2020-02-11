module FlashGame.UI.CardBox exposing (..)

import Element exposing (Decoration, Element, alignBottom, alignRight, centerX, centerY, column, el, fill, fillPortion, height, paddingXY, rgb255, row, scrollbarY, spaceEvenly, spacing, text, width)
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
            , Border.shadow
                { offset = ( 0, 0 )
                , size = 0
                , blur = 3
                , color = rgb255 200 200 200
                }
            , Element.focused [ Border.glow (rgb255 0 0 0) 0 ]
            ]
            { onPress = Just (toMsg (ToggleMode nextMode))
            , label =
                el [ centerX, centerY, Font.size 36 ]
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
            [ width fill
            , alignBottom
            , height (fillPortion 2)
            , Border.shadow
                { offset = ( 0, 0 )
                , size = 0
                , blur = 3
                , color = rgb255 200 200 200
                }
            ]
            [ case mode of
                Question ->
                    button
                        [ height fill
                        , width fill
                        , Background.color (scoreColor curScore)
                        , Element.focused [ Border.glow (rgb255 0 0 0) 0 ]
                        ]
                        { onPress = Just (toMsg (ToggleMode nextMode))
                        , label = el [ centerY, centerX, Font.color (rgb255 255 255 255) ] (text "Reveal")
                        }

                Answer ->
                    row [ centerX, width fill, height fill, spaceEvenly ]
                        (List.map
                            (\score ->
                                button
                                    [ width fill
                                    , height fill
                                    , Background.color (scoreColor score)
                                    , Element.focused [ Border.glow (rgb255 0 0 0) 0 ]
                                    ]
                                    { onPress = Just (toMsg (Score score))
                                    , label = el [ centerX, centerY, Font.color (rgb255 255 255 255) ] (text (String.fromInt score))
                                    }
                            )
                            [ 1, 2, 3, 4, 5 ]
                        )
            ]
        ]
