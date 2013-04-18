module Main where

import System.Directory
import Data.UnixTime

main :: IO ()
main = do
    now    <- getUnixTime
    exists <- doesFileExist "migrations.hs"
    if exists
      then return ()
      else createMigrationsFile
    appendFile "migrations.hs" $ newMigration now

createMigrationsFile :: IO ()
createMigrationsFile = writeFile "migrations.hs" $
    unlines ["import Database.Migrate.MyBackend", "",
             "main = do", "    createTableIfNonExistent Migratable", "    newMigration"]

newMigration :: UnixTime -> String
newMigration time =
    unlines ["", "newMigration :: IO Result",
             "newMigration = migrate " ++ (show $ utSeconds time) ++ " Migratable", ""]

