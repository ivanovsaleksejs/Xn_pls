module Bot.Messaging where

import Data.Maybe
import Data.Acid

import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad.IfElse
import Control.Monad.RWS hiding (join)

import Prelude hiding (putStrLn)
import System.IO hiding (hGetLine, putStrLn)
import System.IO.UTF8
import System.Random

import Bot.Config
import Bot.General
import Bot.Commands
import Bot.Commands.Time

yieldCmd :: a -> (a -> Bool) -> (a -> b) -> (Maybe b)
yieldCmd a cond f
    | cond a    = Just $ f a
    | otherwise = Nothing


listen :: AcidState (EventState AddMessage) -> Net ()
listen acidStack = do

    handle <- asks socket
    env    <- ask
    forever $ do

        line   <- fmap init . liftIO . hGetLine $ handle
        now    <- liftIO nowtime
        stack  <- get

        liftIO $ putStrLn line
        -- If message is on channel, save it in State monad and acid-state base
        whenM (return $ isChan line) $ do
            let msg = (now, line)
            put    $ take 200 $ msg : stack
            liftIO $ update acidStack (AddMessage msg)

        -- Find a appropriate command to execute.
        let cmd = fromJust . msum . map (uncurry $ yieldCmd line) $ commands

        liftIO . forkIO . void $ runRWST cmd env stack

forwardOutput :: Net ()
forwardOutput = do
    q <- asks quick
    s <- asks slow
    forever $ do
        liftIO $ threadDelay =<< fmap interval randomIO
        msg <- liftIO . atomically $ readTChan q `orElse` readTChan s
        write "PRIVMSG" msg
        where
            interval = (*10^5) . (+) 5 . flip mod 10
