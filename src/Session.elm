-- Session.elm - represents the browsing session used to access the app. (settings, accounts, etc)


port module Session exposing (..)

import Json.Decode as Decode exposing (field, maybe, string)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Extra



-- MODEL


type alias Session =
    { accountId : String
    , userId : Maybe String
    , token : String
    }


decoder : Decode.Decoder Session
decoder =
    Decode.map3 Session
        (field "accountId" string)
        (maybe (field "userId" string))
        (field "token" string)



-- PERSISTENCE


store : Session -> Cmd msg
store session =
    let
        json =
            Encode.object
                [ ( "accountId", Encode.string session.accountId )
                , ( "userId", Extra.maybe Encode.string session.userId )
                , ( "token", Encode.string session.token )
                ]
    in
    storeSession (Just json)


port storeSession : Maybe Value -> Cmd msg
