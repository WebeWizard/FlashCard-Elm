module Games.FlashCard.Practice exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Components.Card as Card

-- Practice Model
type alias Model =
  {
    round: Int,
    complete: Bool,
    currentCard: Int,
    flashcardList: String
  }

-- Practice Msg
type Msg
  = Complete
  | CardMsg Card.Msg

-- Practice Update

-- Practice View
practice : Model -> Html a
practice model =
  div [][
    text "some flashcards should go here"
  ]
