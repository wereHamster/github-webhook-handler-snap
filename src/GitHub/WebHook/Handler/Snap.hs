module GitHub.WebHook.Handler.Snap
  ( module GitHub.WebHook.Handler
  , webhookHandler
  ) where


import           Control.Applicative

import           Data.ByteString
import qualified Data.ByteString.Lazy as LBS
import qualified Data.CaseInsensitive as CI

import           Data.UUID

import           Snap.Core

import           GitHub.Types
import           GitHub.WebHook.Handler

import           Prelude



webhookHandler :: ByteString -> [String] -> (Either Error (UUID, Payload) -> Snap ()) -> Snap ()
webhookHandler hookPath secretKeys m =
    path hookPath $ method POST $ runHandler handler
  where
    handler = Handler
        { hSecretKeys = secretKeys
        , hBody = fmap LBS.toStrict $ readRequestBody (100 * 1000)
        , hHeader = \name -> do
            hdrs <- headers <$> getRequest
            return $ getHeader (CI.mk name) hdrs
        , hAction = \res -> m res >> getResponse >>= finishWith
        }
