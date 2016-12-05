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

type SubTopics
  = SubTopics (List Topic)
  | None

type SubMsg
  = SubMsg Msg

type Msg
  = SubTopicMsg SubMsg
  | SetActive Bool

type alias Topic =
  {
    key: String,
    complete: Bool,
    subTopics: SubTopics, --it's gonna complain about recursive types
    words: List String,
    study: Study.Model,
    practice: Practice.Model,
    exam: Exam.Model
  }

-- have to reinvent the keyed list that all programming languages have had since day 2
get : List String -> List Topic -> Maybe Topic
get breadcrumb topicList =
  case (List.head breadcrumb) of
    Just key ->
      let
        filteredList = List.filter (filterByName key) topicList
      in
        if List.length filteredList == 1 then
          -- only one topic matched the key
          case (List.tail breadcrumb) of
            Just childBreadcrumb ->
              if List.length childBreadcrumb == 0 then
                -- last breadcrumb, so return the only member of the filtered list
                case (List.head filteredList) of
                  Just topic ->
                    Just topic
                  Nothing ->
                    Nothing
              else if List.length childBreadcrumb >= 1 then
                -- recurse - check topic for subtopics with the next key
                case (List.head filteredList) of
                  Just topic ->
                    case topic.subTopics of
                      SubTopics subtopics ->
                        get childBreadcrumb subtopics
                      None ->
                        Nothing
                  Nothing ->
                    Nothing
              else
                Nothing
            Nothing ->
              Nothing
        else
          -- list either had 0 matches, or more than one (should even allow this)
          Nothing
    Nothing ->
      Nothing

filterByName : String -> Topic -> Bool
filterByName key topic =
  topic.key == key
