module Components.Card exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type CardStyle
 = Normal
 | RightSideOnly

-- Card Model
type alias Model =
  {
      cardstyle: CardStyle,
      complete: Bool,
      concept: String,
      translation: String,
      guess: String
  }

-- Card Msg
type Msg
  = Guess String

-- Card Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Guess guess ->
      { model | guess = guess }

card : Model -> Html a
card model =
  div [ class "container", style [("text-align","center"),("display","inline-block")] ] (
    case model.cardstyle of
      Normal -> --wtf this syntax
        [
          leftside model,
          rightside model
        ]
      RightSideOnly ->
        [rightside model]
  )


leftside : Model -> Html a
leftside model =
  div [ class "card", style [("display","inline-block"),("margin","15px")] ][
    div [ class "card-image" ][
      figure [ class "image" ][
        img [ src "http://placehold.it/300x225", alt "left-card-alt-text"][]
      ]
    ],
    div [ class "card-content" ][
      text model.concept
    ]
  ]

rightside : Model -> Html a
rightside model =
  div [ class "card", style [("display","inline-block"),("margin","15px")] ][
    div [ class "card-image" ][
      figure [ class "image" ][
        img [ src "http://placehold.it/300x225", alt "left-card-alt-text"][]
      ]
    ],
    div [ class "card-content" ][
      if model.complete then
        text model.translation
      else
        input [ type_ "text", style [("text-align","center")], placeholder "Translate" ] []
    ]
  ]

newCard : CardStyle -> String -> String -> Model
newCard cardstyle concept translation =
  {
    cardstyle = cardstyle,
    complete = False,
    concept = concept,
    translation = translation,
    guess = ""
  }

newNormalCard = newCard Normal
