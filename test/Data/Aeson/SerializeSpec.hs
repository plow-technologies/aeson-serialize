{-# LANGUAGE DeriveGeneric #-}
module Data.Aeson.SerializeSpec where

import Test.Hspec
import Data.Serialize
import Data.Aeson hiding (encode,decode)
import Data.Aeson.Serialize
import GHC.Generics
import Test.HUnit

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Serializing/Deserializing simple objects" $ do
    it "Should serialize and deserialize simple data types" $ do
      let x = IntWrapper 5
          encoded = encode x
          (Right decoded) = decode encoded
      decoded `shouldBe` x
  describe "Serializing/Deserializing nested objects" $ do
    it "Should seriealize and deserialize a complex nested type" $ do
      let d :: TestingData (TestingData (TestingData (Maybe Int) (Either (Either () (Maybe (Either () [Char]))) ()))  (TestingData  (TestingData (Maybe ()) [Char]) (TestingData [Char] (Maybe (Either (Either () [Char]) ()))))) [Char]
          d = TestingData {testingNumber = 4, testingFirst = TestingData {testingNumber = 10, testingFirst = TestingData {testingNumber = 14, testingFirst = Just 10, testingSecond = Left (Right (Just (Right "This is a test")))}, testingSecond = TestingData {testingNumber = 11, testingFirst = TestingData {testingNumber = 10, testingFirst = Nothing, testingSecond = "This isn't very testy"}, testingSecond = TestingData {testingNumber = 123, testingFirst = "Forever", testingSecond = Just (Left (Right "Totally"))}}}, testingSecond = "Hello"}
          encoded = encode d
          (Right decoded) = decode encoded :: Either String (TestingData (TestingData (TestingData (Maybe Int) (Either (Either () (Maybe (Either () [Char]))) ()))  (TestingData  (TestingData (Maybe ()) [Char]) (TestingData [Char] (Maybe (Either (Either () [Char]) ()))))) [Char])
      print . encode $ decoded
      decoded `shouldBe` d

newtype IntWrapper = IntWrapper { unIntWrapper :: Int } deriving (Eq, Show, Generic)

instance FromJSON IntWrapper where
instance ToJSON IntWrapper where

instance Serialize IntWrapper where
  get = getFromJSON
  put = putToJSON

data TestingData a b= TestingData {
  testingNumber :: Int
, testingFirst :: a
, testingSecond :: b
} deriving (Eq, Show, Generic)

instance (FromJSON a, FromJSON b) => FromJSON (TestingData a b) where
instance  (ToJSON a, ToJSON b) =>  ToJSON (TestingData a b) where

instance (FromJSON a, FromJSON b, ToJSON a, ToJSON b) => Serialize (TestingData a b) where
  get = getFromJSON
  put = putToJSON