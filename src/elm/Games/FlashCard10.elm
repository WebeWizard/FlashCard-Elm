module Games.FlashCard10 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Components.Card as Card

-- FlashCard10 Model
type alias Model =
  {
    leftCard: Card.Model,
    rightCard: Card.Model
  }

-- FlashCard10 Msg
type Msg
  = CardMsg Card.Msg

-- FlashCard10 Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    CardMsg subMsg ->
      { model |
        rightCard = Card.update subMsg model.rightCard,
        leftCard = Card.update subMsg model.leftCard
      }


-- FlashCard10 View
flashcard10 : Model -> Html Msg
flashcard10 flashcard10model =
  div [ class "container", style [("text-align","center")] ][
    Html.map CardMsg (Card.card flashcard10model.leftCard),
    Html.map CardMsg (Card.card flashcard10model.rightCard)
  ]
