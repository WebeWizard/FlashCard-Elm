module FlashGame.DeckEditor exposing (..)

import Browser.Dom as Dom exposing (Error, focus)
import Element exposing (alignRight, column, fill, height, paddingXY, row, spacing, text, width)
import Element.Input exposing (button)
import FlashGame.UI.CardBox as CardBox exposing (Card, cardDecoder, EditDetails)
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
    , edit: Maybe EditDetails
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
    | Error String
    | Focus (Result Dom.Error ())


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
                    { onPress = Just (CardBoxMsg (EditQuestion "" ""))
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
                :: List.map (cardBox CardBoxMsg model.edit) model.decks
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
