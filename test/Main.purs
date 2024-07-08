module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

main :: Effect Unit
main = do
  log "The tests for this package are located in purescript-cardano-types: https://github.com/mlabs-haskell/purescript-plutus-types/blob/master/test/Main.purs"
