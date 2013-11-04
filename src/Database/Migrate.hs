module Database.Migrate where

import Control.Monad.State
import Control.Monad.Trans.State as TS

class Migratable m where
    createDB    :: StateT m IO Bool
    createTable :: StateT m IO Bool
    migrate     :: Integer -> m -> StateT m IO Bool
    checkT      :: Integer -> m -> StateT m IO Bool
    insertT     :: Integer -> m -> StateT m IO Bool
    executeM    :: m -> m -> StateT m IO Bool

    migrate t q = do
        h <- TS.get
        let m = "migration " ++ show t ++ ": "
        exists <- checkT t h
        if exists
          then return True
          else do
              inserted <- insertT t h
              if not inserted
                then error $ m ++ "timestamp insertion failed"
                else do
                    success <- executeM q h
                    if success
                      then return True
                      else error    $ m ++ "failed"

