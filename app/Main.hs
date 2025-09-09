{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty

main :: IO ()
main = scotty 3000 $
  get "/auth" (do json ("Hello, World !" :: String))
