{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Web.Scotty.TLS

main :: IO ()
main = scottyTLS 3000 "private.key" "certificate.crt" $ do
  get "/auth" $ do
    json ("Hello, World !" :: String)
