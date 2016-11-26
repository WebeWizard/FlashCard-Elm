module Games.FlashCard exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Components.Card as Card

-- FlashCard10 Model
type alias Model =
  {
    solved: Bool,
    leftCard: Card.Model,
    rightCard: Card.Model
  }

-- converts a question/answer tuple to a new flashcard model
toFlashCard : (String, String) -> Model
toFlashCard words =
  let
    (question, answer) = words
  in
    {
      solved = False,
      leftCard =
        {
          solved = False,
          hidden = True,
          question = question,
          answer = "",
          guess = ""
        },
      rightCard =
        {
          solved = False,
          hidden = True,
          question = "",
          answer = answer,
          guess = ""
        }
    }

-- FlashCard10 Msg
type Msg
  = CardMsg Card.Msg

-- FlashCard10 Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    CardMsg subMsg ->
      let
        rightCard = Card.update subMsg model.rightCard
      in
        { model |
          solved = rightCard.guess == model.rightCard.answer,
          leftCard = Card.update subMsg model.leftCard,
          rightCard = rightCard
        }


-- FlashCard10 View
flashcard : Model -> Html Msg
flashcard model =
  div [ class "container", style [("text-align","center"),("display","inline-block")] ][
    Html.map CardMsg (Card.card model.leftCard),
    Html.map CardMsg (Card.card model.rightCard)
    {- ,
    div [ class "content" ] [
      if model.solved then
        h1 [] [text "Solved!"]
      else
        text ""
    ] -}
  ]
