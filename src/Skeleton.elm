-- Skeleton.elm - page layout/skeleton for the user interface


module Skeleton exposing (Details, Msg(..), view)

import Browser
import Element exposing (Attribute, Element, alignBottom, alignRight, centerX, centerY, column, el, fill, height, html, link, maximum, minimum, padding, px, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input exposing (button)
import Session exposing (Session)



-- UPDATE


type Msg
    = Logout



-- VIEW


type alias Details msg =
    { title : String
    , attrs : List (Attribute msg)
    , body : Element msg
    }


view : (Msg -> msg) -> Maybe Session -> (b -> msg) -> Details b -> Browser.Document msg
view toSkelMsg maybeSession toDetailsMsg details =
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
                                    [ button [ alignRight ] { onPress = Just (toSkelMsg Logout), label = text "Logout" } ]

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
                    (Element.map toDetailsMsg details.body)
                , row
                    [ alignBottom
                    , width fill
                    , Background.color (rgb255 36 0 156)
                    ]
                    [ el [ Font.color (rgb255 255 255 255) ] (text "Footer") ]
                ]
            )
        ]
    }
