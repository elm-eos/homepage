module Main exposing (..)

import Html.Styled
import Model exposing (Model)
import Navigation
import Page exposing (view)
import State exposing (Msg(UrlChange))


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = view >> Html.Styled.toUnstyled
        }
