module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, text, div, h1, img, ul, li, b, a)
import Html.Attributes exposing (src, href)
import Url
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string)


type Route
    = Blog Int
    | User String
    | Comment String Int


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [
            map Blog (s "blog" </> int)
            , map User (s "user" </> string)
            , map Comment (s "user" </> string </> s "comment" </> int)
        ]

---- MODEL ----

type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )



---- UPDATE ----


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
            Browser.Internal url ->
                ( model, Nav.pushUrl model.key (Url.toString url) )

            Browser.External href ->
                ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Url meh"
    , body = [
        div []
            [ img [ src "/logo.svg" ] []
            , h1 [] [ text "Your Elm App is working!" ]
            , b [] [ text (Url.toString model.url) ]
            , ul []
                [
                    viewLink "/home"
                    , viewLink "/create"
                    , viewLink "/about"
                    , viewLink "/blog/1"
                ]
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


---- PROGRAM ----

main : Program () Model Msg
main =
    Browser.application
        {init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }