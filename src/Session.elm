-- Session.elm - represents the browsing session used to access the app. (settings, accounts, etc)


port module Session exposing (..)

import Http
import Json.Decode as Decode exposing (field, int, string)
import Json.Encode as Encode exposing (Value)



-- MODEL


type alias Session =
    { token : String
    , accountId : String
    , timeout : Int
    }


decoder : Decode.Decoder Session
decoder =
    Decode.map3 Session
        (field "token" string)
        (field "accountId" string)
        (field "timeout" int)



-- PERSISTENCE


store : Maybe Session -> Cmd msg
store maybeSession =
    case maybeSession of
        Just session ->
            let
                json =
                    Encode.object
                        [ ( "token", Encode.string session.token )
                        , ( "accountId", Encode.string session.accountId )
                        , ( "timeout", Encode.int session.timeout )
                        ]
            in
            storeSession (Just json)

        Nothing ->
            storeSession Nothing


port storeSession : Maybe Value -> Cmd msg



-- HTTP


getHeader : Session -> Http.Header
getHeader session =
    Http.header "x-webe-token" session.token
