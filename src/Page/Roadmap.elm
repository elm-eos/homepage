module Page.Roadmap exposing (view)

import Html.Styled exposing (..)
import Model exposing (..)
import State exposing (Msg(..))
import View


view : Model -> Html Msg
view model =
    View.container model [ text "Roadmap" ]
