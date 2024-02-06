module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Http
import Lamdera
import Url


type alias NationStatusRow =
    { name : String
    , value : String
    }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , gameName : String
    , gameError : Maybe String
    , nationRows : List NationStatusRow
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | ChangedGameName String
    | SearchGameName


type ToBackend
    = NoOpToBackend
    | ToBackendRequestGamePage String


type BackendMsg
    = NoOpBackendMsg
    | BackendGotDom6Page Lamdera.ClientId (Result Http.Error String)


type alias ParsedNationRows =
    List NationStatusRow


type ToFrontend
    = NoOpToFrontend
    | ToFrontendGotDom6Page (Result Http.Error (Maybe ParsedNationRows))
