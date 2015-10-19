Snap bindings for the GitHub WebHook Handler
--------------------------------------------

This package contains the [snap][snap] specific implementation of the [GitHub
WebHook Handler][github-webhook-handler].


```haskell
import GitHub.Types                (Event)
import GitHub.WebHook.Handler      (Error)
import GitHub.WebHook.Handler.Snap (webhookHandler)

main :: IO ()
main = do
    quickHttpServe $
        -- Add a webhook to your organization or repository and configure it
        -- to send the payload to path "/webhook" and use the secret
        -- "secret^key".
        webhookHandler "/webhook" ["secret^key"] handleEvent

handleEvent :: Either Error (UUID, Event) -> Snap ()
handleEvent (Left e) = do
    -- Send a 4xx or 5xx response.
    return ()

handleEvent (Right (uuid, event)) =
    case event of
        (CommitCommentEventType e) -> do
            -- Somebody added a comment to a commit.
            return ()

        (DeploymentEventType e) -> do
            -- Somebody created a deployment.
            return ()

        _ -> do
            return ()
```


[snap]: http://snapframework.com/
[github-webhook-handler]: https://github.com/wereHamster/github-webhook-handler
