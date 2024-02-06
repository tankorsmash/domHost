module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Events exposing (onAnimationFrameDelta)
import Browser.Navigation as Nav
import Color
import GamePageParser exposing (parseGamePage)
import Html exposing (Html, div)
import Html.Attributes as HA exposing (class, style, value)
import Html.Events as HE exposing (onInput)
import Http
import Lamdera
import Process
import SamplePage
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
      , gameName = "WhoNeedsJ"
      , nationRows = []
      }
    , Cmd.none
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

        ChangedGameName newGameName ->
            ( { model | gameName = newGameName }, Cmd.none )

        SearchGameName ->
            ( model
            , Lamdera.sendToBackend <|
                ToBackendRequestGamePage model.gameName
            )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        ToFrontendGotDom6Page pageResult ->
            case pageResult of
                Ok maybeParsed ->
                    case maybeParsed of
                        Just parsedRows ->
                            ( { model | nationRows = parsedRows }, Cmd.none )

                        Nothing ->
                            ( model, Cmd.none )

                Err err ->
                    ( model, Cmd.none )


renderNationRow : NationStatusRow -> Html msg
renderNationRow nationRow =
    Html.div [ class "row" ] <|
        [ Html.div [ class "col" ] [ Html.text nationRow.name ]
        , Html.div [ class "col" ] [ Html.text nationRow.value ]
        ]


view : Model -> Browser.Document FrontendMsg
view model =
    -- if not model.okayToRender then
    --     { title = ""
    --     , body = [ Html.text "Loading..." ]
    --     }
    --
    -- else
    let
        maybeNationRows =
            123
    in
    { title = ""
    , body =
        [ Html.div
            [ class "container"
            ]
            [ Html.h3 [] <| [ Html.text "Dominions 6: Lobby Status" ]
            , Html.form [ class "input-group mb-3", HE.onSubmit SearchGameName ]
                [ Html.span [ class "input-group-text" ] [ Html.text "Lobby name" ]
                , Html.input [ class "form-control", HA.type_ "text", value model.gameName, HE.onInput ChangedGameName ] []
                , Html.button [ class "btn btn-outline-secondary", HA.type_ "button", HE.onClick SearchGameName ] [ Html.text "Search" ]
                ]
            , Html.div [ class "row" ] <|
                [ Html.div [ class "col" ] [ Html.text "Nation" ]
                , Html.div [ class "col" ] [ Html.text "Status" ]
                ]
            , Html.div [ class "" ] <|
                -- case model.nationRows of
                --     Just nationRows ->
                List.map renderNationRow model.nationRows

            -- Nothing ->
            -- [ Html.text "No nation rows" ]
            ]
        ]
    }
