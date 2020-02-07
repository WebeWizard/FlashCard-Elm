module FlashGame.Game exposing (..)

import Element exposing (alignRight, column, fill, height, paddingXY, row, scrollbarY, spacing, text, width)
import FlashGame.UI.CardBox as CardBox exposing (cardBox)
import FlashGame.UI.CardEditRow exposing (Card, cardDecoder)
import FlashGame.UI.DeckEditRow exposing (DeckInfo, deckInfoDecoder)
import Http
import Json.Decode as Decode exposing (field)
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


type alias Model =
    { session : Session
    , deckId : String
    , deck : Maybe Deck
    , curCard : Maybe Card
    , curMode : CardBox.Mode
    }


init : Session -> String -> ( Model, Cmd Msg )
init session deckId =
    -- initialize using deck Id and start fetching deck/cards
    ( { session = session, deckId = deckId, deck = Nothing, curCard = Nothing, curMode = CardBox.Question }, loadDeck session deckId )



-- UPDATE


type Msg
    = GotDeck (Result Http.Error Deck)
    | GotScore (Result Http.Error ())
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
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        CardBoxMsg cardBoxMsg ->
            case cardBoxMsg of
                CardBox.ToggleMode newMode ->
                    ( { model | curMode = newMode }, Cmd.none )

                CardBox.Score newScore ->
                    -- TODO: upload the score
                    ( model, Cmd.none )

        _ ->
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
                    cardBox CardBoxMsg card model.curMode

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
