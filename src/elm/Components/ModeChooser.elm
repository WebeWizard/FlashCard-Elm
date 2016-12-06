module Components.ModeChooser exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Util.GameModes exposing (..)

-- ModeChooser Model


-- ModeChooser Msg
type Msg
  = SwitchTo GameModes

-- ModeChooser Update


-- ModeChooser View
modechooser : Html Msg
modechooser =
  div [] [
    fieldset [] [
      radio "Topics" (SwitchTo TopicMode),
      radio "Study" (SwitchTo StudyMode),
      radio "Practice" (SwitchTo PracticeMode),
      radio "Exam" (SwitchTo ExamMode)
    ]
  ]

radio : String -> msg -> Html msg
radio value msg =
  label [ style [("padding","20px")] ][
    input [ type_ "radio", name "mode", onClick msg ][],
    text value
  ]
