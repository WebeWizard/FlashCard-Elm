module Components.SiteHeader exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias Model = String -- only take a string for now until we actually want to use something

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
