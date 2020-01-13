module FlashGame.DeckEditor exposing (..)

import Element exposing (alignRight, column, fill, height, paddingXY, row, spacing, text, width)
import Element.Input exposing (button)
import FlashGame.UI.CardBox exposing (Card, cardDecoder)
import FlashGame.UI.DeckBox exposing (DeckInfo)
import Http
import Json.Decode as Decode exposing (field, string)
import Session exposing (Session, getHeader)
import Skeleton



-- MODEL


type alias Deck =
    { deckId : String
    , name : String
    , cards : List Card
    }


deckDecoder : Decode.Decoder Deck
deckDecoder =
    Decode.map3 Deck
        (field "id" string)
        (field "name" string)
        (field "cards" (Decode.list cardDecoder))


type alias Model =
    { session : Session
    , deckId : String
    , deck : Maybe Deck
    }


init : Session -> String -> ( Model, Cmd Msg )
init session deckId =
    -- initialize using deck Id and start fetching deck/cards
    ( { session = session, deckId = deckId, deck = Nothing }, loadDeck session deckId )



-- UPDATE


type Msg
    = GotDeck (Result Http.Error Deck)



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "Deck Editor"
    , attrs = []
    , body =
        text "I am the deck editor"
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
