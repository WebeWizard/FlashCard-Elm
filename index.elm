-- Read all about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/user_input/forms.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }

-- MODEL
type alias Model =
  { hint: String
  , question: String
  , answer: String
  }
model : Model
model =
  Model "test" "" "testAnswer"

-- UPDATE
type Msg
    = Hint  String
    | Question String
    | Answer String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Hint hint ->
      { model | hint = hint }

    Question question ->
      { model | question = question }

    Answer answer ->
      { model | answer = answer }

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ text model.hint
    , input [ type_ "password", placeholder "Password", onInput Question ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput Answer ] []
    , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.question == model.answer then
        ("green", "OK")
      else
        ("red", "not a match!")
  in
    div [ style [("color", color)] ] [ text message ]
