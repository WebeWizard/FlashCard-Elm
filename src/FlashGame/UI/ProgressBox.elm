module FlashGame.UI.ProgressBox exposing (..)
import FlashGame.UI.DeckEditRow exposing (DeckInfo, deckInfoDecoder)
import FlashGame.UI.CardEditRow exposing (Card, cardDecoder)
import List.Extra
import Element exposing (Element, px, alignBottom, alignRight, centerX, centerY, column, el, fill, fillPortion, height, paddingXY, rgb255, row, scrollbarY, spaceEvenly, spacing, text, width)
import Element.Background as Background
import Element.Font as Font


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
                        ones = List.Extra.count (\s -> s.score == 1) scores
                        twos = List.Extra.count (\s -> s.score == 2) scores
                        threes = List.Extra.count (\s -> s.score == 3) scores
                        fours = List.Extra.count (\s -> s.score == 4) scores
                        fives = List.Extra.count (\s -> s.score == 5) scores
                        seen = ones + twos + threes + fours + fives
                        unseen = (List.length deck.cards) - seen
                    in
                        column
                            [ height fill
                            , width (px 300)
                            , Background.color (rgb255 0 0 0)
                            , Font.color (rgb255 255 255 255)
                            ]
                            [
                                (text deck.info.name)
                                ,el [] (text (String.fromInt ones))
                                ,el [] (text (String.fromInt twos))
                                ,el [] (text (String.fromInt threes))
                                ,el [] (text (String.fromInt fours))
                                ,el [] (text (String.fromInt fives))
                                ,el [] (text (String.fromInt unseen))
                            ]
                Nothing -> text "Loading Scores..."
        Nothing -> text "Loading Deck..."
    