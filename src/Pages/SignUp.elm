module Pages.SignUp exposing (Model, Msg, init, update, view)

import Element exposing (centerX, column, paddingXY, rgb255, spacing, text)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input exposing (button, labelHidden, labelLeft, newPassword, placeholder, username)
import Http
import Json.Encode as Encode
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
    | SignUp
    | GotSignUp (Result String ())


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

        SignUp ->
            ( model, signup model )

        GotSignUp result ->
            case result of
                Ok () ->
                    ( { model | error = Nothing }, Cmd.none )

                Err errorText ->
                    ( { model | error = Just errorText }, Cmd.none )



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "SignUp"
    , attrs = []
    , body =
        column [ centerX, spacing 10 ]
            ([ username []
                { onChange = Email
                , placeholder = Just (placeholder [] (text "Email Address"))
                , label = labelHidden "Email Address"
                , text = model.email
                }
             , newPassword []
                { onChange = Secret
                , placeholder = Just (placeholder [] (text "Password"))
                , label = labelHidden "Password"
                , text = model.secret
                , show = False
                }
             , newPassword []
                { onChange = Verify
                , placeholder = Just (placeholder [] (text "Verify Password"))
                , label = labelHidden "Re-enter Password"
                , text = model.verify
                , show = False
                }
             , button
                [ centerX
                , paddingXY 80 8
                , Background.color (rgb255 14 183 196)
                , Border.rounded 3
                ]
                { onPress = Just SignUp
                , label = text "Sign up"
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


signup : Model -> Cmd Msg
signup model =
    Http.post
        { url = "http://localhost:8080/account/create"
        , body =
            Encode.object
                [ ( "email", Encode.string model.email )
                , ( "secret", Encode.string model.secret )
                ]
                |> Http.jsonBody
        , expect =
            Http.expectStringResponse GotSignUp <|
                \response ->
                    case response of
                        Http.GoodStatus_ metadata body ->
                            Ok ()

                        Http.BadStatus_ metadata body ->
                            Err body

                        _ ->
                            Err "Service error while signing up. Please try again"
        }
