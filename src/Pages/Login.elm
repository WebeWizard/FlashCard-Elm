module Pages.Login exposing (Model, Msg, init, update, view)

import Element exposing (centerX, centerY, column, paddingXY, rgb255, text)
import Element.Background as Background
import Element.Input as Input exposing (button, currentPassword, labelHidden, placeholder, username)
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
    , body =
        column [ centerX ]
            ([ username []
                { onChange = Email
                , placeholder = Just (placeholder [] (text "Email Address"))
                , label = labelHidden "Email Address"
                , text = model.email
                }
             , currentPassword []
                { onChange = Secret
                , placeholder = Just (placeholder [] (text "Password"))
                , label = labelHidden "Password"
                , text = model.secret
                , show = False
                }
             , button
                [ centerX
                , centerY
                , paddingXY 60 8
                , Background.color (rgb255 14 183 196)
                ]
                { onPress = Just Login
                , label = text "Log in"
                }
             ]
                ++ (case model.error of
                        Just error ->
                            [ text error ]

                        Nothing ->
                            []
                   )
            )
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