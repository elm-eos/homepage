module Page.Chain exposing (..)

import Dict
import Eos
import Eos.Chain
import Eos.Encode as Encode
import Form
import Form.Field as Field exposing (Field)
import Form.Input as Input
import Form.Validate as Validate exposing (Validation)
import Forms exposing (Form)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (type_)
import Html.Styled.Events exposing (onSubmit)
import Json.Encode exposing (Value)
import Model exposing (..)
import State exposing (Msg(..))
import Task exposing (Task)


getBlockView : Model -> Html Msg
getBlockView model =
    let
        id =
            "v1/chain/get_block"

        validate =
            validateGetBlock model.baseUrl

        form =
            model.forms
                |> Dict.get id
                |> Maybe.withDefault (Form.initial [] validate)
    in
    map (FormInput id validate) <| getBlockFormView form


getBlockFormView : Form -> Html Form.Msg
getBlockFormView form =
    let
        errorFor field =
            case field.liveError of
                Just error ->
                    -- replace toString with your own translations
                    div [] [ text (toString error) ]

                Nothing ->
                    text ""

        blockNum =
            Form.getFieldAsString "blockNum" form

        blockId =
            Form.getFieldAsString "blockId" form

        blockRef =
            Form.getFieldAsString "blockRef" form
    in
    Html.form [ onSubmit Form.Submit ]
        [ label []
            [ strong [] [ text "Block number" ]
            , fromUnstyled <| Input.textInput blockNum []
            ]
        , errorFor blockNum
        , label []
            [ strong [] [ text "Block id" ]
            , fromUnstyled <| Input.textInput blockId []
            ]
        , errorFor blockId
        , errorFor blockRef
        , button [ type_ "submit" ] [ text "Send" ]
        ]


validateGetBlock : Eos.BaseUrl -> Validation Forms.Error Forms.Output
validateGetBlock baseUrl =
    Validate.map
        (\blockRef ->
            Eos.Chain.getBlock baseUrl blockRef
                |> Task.map Encode.block
        )
        validateBlockRef


validateBlockRef : Validation Forms.Error Eos.BlockRef
validateBlockRef =
    Validate.oneOf
        [ Validate.field "blockNum"
            (Validate.int
                |> Validate.andThen (Validate.minInt 1)
                |> Validate.map Eos.blockNum
            )
        , Validate.field "blockId"
            (Validate.string
                |> Validate.map Eos.blockId
            )

        -- , Validate.fail <| Validate.customError "Must specify a block number or id."
        ]
