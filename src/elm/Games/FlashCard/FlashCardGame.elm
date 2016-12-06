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
    breadcrumb: List String,
    topics: List Topic
  }

-- FlashCardGame Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    ModeChooserMsg submsg ->
      case submsg of
        ModeChooser.SwitchTo gamemode ->
          { model | currentMode = gamemode }
    TopicChooserMsg submsg ->
      case submsg of
        TopicChooser.ChangeTopic breadcrumb ->
          { model | breadcrumb = breadcrumb }
    StudyMsg subMsg ->
      model
    PracticeMsg subMsg ->
      model
    ExamMsg subMsg ->
      model

-- FlashCardGame Msg
type Msg
 = ModeChooserMsg ModeChooser.Msg
 | TopicChooserMsg TopicChooser.Msg
 | StudyMsg Study.Msg
 | PracticeMsg Study.Msg
 | ExamMsg Exam.Msg


flashcardgame : Model -> Html Msg
flashcardgame model =
  div [ class "container", style [("text-align","center")] ][
    Html.map ModeChooserMsg ModeChooser.modechooser,
    case model.currentMode of
      TopicMode ->
        TopicChooser.topicchooser model.topics
      StudyMode ->
        case (Topic.get model.breadcrumb model.topics) of
          Just topic ->
            Study.study topic.study
          Nothing ->
            text ""
      PracticeMode ->
        text "practice should go here"
      ExamMode ->
        text "exam should go here"
  ]
