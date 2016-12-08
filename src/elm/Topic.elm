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

type SubMsg
  = SubMsg Msg

type Msg
  = StudyMsg Study.Msg
  | PracticeMsg Practice.Msg
  | ExamMsg Exam.Msg


type alias Topic =
  {
    children: List String,
    name: String,
    complete: Bool,
    study: Study.Model,
    practice: Practice.Model,
    exam: Exam.Model
  }


{-
  How to update something inside of the deeply nested list?

  use a FilterMap

  if the topic.key doesn't match the desired key, then just return it unmodified
  if it DOES match the key,
    use the get function to grab the original model,
    run the update function on it,
    return the updated model

  and somehow recurse this for each level of nested list
-}
