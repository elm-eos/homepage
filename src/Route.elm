module Route exposing (..)

import Navigation
import UrlParser as Url exposing (..)


type Route
    = Loading
    | Home
    | ApiVersion String
    | ApiPlugin String String
    | ApiEndpoint String String String
    | InvalidRoute (Maybe Navigation.Location)


print : Route -> String
print route =
    case route of
        Home ->
            "#/"

        ApiVersion version ->
            "#/" ++ version

        ApiPlugin version plugin ->
            "#/" ++ version ++ "/" ++ plugin

        ApiEndpoint version plugin endpoint ->
            "#/" ++ version ++ "/" ++ plugin ++ "/" ++ endpoint

        _ ->
            "#/?"


parser : Navigation.Location -> Parser (Route -> a) a
parser location =
    oneOf
        [ map Home top
        , map (ApiVersion "v1") <| s "v1"
        , map (ApiPlugin "v1") <| s "v1" </> string
        , map (ApiEndpoint "v1") <| s "v1" </> string </> string
        ]


parse : Navigation.Location -> Route
parse location =
    location
        |> Url.parseHash (parser location)
        |> Maybe.withDefault (InvalidRoute <| Just location)


isEqual : Route -> Route -> Bool
isEqual route1 route2 =
    case ( route1, route2 ) of
        ( Home, Home ) ->
            True

        _ ->
            False
