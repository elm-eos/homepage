-- import Html.Styled
-- import Model exposing (Model)
-- import Navigation
-- import State exposing (Msg(UrlChange))
-- import View exposing (view)
--
--
-- main : Program Never Model Msg
-- main =
--     Navigation.program UrlChange
--         { init = State.init
--         , update = State.update
--         , subscriptions = State.subscriptions
--         , view = view >> Html.Styled.toUnstyled
--         }


module Main exposing (..)

import Html exposing (Html)


main : Program Never () ()
main =
    Html.program
        { init = () ! []
        , update = \_ _ -> () ! []
        , subscriptions = \_ -> Sub.none
        , view = \_ -> Html.text "Neat..."
        }
