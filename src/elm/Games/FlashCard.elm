module Games.FlashCard exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Common.GameMode as GameMode
import Components.Card as Card



-- FlashCard10 Model
type alias Model =
  {
    mode: GameMode.GameMode,
    solved: Bool,
    leftCard: Card.Model,
    rightCard: Card.Model
  }

-- converts a question/answer tuple to a new flashcard model
toFlashCard : GameMode.GameMode -> (String, String) -> Model
toFlashCard gamemode words =
  let
    (question, answer) = words
  in
    {
      mode = gamemode,
      solved = False,
      leftCard =
        {
          solved = False,
          hidden = True,
          noHint = True,
          question = question,
          answer = "",
          guess = ""
        },
      rightCard =
        {
          solved = gamemode == GameMode.Study,
          hidden = True,
          noHint = False, -- this should change based on game type
          question = "",
          answer = answer,
          guess =
            if gamemode == GameMode.Study then
              answer
            else
              ""
        }
    }

-- FlashCard10 Msg
type Msg
  = CardMsg Card.Msg
  | Hide

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
    Hide ->
      { model |
        leftCard = Card.update Card.Hide model.leftCard,
        rightCard = Card.update Card.Hide model.rightCard
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
