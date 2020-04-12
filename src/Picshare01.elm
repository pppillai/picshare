module Picshare01 exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, src)




initialModel: {url: String, caption: String}
initialModel =
    {
        url = baseUrl ++ "1.jpg",
        caption = "Surfing"
    }

baseUrl : String
baseUrl =
    "http://localhost:5000/"


detailedViewPhoto : String -> String -> Html msg
detailedViewPhoto finalUrl caption =
    div [ class "detailed-photo" ]
        [ img [ src finalUrl ] []
        , div [ class "photo-info" ] [ h2 [] [ text caption ] ]
        ]


main : Html msg
main =
    div []
        [ div [ class "header" ] [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ]
            [ detailedViewPhoto (baseUrl ++ "1.jpg") "Surfing"
            , detailedViewPhoto (baseUrl ++ "2.jpg") "The Fox"
            , detailedViewPhoto (baseUrl ++ "3.jpg") "Evening"
            ]
        ]
