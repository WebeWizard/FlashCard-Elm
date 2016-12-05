module Games.FlashCard.Exam exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Components.Card as Card

-- Exam Model
type alias Model =
  {
    complete: Bool,
    flashcardList: String
  }

-- Exam Msg
type Msg
  = Complete
  | CardMsg Card.Msg

-- Exam Update

-- Exam View
exam : Model -> Html a
exam model =
  div [][
    text "some flashcards should go here"
  ]
