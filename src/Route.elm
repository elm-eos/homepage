module Route exposing (..)

import Navigation
import UrlParser as Url exposing (..)


type Route
    = Loading
    | Search String
    | Roadmap
    | Error404 Navigation.Location


print : Route -> String
print route =
    case route of
        Loading ->
            "/"

        Search query ->
            if String.length query > 0 then
                "/?q=" ++ query
            else
                "/"

        Roadmap ->
            "/roadmap"

        Error404 location ->
            "/" ++ Debug.log "404 PATH NAME" location.pathname


parser : Navigation.Location -> Parser (Route -> a) a
parser location =
    oneOf
        [ map (Search << Maybe.withDefault "") <| top <?> stringParam "q"
        , map Roadmap <| s "roadmap"
        ]


parse : Navigation.Location -> Route
parse location =
    location
        |> Url.parsePath (parser location)
        |> Maybe.withDefault (Error404 location)


isEqual : Route -> Route -> Bool
isEqual route1 route2 =
    Basics.toString route1 == Basics.toString route2
