module FlashGame.DeckEditor exposing (..)

import Browser.Dom as Dom exposing (Error, focus)
import FlashGame.UI.DeckBox exposing (DeckInfo, deckInfoDecoder)
import Element exposing (alignRight, column, fill, height, paddingXY, row, spacing, text, width)
import Element.Input exposing (button)
import FlashGame.UI.CardBox as CardBox exposing (Card, EditDetails, EditMode, Msg, cardBox, cardDecoder)
import Http
import Json.Decode as Decode exposing (field, string)
import Json.Encode as Encode
import List.Extra
import Session exposing (Session, getHeader)
import Skeleton
import Task



-- MODEL


type alias Deck =
    { info : DeckInfo
    , cards : List Card
    }


deckDecoder : Decode.Decoder Deck
deckDecoder =
    Decode.map3 Deck
        (field "info" (Decode.decodeValue deckInfoDecoder)
        (field "cards" (Decode.list cardDecoder))


type alias Model =
    { session : Session
    , deckId : String
    , deck : Maybe Deck
    , edit : Maybe EditDetails
    }


init : Session -> String -> ( Model, Cmd Msg )
init session deckId =
    -- initialize using deck Id and start fetching deck/cards
    ( { session = session, deckId = deckId, deck = Nothing, edit = Nothing }, loadDeck session deckId )



-- UPDATE


type Msg
    = GotDeck (Result Http.Error Deck)
    | CardBoxMsg CardBox.Msg
    | GotNewCard (Result Http.Error Card)
    | GotDelete Card (Result Http.Error ())
    | Focus (Result Dom.Error ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotDeck result ->
            case result of
                Ok deck ->
                    ( { model | deck = Just deck }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        GotNewCard result ->
            case model.deck of
                Just deck ->
                    case result of
                        Ok card ->
                            ( { model | edit = Nothing, deck = Just { deck | cards = card :: deck.cards } }, Cmd.none )

                        Err error ->
                            -- TODO: handle error
                            ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        GotDelete info result ->
            case model.deck of
                Just deck ->
                    case result of
                        Ok () ->
                            ( { model | deck = Just { deck | cards = List.Extra.remove info deck.cards } }, Cmd.none )

                        Err error ->
                            ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        CardBoxMsg cardBoxMsg ->
            case model.deck of
                Just deck ->
                    case cardBoxMsg of
                        CardBox.Edit id mode value ->
                            ( { model | edit = Just { id = id, mode = mode, tempValue = value } }, Task.attempt Focus (focus "active_card_edit") )

                        CardBox.End ->
                            case model.edit of
                                Just editDetails ->
                                    if editDetails.id == "" then
                                        -- just stop editing
                                        ( { model | edit = Nothing }, Cmd.none )

                                    else
                                        -- start uploading new card
                                        ( { model | edit = Just { editDetails | mode = CardBox.Uploading } }, newCard model.session editDetails )

                                Nothing ->
                                    ( model, Cmd.none )

                        CardBox.Delete info ->
                            ( model, deleteCard model.session info )

                Nothing ->
                    ( model, Cmd.none )

        -- TODO: show errors somewhere
        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "Deck Editor"
    , attrs = []
    , body =
        column [ paddingXY 80 8, width fill ]
            (row [ alignRight ]
                [ button
                    []
                    { onPress = Just (CardBoxMsg (CardBox.Edit "" CardBox.Question ""))
                    , label = text "+New Card"
                    }
                ]
                :: (case model.edit of
                        Just editDetails ->
                            if editDetails.id == "" then
                                cardBox CardBoxMsg model.edit { id = "", question = "", answer = "", pos = -1 }

                            else
                                text ""

                        Nothing ->
                            text ""
                   )
                :: (case model.deck of
                        Just deck ->
                            List.map (cardBox CardBoxMsg model.edit) deck.cards

                        Nothing ->
                            []
                   )
            )
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


newCard : Session -> EditDetails -> Cmd Msg
newCard session editDetails =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = "http://localhost:8080/deck/create" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                Encode.object
                    [ ( "name", Encode.string editDetails.tempValue ) ]
        , expect = Http.expectJson GotNewCard cardDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


deleteCard : Session -> Card -> Cmd Msg
deleteCard session info =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = "http://localhost:8080/deck/delete" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                Encode.object
                    [ ( "deck_id", Encode.string info.id ) ]
        , expect = Http.expectWhatever (GotDelete info)
        , timeout = Nothing
        , tracker = Nothing
        }
