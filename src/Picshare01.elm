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


detailedViewPhoto : {url: String, caption: String} -> Html msg
detailedViewPhoto model =
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ] [ h2 [] [ text model.caption ] ]
        ]


view : {url: String, caption: String} -> Html msg
view model =
    div []
        [ div [ class "header" ] [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ]
            [ detailedViewPhoto model ]
        ]

main: Html msg
main =
    view initialModel