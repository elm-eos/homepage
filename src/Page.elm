module Page exposing (view)

import Html.Styled exposing (..)
import Model exposing (..)
import Navigation
import Page.Roadmap
import Page.Search
import Route exposing (Route(..))
import State exposing (Msg(..))


init : Model -> ( Model, Cmd Msg )
init model =
    case model.route of
        _ ->
            model ! []


view : Model -> Html Msg
view model =
    case model.route of
        Loading ->
            loadingView

        Search q ->
            Page.Search.view q model

        Roadmap ->
            Page.Roadmap.view model

        Error404 location ->
            error404View location


loadingView : Html Msg
loadingView =
    text "Loading..."


error404View : Navigation.Location -> Html Msg
error404View location =
    text <| "Error 404, " ++ location.pathname ++ " could not be found."
