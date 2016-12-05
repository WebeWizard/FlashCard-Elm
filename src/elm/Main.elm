import Html exposing (..)

import Components.SiteHeader as SiteHeader
import Game
import InitModel

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = InitModel.model, view = view, update = update }

-- MODEL
type alias Model =
  {
    name: String,
    game: Game.Model
  }

-- MSG
type Msg
  = GameMsg Game.Msg

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  InitModel.model

-- VIEW
view : Model -> Html Msg
view model =
  div [][
    SiteHeader.siteheader "WebeWizard",
    div [][
      case model.game of
        Game.FlashCardGameType flashcardgamemodel ->
          Html.map GameMsg (Game.game model.game)
    ]
  ]
