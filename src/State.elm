module State exposing (..)

import Dict
import Eos
import Eos.Chain
import Form exposing (Form)
import Form.Validate exposing (Validation)
import Forms exposing (Forms)
import Json.Encode exposing (Value)
import Model exposing (..)
import Navigation
import Route exposing (Route)
import Task exposing (Task)


type Msg
    = NoOp
    | UrlChange Navigation.Location
    | GoTo Route
    | FormInput Forms.Id (Validation Forms.Error (Task Eos.Error Value)) Form.Msg
    | TaskResult Forms.Id (Result Eos.Error Value)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        model =
            Model.emptyModel

        route =
            Route.parse location

        baseUrl =
            Eos.baseUrl "http://127.0.0.1:8888"

        attempt =
            Task.attempt
                (\result ->
                    let
                        _ =
                            Debug.log "Result" result
                    in
                    NoOp
                )
    in
    { model | route = route }
        ! [ Eos.Chain.getInfo baseUrl |> attempt
          , 1 |> Eos.blockNum |> Eos.Chain.getBlock baseUrl |> attempt
          , "eos" |> Eos.accountName |> Eos.Chain.getAccount baseUrl |> attempt
          , "eos" |> Eos.accountName |> Eos.Chain.getCode baseUrl |> attempt
          ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        UrlChange location ->
            { model | route = Route.parse location } ! []

        GoTo route ->
            model ! [ Navigation.newUrl <| Route.print route ]

        FormInput id validate formMsg ->
            let
                form =
                    model.forms
                        |> Dict.get id
                        |> Maybe.withDefault (Form.initial [] validate)
            in
            case ( formMsg, Form.getOutput form ) of
                ( Form.Submit, Just task ) ->
                    model ! [ Task.attempt (TaskResult id) task ]

                _ ->
                    { model
                        | forms =
                            Forms.insert id
                                (Form.update validate formMsg form)
                                model.forms
                    }
                        ! []

        TaskResult id output ->
            { model | output = Dict.insert id output model.output } ! []


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
