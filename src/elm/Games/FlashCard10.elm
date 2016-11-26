module Games.FlashCard10 exposing (..)

import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Games.FlashCard as FlashCard

-- FlashCard10 Model
type alias Model =
  {
    complete: Bool,
    current: Int,
    flashcards: Array.Array FlashCard.Model
  }

-- FlashCard10 Msg
type Msg
  = FlashCardMsg FlashCard.Msg
  | Previous
  | Next

-- FlashCard10 Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    FlashCardMsg subMsg ->
      case (Array.get model.current model.flashcards) of
        Just currentCard ->
          let
            updatedCard = FlashCard.update subMsg currentCard
          in
            { model | flashcards = Array.set model.current updatedCard model.flashcards }
        Nothing ->
          model
    Previous ->
      { model | current =
        if model.current == 0 then
          (Array.length model.flashcards - 1)
        else (model.current - 1)
      }
    Next ->
      { model | current =
        if model.current == (Array.length model.flashcards - 1) then
          0
        else (model.current + 1)
      }


-- FlashCard10 View
flashcard10 : Model -> Html Msg
flashcard10 model =
  div [ class "container" ] [
    button [ style [("display","inline-block"),("margin","2%")], onClick Previous ] [ text "<" ],
    case (Array.get model.current model.flashcards) of
      Just currentCard ->
        Html.map FlashCardMsg (FlashCard.flashcard currentCard)
      Maybe.Nothing ->
        text ""
    , button [ style [("display","inline-block"),("margin","2%")], onClick Next ] [ text ">" ]
  ]
