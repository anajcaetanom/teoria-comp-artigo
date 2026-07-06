-- Domain/Types.hs

module Domain.Types ( 
  SSID,
  Password,
  Credentials,
  credentialsSSID,
  credentialsPassword,
  ssidValue,
  passwordValue
) where

import Domain.Internal (SSID(..), Password(..), Credentials(..))

ssidValue :: SSID -> String
ssidValue (SSID s) = s

passwordValue :: Password -> String
passwordValue (Password p) = p