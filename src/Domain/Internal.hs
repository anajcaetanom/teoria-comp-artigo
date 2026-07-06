-- Domain/Internal.hs

module Domain.Internal ( 
  SSID(..),
  Password(..),
  Credentials(..)
) where

newtype SSID = SSID String
  deriving (Eq, Show)

newtype Password = Password String
  deriving (Eq, Show)

data Credentials = Credentials { 
  credentialsSSID     :: SSID,
  credentialsPassword :: Password
} deriving (Eq, Show)