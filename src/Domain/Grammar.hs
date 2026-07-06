-- Domain/Grammar.hs

module Domain.Grammar ( 
  SafeChar,
  safeAlphabet,
  isSafeChar,

  Grammar(..),
  ssidGrammar,
  passwordGrammar,
) where

import Data.Set (Set)
import qualified Data.Set as Set

-- --------------------------------------------------------------------------
-- Alfabeto seguro (Σsafe)
-- --------------------------------------------------------------------------

type SafeChar = Char

safeAlphabet :: Set SafeChar
safeAlphabet = Set.fromList $
  ['A'..'Z'] ++
  ['a'..'z'] ++
  ['0'..'9'] ++
  ['-', '_']

isSafeChar :: Char -> Bool
isSafeChar c = c `Set.member` safeAlphabet

-- --------------------------------------------------------------------------
-- Gramática: comprimento + alfabeto
-- --------------------------------------------------------------------------

data Grammar = Grammar { 
  grammarMinLength :: Int,
  grammarMaxLength :: Int,
  grammarAlphabet  :: Set SafeChar
} deriving (Eq, Show)

ssidGrammar :: Grammar
ssidGrammar = Grammar { 
  grammarMinLength = 1,
  grammarMaxLength = 32,
  grammarAlphabet  = safeAlphabet
}

passwordGrammar :: Grammar
passwordGrammar = Grammar { 
  grammarMinLength = 8,
  grammarMaxLength = 63,
  grammarAlphabet  = safeAlphabet
}