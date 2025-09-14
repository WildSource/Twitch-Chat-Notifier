{-# LANGUAGE OverloadedStrings #-}
module Main where

import Env
import Control.Concurrent
import Control.Monad
import System.Environment
import Web.Browser
import Web.Scotty
import Web.Scotty.TLS

authUrl :: IO String
authUrl = do
  let (uri, params') = deconstruct authParams
  values <- traverse getEnv keys
  
  let uriParams = cons params' values

  pure $ uri ++ (cons' uriParams)

  where
    deconstruct :: [String] -> (String, [String])
    deconstruct [] = ("", [])
    deconstruct l = (head l, tail l)

    cons :: [String] -> [String] -> [String]
    cons [] [] = []
    cons (x:xs) (z:zs) = (x ++ z) : cons xs zs

    cons' :: [String] -> String
    cons' [] = ""
    cons' (x:xs) = x ++ cons' xs
    
    authParams :: [String]
    authParams = [ "https://id.twitch.tv/oauth2/authorize"
                 , "?response_type="
                 , "&client_id="
                 , "&redirect_uri="
                 , "&scope="
                 ]
             
    keys :: [String]
    keys = [ "RESPONSE_TYPE"
           , "CLIENT_ID"
           , "REDIRECT_URI"
           , "SCOPE"
           ]

authenticationEndpoint :: IO ()
authenticationEndpoint = do
    putStrLn "Starting Server ..."
    scottyTLS 3000 "private.key" "certificate.crt" $ do
      get "/authentication" $ do
        json ("Hello, World !" :: String)

authenticateUser :: IO ()
authenticateUser = do
  url <- authUrl
  void $ openBrowser url
      
wait :: Int -> IO ()
wait n = putStrLn "Loading ..."
  >> replicateM_ n wait'
  where
    wait' :: IO ()
    wait' = threadDelay $ secondsToMicroseconds 1
    
    secondsToMicroseconds :: Int -> Int
    secondsToMicroseconds = (1000000 *)
    
main :: IO ()
main = do
  loadEnvFile "twitch-chat-notifier.env"
  
  _ <- forkIO authenticationEndpoint
  wait 3
  
  authenticateUser
  
  forever $ pure ()
