module InitModel exposing (..)

import Array exposing (..)
import Dict exposing (..)

import Components.Card as Card
import Components.Registration as Registration
import Components.SiteHeader as SiteHeader
import Components.UserControl as UserControl
import Games.FlashCard.FlashCardGame as FlashCardGame
import Games.FlashCard.Study as Study
import Games.FlashCard.Practice as Practice
import Games.FlashCard.Exam as Exam
import Topic
import User
import Util.GameModes as GameModes

flashstudyList : Array.Array Card.Model
flashstudyList = Array.fromList [
    --Card.newNormalCard "Hello (informal)" "안녕하세요",
    --Card.newNormalCard "Hello (formal)" "안녕하습니까",
    --Card.newNormalCard "How are you?" "안녕한셨습니까?",
    --Card.newNormalCard "Good morning" "좋은 아침",
    --Card.newNormalCard "Good evening" "좋은 저녁",
    --Card.newNormalCard "Good night" "절자"
    Card.newStudyCard "test" "test",
    Card.newStudyCard "asdf" "asdf"
  ]

flashpracticeList : Array.Array Card.Model
flashpracticeList = Array.fromList [
    --Card.newNormalCard "Hello (informal)" "안녕하세요",
    --Card.newNormalCard "Hello (formal)" "안녕하습니까",
    --Card.newNormalCard "How are you?" "안녕한셨습니까?",
    --Card.newNormalCard "Good morning" "좋은 아침",
    --Card.newNormalCard "Good evening" "좋은 저녁",
    --Card.newNormalCard "Good night" "절자"
    Card.newPracticeCard "test" "test",
    Card.newPracticeCard "asdf" "asdf"
  ]

flashexamList : Array.Array Card.Model
flashexamList = Array.fromList [
    --Card.newNormalCard "Hello (informal)" "안녕하세요",
    --Card.newNormalCard "Hello (formal)" "안녕하습니까",
    --Card.newNormalCard "How are you?" "안녕한셨습니까?",
    --Card.newNormalCard "Good morning" "좋은 아침",
    --Card.newNormalCard "Good evening" "좋은 저녁",
    --Card.newNormalCard "Good night" "잘자"
    Card.newExamCard "test" "test",
    Card.newExamCard "asdf" "asdf"
  ]

study : Study.Model
study =
  {
    currentCard = 0,
    complete = False,
    flashcardList = flashstudyList
  }

practice : Practice.Model
practice =
  {
    completeRounds = 0,
    complete = False,
    currentCard = 0,
    flashcardList = flashpracticeList
  }

exam : Exam.Model
exam =
  {
    complete = False,
    currentCard = 0,
    flashcardList = flashexamList
  }

testSubTopic : Topic.Model
testSubTopic =
  {
    children = [],
    name = "Test Sub Topic",
    complete = False,
    study = study,
    practice = practice,
    exam = exam
  }

positionTopic : Topic.Model
positionTopic =
  {
    children = [],
    name = "Position",
    complete = False,
    study = study,
    practice = practice,
    exam = exam
  }

greetingsTopic : Topic.Model
greetingsTopic =
  {
    children = ["Test Sub Topic","Test Sub Topic"],
    name = "Greetings",
    complete = False,
    study = study,
    practice = practice,
    exam = exam
  }

topics : Dict.Dict String Topic.Model
topics =
  Dict.empty
  |> Dict.insert "Position" positionTopic
  |> Dict.insert "Greetings" greetingsTopic
  |> Dict.insert "Test Sub Topic" testSubTopic

flashcardgamemodel : FlashCardGame.Model
flashcardgamemodel =
  {
    currentMode = GameModes.TopicMode,
    currentTopic = "",
    mainTopics = ["Greetings","Position"],
    topics = topics
  }

usercontrol : UserControl.Model
usercontrol =
  {
    logged_in = False,
    name = "",
    pass = "",
    err = ""
  }

siteheader : SiteHeader.Model
siteheader = {
    name = "WebeWizard",
    usercontrol = usercontrol
  }

registration : Registration.Model
registration = {
    name = "",
    email = "",
    pass = "",
    pass_second = "",
    err = ""
  }

-- MAIN MODEL -- This has to be here to prevent circular dependency
type alias Model =
  {
    user: Maybe User.Model,
    header: SiteHeader.Model,
    registration: Maybe Registration.Model,
    game: FlashCardGame.Model
  }

model : Model
model =
  {
    user = Nothing,
    registration = Just registration,
    header = siteheader,
    game = flashcardgamemodel
  }
