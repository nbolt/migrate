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
    unlines ["import Data.Yaml", "import qualified Data.HashMap.Lazy as HM", "import qualified Data.Text as T", "import Control.Monad.State", "import Database.Migrate", "import Database.Migrate.Backend", "import Database.Backend", "",
             "main = do", "    params' <- decodeFile \"migrations.yml\" :: IO (Maybe Value)", "    case params' of", "        Nothing     -> putStrLn \"migrations.yml file not found\"", "        Just params -> do",
             "            let", "                Object json = toJSON params", "                Just (String dbName) = HM.lookup (T.pack \"database\") json",
             "            handle' <- liftIO Migratable", "            runStateT migrations handle", "            return ()", "",
             "migrations = do", "    createDB", "    createTable"]

newMigration :: UnixTime -> String
newMigration time =
    unlines ["", "newMigration = migrate " ++ (show $ utSeconds time) ++ " Migratable"]

