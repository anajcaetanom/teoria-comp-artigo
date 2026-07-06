module Main ( 
  ProvisioningResult(..),
  ProvisioningError(..),
  provision,
  main
) where

import Domain.Types ( 
    Credentials,
    credentialsSSID,
    credentialsPassword,
    ssidValue,
    passwordValue
  )

import Domain.Parser ( 
    ParseError(..),
    parseCredentials
  )

import Domain.Grammar ( 
    ssidGrammar,
    passwordGrammar
  )

import Automata.DFA ( 
    DFA,
    Acceptance(..),
    fromGrammar,
    run
  )

-- --------------------------------------------------------------------------
-- Resultado do pipeline
-- --------------------------------------------------------------------------

newtype ProvisioningResult
  = Provisioned Credentials
  deriving Show

data ProvisioningError
  = RejectedByParser ParseError
  | RejectedByDFA String
  deriving Show

-- --------------------------------------------------------------------------
-- Pipeline
-- --------------------------------------------------------------------------

provision :: String -> String -> Either ProvisioningError ProvisioningResult
provision rawSSID rawPassword = do
  creds <- either (Left . RejectedByParser) Right
                  (parseCredentials rawSSID rawPassword)
  confirmSSID creds
  confirmPassword creds

  pure (Provisioned creds)
  where
    ssidDFA :: DFA
    ssidDFA = fromGrammar ssidGrammar

    passwordDFA :: DFA
    passwordDFA = fromGrammar passwordGrammar

    confirmSSID :: Credentials -> Either ProvisioningError ()
    confirmSSID creds =
      case run ssidDFA (ssidValue (credentialsSSID creds)) of
        Accepted _ -> Right ()
        Rejected   -> Left (RejectedByDFA "SSID rejeitado na reconfirmação pelo DFA")

    confirmPassword :: Credentials -> Either ProvisioningError ()
    confirmPassword creds =
      case run passwordDFA (passwordValue (credentialsPassword creds)) of
        Accepted _ -> Right ()
        Rejected   -> Left (RejectedByDFA "Password rejeitada na reconfirmação pelo DFA")

-- --------------------------------------------------------------------------
-- Simulação de execução (sem efeitos reais de rede/SO)
-- --------------------------------------------------------------------------

report :: String -> String -> IO ()
report rawSSID rawPassword =
  case provision rawSSID rawPassword of
    Right (Provisioned creds) ->
      putStrLn $ "ACCEPTED — SSID=" ++ ssidValue (credentialsSSID creds)
                 ++ " (credenciais reconhecidas pelo parser e confirmadas pelo DFA)"
    Left (RejectedByParser err) ->
      putStrLn $ "REJECTED [parser] — " ++ show err
    Left (RejectedByDFA reason) ->
      putStrLn $ "REJECTED [dfa]    — " ++ reason

main :: IO ()
main = do
  report "MinhaRedeCasa" "senhaSegura123"
  report "" "senhaSegura123"
  report ";$(cmd);#" "senhaSegura123"
  report "MinhaRedeCasa" "1234567"