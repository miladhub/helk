{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.Trans (liftIO)
import Web.Scotty
import People
import PeopleRepo
import Data.Text.Lazy
import Network.HTTP.Types (status404)

helk :: ScottyM ()
helk = do
  get "/" showLandingPage
  get "/people/:name" showPerson
  get "/people/" showPeople
  post "/people/" createPerson

showLandingPage :: ActionM ()
showLandingPage = do
  readme <- liftIO $ readFile "README.md"
  text . pack $ readme
  return ()

createPerson :: ActionM ()
createPerson = do
  p <- jsonData :: ActionM Person 
  liftIO $ insertPersMongo p
  json p

showPeople :: ActionM ()
showPeople = do
  ps <- liftIO $ findPeople
  json ps

showPerson :: ActionM ()
showPerson = do
  n <- param "name"
  p <- liftIO $ findPersMongo n
  case p of
    Just match -> json match
    Nothing -> status status404

main :: IO ()
main =
  scotty 9176 helk

