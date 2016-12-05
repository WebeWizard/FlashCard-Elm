module Game exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Games.FlashCard.FlashCardGame as FlashCardGame

type Model =
  FlashCardGameType FlashCardGame.Model
  -- | OtherGameTypes

-- Game Msg
type Msg
  = FlashCardGameMsg FlashCardGame.Msg

-- Game View
game : Model -> Html Msg
game model =
  div [][
    case model of
      FlashCardGameType flashcardgamemodel ->
        Html.map FlashCardGameMsg (FlashCardGame.flashcardgame flashcardgamemodel)
  ]
