module Flags exposing (FlagModel, decoder)

import Json.Decode as Decode exposing (Value, decodeValue, field, map, nullable)
import Session exposing (Session)


type alias FlagModel =
    { session : Maybe Session }


decoder : Decode.Decoder FlagModel
decoder =
    Decode.map FlagModel
        (field "session" (nullable Session.decoder))
