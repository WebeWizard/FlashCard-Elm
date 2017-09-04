import Html exposing (..)

import Components.Registration as Registration
import Components.SiteHeader as SiteHeader
import Games.FlashCard.FlashCardGame as FlashCardGame
import InitModel
import User

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = InitModel.model, view = view, update = update }

-- MODEL
type alias Model =
  {
    user: Maybe User.Model,
    header: SiteHeader.Model,
    registration: Maybe Registration.Model,
    game: FlashCardGame.Model
  }

-- MSG
type Msg
  = FlashCardGameMsg FlashCardGame.Msg
  | RegistrationMsg Registration.Msg
  | SiteHeaderMsg SiteHeader.Msg

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    FlashCardGameMsg submsg ->
      { model | game = FlashCardGame.update submsg model.game }
    RegistrationMsg submsg ->
      case model.registration of
        Just registration ->
          { model | registration = Just (Registration.update submsg registration) }
        Nothing ->
          { model | registration = Just (Registration.update submsg InitModel.registration) }
    SiteHeaderMsg submsg ->
      { model | header = SiteHeader.update submsg model.header }

-- VIEW
view : Model -> Html Msg
view model =
  div [][
    Html.map SiteHeaderMsg (SiteHeader.siteheader model.header),
    case model.user of
      Just user ->
        div [][
          Html.map FlashCardGameMsg (FlashCardGame.flashcardgame model.game)
        ]
      Nothing ->
        div [][
          case model.registration of
            Just registration ->
              Html.map RegistrationMsg (Registration.registration registration)
            Nothing ->
              Html.map RegistrationMsg (Registration.registration InitModel.registration)
        ]
  ]
