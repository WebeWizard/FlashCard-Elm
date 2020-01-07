module FlashGame.FlashHome exposing (Model, Msg, init, update, view)

import Json.Encode as Encode
import Element exposing (alignRight, column, fill, paddingXY, row, text, width)
import Element.Input exposing (button)
import FlashGame.UI.DeckBox as DeckBox exposing (DeckInfo, EditDetails, EditMode(..), Msg(..), deckBox)
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
    , edit : Maybe EditDetails
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, mode = DeckList, decks = [], edit = Nothing }
    , loadDecks session )



-- UPDATE


type Msg
    = GotDecks (Result Http.Error (List DeckInfo))
    | GotRenameDeck (Result Http.Error ())
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
                    ( model, Cmd.none ) -- TODO: handle error

        GotRenameDeck result ->
            case result of
                Ok () ->
                    ( { model |
                        decks = List.map (
                            \info ->
                                    case model.edit of
                                        Just editDetails ->
                                            if info.id == editDetails.id then
                                                {info | name = editDetails.tempName}
                                            else
                                                info
                                        Nothing ->
                                            info
                        ) model.decks
                        , edit = Nothing
                    }, Cmd.none )

                Err error ->
                    ( model, Cmd.none ) -- TODO: handle error

        DeckBoxMsg deckBoxMsg ->
            case deckBoxMsg of
                EditName id newName ->
                    ( {model | edit = Just { mode = Editing, id = id, tempName = newName}}, Cmd.none)


                EndEdit ->
                    -- Initiate a name change against the server
                    case model.edit of
                        Just editDetails ->
                            -- TODO: only do http request if new name doesn't match original
                            ( {model | edit = Just {editDetails | mode = Uploading}}, renameDeck model.session editDetails)
                        Nothing ->
                            (model, Cmd.none)

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
            (row [ alignRight ] [ button
                        []
                        { onPress = Just (DeckBoxMsg (EditName "new" ""))
                        , label = text "+New Deck"
                        } ]
                :: List.map (deckBox DeckBoxMsg model.edit) model.decks
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

renameDeck : Session -> EditDetails -> Cmd Msg
renameDeck session editDetails =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = "http://localhost:8080/deck/rename" -- urls should be constants stored somewhere else
        , body = Http.jsonBody <|
            Encode.object
                [("deck_id", Encode.string editDetails.id)
                ,("name", Encode.string editDetails.tempName)]
        , expect = Http.expectWhatever GotRenameDeck
        , timeout = Nothing
        , tracker = Nothing
        }