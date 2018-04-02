module PeopleDB where

import MyAeson
import Data.List.Split

{-
import Data.List.Split
let notempty c = length c  > 0
let l = lines <$> readFile "people.txt"
let pl = filter notempty <$> l
let ppl = (fmap $ splitOn " ") <$> pl
ppp <- ppl
let people = fmap (\s -> Person (s !! 0) (read $ s !! 1)) ppp
-}

notempty :: String -> Bool
notempty c = length c > 0

people :: String -> IO [Person]
people fileName = do
  lle <- lines <$> readFile fileName
  let ll = filter notempty lle
      ppl = fmap (splitOn " ") ll
      people = fmap (\s -> Person (s !! 0) (read $ s !! 1)) ppl
  return people

first :: [Person] -> Maybe Person
first matches =
  case matches of (h : _) -> Just h
                  _   -> Nothing
                  
findPerson :: String -> IO (Maybe Person)
findPerson n = do
  all <- people "people.txt"
  let matches = filter (\p -> (name p) == n) all
  return $ first matches

