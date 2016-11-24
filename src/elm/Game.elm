module Game exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Games.FlashCard10 as FlashCard10

type GameModelType = FlashCard10Type FlashCard10.Model | TextType String

-- Game Model
type alias Model =
  {
    game: GameModelType
  }

-- Game Msg
type Msg
  = FlashCard10Msg FlashCard10.Msg
  | TextMsg String

-- Gamer Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    FlashCard10Msg subMsg ->
      case model.game of
        FlashCard10Type flashcard10Model ->
          { model | game = FlashCard10Type (FlashCard10.update subMsg flashcard10Model) }
        TextType text ->
          { model | game = TextType text }
    TextMsg subMsg ->
      { model | game = TextType subMsg }


-- Game View
game : Model -> Html Msg
game model =
  div [ class "container", style [("text-align","center")] ][
  case model.game of
    FlashCard10Type flashcard10model ->
      Html.map FlashCard10Msg (FlashCard10.flashcard10 flashcard10model)
    TextType textmodel ->
      text textmodel
  ]