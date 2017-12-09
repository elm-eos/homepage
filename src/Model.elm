module Model exposing (..)

import Dict exposing (Dict)
import Eos
import Forms exposing (Forms)
import Json.Decode exposing (Value)
import Route exposing (Route)


type alias Model =
    { route : Route
    , baseUrl : Eos.BaseUrl
    , forms : Forms
    , output : Dict Forms.Id (Result Eos.Error Value)
    }


emptyModel : Model
emptyModel =
    { route = Route.Loading
    , baseUrl = Eos.baseUrl "http://127.0.0.1:8888"
    , forms = Forms.empty
    , output = Dict.empty
    }
