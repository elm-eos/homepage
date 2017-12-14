module Model exposing (..)

import Dict exposing (Dict)
import Elm.Documentation exposing (Documentation)
import Eosc
import Http
import Json.Encode exposing (Value)
import RemoteData exposing (RemoteData(NotAsked))
import Route exposing (Route)
import Style


type alias Model =
    { route : Route
    , docs : Dict String Documentation
    , query : String
    , theme : Style.Theme
    , eoscResult : RemoteData Eosc.Error Value
    }


emptyModel : Model
emptyModel =
    { route = Route.Loading
    , docs = Dict.empty
    , query = ""
    , theme = Style.darkTheme
    , eoscResult = NotAsked
    }
