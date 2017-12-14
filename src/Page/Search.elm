module Page.Search exposing (view)

import Css
import Eosc
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as HtmlAttr
import Html.Styled.Events as HtmlEvt
import Html.Styled.Lazy as Html
import Json.Encode as Encode exposing (Value)
import Model exposing (..)
import RemoteData exposing (RemoteData(..))
import Route
import State exposing (Msg(..))
import Style
import View
import VirtualDom


view : String -> Model -> Html Msg
view _ model =
    View.container model
        [ Html.lazy2 searchForm model.theme model.query
        , if String.startsWith "eosc" model.query then
            Html.lazy2 eoscView model.query model.eoscResult
          else
            Html.text ""
        ]


searchForm : Style.Theme -> String -> VirtualDom.Node Msg
searchForm theme query =
    Html.form
        [ HtmlEvt.onSubmit (GoTo <| Route.Search query)
        , HtmlAttr.css
            [ Css.width <| Css.pct 100 ]
        ]
        [ Html.input
            [ HtmlEvt.onInput SetQuery
            , HtmlAttr.autocomplete False
            , HtmlAttr.placeholder "Search"
            , HtmlAttr.name "q"
            , HtmlAttr.value query
            , HtmlAttr.css
                [ Css.borderRadius Css.zero
                , Css.borderColor <| Css.hex "#000000"
                , Css.borderStyle Css.solid
                , Css.borderWidth <| Css.px 1
                , Css.fontFamilies [ "monospace" ]
                , Css.width <| Css.pct 100
                , Style.padX theme 2
                , Style.padY theme 1.5
                ]
            , HtmlAttr.autofocus True
            ]
            []
        , Html.button [ HtmlAttr.type_ "submit" ] [ Html.text "Go" ]
        ]
        |> Html.toUnstyled


helpText : String -> Html Msg
helpText query =
    Html.div [] <|
        case String.words <| String.toLower query of
            [ "eosc" ] ->
                [ Html.text "EOSC!" ]

            _ ->
                [ Html.text "Hmm..." ]


eoscView : String -> RemoteData Eosc.Error Value -> VirtualDom.Node Msg
eoscView query eoscResult =
    Html.div
        [ HtmlAttr.css
            [ Css.displayFlex
            , Css.flexDirection Css.row
            ]
        ]
        [ Html.lazy eoscHelpView query
        , Html.lazy eoscOutputView eoscResult
        ]
        |> Html.toUnstyled


eoscHelpView : String -> VirtualDom.Node Msg
eoscHelpView query =
    Html.pre
        [ HtmlAttr.css
            [ Css.flex <| Css.int 1 ]
        ]
        [ Html.text
            """Command Line Interface to Eos Client
Usage: eosc [OPTIONS] SUBCOMMAND

Options:
  -h,--help                   Print this help message and exit
  -H,--host TEXT=localhost    the host where eosd is running
  -p,--port UINT=8888         the port where eosd is running
  --wallet-host TEXT=localhost
                              the host where eos-walletd is running
  --wallet-port UINT=8888     the port where eos-walletd is running
  -v,--verbose                output verbose messages on error

Subcommands:
  version                     Retrieve version information
  create                      Create various items, on and off the blockchain
  get                         Retrieve various items and information from the blockchain
  set                         Set or update blockchain state
  transfer                    Transfer EOS from account to account
  net                         Interact with local p2p network connections
  wallet                      Interact with local wallet
  benchmark                   Configure and execute benchmarks
  push                        Push arbitrary transactions to the blockchain
        """
        ]
        |> Html.toUnstyled


eoscOutputView : RemoteData Eosc.Error Value -> VirtualDom.Node Msg
eoscOutputView data =
    case data of
        NotAsked ->
            Html.text ""
                |> Html.toUnstyled

        Loading ->
            Html.text "Loading..."
                |> Html.toUnstyled

        Success value ->
            Html.pre
                [ HtmlAttr.css
                    [ Css.flex <| Css.int 1 ]
                ]
                [ Html.text <| Encode.encode 4 value ]
                |> Html.toUnstyled

        Failure err ->
            Html.pre
                [ HtmlAttr.css
                    [ Css.flex <| Css.int 1 ]
                ]
                [ Html.text <| Basics.toString err ]
                |> Html.toUnstyled
