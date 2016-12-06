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

study : Study.Model
study =
  {
    complete = False,
    flashcardList = Array.fromList [
      {
        cardstyle = Card.Normal,
        complete = True,
        concept = "Hello",
        translation = "안녕하세요",
        guess = ""
      }
    ]
  }

practice : Practice.Model
practice =
  {
    round = 1,
    complete = False,
    flashcardList = "asdf"
  }

exam : Exam.Model
exam =
  {
    complete = False,
    flashcardList = "asdf"
  }

testSubTopic : Topic.Topic
testSubTopic =
  {
    key = "Test Subtopic",
    complete = False,
    subTopics = Topic.SubTopics [otherSubTopic,otherSubTopic],
    words = ["hi", "macro"],
    study = study,
    practice = practice,
    exam = exam
  }

otherSubTopic : Topic.Topic
otherSubTopic =
  {
    key = "Test Subtopic",
    complete = False,
    subTopics = Topic.None,
    words = ["hi", "macro"],
    study = study,
    practice = practice,
    exam = exam
  }

positionTopic : Topic.Topic
positionTopic =
  {
    key = "Position",
    complete = False,
    subTopics = Topic.SubTopics [testSubTopic,testSubTopic],
    words = ["hi","mom"],
    study = study,
    practice = practice,
    exam = exam
  }

greetingsTopic : Topic.Topic
greetingsTopic =
  {
    key = "Greetings",
    complete = False,
    subTopics = Topic.None,
    words = ["hello","goodbye"],
    study = study,
    practice = practice,
    exam = exam
  }

topics = [positionTopic, greetingsTopic]

flashcardgamemodel =
  {
    currentMode = GameModes.StudyMode,
    breadcrumb = ["Greetings"],
    topics = topics
  }

model =
  {
    name = "WebeWizard",
    game = flashcardgamemodel
  }
