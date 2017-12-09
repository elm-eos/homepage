module Forms exposing (..)

import Dict exposing (Dict)
import Eos
import Form
import Form.Validate as V exposing (Validation)
import Json.Encode exposing (Value)
import Task exposing (Task)


-- Basics


type alias Forms =
    Dict Id Form


type alias Form =
    Form.Form Error Output


type alias Output =
    Task Eos.Error Value


empty : Forms
empty =
    Dict.empty


insert : Id -> Form -> Forms -> Forms
insert =
    Dict.insert


type alias Id =
    String


type alias Error =
    String



-- Chain


validateBlockRef : Validation Error Eos.BlockRef
validateBlockRef =
    V.oneOf
        [ V.field "blockNum"
            (V.int
                |> V.andThen (V.minInt 1)
                |> V.map Eos.blockNum
            )
        , V.field "blockId"
            (V.string
                |> V.map Eos.blockId
            )
        ]
