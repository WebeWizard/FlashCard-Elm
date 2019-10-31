-- Main.elm - root control flow for the application


port module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Json.Decode exposing (Value, decodeValue, string)
import Pages.Landing as Landing exposing (Model)
import Pages.Login as Login exposing (Model)
import Pages.Problem as Problem
import Pages.Settings as Settings exposing (Model)
import Pages.SignUp as SignUp exposing (Model)
import Session exposing (Session)
import Skeleton
import Url
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string, top)



-- MAIN


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Page
    , session : Maybe Session
    }


type Page
    = NotFound
    | Landing Landing.Model
    | SignUp SignUp.Model
    | Login Login.Model
    | Settings Settings.Model



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    stepUrl url
        { key = key
        , page = NotFound
        , session = Nothing
        }



-- UPDATE


type Msg
    = LandingMsg Landing.Msg
    | LinkClicked Browser.UrlRequest
    | LoginMsg Login.Msg
    | SignUpMsg SignUp.Msg
    | SettingsMsg Settings.Msg
    | UrlChanged Url.Url
    | SessionChanged Value


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SessionChanged value ->
            case decodeValue Session.decoder value of
                Ok session ->
                    let
                        asdf =
                            Debug.log "test" session
                    in
                    ( { model | session = Just session }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        UrlChanged url ->
            stepUrl url model

        LandingMsg msg ->
            case model.page of
                Landing pageModel ->
                    stepLanding model (Landing.update msg pageModel)

                _ ->
                    ( model, Cmd.none )

        SignUpMsg msg ->
            case model.page of
                SignUp pageModel ->
                    stepSignUp model (SignUp.update msg pageModel)

                _ ->
                    ( model, Cmd.none )

        LoginMsg msg ->
            case model.page of
                Login pageModel ->
                    stepLogin model (Login.update msg pageModel)

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        viewPage =
            Skeleton.view model.session
    in
    case model.page of
        NotFound ->
            viewPage never
                { title = "Not Found"
                , attrs = Problem.styles
                , body = Problem.notFound
                }

        Landing pageModel ->
            viewPage LandingMsg (Landing.view pageModel)

        Login pageModel ->
            viewPage LoginMsg (Login.view pageModel)

        SignUp pageModel ->
            viewPage SignUpMsg (SignUp.view pageModel)

        _ ->
            -- TODO: implement the rest
            viewPage
                never
                { title = "Not Found"
                , attrs = Problem.styles
                , body = Problem.notFound
                }



-- ROUTER


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        session =
            model.session

        parser =
            oneOf
                [ route top
                    (stepLanding model Landing.init)
                , route (s "signup")
                    (stepSignUp model SignUp.init)
                , route (s "login")
                    (stepLogin model Login.init)
                ]
    in
    case Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


stepLanding : Model -> ( Landing.Model, Cmd Landing.Msg ) -> ( Model, Cmd Msg )
stepLanding mainModel ( pageModel, cmds ) =
    ( { mainModel | page = Landing pageModel }
    , Cmd.map LandingMsg cmds
    )


stepSignUp : Model -> ( SignUp.Model, Cmd SignUp.Msg ) -> ( Model, Cmd Msg )
stepSignUp mainModel ( pageModel, cmds ) =
    ( { mainModel | page = SignUp pageModel }
    , Cmd.map SignUpMsg cmds
    )


stepLogin : Model -> ( Login.Model, Cmd Login.Msg ) -> ( Model, Cmd Msg )
stepLogin mainModel ( pageModel, cmds ) =
    ( { mainModel | page = Login pageModel }
    , Cmd.map LoginMsg cmds
    )


stepSettings : Model -> ( Settings.Model, Cmd Settings.Msg ) -> ( Model, Cmd Msg )
stepSettings mainModel ( pageModel, cmds ) =
    ( { mainModel | page = Settings pageModel }
    , Cmd.map SettingsMsg cmds
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    updateSession SessionChanged



--  PERSISTENCE


port updateSession : (Value -> msg) -> Sub msg



-- HTTP
