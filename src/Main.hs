{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import MyAeson

chrstmsly :: ScottyM ()
chrstmsly = do
  get "/" showLandingPage
  get "/:name" showPerson
  post "/" doTheParsing

showLandingPage :: ActionM ()
showLandingPage = do
  text "hello there"

doTheParsing :: ActionM ()
doTheParsing = do
  p <- jsonData :: ActionM Person 
  json p

showPerson :: ActionM()
showPerson = do
  n <- param "name"
  json $ Person n 42

main :: IO ()
main =
  scotty 9176 chrstmsly

