module FlashGame.FlashHome exposing (Model, Msg, init, update, view)

import Element exposing (alignRight, column, fill, paddingXY, row, text, width)
import FlashGame.UI.DeckBox as DeckBox exposing (DeckInfo, Msg(..), deckBox)
import Http
import Json.Decode as Decode exposing (field, string)
import Session exposing (Session, getHeader)
import Skeleton



-- MODEL


deckInfodecoder : Decode.Decoder DeckInfo
deckInfodecoder =
    Decode.map2 DeckInfo
        (field "id" string)
        (field "name" string)


type Mode
    = DeckList -- DeckListModel


type alias Model =
    { session : Session
    , mode : Mode
    , decks : List DeckInfo
    , editId : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, mode = DeckList, decks = [], editId = "" }, loadDecks session )



-- UPDATE


type Msg
    = GotDecks (Result Http.Error (List DeckInfo))
    | DeckBoxMsg DeckBox.Msg
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotDecks result ->
            case result of
                Ok decks ->
                    ( { model | decks = decks }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        DeckBoxMsg deckBoxMsg ->
            case deckBoxMsg of
                Edit id ->
                    ( { model | editId = id }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        -- TODO: show errors somewhere
        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "FlashHome"
    , attrs = []
    , body =
        column [ paddingXY 80 8, width fill ]
            (row [ alignRight ] [ text "+New Deck" ]
                :: List.map (deckBox DeckBoxMsg model.editId) model.decks
            )
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
