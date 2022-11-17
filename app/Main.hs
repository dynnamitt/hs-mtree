module Main where

import Data.Maybe
import qualified Data.Text as T
import qualified Data.Text.IO as T
import System.Environment (getArgs, getProgName)
import System.Exit
import System.Directory.Tree

toolDescription :: String
toolDescription = "Traverse directory tool"

main :: IO ()
main = do
  startPath <- parseArgs
  (_ :/ Dir _ xs ) <- readDirectory startPath
  -- fail unless dir, since un-pure IO
  print  (meta xs)


meta [] = ""
meta (x:xs) 
  | null xs = name x
  | otherwise = name x ++ "/ " ++ meta xs


-- help
usage :: IO ()
usage = do
  prog <- getProgName
  putStrLn toolDescription
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
