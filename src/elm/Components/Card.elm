module Components.Card exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onInput, onClick )

-- Game Model
type alias Model =
  {
    solved: Bool,
    hidden: Bool,
    question: String,
    answer: String,
    guess: String
  }

-- Game Msg
type Msg
  = Guess String
  | ToggleHidden

-- Game Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Guess guess ->
      { model |
        guess = guess,
        solved = (guess == model.answer)}
    ToggleHidden ->
      { model | hidden = not model.hidden}

-- Game View
card : Model -> Html Msg
card model =
  if model.question /= "" && model.answer == "" then
    div [ class "card", style [("display","inline-block"),("margin","15px")] ][
      div [ class "card-image" ][
        figure [ class "image" ][
          img [ src "http://placehold.it/300x225", alt "left-card-alt-text"][]
        ]
      ],
      div [ class "card-content" ][
        text model.question
      ]
    ]
  else if model.question == "" && model.answer /= "" then
    div [ class "card", style [("display","inline-block"),("margin","15px")] ][
      div [ class "card-image" ][
        figure [ class "image", onClick ToggleHidden ][
          img [ src "http://placehold.it/300x225", alt "left-card-alt-text"][],
          if not model.hidden then
            div [ class "content",
              style [
                ("position","relative")
                ,("height","30px")
                ,("margin-top","-30px")
                ,("background","rgba(255,255,255,0.5)")
              ]
            ][
              text model.answer
            ]
          else
            text ""
        ]
      ],
      div [ class "card-content" ][
        if model.solved then
          text model.answer
        else
          input [ type_ "guess", style [("text-align","center")], placeholder "guess", onInput Guess ] []
      ]
    ]
  else
    text "not a valid card"
