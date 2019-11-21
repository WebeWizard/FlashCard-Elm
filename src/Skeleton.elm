-- Skeleton.elm - page layout/skeleton for the user interface


module Skeleton exposing (Details, view)

import Browser
import Element exposing (Attribute, Element, alignBottom, alignRight, centerX, centerY, column, el, fill, height, html, link, maximum, minimum, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input exposing (button)
import Session exposing (Session)



-- VIEW


type alias Details msg =
    { title : String
    , attrs : List (Attribute msg)
    , body : Element msg
    }


type Msg
    = Logout


view : Maybe Session -> (a -> msg) -> Details a -> Browser.Document msg
view maybeSession toMsg details =
    { title =
        details.title
    , body =
        [ Element.layout
            [ height fill
            , Background.color (rgb255 246 247 248)
            ]
            (column
                [ width fill
                , height fill
                , spacing 10
                ]
                [ row
                    [ width fill
                    , height (px 75)
                    , padding 30
                    , spacing 30
                    , Background.color (rgb255 255 255 255)
                    , Border.shadow
                        { offset = ( 0, 2 )
                        , size = 0
                        , blur = 3
                        , color = rgb255 232 232 233
                        }
                    ]
                    ([ link []
                        { url = "/"
                        , label = text "WebeWizard"
                        }
                     , text "About"
                     , text "Blog"
                     ]
                        ++ (case maybeSession of
                                Just session ->
                                    [ link [ alignRight ] { url = "logout", label = text "Logout" } ]

                                Nothing ->
                                    [ link [ alignRight ]
                                        { url = "/login"
                                        , label = text "Login"
                                        }
                                    , link [ alignRight ]
                                        { url = "/signup"
                                        , label = text "SignUp"
                                        }
                                    ]
                           )
                    )
                , el
                    [ width fill
                    , height
                        (fill
                            |> minimum 100
                            |> maximum 600
                        )
                    ]
                    (Element.map toMsg details.body)
                , row
                    [ alignBottom
                    , width fill
                    , height fill
                    , Background.color (rgb255 36 0 156)
                    ]
                    [ el [ Font.color (rgb255 255 255 255) ] (text "Footer") ]
                ]
            )
        ]
    }
