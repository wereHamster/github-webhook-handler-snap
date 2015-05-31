module GitHub.WebHook.Handler.Snap
  ( webhookHandler
  ) where


import           Data.ByteString
import qualified Data.ByteString.Lazy as LBS
import qualified Data.CaseInsensitive as CI

import           Snap.Core

import           GitHub.Types
import           GitHub.WebHook.Handler



webhookHandler :: ByteString -> Maybe String -> (Either Error Event -> Snap ()) -> Snap ()
webhookHandler hookPath mbSecretKey m =
    path hookPath $ method POST $ runHandler handler
  where
    handler = Handler
        { hSecretKey = mbSecretKey
        , hBody = fmap LBS.toStrict $ readRequestBody (100 * 1000)
        , hHeader = \name -> do
            hdrs <- headers <$> getRequest
            return $ getHeader (CI.mk name) hdrs
        , hAction = \res -> m res >> getResponse >>= finishWith
        }
