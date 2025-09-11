{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Concurrent
import Control.Monad
import Web.Browser
import Web.Scotty
import Web.Scotty.TLS

authUrl :: String
authUrl = "https://id \
          \ .twitch.tv/oauth2/authorize"

authenticationEndpoint :: IO ()
authenticationEndpoint = do
    scottyTLS 3000 "private.key" "certificate.crt" $ do
      get "/auth" $ do
        json ("Hello, World !" :: String)

authenticateUser :: IO ()
authenticateUser = do
  void $ openBrowser authUrl
      
main :: IO ()
main = do
  done1 <- newEmptyMVar
  done2 <- newEmptyMVar
  
  _ <- forkFinally authenticationEndpoint (\_ -> putMVar done1 ())
  _ <- forkFinally authenticateUser (\_ -> putMVar done2 ())
  
  takeMVar done1
  takeMVar done2
