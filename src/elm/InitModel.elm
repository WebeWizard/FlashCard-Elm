module InitModel exposing (..)

import Array
import Dict

import Words.Position
import Game
import Games.FlashCard10 as FlashCard10
import Games.FlashCard as FlashCard
import Components.Card as Card

type alias Model =
  {
    name: String,
    game: Game.Model
  }

-- dict of flashcards
flashcardsList = List.map FlashCard.toFlashCard Words.Position.position_list
flashcardsArray = Array.fromList flashcardsList

flashcard10model : FlashCard10.Model
flashcard10model =
  {
    complete = False,
    current = 0,
    flashcards = flashcardsArray
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
