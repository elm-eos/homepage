module Style exposing (..)

import Css exposing (..)
import Html
import Html.Attributes as Html
import Svg
import Svg.Attributes as Svg


type CssClass
    = Container
    | Logo
    | Sidebar
    | Content


className : class -> String
className =
    Basics.toString


class : class -> Html.Attribute msg
class =
    Html.class << className


classList : List ( class, Bool ) -> Html.Attribute msg
classList =
    Html.classList << List.map (\( t, b ) -> ( className t, b ))


classes : List class -> Html.Attribute msg
classes =
    classList << List.map (\t -> ( t, True ))


svgClass : class -> Svg.Attribute msg
svgClass =
    Svg.class << className


svgClassList : List ( class, Bool ) -> Svg.Attribute msg
svgClassList =
    Svg.class
        << String.join " "
        << List.map (className << Tuple.first)
        << List.filter Tuple.second


svgClasses : List class -> Svg.Attribute msg
svgClasses =
    svgClassList << List.map (\t -> ( t, True ))
