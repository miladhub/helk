{-# LANGUAGE OverloadedStrings #-}

module PeopleRepo (findPeople, findPerson, createPerson, deletePerson) where

import Database.MongoDB
import qualified Database.MongoDB as M (lookup, find, select)
import Control.Monad.IO.Class
import People
import Control.Monad.Reader
import Data.Maybe

findPeople :: IO [Person]
findPeople =
  let docs = find (select [] "people") >>= rest
  in fmap fromDocs (onPeople docs)

findPerson :: String -> IO (Maybe Person)
findPerson n = do
  doc <- onPeople $ findOne $ select ["name" =: n] "people"
  return $ doc >>= fromDoc

createPerson :: Person -> IO ()
createPerson p = do
  onPeople $ insert "people" $ toDoc p
  return ()

deletePerson :: String -> IO ()
deletePerson n = do
  onPeople $ delete (select ["name" =: n] "people")

onPeople :: Action IO a -> IO a
onPeople act = do
  pipe <- connect $ host "127.0.0.1"
  r <- access pipe master "people" act
  close pipe
  return r

toDoc :: Person -> Document
toDoc p = ["name" =: (name p), "age" =: (age p)]

fromDocs :: [Document] -> [Person]
fromDocs ds = 
  let mp = fmap fromDoc ds
  in catMaybes mp

fromDoc :: Document -> Maybe Person
fromDoc = runReaderT $ do
  name <- getName
  age <- getAge
  return $ Person name age

getName :: ReaderT Document Maybe String
getName = ReaderT $ M.lookup "name"

getAge :: ReaderT Document Maybe Int
getAge = ReaderT $ M.lookup "age"
