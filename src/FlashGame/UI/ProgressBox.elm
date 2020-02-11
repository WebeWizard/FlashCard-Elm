module FlashGame.UI.ProgressBox exposing (..)

import Element exposing (Element, alignBottom, alignRight, centerX, centerY, column, el, fill, fillPortion, height, paddingXY, px, rgb255, row, scrollbarY, spaceEvenly, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FlashGame.UI.CardEditRow exposing (Card, cardDecoder)
import FlashGame.UI.DeckEditRow exposing (DeckInfo, deckInfoDecoder)
import FlashGame.Utility exposing (scoreColor)
import List.Extra



-- TODO: replace with a shared version


type alias Deck =
    { info : DeckInfo
    , cards : List Card
    }


type alias Score =
    { cardId : String
    , score : Int
    }


progressBox : Maybe Deck -> Maybe (List Score) -> Element msg
progressBox maybeDeck maybeScores =
    case maybeDeck of
        Just deck ->
            case maybeScores of
                Just scores ->
                    let
                        scoreCounts =
                            List.map (\v -> ( v, List.Extra.count (\s -> s.score == v) scores )) [ 1, 2, 3, 4, 5 ]

                        total =
                            List.length deck.cards
                    in
                    column
                        [ height fill
                        , width (px 300)
                        , Background.color (scoreColor 0)
                        , Font.color (rgb255 255 255 255)
                        , spacing 15
                        , paddingXY 10 10
                        , Border.shadow
                            { offset = ( 0, 0 )
                            , size = 0
                            , blur = 3
                            , color = rgb255 30 30 30
                            }
                        ]
                        (el [ centerX, Font.size 24 ]
                            (text
                                deck.info.name
                            )
                            :: List.map
                                (\s ->
                                    let
                                        score =
                                            Tuple.first s

                                        count =
                                            Tuple.second s
                                    in
                                    row [ centerX, width fill, spacing 10 ]
                                        [ text (String.fromInt score ++ ":")
                                        , row [ width fill ]
                                            [ el [ width (fillPortion count), Background.color (scoreColor score) ] (text "")
                                            , el [ width (fillPortion (total - count)), Background.color (rgb255 70 84 107) ] (text "")
                                            ]
                                        , text (String.fromInt count)
                                        ]
                                )
                                scoreCounts
                            ++ [ row [ width fill, spacing 10, centerX ]
                                    [ el [ Font.size 10 ] (text "New")
                                    , row [ width fill ]
                                        [ el [ width (fillPortion (total - List.length scores)), Background.color (rgb255 200 200 200) ] (text "")
                                        , el [ width (fillPortion (List.length scores)), Background.color (rgb255 70 84 107) ] (text "")
                                        ]
                                    , text (String.fromInt (total - List.length scores))
                                    ]
                               ]
                        )

                Nothing ->
                    text "Loading Scores..."

        Nothing ->
            text "Loading Deck..."
