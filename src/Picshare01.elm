module Picshare01 exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, src, placeholder, type_, disabled, value)
import Html.Events exposing (onClick, onSubmit, onInput)


type alias Id =
    Int

type alias Photo =
    { id: Id
    , url: String
    , caption: String
    , liked: Bool
    , newComment: String
    , comments: List String
    }
type alias Model =
    Photo


type Msg =
    ToggleLike
    | UpdateComment String
    | SaveComment


baseUrl : String
baseUrl =
    "http://localhost:5000/"


initialModel: Model
initialModel =
    { id = 1
    , url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    , liked = False
    , newComment = ""
    , comments = ["Cowobanga Dude!"]
    }


viewComment: String -> Html Msg
viewComment comment =
    li []
    [ strong [] [text "Comment: "]
    , text comment
    ]


viewCommentList: List String -> Html Msg
viewCommentList comments =
    case comments of
        [] -> text "No Comments!"

        _ ->  ul [] ( List.map viewComment comments )

viewComments: Model -> Html Msg
viewComments model =
    div []
    [
        viewCommentList model.comments
        , form [class "new-comment", onSubmit SaveComment]
            [
                input [type_ "text", placeholder "Add more comments", value model.newComment, onInput UpdateComment] []
                , button [disabled (String.isEmpty model.newComment) ] [text "Save"]
            ]
    ]


viewLoveButton: Model -> Html Msg
viewLoveButton model =
    let
            buttonClass =
                if model.liked then
                    "fa-heart"
                else
                    "fa-heart-o"

        in
        div [ class "like-button" ]
            [
                i [ class "fa fa-2x" , class buttonClass , onClick ToggleLike] []
            ]


viewDetailedPhoto : Model -> Html Msg
viewDetailedPhoto model =
    let
        buttonClass =
            if model.liked then
                "fa-heart"
            else
                "fa-heart-o"

    in
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
        [
            viewLoveButton model
            , h2 [class "caption"] [ text model.caption ]
            , viewComments model
        ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ] [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model ]
        ]


saveComment: Model -> Model
saveComment model =
    let
        comment = String.trim model.newComment
    in
    case comment of
        "" ->
            model
        _ ->
            { model | comments = model.comments ++ [comment], newComment = "" }



update: Msg -> Model ->  Model
update msg model =
    case msg of
        ToggleLike -> { model | liked = not model.liked }
        UpdateComment comment -> { model | newComment = comment}
        SaveComment -> saveComment model



main: Program () Model Msg
main =
    Browser.sandbox {
        init = initialModel
        , view = view
        , update = update
    }