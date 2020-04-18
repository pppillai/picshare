module Picshare01 exposing (main, photoDecoder)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, disabled, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode exposing (Decoder, bool, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, required)


type alias Id =
    Int


type alias Photo =
    { id : Id
    , url : String
    , caption : String
    , liked : Bool
    , newComment : String
    , comments : List String
    }


type alias Model =
    { photo : Maybe Photo }


type Msg
    = ToggleLike
    | UpdateComment String
    | SaveComment
    | LoadFeed (Result Http.Error Photo)


photoDecoder : Decoder Photo
photoDecoder =
    succeed Photo
        |> required "id" int
        |> required "url" string
        |> required "caption" string
        |> required "liked" bool
        |> hardcoded ""
        |> required "comments" (list string)


fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = baseUrl ++ "feed/1"
        , expect = Http.expectJson LoadFeed photoDecoder
        }


baseUrl : String
baseUrl =
    --"http://localhost:5000/"
    "https://programming-elm.com/"


initialModel : Model
initialModel =
    { photo =
        Nothing
    }


viewComment : String -> Html Msg
viewComment comment =
    li []
        [ strong [] [ text "Comment: " ]
        , text comment
        ]


viewCommentList : List String -> Html Msg
viewCommentList comments =
    case comments of
        [] ->
            text "No Comments!"

        _ ->
            ul [] (List.map viewComment comments)


viewComments : Photo -> Html Msg
viewComments model =
    div []
        [ viewCommentList model.comments
        , form [ class "new-comment", onSubmit SaveComment ]
            [ input [ type_ "text", placeholder "Add more comments", value model.newComment, onInput UpdateComment ] []
            , button [ disabled (String.isEmpty model.newComment) ] [ text "Save" ]
            ]
        ]


viewLoveButton : Photo -> Html Msg
viewLoveButton model =
    let
        buttonClass =
            if model.liked then
                "fa-heart"

            else
                "fa-heart-o"
    in
    div [ class "like-button" ]
        [ i [ class "fa fa-2x", class buttonClass, onClick ToggleLike ] []
        ]


viewDetailedPhoto : Photo -> Html Msg
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
            [ viewLoveButton model
            , h2 [ class "caption" ] [ text model.caption ]
            , viewComments model
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ] [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ]
            [ viewFeed model.photo ]
        ]


viewFeed : Maybe Photo -> Html Msg
viewFeed maybephoto =
    case maybephoto of
        Just photo ->
            viewDetailedPhoto photo

        Nothing ->
            div [ class "loading-feed" ]
                [ text "Loading Feed..." ]


saveComment : Photo -> Photo
saveComment model =
    let
        comment =
            String.trim model.newComment
    in
    case comment of
        "" ->
            model

        _ ->
            { model | comments = model.comments ++ [ comment ], newComment = "" }


toggleLike : Photo -> Photo
toggleLike photo =
    { photo | liked = not photo.liked }


updateComment : String -> Photo -> Photo
updateComment comment photo =
    { photo | newComment = comment }



--updateFeed: (Photo -> Photo) -> Maybe Photo -> Maybe Photo
--updateFeed updatePhoto maybePhoto =
--    case maybePhoto of
--        Just photo ->
--            Just (updatePhoto photo)
--        Nothing ->
--            Nothing
--


updateFeed : (Photo -> Photo) -> Maybe Photo -> Maybe Photo
updateFeed myfun maybephoto =
    Maybe.map myfun maybephoto


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleLike ->
            ( { model | photo = updateFeed toggleLike model.photo }
            , Cmd.none
            )

        UpdateComment comment ->
            ( { model | photo = updateFeed (updateComment comment) model.photo }
            , Cmd.none
            )

        SaveComment ->
            ( { model | photo = updateFeed saveComment model.photo }
            , Cmd.none
            )

        LoadFeed (Ok photo) ->
            ( { model | photo = Just photo }
            , Cmd.none
            )

        LoadFeed (Err _) ->
            ( model, Cmd.none )


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel, fetchFeed )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
