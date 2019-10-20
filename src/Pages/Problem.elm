-- Problem.elm - page to show some app problem (ex. Not Found) message to the user


module Pages.Problem exposing (notFound, styles)

import Html exposing (Attribute, Html, div, text)
import Html.Attributes exposing (style)



-- MODEL


type alias Model =
    {}



-- NOT FOUND


notFound : List (Html msg)
notFound =
    [ div [ style "font-size" "12em" ] [ text "404" ]
    , div [ style "font-size" "3em" ] [ text "I cannot find this page!" ]
    ]


styles : List (Attribute msg)
styles =
    [ style "text-align" "center"
    , style "color" "#9A9A9A"
    , style "padding" "6em 0"
    ]
