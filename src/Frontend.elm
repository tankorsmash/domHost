module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Events exposing (onAnimationFrameDelta)
import Browser.Navigation as Nav
import Color
import GamePageParser exposing (NationStatusRow, parsedGamePage)
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


renderNationRow : NationStatusRow -> Html msg
renderNationRow nationRow =
    Html.div [ class "row" ] <|
        [ Html.div [ class "col" ] [ Html.text nationRow.name ]
        , Html.div [ class "col" ] [ Html.text nationRow.value ]
        ]


view : Model -> Browser.Document FrontendMsg
view model =
    if not model.okayToRender then
        { title = ""
        , body = [ Html.text "Loading..." ]
        }

    else
        let
            maybeNationRows =
                Debug.log "parsed from Frontend" parsedGamePage
        in
        { title = ""
        , body =
            [ Html.div
                [ class "container"
                ]
                [ Html.h3 [] <| [ Html.text "Hello, Lamdera!" ]
                , Html.div [] <| [ Html.text "How are you?" ]
                , Html.div [ class "container" ] <|
                    case maybeNationRows of
                        Just nationRows ->
                            List.map renderNationRow nationRows

                        Nothing ->
                            [ Html.text "No nation rows" ]
                ]
            ]
        }
