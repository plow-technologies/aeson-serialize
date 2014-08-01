module Data.Aeson.Serialize where

import           Data.Aeson
import           Data.Serialize hiding (decode, encode)


putToJSON :: (ToJSON a) => Putter a
putToJSON = put . encode

getToJSON :: (FromJSON a) => Get a
getToJSON = get >>= (either fail return) . eitherDecode
