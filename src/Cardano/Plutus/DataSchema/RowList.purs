module Cardano.Plutus.DataSchema.RowList
  ( class AllUniqueLabels
  , class SameLength
  ) where

import Type.RowList (class ListToRow)
import Prim.Row as R
import Prim.RowList as RL

-- | Uniqueness constraint on the labels of an unordered RowList
-- | Current implementation causes a compilation slowdown for complex types
-- | GH Issue: https://github.com/Plutonomicon/cardano-transaction-lib/issues/433
class AllUniqueLabels :: forall (k :: Type). RL.RowList k -> Constraint
class AllUniqueLabels list

class SameLength :: forall (a :: Type) (b :: Type). RL.RowList a -> RL.RowList b -> Constraint
class SameLength a b | a -> b

instance SameLength RL.Nil RL.Nil
instance SameLength as bs => SameLength (RL.Cons a ta as) (RL.Cons b tb bs)

instance
  ( R.Nub row nbd
  , RL.RowToList nbd nbdl
  , ListToRow rl row
  , SameLength rl nbdl
  ) =>
  AllUniqueLabels rl