module Components.Registration exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

-- Registration Model
type alias Model =
  {
      name: String,
      email: String,
      pass: String,
      pass_second: String,
      err: String
  }


-- Registration Msg
type Msg
  = Name String
  | Email String
  | Pass String
  | PassSecond String
  | SubmitReg
  | Error String

-- Registration Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }
    Email email ->
      { model | email = email }
    Pass pass ->
      { model | pass = pass }
    PassSecond pass_second ->
      -- TODO: is it possible to detect loss of focus? for all required fields
      { model | pass_second = pass_second }
    SubmitReg ->
      { model | err =
          if model.name == "" then
            "Username is required"
          else if model.email == "" then
            "Email address is required"
          -- TODO: validate email format
          -- TODO: validate password strength
          else if model.pass == "" then
            "Password is required"
          else if model.pass /= model.pass_second then
            "Passwords do not match"
          else
            ""
          -- TODO: No errors? make the request to the server!
          -- TODO: If server result is OK, then reset to initmodel
        }
    Error err ->
      { model | err = err }


-- Registration View
registration : Model -> Html Msg
registration model =
  div [ class "registration_container" ] [
    input [ type_ "text", placeholder "Username", onInput Name ] [],
    input [ type_ "email", placeholder "email address", onInput Email ] [],
    input [ type_ "password", onInput Pass ] [],
    input [ type_ "password", onInput PassSecond ] [],
    div [] [ text model.err ],
    button [ onClick (SubmitReg) ] [ text "Submit" ]

  ]
