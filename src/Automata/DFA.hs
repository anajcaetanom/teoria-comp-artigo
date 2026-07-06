-- Automata/DFA.hs
module Automata.DFA ( 
  State(..),
  DFA(..),
  Acceptance(..),
  fromGrammar,
  step,
  run
) where

import Data.Set (Set)
import qualified Data.Set as Set

import Domain.Grammar (Grammar(..), isSafeChar)



data State
  = Counting Int
  | Dead
  deriving (Eq, Ord, Show)

data DFA = DFA { 
  dfaStates      :: Set State,              -- ^ Q
  dfaStart       :: State,                  -- ^ q0
  dfaAccepting   :: Set State,              -- ^ F
  dfaTransition  :: State -> Char -> State  -- ^ δ : Q × Σ → Q
}


fromGrammar :: Grammar -> DFA
fromGrammar grammar =
  DFA { 
    dfaStates     = Set.fromList (Dead : map Counting [0 .. maxLen]),
    dfaStart      = Counting 0,
    dfaAccepting  = Set.fromList
        [ Counting n | n <- [0 .. maxLen], n >= minLen ],
    dfaTransition = transitionFor grammar
  } where
      maxLen = grammarMaxLength grammar
      minLen = grammarMinLength grammar

transitionFor :: Grammar -> State -> Char -> State
transitionFor _       Dead _ = Dead
transitionFor grammar (Counting n) c
  | n < grammarMaxLength grammar && isSafeChar c = Counting (n + 1)
  | otherwise                                    = Dead


data Acceptance
  = Accepted State
  | Rejected
  deriving (Eq, Show)

step :: DFA -> State -> Char -> State
step dfa = dfaTransition dfa

run :: DFA -> String -> Acceptance
run dfa input =
  let finalState = foldl (step dfa) (dfaStart dfa) input
  in if finalState `Set.member` dfaAccepting dfa
       then Accepted finalState
       else Rejected