module Data.Aeson.Serialize where

import           Data.Aeson
import           Data.Serialize hiding (decode, encode)

-- | put function for all serialization of a json type
putToJSON :: (ToJSON a) => Putter a
putToJSON = put . encode

-- | get function for all deserialization of a json type
getFromJSON :: (FromJSON a) => Get a
getFromJSON = get >>= (either fail return) . eitherDecode


-- The intended use is to define an instance of Serialize where get and put are putToJSON and getFromJSON respectively