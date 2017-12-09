-- Chain


module Main exposing (..)


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
