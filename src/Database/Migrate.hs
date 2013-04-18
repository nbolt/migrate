module Main where

import System.Directory
import Data.UnixTime

data Result = Result String Bool

class Migratable m where
    migrate :: Int -> m -> IO ()

main :: IO ()
main = do
    now    <- getUnixTime
    exists <- doesFileExist "migrations.hs"
    if exists
      then return ()
      else createMigrationsFile
    appendFile "migrations.hs" $ newMigration now

createMigrationsFile :: IO ()
createMigrationsFile = writeFile "migrations.hs" $ unlines ["main = do", "    newMigration"]

newMigration :: UnixTime -> String
newMigration time =
    unlines ["", "newMigration :: IO Result",
             "newMigration = migrate " ++ (show $ utSeconds time) ++ " Migratable", ""]

