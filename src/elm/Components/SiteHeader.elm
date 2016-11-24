module Components.SiteHeader exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import String

-- SiteHeader Model
type alias Model = String

-- SiteHeader view
siteheader : Model -> Html a
siteheader model =
  div [ class "hero is-primary" ][
    div [ class "hero-body" ][
      div [ class "container" ][
        h1 [ class "title" ][
          text (String.concat ["Simple Flashcard App - ",model])
        ]
      ]
    ]
  ]
