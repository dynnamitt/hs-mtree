{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Maybe
import qualified Data.Text as T
import qualified Data.Text.IO as T
import System.Environment (getArgs, getProgName)
import System.Exit
import System.Directory.Tree

toolDescription :: T.Text
toolDescription = "Traverse directory tool"

main :: IO ()
main = do
  startPath <- parseArgs
  (_ :/ Dir _ xs ) <- readDirectory startPath
  -- fail unless dir, since un-pure IO
  putStrLn $ meta xs 0

meta :: [DirTree a] -> Int -> String
meta [] _ = ""
meta ( x : xs) pad
  | null xs = pad' ++ n' x 
  | otherwise = pad' ++ n' x ++ "\n" ++ meta xs pad
  where 
    pad' = replicate pad ' '
    n' (Dir n c) = "[" ++ n ++ "]\n"  ++ meta c (pad + 2)
    n' (File n _) = n
    n' (Failed n err) = "err:" ++ n ++ ":" ++ show err 

-- help
usage :: IO ()
usage = do
  prog <- getProgName
  let prog' = T.pack prog
  T.putStrLn toolDescription
  putStrLn "usage:"
  putStrLn $ "  " ++ prog ++ " <Directory>"

--
-- args or death
parseArgs :: IO String
parseArgs = do
  let argsLen = 1
  args <- getArgs -- IO
  if length args /= argsLen
    then do
      usage
      exitWith $ ExitFailure 1
    else do
      -- TODO errorhandling
      return $ head args
