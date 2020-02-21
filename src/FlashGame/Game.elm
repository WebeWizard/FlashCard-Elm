module FlashGame.Game exposing (..)

import Constants exposing (Constants)
import Element exposing (alignLeft, alignRight, column, fill, height, link, paddingXY, row, scrollbarY, spacing, text, width)
import FlashGame.UI.CardBox as CardBox exposing (cardBox)
import FlashGame.UI.CardEditRow exposing (Card, cardDecoder)
import FlashGame.UI.DeckEditRow exposing (DeckInfo, deckInfoDecoder)
import FlashGame.UI.ProgressBox as ProgressBox exposing (progressBox)
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
    { constants : Constants
    , session : Session
    , deckId : String
    , deck : Maybe Deck
    , curCard : Maybe Card
    , curMode : CardBox.Mode
    , scores : Maybe (List Score)
    }


init : Constants -> Session -> String -> ( Model, Cmd Msg )
init constants session deckId =
    -- initialize using deck Id and start fetching deck/cards
    ( { constants = constants
      , session = session
      , deckId = deckId
      , deck = Nothing
      , curCard = Nothing
      , curMode = CardBox.Question
      , scores = Nothing
      }
    , loadDeck constants session deckId
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
                      }
                    , loadScores model.constants model.session model.deckId
                    )

                Err error ->
                    -- TODO: handle errors
                    ( model, Cmd.none )

        GotScores result ->
            case result of
                Ok scores ->
                    case model.deck of
                        Just deck ->
                            ( { model
                                | scores = Just scores
                                , curCard = getNextCard deck model.curCard
                              }
                            , Cmd.none
                            )

                        Nothing ->
                            ( model, Cmd.none )

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
                            ( model, updateScore model.constants model.session curCard.id newScore )

                        Nothing ->
                            ( model, Cmd.none )


getNextCard : Deck -> Maybe Card -> Maybe Card
getNextCard deck card =
    case card of
        Just curCard ->
            -- since position index is 1 based (0 is reserved internally), pos of current card = index of next card
            case List.Extra.getAt curCard.pos deck.cards of
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
        column
            [ height fill
            , width fill
            , scrollbarY
            , spacing 20
            ]
            [ link
                [ alignLeft, paddingXY 80 0 ]
                { url = "/flash"
                , label = text "< Deck List"
                }
            , row
                [ height fill
                , width fill
                , scrollbarY
                , spacing 20
                , paddingXY 80 5
                ]
                [ progressBox model.deck model.scores
                , case model.curCard of
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
            ]
    }



-- HTTP


loadDeck : Constants -> Session -> String -> Cmd Msg
loadDeck constants session deckId =
    Http.request
        { method = "GET"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/deck/" ++ deckId -- urls should be constants stored somewhere else
        , body = Http.emptyBody
        , expect = Http.expectJson GotDeck deckDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


loadScores : Constants -> Session -> String -> Cmd Msg
loadScores constants session deckId =
    Http.request
        { method = "GET"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/deck/scores/" ++ deckId -- urls should be constants stored somewhere else
        , body = Http.emptyBody
        , expect = Http.expectJson GotScores (Decode.list scoreDecoder)
        , timeout = Nothing
        , tracker = Nothing
        }


updateScore : Constants -> Session -> String -> Int -> Cmd Msg
updateScore constants session cardId newScore =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/card/score" -- urls should be constants stored somewhere else
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
