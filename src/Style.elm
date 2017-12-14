module Style exposing (..)

import Css exposing (..)
import Html.Styled exposing (Html)


type alias Theme =
    { backgroundColor : Color
    , foregroundColor : Color
    , borderColor : Color
    , fontFamilies : List String
    , fontSizeRoot : Px
    , fontSizeScale : Float
    , gutterX : Float
    , gutterY : Float
    }


darkTheme : Theme
darkTheme =
    { backgroundColor = hex "#34495E"
    , foregroundColor = hex "#ffffff"
    , borderColor = rgba 255 255 255 0.5
    , fontFamilies = [ "sans-serif" ]
    , fontSizeRoot = px 10
    , fontSizeScale = 1.414
    , gutterX = 10
    , gutterY = 10
    }


backgroundColor : Theme -> Style
backgroundColor theme =
    Css.backgroundColor theme.backgroundColor


foregroundColor : Theme -> Style
foregroundColor theme =
    Css.color theme.foregroundColor


fontSizeRoot : Theme -> Style
fontSizeRoot theme =
    Css.fontSize theme.fontSizeRoot


fontFamilies : Theme -> Style
fontFamilies theme =
    Css.fontFamilies theme.fontFamilies


fontSize : Theme -> Int -> Style
fontSize theme i =
    Css.fontSize <| Css.rem <| scale theme.fontSizeScale i


gutterX : Theme -> Float -> Px
gutterX theme i =
    px <| theme.gutterX * i


gutterY : Theme -> Float -> Px
gutterY theme i =
    px <| theme.gutterY * i


padL : Theme -> Float -> Style
padL theme i =
    paddingLeft <| gutterX theme i


padR : Theme -> Float -> Style
padR theme i =
    paddingRight <| gutterX theme i


padT : Theme -> Float -> Style
padT theme i =
    paddingTop <| gutterY theme i


padB : Theme -> Float -> Style
padB theme i =
    paddingBottom <| gutterY theme i


padX : Theme -> Float -> Style
padX theme i =
    batch
        [ padL theme i
        , padR theme i
        ]


padY : Theme -> Float -> Style
padY theme i =
    batch
        [ padT theme i
        , padB theme i
        ]


pad : Theme -> Float -> Style
pad theme i =
    batch
        [ padX theme i
        , padY theme i
        ]


scale : Float -> Int -> Float
scale s i =
    s ^ Basics.toFloat i
