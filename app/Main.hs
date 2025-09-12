{-# LANGUAGE OverloadedStrings #-}
module Main where

import Env
import Control.Concurrent
import Control.Monad
import System.Environment
import Web.Browser
import Web.Scotty
import Web.Scotty.TLS

authUrl :: String
authUrl = "https://id.twitch.tv/oauth2/authorize"
          ++ "?response_type=" <> getEnv "RESPONSE_TYPE"
          ++ "&client_id=" <> getEnv "CLIENT_ID"
          ++ "&redirect_uri=" <> getEnv "REDIRECT_URI"
          ++ "&scope=" <> getEnv "SCOPE"

authenticationEndpoint :: IO ()
authenticationEndpoint = do
    scottyTLS 3000 "private.key" "certificate.crt" $ do
      get "/auth" $ do
        json ("Hello, World !" :: String)

authenticateUser :: IO ()
authenticateUser = do
  void $ openBrowser authUrl
      
secondsToMicroseconds :: Int -> Int
secondsToMicroseconds = (1000000 *)

wait :: Int -> IO ()
wait n = putStrLn "Loading ..."
  >> flip replicateM_ wait' n
  where
    wait' :: IO ()
    wait' = threadDelay $ secondsToMicroseconds 1

main :: IO ()
main = do
  loadEnvFile "twitch-chat-notifier.env"
  _ <- forkIO authenticationEndpoint
  threadDelay $ secondsToMicroseconds 3
  authenticateUser
  forever $ pure ()
