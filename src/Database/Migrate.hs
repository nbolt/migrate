module Database.Migrate where

data Result = Result Bool String

class Migratable m where
    migrate     :: Int -> m -> IO ()
    executeM    :: m -> IO Bool
    checkT      :: Int -> m -> IO Bool
    insertT     :: Int -> m -> IO Bool
    createTable :: m -> IO ()

