{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.Trans (liftIO)
import Web.Scotty
import People
import PeopleRepo
import Data.Text.Lazy
import Network.HTTP.Types (status404)
import Network.Wai.Middleware.Cors

helk :: ScottyM ()
helk = do
  middleware simpleCors
  get "/" showLandingPage
  get "/people/:name" showPerson
  get "/people/" showPeople
  post "/people/" addPerson
  delete "/people/:name" removePerson

showLandingPage :: ActionM ()
showLandingPage = do
  readme <- liftIO $ readFile "README.md"
  text . pack $ readme
  return ()

addPerson :: ActionM ()
addPerson = do
  p <- jsonData :: ActionM Person 
  liftIO $ createPerson p
  json p

removePerson :: ActionM ()
removePerson = do
  n <- param "name"
  liftIO $ deletePerson n

showPeople :: ActionM ()
showPeople = do
  ps <- liftIO $ findPeople
  json ps

showPerson :: ActionM ()
showPerson = do
  n <- param "name"
  p <- liftIO $ findPerson n
  case p of
    Just match -> json match
    Nothing -> status status404

main :: IO ()
main =
  scotty 9176 helk

