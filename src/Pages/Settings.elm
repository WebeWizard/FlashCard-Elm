-- Settings.elm - page to view the logged in account's details and settings


module Pages.Settings exposing (Model, Msg)

import Session exposing (Session)



-- MODEL


type alias Model =
    { email : String }



-- INIT


init : Session -> ( Model, Cmd Msg )
init session =
    ( { email = "" }, Cmd.none )



-- UPDATE


type Msg
    = GotAccountInfo Session
