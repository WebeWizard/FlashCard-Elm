-- Session.elm - represents the browsing session used to access the app. (settings, accounts, etc)


port module Session exposing (..)

import Json.Decode as Decode exposing (field, int, maybe, string)
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
        (field "account_id" string)
        (field "timeout" int)



-- PERSISTENCE


store : Session -> Cmd msg
store session =
    let
        json =
            Encode.object
                [ ( "token", Encode.string session.token )
                , ( "accountId", Encode.string session.accountId )
                , ( "timeout", Encode.int session.timeout )
                ]
    in
    storeSession (Just json)


port storeSession : Maybe Value -> Cmd msg
