module Flags exposing (FlagModel, decoder)

import Constants exposing (Constants)
import Json.Decode as Decode exposing (field, nullable)
import Session exposing (Session)


type alias FlagModel =
    { constants : Constants
    , session : Maybe Session
    }


decoder : Decode.Decoder FlagModel
decoder =
    Decode.map2 FlagModel
        (field "constants" Constants.decoder)
        (field "session" (nullable Session.decoder))
