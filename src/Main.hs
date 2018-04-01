{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import MyAeson

chrstmsly :: ScottyM ()
chrstmsly = do
  get "/" showLandingPage
  post "/" doTheParsing

showLandingPage :: ActionM ()
showLandingPage = do
  text "hello there"

doTheParsing :: ActionM ()
doTheParsing = do
  p <- jsonData :: ActionM Person 
  json p

main :: IO ()
main =
  scotty 9176 chrstmsly

