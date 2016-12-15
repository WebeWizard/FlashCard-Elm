module Games.FlashCard.Practice exposing (..)

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Components.Card as Card

-- Practice Model
type alias Model =
  {
    completeRounds: Int, -- round >= 2 unlocks exam mode
    complete: Bool,
    currentCard: Int,
    flashcardList: Array Card.Model
  }

-- Practice Msg
type Msg
  = CardMsg Card.Msg
  | PreviousCard
  | NextCard
  | NextRound -- resets the flashcards
  -- maybe add a way to select a specific card via some Card Chooser

-- Practice Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    CardMsg submsg ->
      case (Array.get model.currentCard model.flashcardList) of
        Just cardmodel ->
          let
            updatedflashcardList =
              Array.set model.currentCard (Card.update submsg cardmodel) model.flashcardList
            complete =
              Array.length (Array.filter (\card -> card.complete == False) updatedflashcardList ) == 0
            completeRounds =
              case submsg of
                Card.Guess string ->
                  if complete then
                    model.completeRounds + 1
                  else
                    model.completeRounds
                _ ->
                  model.completeRounds
          in
            { model |
              completeRounds = completeRounds,
              complete = complete,
              flashcardList = updatedflashcardList
            }
        Nothing ->
          model
    PreviousCard ->
      { model |
        flashcardList =
          case (Array.get model.currentCard model.flashcardList) of
            Just cardmodel ->
              -- reset hint visibility of the card we are leaving
              Array.set model.currentCard (Card.resetCardHint cardmodel) model.flashcardList
            Nothing ->
              model.flashcardList
        , currentCard =
          if (model.currentCard == 0) then
            Array.length model.flashcardList - 1
          else
            model.currentCard - 1
      }
    NextCard ->
      { model |
        flashcardList =
          case (Array.get model.currentCard model.flashcardList) of
            Just cardmodel ->
              -- reset hint visibility of the card we are leaving
              Array.set model.currentCard (Card.resetCardHint cardmodel) model.flashcardList
            Nothing ->
              model.flashcardList
        , currentCard =
          if ( (model.currentCard + 1) == (Array.length model.flashcardList) ) then
            0
          else
            model.currentCard + 1
      }
    NextRound ->
      { model |
        complete = False,
        currentCard = 0,
        flashcardList = Array.map Card.resetCard model.flashcardList
      }



-- Practice View
practice : Model -> Html Msg
practice model =
  div [][
    text (toString model.completeRounds)
    ,button [ style [("display","inline-block"),("margin","2%")], onClick PreviousCard ] [ text "<" ],
    let
      currentCard = Array.get model.currentCard model.flashcardList
    in
      case currentCard of
        Just cardmodel ->
          Html.map CardMsg (Card.card cardmodel)
        Nothing ->
          text ""
    , button [ style [("display","inline-block"),("margin","2%")], onClick NextCard ] [ text ">" ],
    if model.complete then
      button [ onClick NextRound ] [ text "NEXT ROUND" ]
    else
      text ""
  ]
