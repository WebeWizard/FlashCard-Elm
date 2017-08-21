module Components.UserControl exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import User exposing (..)

-- UserControl Model
type alias Model =
  {
      logged_in: Bool,
      name: String,
      pass: String,
      err: String
  }


-- UserControl Msg
type Msg
  = Name String
  | Pass String
  | Login User.Model
  | Logout
  | Error String


-- UserControl Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }
    Pass pass ->
      { model | pass = pass }
    Login user_model ->
      { model |
        logged_in = True,
        name = user_model.name,
        pass = "",
        err = ""
      }
    Logout ->
      { model |
        logged_in = False,
        name = "",
        pass = "",
        err = ""
      }
    Error err ->
      { model | err = err }

-- UserControl View
usercontrol : Model -> Html Msg
usercontrol model =
  div [ class "usercontrol", style [("float","right")] ] [
    input [ type_ "text" , placeholder "User", onInput Name ] [],
    input [ type_ "password", onInput Pass ] [],
    button [ onClick (Pass "balls") ] [ text "Login" ],
    text model.pass
  ]
