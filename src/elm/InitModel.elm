module InitModel exposing (..)

import Array exposing (..)
import Dict exposing (..)

import Components.Card as Card
import Games.FlashCard.FlashCardGame as FlashCardGame
import Games.FlashCard.Study as Study
import Games.FlashCard.Practice as Practice
import Games.FlashCard.Exam as Exam
import Topic
import Util.GameModes as GameModes

flashcardList = Array.fromList [
    --Card.newNormalCard "Hello (informal)" "안녕하세요",
    --Card.newNormalCard "Hello (formal)" "안녕하습니까",
    --Card.newNormalCard "How are you?" "안녕한셨습니까?",
    --Card.newNormalCard "Good morning" "좋은 아침",
    --Card.newNormalCard "Good evening" "좋은 저녁",
    --Card.newNormalCard "Good night" "절자"
    Card.newNormalCard "test" "test",
    Card.newNormalCard "asdf" "asdf"
  ]

study : Study.Model
study =
  {
    currentCard = 0,
    complete = False,
    flashcardList = Array.map Card.completeCard flashcardList
  }

practice : Practice.Model
practice =
  {
    completeRounds = 0,
    complete = False,
    currentCard = 0,
    flashcardList = flashcardList
  }

exam : Exam.Model
exam =
  {
    complete = False,
    flashcardList = "asdf"
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

topics =
  Dict.empty
  |> Dict.insert "Position" positionTopic
  |> Dict.insert "Greetings" greetingsTopic
  |> Dict.insert "Test Sub Topic" testSubTopic


flashcardgamemodel =
  {
    currentMode = GameModes.TopicMode,
    currentTopic = "",
    mainTopics = ["Greetings","Position"],
    topics = topics
  }

model =
  {
    name = "WebeWizard",
    game = flashcardgamemodel
  }
