module Components.ModeChooser exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Topic exposing (..)
import Util.GameModes exposing (..)

-- ModeChooser Model


-- ModeChooser Msg
type Msg
  = SwitchTo GameModes

-- ModeChooser Update


-- ModeChooser View
modechooser : GameModes -> Topic.Model -> Html Msg
modechooser currentMode topic =
  div [] [
    let
      makeRadio = radio currentMode
    in
      fieldset [] [
        makeRadio TopicMode "Topics",
        makeRadio StudyMode "Study",
        makeRadio PracticeMode "Practice",
        (
          if topic.practice.completeRounds >= 3 then
            makeRadio ExamMode "Exam"
          else
            text ""
        )
      ]
  ]

radio : GameModes -> GameModes -> String -> Html Msg
radio currentMode targetMode value =
  label [ style [("padding","20px")] ][
    input [ type_ "radio", name "mode", onClick (SwitchTo targetMode),
          if (currentMode == targetMode) then
            checked True
          else
            checked False
    ][],
    text value
  ]
