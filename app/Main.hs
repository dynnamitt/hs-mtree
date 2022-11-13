module Main where

import Data.Maybe
import qualified Data.Text as T
import qualified Data.Text.IO as T
import System.Directory.Contents
import System.Environment (getArgs, getProgName)
import System.Exit

toolDescription :: String
toolDescription = "Traverse directory tool"

main :: IO ()
main = do
  startPath <- parseArgs
  putStrLn startPath
  t0 <- buildDirTree startPath
  let t2 = walkDirTree "./code" $ fromJust t0
  let t = fromJust t2
  T.putStrLn $ drawDirTree t

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
