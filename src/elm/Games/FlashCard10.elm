module Games.FlashCard10 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Common.GameMode as GameMode
import Games.FlashCard10Study as FlashCard10Study
import Games.FlashCard10Practice as FlashCard10Practice
import Games.FlashCard10Exam as FlashCard10Exam




-- FlashCard10 Model
type alias Model =
  {
    complete: Bool,
    currentMode: GameMode.GameMode,
    subGames:
      {
        study: FlashCard10Study.Model,
        practice: FlashCard10Practice.Model,
        exam: FlashCard10Exam.Model
      }
  }

-- FlashCard10 Msg
type FlashCardGameMsg
  = FlashCard10StudyMsg FlashCard10Study.Msg
  | FlashCard10PracticeMsg FlashCard10Practice.Msg
  | FlashCard10ExamMsg FlashCard10Exam.Msg

type Msg
  = SubGameMsg FlashCardGameMsg
  | Switch GameMode.GameMode

-- FlashCard10 Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    SubGameMsg subMsg ->
      -- pass the subMsg to the appropriate SubGame
      case subMsg of
        FlashCard10StudyMsg flashcardMsg ->
          let
            updatedStudyGame = FlashCard10Study.update flashcardMsg model.subGames.study
            updatedSubGames =
              {
                study = updatedStudyGame,
                practice = model.subGames.practice,
                exam = model.subGames.exam
              }
          in
            { model | subGames = updatedSubGames }
        FlashCard10PracticeMsg flashcardMsg ->
          let
            updatedPracticeGame = FlashCard10Practice.update flashcardMsg model.subGames.practice
            updatedSubGames =
              {
                study = model.subGames.study,
                practice = updatedPracticeGame,
                exam = model.subGames.exam
              }
          in
            { model | subGames = updatedSubGames }
        FlashCard10ExamMsg flashcardMsg ->
          let
            updatedExamGame = FlashCard10Exam.update flashcardMsg model.subGames.exam
            updatedSubGames =
              {
                study = model.subGames.study,
                practice = model.subGames.practice,
                exam = updatedExamGame
              }
          in
            { model | subGames = updatedSubGames }
    Switch newMode ->
      { model | currentMode = newMode }
  -- meat and potatoes of the update function


-- FlashCard10 View
flashcard10 : Model -> Html Msg
flashcard10 model =
  div [ class "container", style [("text-align","center")] ][
  case model.currentMode of
    GameMode.Study ->
      Html.map SubGameMsg (Html.map FlashCard10StudyMsg (FlashCard10Study.flashcard10study model.subGames.study))
    GameMode.Practice ->
      Html.map SubGameMsg (Html.map FlashCard10PracticeMsg (FlashCard10Practice.flashcard10practice model.subGames.practice))
    GameMode.Exam ->
      Html.map SubGameMsg (Html.map FlashCard10ExamMsg (FlashCard10Exam.flashcard10exam model.subGames.exam))
  ]
