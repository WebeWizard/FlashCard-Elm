module Pages.FlashHome exposing (Model, Msg, init, update, view)

import Element exposing (column, row, text, alignRight, width, fill, paddingXY)
import Http
import Json.Decode as Decode exposing (field, string)
import Session exposing (Session, getHeader)
import Skeleton exposing (Details)
import UI.DeckBox as DeckBox exposing (DeckInfo, deckBox)



-- MODEL


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
    | DeckBoxMsg DeckBox.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let asdf = Debug.log "msg" msg in
        case msg of
            GotDecks result ->
                case result of
                    Ok decks ->
                        let test = Debug.log "decks" decks in
                            ( {model | decks = Just decks}, Cmd.none)
                    Err error ->
                        let test = Debug.log "error" error in
                        
                            ( model, Cmd.none ) -- TODO: show errors somewhere
            _ ->
                ( model, Cmd.none )


view : Model -> Skeleton.Details Msg
view model =
    { title = "FlashHome"
    , attrs = []
    , body = column [paddingXY 80 8, width fill] (
        (row [alignRight] [text "+New Deck"])
        ::(case model.decks of
           Just deck_list ->
            List.map (deckBox DeckBoxMsg) deck_list
           Nothing -> []
        ))
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

