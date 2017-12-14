module View exposing (..)

import Css
import Css.Foreign
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as HtmlAttr
import Html.Styled.Events as HtmlEvt
import Model exposing (..)
import Route
import State exposing (Msg(..))
import Style
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttr


container : Model -> List (Html Msg) -> Html Msg
container model innerHtml =
    Html.div
        [ HtmlAttr.css
            [ Style.backgroundColor model.theme
            , Style.foregroundColor model.theme
            , Style.fontFamilies model.theme
            , Css.height <| Css.pct 100
            , Css.overflow Css.auto
            , Css.displayFlex
            , Css.flexDirection Css.row
            ]
        ]
        [ Css.Foreign.global
            [ Css.Foreign.selector "*"
                [ Css.boxSizing Css.borderBox
                ]
            , Css.Foreign.selector "body"
                [ Css.margin Css.zero
                , Css.padding Css.zero
                , Css.height <| Css.vh 100
                ]
            ]
        , sidebar model
        , Html.main_
            [ HtmlAttr.css
                [ Css.flex <| Css.int 1 ]
            ]
            innerHtml
        ]


sidebar : Model -> Html Msg
sidebar model =
    Html.aside []
        [ logo model.theme
        , title
        ]


title : Html Msg
title =
    Html.div
        [ HtmlAttr.css
            [ Css.fontWeight Css.bold ]
        ]
        [ Html.text "ELM-EOS" ]


logo : Style.Theme -> Html Msg
logo theme =
    let
        polygonPoints =
            [ "25.7,71.2 25.6,71.3 1.8,174.6 38,112 "
            , "87.8,179 108,112.1 73.6,52.5 39.1,112.1 59.3,179 "
            , "1.1,177.9 0.8,179 58.2,179 38.4,113.3 "
            , "0.6,180 0.6,180.1 72.3,225.7 58.5,180 "
            , "121.4,71.2 121.5,71.3 145.2,174.6 109.1,112 "
            , "146,177.9 146.2,179 88.8,179 108.7,113.3 "
            , "87.5,180 73.6,226 59.6,180 "
            , "146.4,180 146.5,180.1 74.7,225.7 88.5,180 "
            , "73,1.6 26.4,70.1 38.7,110.8 73,51.3 "
            , "74,1.6 74,51.3 108.4,110.8 120.6,70.1 "
            ]

        toPolygon pts =
            Svg.polygon
                [ SvgAttr.points pts
                , SvgAttr.fill "#ffffff"
                , SvgAttr.css [ Css.opacity <| Css.num 0.8 ]
                ]
                []
    in
    Svg.svg
        [ SvgAttr.version "1.2"
        , SvgAttr.baseProfile "tiny"
        , SvgAttr.viewBox "0 0 147 227.8"
        , SvgAttr.css [ Css.width <| Css.px 150 ]
        ]
    <|
        List.map toPolygon polygonPoints
