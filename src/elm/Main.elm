import Html exposing (..)

import Components.SiteHeader as SiteHeader
import Games.FlashCard.FlashCardGame as FlashCardGame
import InitModel

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = InitModel.model, view = view, update = update }

-- MODEL
type alias Model =
  {
    name: String,
    game: FlashCardGame.Model
  }

-- MSG
type Msg
  = FlashCardGameMsg FlashCardGame.Msg

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    FlashCardGameMsg submsg ->
      { model | game = FlashCardGame.update submsg model.game }

-- VIEW
view : Model -> Html Msg
view model =
  div [][
    SiteHeader.siteheader "WebeWizard",
    div [][
      Html.map FlashCardGameMsg (FlashCardGame.flashcardgame model.game)
    ]
  ]
