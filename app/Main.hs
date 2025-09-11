{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Concurrent
import Control.Monad
import Web.Browser
import Web.Scotty
import Web.Scotty.TLS

authenticationEndpoint :: IO ()
authenticationEndpoint = do
    scottyTLS 3000 "private.key" "certificate.crt" $ do
      get "/auth" $ do
        json ("Hello, World !" :: String)
      
main :: IO ()
main = do
  thread1 <- forkIO authenticationEndpoint
  thread2 <- forkIO $ void $ openBrowser "https://id.twitch.tv/oauth2/authorize"
  pure ()

