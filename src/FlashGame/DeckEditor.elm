module FlashGame.DeckEditor exposing (..)

import Browser.Dom as Dom exposing (Error, focus)
import Constants exposing (Constants)
import Element exposing (alignLeft, alignRight, column, fill, height, link, paddingXY, row, scrollbarY, spacing, text, width)
import Element.Input exposing (button)
import FlashGame.UI.CardEditRow as CardEditRow exposing (Card, EditDetails, EditMode, Msg, cardDecoder, cardEditRow, cardEncoder)
import FlashGame.UI.DeckEditRow exposing (DeckInfo, deckInfoDecoder)
import Http
import Json.Decode as Decode exposing (decodeValue, field, list, string)
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
    Decode.map2 Deck
        (field "info" deckInfoDecoder)
        (field "cards" (Decode.list cardDecoder))


type alias Model =
    { constants : Constants
    , session : Session
    , deckId : String
    , deck : Maybe Deck
    , edit : Maybe EditDetails
    }


init : Constants -> Session -> String -> ( Model, Cmd Msg )
init constants session deckId =
    -- initialize using deck Id and start fetching deck/cards
    ( { constants = constants
      , session = session
      , deckId = deckId
      , deck = Nothing
      , edit = Nothing
      }
    , loadDeck constants session deckId
    )



-- UPDATE


type Msg
    = GotDeck (Result Http.Error Deck)
    | CardEditRowMsg CardEditRow.Msg
    | GotNewCard (Result Http.Error Card)
    | GotUpdateCard Card (Result Http.Error ())
    | GotUpdatePos Card (Result Http.Error ())
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

        GotUpdateCard info result ->
            case model.deck of
                Just deck ->
                    case result of
                        Ok () ->
                            ( { model
                                | deck = Just { deck | cards = List.Extra.updateIf (\card -> card.id == info.id) (\card -> info) deck.cards }
                                , edit = Nothing -- TODO: only set to nothing if info and mode match current edit details
                              }
                            , Cmd.none
                            )

                        Err error ->
                            ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        GotUpdatePos info result ->
            case model.deck of
                Just deck ->
                    case result of
                        Ok () ->
                            -- correct all of the card positions
                            ( { model
                                | deck =
                                    Just
                                        { deck
                                            | cards =
                                                case List.Extra.find (\orig -> orig.id == info.id) deck.cards of
                                                    Just origCard ->
                                                        if origCard.pos > info.pos then
                                                            -- position decreased
                                                            List.Extra.updateIf
                                                                (\card -> card.pos >= info.pos && card.pos <= origCard.pos)
                                                                (\card -> { card | pos = card.pos + 1 })
                                                                deck.cards
                                                                |> List.Extra.updateIf (\card -> card.id == info.id) (\card -> info)

                                                        else
                                                            List.Extra.updateIf
                                                                -- position increased
                                                                (\card -> card.pos <= info.pos && card.pos >= origCard.pos)
                                                                (\card -> { card | pos = card.pos - 1 })
                                                                deck.cards
                                                                |> List.Extra.updateIf (\card -> card.id == info.id) (\card -> info)

                                                    Nothing ->
                                                        deck.cards
                                        }
                                , edit = Nothing -- TODO: only set to nothing if info and mode match current edit details
                              }
                            , Cmd.none
                            )

                        Err error ->
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

        CardEditRowMsg cardEditRowMsg ->
            case model.deck of
                Just deck ->
                    case cardEditRowMsg of
                        CardEditRow.Edit mode value ->
                            -- TODO only focus if this is the first Edit detected (just clicked on button)
                            ( { model | edit = Just { mode = mode, value = value } }, Task.attempt Focus (focus "active_card_edit") )

                        CardEditRow.End ->
                            case model.edit of
                                Just editDetails ->
                                    if editDetails.value.id == "" then
                                        if editDetails.value.question == "" && editDetails.value.answer == "" then
                                            -- just stop editing
                                            ( { model | edit = Nothing }, Cmd.none )

                                        else
                                            -- start uploading new card
                                            ( { model | edit = Just { editDetails | mode = CardEditRow.Uploading } }, newCard model.constants model.session editDetails )

                                    else
                                        case List.Extra.find (\orig -> orig.id == editDetails.value.id) deck.cards of
                                            Just origCard ->
                                                if editDetails.value.pos /= origCard.pos then
                                                    ( { model | edit = Just { editDetails | mode = CardEditRow.Uploading } }, updatePos model.constants model.session editDetails origCard )

                                                else if editDetails.value /= origCard then
                                                    ( { model | edit = Just { editDetails | mode = CardEditRow.Uploading } }, updateCard model.constants model.session editDetails )

                                                else
                                                    -- just stop editing
                                                    ( { model | edit = Nothing }, Cmd.none )

                                            Nothing ->
                                                -- just stop editing
                                                ( { model | edit = Nothing }, Cmd.none )

                                Nothing ->
                                    ( model, Cmd.none )

                        CardEditRow.Delete info ->
                            ( model, deleteCard model.constants model.session info )

                Nothing ->
                    ( model, Cmd.none )

        -- TODO: show errors somewhere
        _ ->
            ( model, Cmd.none )



