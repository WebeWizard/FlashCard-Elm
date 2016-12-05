module Games.FlashCard.Study exposing (..)

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

import Components.Card as Card

-- Study Model
type alias Model =
  {
    complete: Bool,
    flashcardList: Array Card.Model -- list? array?
  }

-- Study Msg
type Msg
  = Complete
  | CardMsg Card.Msg

-- Study Update

-- Study View
study : Model -> Html a
study model =
  div [][
    let
      currentCard = Array.get 0 model.flashcardList
    in
      case currentCard of
        Just cardmodel ->
          Card.card cardmodel
        Nothing ->
          text ""
  ]
