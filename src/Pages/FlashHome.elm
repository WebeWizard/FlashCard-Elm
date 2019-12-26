module Pages.FlashHome exposing (Model, Msg, init, update, view)

import Element exposing (text)
import Http
import Json.Decode as Decode exposing (field, string)
import Session exposing (Session, getHeader)
import Skeleton exposing (Details)



-- MODEL


type alias DeckInfo =
    { id : String
    , name : String
    }


deckInfodecoder : Decode.Decoder DeckInfo
deckInfodecoder =
    Decode.map2 DeckInfo
        (field "id" string)
        (field "name" string)


type alias Model =
    { session : Session
    , decks : Maybe (List DeckInfo)
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, decks = Nothing }, loadDecks session )



-- UPDATE


type Msg
    = GotDecks (Result Http.Error (List DeckInfo))
      -- | StartGame DeckInfo
    | Error String
    | CreateDeck
    | DeleteDeck


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Skeleton.Details Msg
view model =
    { title = "FlashHome"
    , attrs = []
    , body = text "this is the flash home / deck manager"
    }



-- HTTP


loadDecks : Session -> Cmd Msg
loadDecks session =
    Http.request
        { method = "GET"
        , headers = [ getHeader session ]
        , url = "http://localhost:8080/decks" -- urls should be constants stored somewhere else
        , body = Http.emptyBody
        , expect = Http.expectJson GotDecks (Decode.list deckInfodecoder)
        , timeout = Nothing
        , tracker = Nothing
        }
