module Picshare01 exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)




initialModel: {url: String, caption: String, liked: Bool}
initialModel =
    {
        url = baseUrl ++ "1.jpg"
        , caption = "Surfing"
        , liked = False
    }

baseUrl : String
baseUrl =
    "http://localhost:5000/"


viewDetailedPhoto : {url: String, caption: String, liked: Bool} -> Html Msg
viewDetailedPhoto model =
    let
        buttonClass =
            if model.liked then
                "fa-heart"
            else
                "fa-heart-o"

        msg =
            if model.liked then
                Unlike
            else
                Liked
    in
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
        [
            i [ class "fa fa-2x" , class buttonClass , onClick msg] []
            , h2 [] [ text model.caption ]
        ]
        ]


view : {url: String, caption: String, liked: Bool} -> Html Msg
view model =
    div []
        [ div [ class "header" ] [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model ]
        ]


type Msg =
    Liked
    | Unlike


update: Msg -> {url: String, caption: String, liked: Bool} -> {url: String, caption: String, liked: Bool}
update msg model =
    case msg of
        Liked -> { model | liked = True }
        Unlike -> { model | liked = False }



main: Program () {url: String, caption: String, liked: Bool} Msg
main =
    Browser.sandbox {
        init = initialModel
        , view = view
        , update = update
    }