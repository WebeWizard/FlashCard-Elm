module FlashGame.Utility exposing (..)

import Element exposing (Color, rgb255)


scoreColor : Int -> Color
scoreColor score =
    case score of
        1 ->
            rgb255 107 0 107

        2 ->
            rgb255 255 128 0

        3 ->
            rgb255 255 219 77

        4 ->
            rgb255 46 184 46

        5 ->
            rgb255 26 26 255

        _ ->
            rgb255 0 0 0
