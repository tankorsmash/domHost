module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import Lamdera exposing (ClientId)
import Url exposing (Url)


type alias NationStatusRow =
    { name : String, value : String }

type alias  ParsedNationRows= List NationStatusRow

type alias FrontendModel =
    { key : Key
    , message : String
    , gameName : String
    , nationRows : List NationStatusRow
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
    | ToBackendRequestGamePage String


type BackendMsg
    = NoOpBackendMsg
    | BackendGotDom6Page ClientId (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | ToFrontendGotDom6Page (Result Http.Error (Maybe ParsedNationRows))
