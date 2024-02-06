module Backend exposing (..)

import Html
import Http
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { message = "Hello!" }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        BackendGotDom6Page  clientId result  ->
            (model, sendToFrontend clientId<| ToFrontendGotDom6Page result)


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        ToBackendRequestGamePage gameName ->
            let
                cmd =
                    Http.get
                        { url = "http://ulm.illwinter.com/dom6/server/" ++ gameName ++ ".html"
                        , expect =
                            Http.expectString
                                (BackendGotDom6Page clientId)
                        }
            in
            ( model, cmd )