-- VIEW


getNextPos : List Card -> Int
getNextPos cardList =
    case List.Extra.maximumBy (\card -> card.pos) cardList of
        Just lastCard ->
            lastCard.pos + 1

        Nothing ->
            1


view : Model -> Skeleton.Details Msg
view model =
    { title = "Deck Editor"
    , attrs = []
    , body =
        column [ paddingXY 80 8, width fill, scrollbarY ]
            ([ link
                [ alignLeft ]
                { url = "/flash"
                , label = text "< Deck List"
                }
             , button
                [ alignRight ]
                { onPress =
                    Just
                        (CardEditRowMsg
                            (CardEditRow.Edit CardEditRow.Question
                                { id = ""
                                , deckId = model.deckId
                                , question = ""
                                , answer = ""
                                , pos =
                                    case model.deck of
                                        Just deck ->
                                            getNextPos deck.cards

                                        Nothing ->
                                            1
                                }
                            )
                        )
                , label = text "+New Card"
                }
             , case model.edit of
                Just editDetails ->
                    if editDetails.value.id == "" then
                        cardEditRow CardEditRowMsg model.edit editDetails.value

                    else
                        text ""

                Nothing ->
                    text ""
             ]
                ++ (case model.deck of
                        Just deck ->
                            List.map (cardEditRow CardEditRowMsg model.edit) deck.cards

                        Nothing ->
                            []
                   )
            )
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


newCard : Constants -> Session -> EditDetails -> Cmd Msg
newCard constants session editDetails =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/card/create" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                cardEncoder editDetails.value
        , expect = Http.expectJson GotNewCard cardDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


updateCard : Constants -> Session -> EditDetails -> Cmd Msg
updateCard constants session editDetails =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/card/update" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                cardEncoder editDetails.value
        , expect = Http.expectWhatever (GotUpdateCard editDetails.value)
        , timeout = Nothing
        , tracker = Nothing
        }


updatePos : Constants -> Session -> EditDetails -> Card -> Cmd Msg
updatePos constants session editDetails origCard =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/card/updatepos" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                Encode.object
                    [ ( "id", Encode.string origCard.id )
                    , ( "deck_id", Encode.string origCard.deckId )
                    , ( "orig_pos", Encode.int origCard.pos )
                    , ( "new_pos", Encode.int editDetails.value.pos )
                    ]
        , expect = Http.expectWhatever (GotUpdatePos editDetails.value)
        , timeout = Nothing
        , tracker = Nothing
        }


deleteCard : Constants -> Session -> Card -> Cmd Msg
deleteCard constants session info =
    Http.request
        { method = "POST"
        , headers = [ getHeader session ]
        , url = constants.publicUrl ++ "/card/delete" -- urls should be constants stored somewhere else
        , body =
            Http.jsonBody <|
                Encode.object
                    [ ( "card_id", Encode.string info.id ) ]
        , expect = Http.expectWhatever (GotDelete info)
        , timeout = Nothing
        , tracker = Nothing
        }
