{-# LANGUAGE OverloadedStrings #-}

module MyAeson where

import Data.Aeson
import GHC.Exts
import qualified Data.HashMap.Strict as HM
import qualified Data.Text as T
import Data.Aeson.Types
import qualified Data.Vector as V

{-
:set -XOverloadedStrings
let obj = fromList [("a", (Bool True)), ("b", (Bool False))] :: Object
let p = parseTuple $ Object obj

let v = Array $ fromList [ Object ( fromList [ ("a", String "hello"), ("b", Bool True) ] ), Object ( fromList [ ("a", String "hello"), ("b", Bool True) ] ) ]
parseMaybe parseArray v
-}

{-
:set -XOverloadedStrings
let o = Object $ fromList [("foo", Number 42)]
let obj = fromList [("foo", Number 42)] :: Object
HM.lookup "foo" obj
let p = parseTuple $ Object obj

let obj = fromList [("foo", Bool True), ("bar", Bool False)] :: Object
-}

parseTuple :: Value -> Parser (String, Bool)

{-
parseTuple (Object obj) = do
  -- Look up the "a" field.
  let mbFieldA = HM.lookup "a" obj

  -- Fail if it wasn't found.
  fieldA <- case mbFieldA of
    Just x  -> return x
    Nothing -> fail "no field 'a'"

  -- Extract the value from it, or fail if it's of the wrong type.
  a <- case fieldA of
    String x -> return (T.unpack x)
    _        -> fail "expected a string"

  -- Do all the same for "b" (in a slightly terser way, to save space):
  b <- case HM.lookup "b" obj of
    Just (Bool x) -> return x
    Just _        -> fail "expected a boolean"
    Nothing       -> fail "no field 'b'"

  -- That's all!
  return (a, b)
-}

parseTuple = withObject "tuple" $ \o -> do
  a <- o .: "a"
  b <- o .: "b"
  return (a, b)

parseArray :: Value -> Parser [(String, Bool)]
parseArray (Array arr) = mapM parseTuple (V.toList arr)
parseArray _           = fail "expected an array"

data Person = Person {name :: String, age :: Int}

instance FromJSON Person where
  parseJSON = withObject "person" $ \o ->
      Person <$> o .: "name" <*> o .: "age"

instance ToJSON Person where
  toJSON p = object [
      "name" .= name p,
          "age"  .= age  p ]

