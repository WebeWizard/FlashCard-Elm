module Pages.Login exposing (Model, Msg, init, update, view)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode as Encode
import Session exposing (Session)
import Skeleton exposing (Details)



-- MODEL


type alias Model =
    { email : String
    , secret : String
    , error : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( { email = "", secret = "", error = Nothing }, Cmd.none )



-- UPDATE


type Msg
    = Email String
    | Secret String
    | Error String
    | Login
    | GotLogin (Result Http.Error Session)
    | SaveSuccess


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Email name ->
            ( { model | email = name }, Cmd.none )

        Secret secret ->
            ( { model | secret = secret }, Cmd.none )

        Error error ->
            ( { model | error = Just error }, Cmd.none )

        Login ->
            ( model, login model )

        GotLogin result ->
            case result of
                Ok session ->
                    ( { model | error = Nothing }, Session.store session )

                Err error ->
                    let
                        errorText =
                            case error of
                                Http.BadStatus status ->
                                    if status == 401 then
                                        "Email or Password incorrect."

                                    else
                                        "Unable to Log in at this time."

                                _ ->
                                    "Unable to Log in at this time."
                    in
                    ( { model | error = Just errorText }, Cmd.none )

        SaveSuccess ->
            ( { model | email = "SUCCESS!" }, Cmd.none )



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "Login"
    , attrs = []
    , kids =
        [ div []
            ([ input [ placeholder "Email Address", value model.email, onInput Email ] []
             , input [ type_ "Password", value model.secret, onInput Secret ] []
             , button [ onClick Login ] [ text "test" ]
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


login : Model -> Cmd Msg
login model =
    Http.post
        { url = "http://localhost:8080/login"
        , body =
            Encode.object
                [ ( "email", Encode.string model.email )
                , ( "pass", Encode.string model.secret )
                ]
                |> Http.jsonBody
        , expect = Http.expectJson GotLogin Session.decoder
        }
