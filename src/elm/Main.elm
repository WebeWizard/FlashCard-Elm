import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onInput )

import Components.SiteHeader exposing ( siteheader )
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


-- UPDATE
type Msg
  = GameMsg Game.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    GameMsg gameMsg ->
      case gameMsg of
        Game.TextMsg textMsg ->
          { model | name = textMsg }
        _ ->
          { model | name = "Webe" }


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [] [
    siteheader model.name,
    Html.map GameMsg (Game.game model.game)
  ]
