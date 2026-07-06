-- Domain/Parser.hs

module Domain.Parser ( 
  ParseError(..),
  parseSSID,
  parsePassword,
  parseCredentials
) where

import Domain.Internal (SSID(..), Password(..), Credentials(..))

import Domain.Grammar (
    Grammar(..),
    ssidGrammar,
    passwordGrammar,
    isSafeChar
  )

-- --------------------------------------------------------------------------
-- Erros de parsing
-- --------------------------------------------------------------------------

data ParseError
  = InvalidChar { 
      errChar     :: Char,  
      errPosition :: Int  
    }
  | InvalidLength { 
      errMin    :: Int,
      errMax    :: Int,
      errActual :: Int
    }
  deriving (Eq, Show)

-- --------------------------------------------------------------------------
-- Reconhecedor genérico 
-- --------------------------------------------------------------------------

recognize :: Grammar -> String -> Either ParseError String
recognize grammar input =
  case findFirstInvalidChar input of
    Just (c, pos) -> Left (InvalidChar c pos)
    Nothing ->
      let len = length input
      in if len >= grammarMinLength grammar && len <= grammarMaxLength grammar
           then Right input
           else Left (InvalidLength (grammarMinLength grammar)
                                     (grammarMaxLength grammar)
                                     len)
  where
    findFirstInvalidChar :: String -> Maybe (Char, Int)
    findFirstInvalidChar =
      go 0
      where
        go _ [] = Nothing
        go i (x:xs)
          | isSafeChar x = go (i + 1) xs
          | otherwise    = Just (x, i)

-- --------------------------------------------------------------------------
-- Parsers específicos do domínio
-- --------------------------------------------------------------------------

parseSSID :: String -> Either ParseError SSID
parseSSID input = SSID <$> recognize ssidGrammar input

parsePassword :: String -> Either ParseError Password
parsePassword input = Password <$> recognize passwordGrammar input

parseCredentials :: String -> String -> Either ParseError Credentials
parseCredentials rawSSID rawPassword = do
  ssid     <- parseSSID rawSSID
  password <- parsePassword rawPassword
  pure (Credentials ssid password)