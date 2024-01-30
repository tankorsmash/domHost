module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String
    , gameName : String
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | ChangedGameName String
    | SearchGameName
    | GotDom6Page (Result Http.Error String)



-- | OkToRender


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
