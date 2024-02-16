# purescript-cardano-plutus-data-schema

This package implements type-level machinery that we use across the [`cardano-transaction-lib`](https://github.com/Plutonomicon/cardano-transaction-lib/) ecosystem to specify  `PlutusData` encodings for arbitrary algebraic data types.

It is similar in spirit to [`PlutusTx.makeIsDataIndexed`](https://github.com/IntersectMBO/plutus/blob/eceae8831b8186655535dee587486dbd3fd037f4/plutus-ledger-api/src/PlutusLedgerApi/V1/Credential.hs#L78) from Plutus, that is implemented in TemplateHaskell.

In PureScript, we couldn't use templates for the lack of them, and we couldn't rely on the ordering of record fields and constructors in ADTs when using `Generic` machinery, because PureScript always sorts them alphabetically. So, this module was invented to fix the order when deriving instances via `Generic`.

A quick usage example (`S` and `Z` are for type-level [Peano numbers](https://wiki.haskell.org/Peano_numbers)):

```purescript
data FType
  = F0
      { f0A :: BigInt
      }
  | F1
      { f1A :: Boolean
      , f1B :: Boolean
      , f1C :: Boolean
      }
  | F2
      { f2A :: BigInt
      , f2B :: FType
      }

instance
  HasPlutusSchema FType
    ( "F0" :=
          ( "f0A" := I BigInt
          :+ PNil)
       @@ Z

    :+ "F1" :=
          ( "f1A"  := I Boolean
          :+ "f1B" := I Boolean
          :+ "f1C" := I Boolean
          :+ PNil
          )
        @@ (S Z)

    :+ "F2" :=
          (  "f2A" := I BigInt
          :+ "f2B" := I FType
          :+ PNil
          )
        @@ (S (S Z))

    :+ PNil
    )


instance ToData FType where
  toData = genericToData

instance FromData FType where
  fromData = genericFromData
```
