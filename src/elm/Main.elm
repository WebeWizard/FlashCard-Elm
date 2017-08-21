import Html exposing (..)

import Components.SiteHeader as SiteHeader
import Games.FlashCard.FlashCardGame as FlashCardGame
import InitModel
import User

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = InitModel.model, view = view, update = update }

-- MODEL
type alias Model =
  {
    user: Maybe User.Model,
    header: SiteHeader.Model,
    game: FlashCardGame.Model
  }

-- MSG
type Msg
  = FlashCardGameMsg FlashCardGame.Msg
  | SiteHeaderMsg SiteHeader.Msg

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    FlashCardGameMsg submsg ->
      { model | game = FlashCardGame.update submsg model.game }
    SiteHeaderMsg submsg ->
      { model | header = SiteHeader.update submsg model.header }

-- VIEW
view : Model -> Html Msg
view model =
  div [][
    Html.map SiteHeaderMsg (SiteHeader.siteheader model.header),
    div [][
      Html.map FlashCardGameMsg (FlashCardGame.flashcardgame model.game)
    ]
  ]
