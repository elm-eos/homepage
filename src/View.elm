module View exposing (view)

import Css exposing (..)
import EveryDict exposing (EveryDict)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events exposing (onWithOptions)
import Json.Decode as Decode
import Model exposing (..)
import Page.ApiEndpoint
import Route exposing (Route(..))
import State exposing (Msg(..))
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr


view : Model -> Html Msg
view model =
    div
        [ css
            [ fontFamilies [ "sans-serif" ]
            , displayFlex
            ]
        ]
        [ sidebarView model
        , contentView model
        ]


sidebarView : Model -> Html Msg
sidebarView model =
    aside
        [ css
            [ flexBasis <| px 300
            , flexGrow zero
            , flexShrink zero
            ]
        ]
        [ elmEosLogoView
        , linkGroupView model.route
            "chain"
            [ ( "get_info", ApiEndpoint "v1" "chain" "get_info" )
            , ( "get_block", ApiEndpoint "v1" "chain" "get_block" )
            ]
        ]


linkGroupView : Route -> String -> List ( String, Route ) -> Html Msg
linkGroupView currentRoute title links =
    div []
        [ h3 [] [ text title ]
        , nav [] <|
            List.map (linkView currentRoute) links
        ]


linkView : Route -> ( String, Route ) -> Html Msg
linkView currentRoute ( label, newRoute ) =
    a
        [ goTo newRoute
        , href <| Route.print newRoute
        , css
            [ textDecoration none ]
        ]
        [ text label ]



-- apiLinksView : Model -> Html Msg
-- apiLinksView model =
--     nav
--         [ css
--             [ displayFlex
--             , flexDirection column
--             , fontFamilies [ "monospace" ]
--             ]
--         ]
--     <|
--         List.map (apiPluginLinksView model) <|
--             List.sortBy (Tuple.first >> Basics.toString) <|
--                 EveryDict.toList apiEndpointsDict
-- apiPluginLinksView : Model -> ( ApiPlugin, List ApiEndpoint ) -> Html Msg
-- apiPluginLinksView model ( apiPlugin, apiEndpoints ) =
--     li []
--         [ strong [] [ text <| apiPluginToString apiPlugin ]
--         , ul [] <|
--             List.map (apiEndpointLinkView model) <|
--                 List.sortBy .path <|
--                     apiEndpoints
--         ]
-- apiEndpointLinkView : Model -> ApiEndpoint -> Html Msg
-- apiEndpointLinkView model apiEndpoint =
--     let
--         route =
--             Route.ApiEndpoint
--                 (apiVersionToString apiEndpoint.version)
--                 (apiPluginToString apiEndpoint.plugin)
--                 apiEndpoint.path
--     in
--     li []
--         [ a
--             [ goTo route
--             , href <| Route.print route
--             , css
--                 [ textDecoration none ]
--             ]
--             [ text apiEndpoint.path
--             ]
--         ]


elmEosLogoView : Html Msg
elmEosLogoView =
    fromUnstyled <|
        svg
            [ SvgAttr.width "227"
            , SvgAttr.height "227"
            , SvgAttr.viewBox "0 0 227 227"
            ]
            [ path
                [ SvgAttr.d "M197.356 177.182L169.76 71.209a5.52 5.52 0 0 0-.942-1.938l-50.901-67.08a5.548 5.548 0 0 0-8.814-.024L57.588 69.245a5.481 5.481 0 0 0-.968 1.994L29.635 177.21a5.502 5.502 0 0 0 2.679 6.172l78.498 43.403a5.563 5.563 0 0 0 5.375 0l78.499-43.403a5.503 5.503 0 0 0 2.67-6.2zm-19.644-31.527l-21.038-33.234 7.018-20.596 14.02 53.83zM119.035 21.952l39.184 51.635-9.145 26.831-30.039-47.455V21.952zm-5.535 42.94l30.995 48.963-20.172 59.198h-21.839v-.003l-20.262-58.748 31.278-49.41zm-5.535-43.097v31.167L77.607 100.92l-9.423-27.326 39.781-51.799zM62.784 91.88l7.247 21.01h-.001l-21.072 33.289L62.784 91.88zm11.861 34.392l16.134 46.78H45.032l29.613-46.78zm-18.273 57.803h38.21l9.001 26.102-47.211-26.102zm57.097 20.83l-7.185-20.83h14.283l-7.098 20.83zm9.881 5.309l8.908-26.139h38.371l-47.279 26.139zm12.665-37.161l16.08-47.192 29.872 47.192h-45.952z" ]
                []
            ]


contentView : Model -> Html Msg
contentView model =
    main_ [] <|
        case model.route of
            Route.ApiEndpoint version plugin endpoint ->
                [ Page.ApiEndpoint.view version plugin endpoint model ]

            _ ->
                [ text <| Basics.toString model.route ]


goTo : Route -> Attribute Msg
goTo route =
    onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (Decode.succeed <| GoTo route)
