{-# LANGUAGE OverloadedStrings #-}

module MyMongo where

import Database.MongoDB
import Control.Monad.IO.Class

ppl :: Action IO a -> IO a
ppl act = do
    pipe <- connect $ host "127.0.0.1"
    r <- access pipe master "people" act
    close pipe
    return r
