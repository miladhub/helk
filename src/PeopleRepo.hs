{-# LANGUAGE OverloadedStrings #-}

module PeopleRepo where

import Database.MongoDB
import qualified Database.MongoDB as M (lookup, find, select)
import Control.Monad.IO.Class
import People
import Control.Monad.Reader
import Data.Maybe

ppl :: Action IO a -> IO a
ppl act = do
    pipe <- connect $ host "127.0.0.1"
    r <- access pipe master "people" act
    close pipe
    return r

findPeople :: IO [Person]
findPeople =
  let docs = find (select [] "people") >>= rest
  in fmap fromDocs (ppl docs)

findPersMongo :: String -> IO (Maybe Person)
findPersMongo n = do
    doc <- ppl $ findOne $ select ["name" =: n] "people"
    return $ doc >>= fromDoc

insertPersMongo :: Person -> IO ()
insertPersMongo p = do
    ppl $ insert "people" $ toDoc p
    return ()

toDoc :: Person -> Document
toDoc p = ["name" =: (name p), "age" =: (age p)]

fromDocs :: [Document] -> [Person]
fromDocs ds = 
  let mp = fmap fromDoc ds
  in fmap fromJust $ Prelude.filter isJust $ mp

fromDoc :: Document -> Maybe Person
fromDoc = runReaderT $ do
  name <- getName
  age <- getAge
  return $ Person name age

getName :: ReaderT Document Maybe String
getName = ReaderT $ M.lookup "name"

getAge :: ReaderT Document Maybe Int
getAge = ReaderT $ M.lookup "age"
