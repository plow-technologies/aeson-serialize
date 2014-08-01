module Data.Aeson.Serialize where

import           Data.Aeson
import           Data.Serialize hiding (decode, encode)


putToJSON :: (ToJSON a) => Putter a
putToJSON = put . encode

getFromJSON :: (FromJSON a) => Get a
getFromJSON = get >>= (either fail return) . eitherDecode
