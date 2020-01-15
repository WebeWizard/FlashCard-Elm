module FlashGame.UI.CardBox exposing (..)

import Json.Decode as Decode exposing (field, int, string)


type alias Card =
    { id : String
    , question : String
    , answer : String
    , pos : Int
    }

type EditMode
    = EditQuestion
    | EditAnswer
    | Uploading


type alias EditDetails =
    { mode : EditMode, id : String, tempValue : String }


type Msg
    = Edit String String
    | End
    | Start String
    | Delete Card



cardDecoder : Decode.Decoder Card
cardDecoder =
    Decode.map4 Card
        (field "id" string)
        (field "question" string)
        (field "answer" string)
        (field "pos" int)
