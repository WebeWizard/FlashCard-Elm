module Pages.SignUp exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput)
import Http
import Skeleton



-- MODEL


type alias Model =
    { email : String
    , secret : String
    , verify : String
    , error : Maybe String
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { email = ""
      , secret = ""
      , verify = ""
      , error = Nothing
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Email String
    | Secret String
    | Verify String
    | Error String
    | SignedUp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Email name ->
            ( { model | email = name }, Cmd.none )

        Secret secret ->
            ( { model | secret = secret }, Cmd.none )

        Verify verify ->
            ( { model | verify = verify }, Cmd.none )

        Error error ->
            ( { model | error = Just error }, Cmd.none )

        SignedUp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "SignUp"
    , attrs = []
    , kids =
        [ div
            []
            ([ input [ placeholder "Email Address", value model.email, onInput Email ] []
             , input [ type_ "Password", value model.secret, onInput Secret ] []
             , input [ type_ "Verify Password", value model.verify, onInput Verify ] []
             ]
                -- add error message if exists
                ++ (case model.error of
                        Just error ->
                            [ text error ]

                        Nothing ->
                            []
                   )
            )
        ]
    }



-- HTTP
