import System.Exit
import System.Environment
import System.Directory
import Control.Exception
import System.IO.Error
import Data.Typeable
import GHC.IO.Exception


toolDescription = "Traverse directory tool"

main :: IO ()
main = do 
  startPath <- parseArgs
  putStrLn $ "running down:" ++ startPath
  getFiles startPath


getFiles :: FilePath -> IO ()
getFiles startDir = do
  files <- tryJust handleListErrors (listDirectory startDir)
  case files of
    Left errMsg -> putStrLn $ show errMsg
    Right fileNames -> mapM_ hFile fileNames
  where
    hFile f = putStrLn f

data ListError = DoesNotExist
                | NoAccess
                | DiskFull
                | HardwareIssue
                | BadName
                | WrongType
                | OtherIOErr IOError
                deriving (Show,Eq)

handleListErrors :: IOError -> Maybe ListError
handleListErrors err
  -- https://hackage.haskell.org/package/directory-1.3.8.0/docs/System-Directory.html#v:listDirectory
  -- can fail in 6 expected ways
  | isDoesNotExistError err = Just DoesNotExist
  | isPermissionError err = Just NoAccess
  | isFullError err = Just DiskFull 
  | otherwise = -- lower-level 
      case err of
        IOError _ HardwareFault _ _ _ _ -> Just HardwareIssue
        IOError _ InvalidArgument _ _ _ _ -> Just BadName
        IOError _ InappropriateType _ _ _ _ -> Just WrongType
        otherwise -> Just $ OtherIOErr err

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


