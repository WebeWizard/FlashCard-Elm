module InitModel exposing (..)

import Game
import Games.FlashCard10 as FlashCard10
import Components.Card as Card

type alias Model =
  {
    name: String,
    game: Game.Model
  }

leftcardmodel : Card.Model
leftcardmodel =
  {
    question = "Hello",
    answer = "",
    guess = ""
  }

rightcardmodel : Card.Model
rightcardmodel =
  {
    question = "",
    answer = "hello",
    guess = ""
  }

flashcard10model : FlashCard10.Model
flashcard10model =
  {
    leftCard = leftcardmodel,
    rightCard = rightcardmodel
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
