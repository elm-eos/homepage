module Page.ApiEndpoint exposing (..)

import Html.Styled exposing (..)
import Model exposing (..)
import Page.Chain
import State exposing (Msg(..))


view : String -> String -> String -> Model -> Html Msg
view version plugin endpoint model =
    case ( version, plugin, endpoint ) of
        ( "v1", "chain", "get_block" ) ->
            Page.Chain.getBlockView model

        _ ->
            text "Unknown API endpoint"
