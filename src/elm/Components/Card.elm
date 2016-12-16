module Components.Card exposing (..)

import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick, onInput )

type CardStyle
  = Study
  | Practice
  | Exam

type HintVisibility
  = Always
  | Never
  | Visible
  | Hidden

-- Card Model
type alias Model =
  {
      cardstyle: CardStyle,
      complete: Bool,
      concept: String,
      translation: String,
      guess: String,
      hint: HintVisibility
  }

-- Card Msg
type Msg
  = Guess String
  | ToggleHint

-- Card Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Guess guess ->
      { model |
        complete = model.translation == guess,
        guess = guess }
    ToggleHint ->
      { model |
        hint =
          case model.hint of
            Hidden -> Visible
            Visible -> Hidden
            _ -> model.hint
      }

card : Model -> Html Msg
card model =
  div [ class "container", style [("text-align","center"),("display","inline-block")] ] [
    leftside model,
    rightside model,
    if model.cardstyle == Exam && model.complete == False then
      input [ type_ "text", style [("text-align","center")], placeholder "Translate", onInput Guess ] []
    else if model.cardstyle == Exam then
      text model.translation
    else
      text ""
  ]


leftside : Model -> Html Msg
leftside model =
  div [ class "card", style [("display","inline-block"),("margin","15px")] ][
    div [ class "card-image" ][
      figure [ class "image" ][
        img [ src "http://placehold.it/300x225", alt "left-card-alt-text"][]
      ]
    ],
    if model.cardstyle /= Exam then
      div [ class "card-content" ][
        text model.concept
      ]
    else
      text ""
  ]

rightside : Model -> Html Msg
rightside model =
  div [ class "card", style [("display","inline-block"),("margin","15px")] ][
    div [ class "card-image", onClick ToggleHint ][
      figure [ class "image" ][
        img [ src "http://placehold.it/300x225", alt "left-card-alt-text"][]
      ]
    ],
    if model.hint == Visible || model.hint == Always then
      div [   style [
                ("position","relative")
                ,("height","30px")
                ,("margin-top","-30px")
                ,("background","rgba(255,255,255,0.5)")
              ]
          ][
            text model.translation
          ]
    else
      text ""
    ,
    if model.cardstyle /= Exam then
      div [ class "card-content" ][
        if model.complete || model.cardstyle == Study || model.cardstyle == Exam then
          text model.translation
        else
          input [ type_ "text", style [("text-align","center")], placeholder "Translate", onInput Guess ] []
      ]
    else
      text ""
  ]

newCard : CardStyle -> String -> String -> Model
newCard cardstyle concept translation =
  {
    cardstyle = cardstyle,
    complete = False,
    concept = concept,
    translation = translation,
    guess = "",
    hint =
      case cardstyle of
        Study ->
          Never
        Practice ->
          Hidden
        Exam ->
          Never
  }

newStudyCard = newCard Study
newPracticeCard = newCard Practice
newExamCard = newCard Exam

-- complete = true
completeCard : Model -> Model
completeCard card =
  { card | complete = True }

resetCard : Model -> Model
resetCard card =
  { card |
    complete = False,
    guess = "",
    hint =
      if card.hint == Visible then
        Hidden
      else
        card.hint
  }

resetCardHint : Model -> Model
resetCardHint card =
  { card | hint =
      if card.hint == Visible then
        Hidden
      else
        card.hint
  }
