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
  | SetCurrent Int
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
            updatedFlashCards = Array.set model.current updatedCard model.flashcards
          in
            { model |
              flashcards = updatedFlashCards,
              complete = -- see if any of the flashcards are still unsolved
                not (List.any (\m -> not m.solved) (Array.toList updatedFlashCards))
             }
        Nothing ->
          model
    SetCurrent index ->
      { model | current = index }
    Previous ->
      case (Array.get model.current model.flashcards) of
        Just currentCard ->
          let
            updatedCard = FlashCard.update FlashCard.Hide currentCard
            updatedFlashCards = Array.set model.current updatedCard model.flashcards
          in
            { model |
              current =
                if model.current == 0 then
                  (Array.length model.flashcards - 1)
                else (model.current - 1)
              , flashcards = updatedFlashCards
            }
        Nothing ->
          model
    Next ->
      case (Array.get model.current model.flashcards) of
        Just currentCard ->
          let
            updatedCard = FlashCard.update FlashCard.Hide currentCard
            updatedFlashCards = Array.set model.current updatedCard model.flashcards
          in
            { model |
              current =
                if model.current == (Array.length model.flashcards - 1) then
                  0
                else (model.current + 1)
              , flashcards = updatedFlashCards
            }
        Nothing ->
          model

flashcardNavigation : Array.Array FlashCard.Model -> Int -> Html Msg
flashcardNavigation flashcards current =
  nav [ class "level" ]
    -- map over the array and create a level-item per index in the array
    -- use the curried function to include the currently visible index
    (Array.toList (Array.indexedMap (flashcardNavigationDiv current) flashcards))

flashcardNavigationDiv : Int -> Int -> FlashCard.Model -> Html Msg
flashcardNavigationDiv current index value =
  div [ class "level-item", onClick (SetCurrent index) ][
    if index == current then
      a [ class "button is-primary", style [("width","100%")] ] [ text (toString (index+1)) ]
    else if value.solved then
      a [ class "button is-success", style [("width","100%")] ] [ text (toString (index+1)) ]
    else
      a [ class "button", style [("width","100%")] ] [ text (toString (index+1)) ]
  ]


-- FlashCard10 View
flashcard10 : Model -> Html Msg
flashcard10 model =
  div [ class "container" ] [
    flashcardNavigation model.flashcards model.current,
    button [ style [("display","inline-block"),("margin","2%")], onClick Previous ] [ text "<" ],
    case (Array.get model.current model.flashcards) of
      Just currentCard ->
        Html.map FlashCardMsg (FlashCard.flashcard currentCard)
      Maybe.Nothing ->
        text ""
    , button [ style [("display","inline-block"),("margin","2%")], onClick Next ] [ text ">" ]
    , if model.complete then
      text "Model Complete!"
    else
      text ""
  ]
