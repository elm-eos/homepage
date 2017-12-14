module State exposing (..)

import Dict
import Elm.Documentation exposing (Documentation)
import Eosc
import Http
import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import Model exposing (..)
import Navigation
import RemoteData exposing (RemoteData)
import Route exposing (Route)
import Task


type Msg
    = NoOp
    | UrlChange Navigation.Location
    | GoTo Route
    | DocsMsg (Result Http.Error (List Documentation))
    | SetQuery String
    | EoscResult (Result Eosc.Error Value)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        model =
            Model.emptyModel

        route =
            Route.parse location

        ( query, maybeCmd ) =
            searchQueryAndCmd route model.query

        eoscResult =
            if maybeCmd == Nothing then
                model.eoscResult
            else
                RemoteData.Loading
    in
    { model | route = route, query = query, eoscResult = eoscResult }
        ! [ fetchDocs "core"
          , maybeCmd |> Maybe.withDefault Cmd.none
          ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        UrlChange location ->
            { model | route = Route.parse location } ! []

        GoTo route ->
            let
                ( query, maybeCmd ) =
                    searchQueryAndCmd route model.query

                eoscResult =
                    if maybeCmd == Nothing then
                        model.eoscResult
                    else
                        RemoteData.Loading
            in
            { model
                | query = query
                , eoscResult = eoscResult
            }
                ! [ Navigation.newUrl <| Route.print route
                  , maybeCmd |> Maybe.withDefault Cmd.none
                  ]

        DocsMsg (Ok newDocs) ->
            let
                docs =
                    Dict.union
                        (newDocs |> List.map (\d -> ( d.name, d )) |> Dict.fromList)
                        model.docs
            in
            { model | docs = docs } ! []

        DocsMsg (Err err) ->
            let
                _ =
                    Debug.log "Error fetching documentation" err
            in
            model ! []

        SetQuery query ->
            { model | query = query } ! []

        EoscResult eoscResult ->
            { model
                | eoscResult =
                    case eoscResult of
                        Ok value ->
                            RemoteData.Success value

                        Err err ->
                            RemoteData.Failure err
            }
                ! []


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- INTERNAL


fetchDocs : String -> Cmd Msg
fetchDocs packageName =
    Http.send DocsMsg <|
        Http.get ("/docs/" ++ packageName ++ ".json") <|
            Decode.list Elm.Documentation.decoder


searchQueryAndCmd : Route -> String -> ( String, Maybe (Cmd Msg) )
searchQueryAndCmd route currentQuery =
    case route of
        Route.Search q ->
            ( q, eoscResultCmd q )

        _ ->
            ( currentQuery, Nothing )


eoscResultCmd : String -> Maybe (Cmd Msg)
eoscResultCmd query =
    if String.startsWith "eosc" query then
        query
            |> String.dropLeft 4
            |> String.trim
            |> Eosc.run
            |> Task.attempt EoscResult
            |> Just
    else
        Nothing
