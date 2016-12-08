module Games.FlashCard.Study exposing (..)

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Components.Card as Card

import Debug exposing (..)

-- Study Model
type alias Model =
  {
    currentCard: Int,
    complete: Bool,
    flashcardList: Array Card.Model -- list? array?
  }

-- Study Msg
type Msg
  = CardMsg Card.Msg
  | PreviousCard
  | NextCard

-- Study Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    CardMsg submsg ->
      case (Array.get model.currentCard model.flashcardList) of
        Just cardmodel ->
          { model | flashcardList = Array.set model.currentCard (Card.update submsg cardmodel) model.flashcardList }
        Nothing ->
          model
    PreviousCard ->
      { model | currentCard =
        if (model.currentCard == 0) then
          Array.length model.flashcardList - 1
        else
          model.currentCard - 1
      }
    NextCard ->
      { model | currentCard =
        if ( (model.currentCard + 1) == (Array.length model.flashcardList) ) then
          0
        else
          model.currentCard + 1
      }

-- Study View
study : Model -> Html Msg
study model =
  div [][
    button [ style [("display","inline-block"),("margin","2%")], onClick PreviousCard ] [ text "<" ],
    let
      currentCard = Array.get model.currentCard model.flashcardList
    in
      case currentCard of
        Just cardmodel ->
          Card.card cardmodel
        Nothing ->
          text ""
    , button [ style [("display","inline-block"),("margin","2%")], onClick NextCard ] [ text ">" ]
  ]
