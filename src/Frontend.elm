module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Events exposing (onAnimationFrameDelta)
import Browser.Navigation as Nav
import Canvas
import Canvas.Settings
import Canvas.Settings.Advanced
import Canvas.Settings.Text
import Color
import Html exposing (Html, div)
import Html.Attributes exposing (class, style)
import Lamdera
import Process
import Task
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
      , okayToRender = False
      }
    , Process.sleep 1 |> Task.perform (always OkToRender)
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        OkToRender ->
            ( { model | okayToRender = True }, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


view : Model -> Browser.Document FrontendMsg
view model =
    let
        bootstrapStyleTag =
            Html.node "link"
                [ Html.Attributes.rel "stylesheet"
                , Html.Attributes.href "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                , Html.Attributes.attribute "integrity" "sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
                , Html.Attributes.attribute "crossorigin" "anonymous"
                ]
                []

        bootstrapScriptTag =
            Html.node "script"
                [ Html.Attributes.src "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                , Html.Attributes.attribute "integrity" "sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
                , Html.Attributes.attribute "crossorigin" "anonymous"
                ]
                []
    in
    if not model.okayToRender then
        { title = ""
        , body = [ Html.text "Loading..." ]
        }

    else
        let
            _ =
                Debug.log "view" 123
        in
        { title = ""
        , body =
            [ Html.div
                [ class "container"
                ]
                [ Html.h3 [] <| [ Html.text "Hello, Lamdera!" ]
                , Html.div [] <| [ Html.text "How are you?" ]
                ]
            ]
        }
