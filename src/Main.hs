{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.Trans (liftIO)
import Web.Scotty
import MyAeson
import PeopleDB
import qualified Data.Aeson as A
import MyMongo

chrstmsly :: ScottyM ()
chrstmsly = do
  get "/" showLandingPage
  get "/:name" showPerson
  post "/" createPerson

showLandingPage :: ActionM ()
showLandingPage = do
  text "hello there"

createPerson :: ActionM ()
createPerson = do
  p <- jsonData :: ActionM Person 
  liftIO $ insertPersMongo p
  json p

showPerson :: ActionM()
showPerson = do
  n <- param "name"
  p <- liftIO $ findPersMongo n
  case p of
    Just match -> json match
    Nothing -> json $ A.object [ "error" A..= ("Not found: " ++ n) ]

main :: IO ()
main =
  scotty 9176 chrstmsly

