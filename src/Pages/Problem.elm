-- Problem.elm - page to show some app problem (ex. Not Found) message to the user


module Pages.Problem exposing (notFound, styles)

import Element exposing (Attribute, Element, text)



-- MODEL


type alias Model =
    {}



-- NOT FOUND


notFound : Element msg
notFound =
    text "404 - I cannot find this page!"


styles : List (Attribute msg)
styles =
    []
