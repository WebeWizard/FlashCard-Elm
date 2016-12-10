module Topic exposing (..)

import List

import Concept
import Games.FlashCard.Study as Study
import Games.FlashCard.Practice as Practice
import Games.FlashCard.Exam as Exam

type GameModeModel
  = StudyModel Study.Model
  | PracticeModel Practice.Model
  | ExamModel Exam.Model
  | NoGameModel

-- Topic Model
type alias Model =
  {
    children: List String,
    name: String,
    complete: Bool,
    study: Study.Model,
    practice: Practice.Model,
    exam: Exam.Model
  }

-- Topic Msg
type Msg
  = StudyMsg Study.Msg
  | PracticeMsg Practice.Msg
  | ExamMsg Exam.Msg

-- Topic Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    StudyMsg submsg ->
      { model | study = Study.update submsg model.study }
    PracticeMsg submsg ->
      model
    ExamMsg submsg ->
      model
