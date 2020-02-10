module FlashGame.Game exposing (..)

import Element exposing (alignRight, column, fill, height, paddingXY, row, scrollbarY, spacing, text, width)
import FlashGame.UI.CardBox as CardBox exposing (cardBox)
import FlashGame.UI.CardEditRow exposing (Card, cardDecoder)
import FlashGame.UI.DeckEditRow exposing (DeckInfo, deckInfoDecoder)
import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import List.Extra
import Session exposing (Session, getHeader)
import Skeleton



-- MODEL


type alias Deck =
    { info : DeckInfo
    , cards : List Card
    }


deckDecoder : Decode.Decoder Deck
deckDecoder =
    Decode.map2 Deck
        (field "info" deckInfoDecoder)
        (field "cards" (Decode.list cardDecoder))



-- currently only getting scores that belong to logged in account


type alias Score =
    { cardId : String
    , score : Int
    }


scoreDecoder : Decode.Decoder Score
scoreDecoder =
    Decode.map2 Score
        (field "card_id" Decode.string)
        (field "score" Decode.int)


type alias Model =
    { session : Session
    , deckId : String
    , deck : Maybe Deck
    , curCard : Maybe Card
    , curMode : CardBox.Mode
    , scores : Maybe (List Score)
    }


init : Session -> String -> ( Model, Cmd Msg )
init session deckId =
    -- initialize using deck Id and start fetching deck/cards
    ( { session = session
      , deckId = deckId
      , deck = Nothing
      , curCard = Nothing
      , curMode = CardBox.Question
      , scores = Nothing
      }
    , loadDeck session deckId
    )



-- UPDATE


type Msg
    = GotDeck (Result Http.Error Deck)
    | GotScores (Result Http.Error (List Score))
    | GotUpdateScore String Int (Result Http.Error ())
    | CardBoxMsg CardBox.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotDeck result ->
            case result of
                Ok deck ->
                    ( { model
                        | deck = Just deck
                        , curCard = getNextCard deck model.curCard
                      }
                    , loadScores model.session model.deckId
                    )

                Err error ->
                    -- TODO: handle errors
                    ( model, Cmd.none )

        GotScores result ->
            case result of
                Ok scores ->
                    ( { model | scores = Just scores }, Cmd.none )

                Err error ->
                    -- TODO: handle errors
                    ( model, Cmd.none )

        GotUpdateScore cardId newScore result ->
            case result of
                Ok () ->
                    case model.scores of
                        Just scores ->
                            case model.deck of
                                Just deck ->
                                    -- if score exists, update it, otherwise insert a new one
                                    case List.Extra.find (\s -> s.cardId == cardId) scores of
                                        Just cardScore ->
                                            ( { model
                                                | scores = Just (List.Extra.updateIf (\s -> s.cardId == cardId) (\s -> { s | score = newScore }) scores)
                                                , curCard = getNextCard deck model.curCard
                                                , curMode = CardBox.Question
                                              }
                                            , Cmd.none
                                            )

                                        Nothing ->
                                            ( { model
                                                | scores = Just ({ cardId = cardId, score = newScore } :: scores)
                                                , curCard = getNextCard deck model.curCard
                                                , curMode = CardBox.Question
                                              }
                                            , Cmd.none
                                            )

                                Nothing ->
                                    ( model, Cmd.none )

                        Nothing ->
                            ( { model | scores = Just [ { cardId = cardId, score = newScore } ] }, Cmd.none )

                Err error ->
                    -- TODO: handle errors
                    ( model, Cmd.none )

        CardBoxMsg cardBoxMsg ->
            case cardBoxMsg of
                CardBox.ToggleMode newMode ->
                    ( { model | curMode = newMode }, Cmd.none )

                CardBox.Score newScore ->
                    case model.curCard of
                        Just curCard ->
                            ( model, updateScore model.session curCard.id newScore )

                        Nothing ->
                            ( model, Cmd.none )


getNextCard : Deck -> Maybe Card -> Maybe Card
getNextCard deck card =
    case card of
        Just curCard ->
            case List.Extra.getAt (curCard.pos + 1) deck.cards of
                Just nextCard ->
                    Just nextCard

                Nothing ->
                    List.Extra.getAt 0 deck.cards

        Nothing ->
            List.Extra.getAt 0 deck.cards



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "Deck Editor"
    , attrs = []
    , body =
        row
            [ height fill
            , paddingXY 80 8
            , width fill
            , scrollbarY
            ]
            [ case model.curCard of
                Just card ->
                    case model.scores of
                        Just scores ->
                            case List.Extra.find (\s -> s.cardId == card.id) scores of
                                Just curScore ->
                                    cardBox CardBoxMsg card model.curMode curScore.score

                                Nothing ->
                                    cardBox CardBoxMsg card model.curMode 0

                        Nothing ->
                            cardBox CardBoxMsg card model.curMode 0

                Nothing ->
                    text "No card available"
            ]
    }



-- HTTP


loadDeck : Session -> String -> Cmd Msg
loadDeck session deckId =
    Http.request
        { method = "GET"
        , headers = [ getHeader session ]
        , url = "http://localhost:8080/deck/" ++ deckId -- urls should be constants stored somewhere else
        , body = Http.emptyBody
        , expect = Http.expectJson GotDeck deckDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


loadScores : Session -> String -> Cmd Msg
loadScores session deckId =
    Http.request
        { method = "GET"
        , headers = [ getHeader session ]
        , url = "http://localhost:8080/deck/scores/" ++ deckId -- urls should be constants stored somewhere else
        , body = Http.emptyBody
        , expect = Http.expectJson GotScores (Decode.list scoreDecoder)
        , timeout = Nothing
        , tracker = Nothing
        }


updateScore : Session -> String -> Int -> Cmd Msg
updateScore session cardId newScore =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = "http://localhost:8080/card/score" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                Encode.object
                    [ ( "card_id", Encode.string cardId )
                    , ( "score", Encode.int newScore )
                    ]
        , expect = Http.expectWhatever (GotUpdateScore cardId newScore)
        , timeout = Nothing
        , tracker = Nothing
        }
