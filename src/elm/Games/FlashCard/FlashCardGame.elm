module Games.FlashCard.FlashCardGame exposing (..)

import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

import Components.ModeChooser as ModeChooser
import Components.TopicChooser as TopicChooser
import Games.FlashCard.Study as Study
import Games.FlashCard.Practice as Practice
import Games.FlashCard.Exam as Exam
import Topic exposing (..)
import Util.GameModes exposing (..)


-- FlashCardGame Model
type alias Model = -- really gonna have to put some thought into how this is laid out with subtopics
  {
    currentMode: GameModes,
    currentTopic: String,
    mainTopics: List String,
    topics: Dict String Topic.Model
  }

-- FlashCardGame Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    ModeChooserMsg submsg ->
      case submsg of
        ModeChooser.SwitchTo gamemode ->
          { model |
            currentMode = gamemode,
            currentTopic = if gamemode == TopicMode then "" else model.currentTopic
          }
    TopicChooserMsg submsg ->
      case submsg of
        TopicChooser.ChangeTopic currentTopic ->
          { model |
            currentTopic = currentTopic,
            currentMode = StudyMode
          }
    TopicMsg submsg ->
      case (Dict.get model.currentTopic model.topics) of
        Just topic ->
          { model | topics =
            Dict.insert model.currentTopic (Topic.update submsg topic) model.topics
          }
        Nothing ->
          model

-- FlashCardGame Msg
type Msg
 = ModeChooserMsg ModeChooser.Msg
 | TopicChooserMsg TopicChooser.Msg
 | TopicMsg Topic.Msg

-- FlashCardGame View
flashcardgame : Model -> Html Msg
flashcardgame model =
  div [ class "container", style [("text-align","center")] ]
    (
      case (Dict.get model.currentTopic model.topics) of
        Just topic -> -- If we have a topic, allow for switching modes
          [
            Html.map ModeChooserMsg (ModeChooser.modechooser model.currentMode topic),
            text (toString model.currentTopic),
            case model.currentMode of
              TopicMode ->
                Html.map TopicChooserMsg (TopicChooser.topicchooser model.mainTopics model.topics)
              StudyMode ->
                Html.map TopicMsg (Html.map Topic.StudyMsg (Study.study topic.study))
              PracticeMode ->
                Html.map TopicMsg (Html.map Topic.PracticeMsg (Practice.practice topic.practice))
              ExamMode ->
                Html.map TopicMsg (Html.map Topic.ExamMsg (Exam.exam topic.exam))
          ]
        Nothing -> -- if there is no set topic, then only show the topic chooser
          [ Html.map TopicChooserMsg (TopicChooser.topicchooser model.mainTopics model.topics) ]
    )
