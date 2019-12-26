-- Landing.elm - the first page a browser sees if there is no user session


module Pages.Landing exposing (Model, Msg, init, update, view)

import Element exposing (el, text)
import Skeleton



-- MODEL


type alias Model =
    {}



-- INIT


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = "WebeWizard"
    , attrs = []
    , body =
        text "Elm + Rust"
    }
