{-# LANGUAGE OverloadedStrings #-}

module MyAeson where

import Data.Aeson

data Person =
  Person {
    name :: String
  , age :: Int
  }

instance Show Person where
  show p = name p ++ ", " ++ show (age p)

instance FromJSON Person where
  parseJSON = withObject "person" $ \o ->
      Person <$> o .: "name" <*> o .: "age"

instance ToJSON Person where
  toJSON p = object
    [
      "name" .= name p
    , "age"  .= age  p
    ]

