module FlashGame.Utility exposing (..)

import Element exposing (Color, rgb255)


scoreColor : Int -> Color
scoreColor score =
    case score of
        1 ->
            rgb255 170 0 128

        2 ->
            rgb255 255 138 71

        3 ->
            rgb255 255 221 0

        4 ->
            rgb255 127 174 46

        5 ->
            rgb255 0 168 215

        _ ->
            rgb255 36 48 67
