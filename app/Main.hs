import System.Exit
import System.Environment
import System.Directory

toolDescription = "Traverse directory tool"

main :: IO ()
main = do 
  startPath <- parseArgs
  putStrLn $ "Hello, World!" ++ startPath 
  files <- listDirectory startPath
  mapM_ putStrLn files


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


