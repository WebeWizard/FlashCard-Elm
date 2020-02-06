module FlashGame.Game exposing (..)

import FlashGame.UI.CardEditRow exposing (Card, cardDecoder)
import FlashGame.UI.DeckEditRow exposing (DeckInfo, deckInfoDecoder)
import Http
import Json.Decode as Decode exposing (field)
import Session exposing (Session, getHeader)



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
    , cardId : Maybe String
    }


init : Session -> String -> ( Model, Cmd Msg )
init session deckId =
    -- initialize using deck Id and start fetching deck/cards
    ( { session = session, deckId = deckId, deck = Nothing, cardId = Nothing }, loadDeck session deckId )



-- UPDATE


type Msg
    = GotDeck (Result Http.Error Deck)



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
