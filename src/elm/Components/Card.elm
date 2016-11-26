module Components.Card exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onInput )

-- Game Model
type alias Model =
  {
    question: String,
    answer: String,
    guess: String
  }

-- Game Msg
type Msg
  = Guess String

-- Game Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Guess guess ->
      { model | guess = guess }

-- Game View
card : Model -> Html Msg
card cardmodel =
  if cardmodel.question /= "" && cardmodel.answer == "" then
    div [ class "card", style [("display","inline-block"),("margin","15px")] ][
      div [ class "card-image" ][
        figure [ class "image" ][
          img [ src "http://placehold.it/300x225", alt "left-card-alt-text"][]
        ]
      ],
      div [ class "card-content" ][
        text cardmodel.question
      ]
    ]
  else if cardmodel.question == "" && cardmodel.answer /= "" then
    div [ class "card", style [("display","inline-block"),("margin","15px")] ][
      div [ class "card-image" ][
        figure [ class "image" ][
          img [ src "http://placehold.it/300x225", alt "left-card-alt-text"][]
        ]
      ],
      div [ class "card-content" ][
        input [ type_ "guess", style [("text-align","center")], placeholder "guess", onInput Guess ] []
      ]
    ]
  else
    text "not a valid card"
