module FlashGame.UI.CardBox exposing (..)

import Json.Decode as Decode exposing (field, int, string)


type alias Card =
    { id : String
    , question : String
    , answer : String
    , pos : Int
    }


cardDecoder : Decode.Decoder Card
cardDecoder =
    Decode.map4 Card
        (field "id" string)
        (field "question" string)
        (field "answer" string)
        (field "pos" int)
