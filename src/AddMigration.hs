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
    unlines ["import Control.Monad.State", "import Database.Migrate", "import Database.Migrate.Backend", "import Database.Backend", "",
             "main = do", "    handle <- liftIO $ dbHandle", "    runStateT migrations Migratable", "",
             "migrations = do", "    createTable", ""]

newMigration :: UnixTime -> String
newMigration time =
    unlines ["", "newMigration = migrate " ++ (show $ utSeconds time) ++ " Migratable"]

