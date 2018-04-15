{-# LANGUAGE OverloadedStrings #-}

module MyMongo where

import Database.MongoDB
import qualified Database.MongoDB as M (lookup)
import Control.Monad.IO.Class
import MyAeson

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
fromDoc d = do
    n <- getName d
    a <- getAge d
    return $ Person n a

getName :: Document -> Maybe String
getName d = M.lookup "name" d :: Maybe String

getAge :: Document -> Maybe Int
getAge d = M.lookup "age" d :: Maybe Int
