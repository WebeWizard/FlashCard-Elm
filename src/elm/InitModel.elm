module InitModel exposing (..)

import Array
import Dict

import Common.GameMode as GameMode
import Words.Position
import Game
import Games.FlashCard10 as FlashCard10
import Games.FlashCard10Study as FlashCard10Study
import Games.FlashCard10Practice as FlashCard10Practice
import Games.FlashCard10Exam as FlashCard10Exam
import Games.FlashCard as FlashCard
import Components.Card as Card

type alias Model =
  {
    name: String,
    game: Game.Model
  }

-- dict of flashcards
studyFlashCardsList = List.map (FlashCard.toFlashCard GameMode.Study) Words.Position.position_list
studyFlashCardsArray = Array.fromList studyFlashCardsList

practiceFlashCardsList = List.map (FlashCard.toFlashCard GameMode.Practice) Words.Position.position_list
practiceFlashCardsArray = Array.fromList practiceFlashCardsList

examFlashCardsList = List.map (FlashCard.toFlashCard GameMode.Exam) Words.Position.position_list
examFlashCardsArray = Array.fromList examFlashCardsList

flashcard10studymodel : FlashCard10Study.Model
flashcard10studymodel =
  {
    complete = False,
    current = 0,
    flashcards = studyFlashCardsArray
  }

flashcard10practicemodel : FlashCard10Practice.Model
flashcard10practicemodel =
  {
    complete = False,
    current = 0,
    flashcards = practiceFlashCardsArray
  }

flashcard10exammodel : FlashCard10Exam.Model
flashcard10exammodel =
  {
    complete = False,
    current = 0,
    flashcards = examFlashCardsArray
  }

flashcard10model : FlashCard10.Model
flashcard10model =
  {
    complete = False,
    currentMode = GameMode.Study,
    subGames =
      {
        study = flashcard10studymodel,
        practice = flashcard10practicemodel,
        exam = flashcard10exammodel
      }
  }

gamemodel : Game.Model
gamemodel =
  {
    game = Game.FlashCard10Type flashcard10model
  }

model : Model
model =
  {
    name = "FlashCard10",
    game = gamemodel
  }
