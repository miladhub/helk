{-# LANGUAGE OverloadedStrings #-}

module MyMongo where

import Database.MongoDB
import qualified Database.MongoDB as M (lookup)
import Control.Monad.IO.Class
import MyAeson
import Control.Monad.Reader

ppl :: Action IO a -> IO a
ppl act = do
    pipe <- connect $ host "127.0.0.1"
    r <- access pipe master "people" act
    close pipe
    return r

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

fromDoc :: Document -> Maybe Person
fromDoc = runReader $ do
    maybeName <- getName
    maybeAge <- getAge
    return $ do
        name <- maybeName
        age <- maybeAge
        return $ Person name age

getName :: Reader Document (Maybe String)
getName = do
    doc <- ask
    return (M.lookup "name" doc :: Maybe String)

getAge :: Reader Document (Maybe Int)
getAge = do
    doc <- ask
    return (M.lookup "age" doc :: Maybe Int)
