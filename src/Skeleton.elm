-- Skeleton.elm - page layout/skeleton for the user interface


module Skeleton exposing (Details, view)

import Browser
import Html exposing (Attribute, Html, a, div, text)
import Html.Attributes exposing (class, href)
import Session exposing (Session)



-- VIEW


type alias Details msg =
    { title : String
    , attrs : List (Attribute msg)
    , kids : List (Html msg)
    }


view : Maybe Session -> (a -> msg) -> Details a -> Browser.Document msg
view maybeSession toMsg details =
    { title =
        details.title
    , body =
        [ viewHeader maybeSession
        , Html.map toMsg <|
            div (class "center" :: details.attrs) details.kids
        , viewFooter
        ]
    }


viewHeader : Maybe Session -> Html msg
viewHeader maybeSession =
    div [ class "header" ]
        [ text "WebeWizard"
        , div [ class "header-buttons" ]
            ([]
                ++ (case maybeSession of
                        Just session ->
                            [ a [ href "profile" ] [ text "Profile" ] ]

                        Nothing ->
                            [ a [ href "signup" ] [ text "Sign Up" ]
                            , a [ href "login" ] [ text "Login" ]
                            ]
                   )
            )
        ]


viewFooter : Html msg
viewFooter =
    div [ class "footer" ]
        [ text "this is the footer" ]
