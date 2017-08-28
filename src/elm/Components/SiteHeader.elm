module Components.SiteHeader exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Components.UserControl as UserControl

-- SiteHeader Model
type alias Model =
  {
    name: String,
    usercontrol: UserControl.Model
  }

-- SiteHeader Msg
type Msg
  = UserControlMsg UserControl.Msg

-- SiteHeader Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    UserControlMsg submsg ->
      { model | usercontrol = UserControl.update submsg model.usercontrol}

-- SiteHeader View
siteheader : Model -> Html Msg
siteheader model =
  div [][
    div [ class "hero is-primary" ][
      div [ class "hero-body" ][
        div [ class "container" ][
          h1 [ class "title" ][
            text (String.concat ["Simple Flashcard App - ",model.name])
          ]
        ]
      ],
      Html.map UserControlMsg (UserControl.usercontrol model.usercontrol)
    ]
  ]
