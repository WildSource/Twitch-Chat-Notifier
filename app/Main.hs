{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty

main :: IO ()
main = scotty 3000 $
  get "/hello" (do json ("Hello, World !" :: String))
