module Constants exposing (..)

import Json.Decode as Decode exposing (field, string)


type alias Constants =
    { publicUrl : String }



-- consider using Json.Decode.Pipeline if this grows


decoder : Decode.Decoder Constants
decoder =
    Decode.map Constants
        (field "publicUrl" string)
