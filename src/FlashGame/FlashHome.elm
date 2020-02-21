module FlashGame.FlashHome exposing (Model, Msg, init, update, view)

import Browser.Dom as Dom exposing (Error, focus)
import Constants exposing (Constants)
import Element exposing (alignRight, column, fill, height, paddingXY, row, scrollbarY, spacing, text, width)
import Element.Input exposing (button)
import FlashGame.UI.DeckEditRow as DeckEditRow exposing (DeckInfo, EditDetails, EditMode(..), Msg(..), deckEditRow, deckInfoDecoder)
import Http
import Json.Decode as Decode exposing (decodeValue, field, list, string)
import Json.Encode as Encode
import List.Extra
import Session exposing (Session, getHeader)
import Skeleton
import Task



-- MODEL


type Mode
    = DeckList -- DeckListModel


type alias Model =
    { constants : Constants
    , session : Session
    , mode : Mode
    , decks : List DeckInfo
    , edit : Maybe EditDetails
    }


init : Constants -> Session -> ( Model, Cmd Msg )
init constants session =
    ( { constants = constants
      , session = session
      , mode = DeckList
      , decks = []
      , edit = Nothing
      }
    , loadDecks constants session
    )



-- UPDATE


type Msg
    = GotDecks (Result Http.Error (List DeckInfo))
    | GotRenameDeck (Result Http.Error ())
    | GotNewDeck (Result Http.Error DeckInfo)
    | GotDelete DeckInfo (Result Http.Error ())
    | DeckEditRowMsg DeckEditRow.Msg
    | Focus (Result Dom.Error ())



-- TODO: handle errors


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotDecks result ->
            case result of
                Ok decks ->
                    ( { model | decks = decks }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        -- TODO: handle error
        GotRenameDeck result ->
            case result of
                Ok () ->
                    ( { model
                        | decks =
                            List.map
                                (\info ->
                                    case model.edit of
                                        Just editDetails ->
                                            if info.id == editDetails.id then
                                                { info | name = editDetails.tempName }

                                            else
                                                info

                                        Nothing ->
                                            info
                                )
                                model.decks
                        , edit = Nothing -- TODO: only set to nothing if info *and mode* match current edit details
                      }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        GotNewDeck result ->
            case result of
                Ok deck ->
                    ( { model | edit = Nothing, decks = deck :: model.decks }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        -- TODO: handle error
        GotDelete info result ->
            case result of
                Ok () ->
                    ( { model | decks = List.Extra.remove info model.decks }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        -- TODO: handle error
        DeckEditRowMsg deckEditRowMsg ->
            case deckEditRowMsg of
                EditName id newName ->
                    ( { model | edit = Just { mode = Editing, id = id, tempName = newName } }, Task.attempt Focus (focus "active_deck_edit") )

                EndName ->
                    case model.edit of
                        Just editDetails ->
                            if editDetails.id == "" then
                                if editDetails.tempName == "" then
                                    -- just stop editing
                                    ( { model | edit = Nothing }, Cmd.none )

                                else
                                    -- start uploading new deck
                                    ( { model | edit = Just { editDetails | mode = Uploading } }, newDeck model.constants model.session editDetails )

                            else
                                case List.Extra.find (\orig -> orig.id == editDetails.id && orig.name == editDetails.tempName) model.decks of
                                    Just _ ->
                                        -- if it hasn't changed, just stop editing
                                        ( { model | edit = Nothing }, Cmd.none )

                                    Nothing ->
                                        -- Initiate a name change against the server
                                        ( { model | edit = Just { editDetails | mode = Uploading } }, renameDeck model.constants model.session editDetails )

                        Nothing ->
                            ( model, Cmd.none )

                Delete info ->
                    ( model, deleteDeck model.constants model.session info )

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
        column [ paddingXY 80 8, width fill, scrollbarY ]
            (button
                [ alignRight ]
                { onPress = Just (DeckEditRowMsg (EditName "" ""))
                , label = text "+New Deck"
                }
                :: (case model.edit of
                        Just editDetails ->
                            if editDetails.id == "" then
                                deckEditRow DeckEditRowMsg model.edit { id = "", name = "" }

                            else
                                text ""

                        Nothing ->
                            text ""
                   )
                :: List.map (deckEditRow DeckEditRowMsg model.edit) model.decks
            )
    }



-- HTTP


loadDecks : Constants -> Session -> Cmd Msg
loadDecks constants session =
    Http.request
        { method = "GET"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/decks" -- urls should be constants stored somewhere else
        , body = Http.emptyBody
        , expect = Http.expectJson GotDecks (Decode.list deckInfoDecoder)
        , timeout = Nothing
        , tracker = Nothing
        }


renameDeck : Constants -> Session -> EditDetails -> Cmd Msg
renameDeck constants session editDetails =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/deck/rename" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                Encode.object
                    [ ( "deck_id", Encode.string editDetails.id )
                    , ( "name", Encode.string editDetails.tempName )
                    ]
        , expect = Http.expectWhatever GotRenameDeck
        , timeout = Nothing
        , tracker = Nothing
        }


newDeck : Constants -> Session -> EditDetails -> Cmd Msg
newDeck constants session editDetails =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/deck/create" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                Encode.object
                    [ ( "name", Encode.string editDetails.tempName ) ]
        , expect = Http.expectJson GotNewDeck deckInfoDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


deleteDeck : Constants -> Session -> DeckInfo -> Cmd Msg
deleteDeck constants session info =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/deck/delete" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                Encode.object
                    [ ( "deck_id", Encode.string info.id ) ]
        , expect = Http.expectWhatever (GotDelete info)
        , timeout = Nothing
        , tracker = Nothing
        }
