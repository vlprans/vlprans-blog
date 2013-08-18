{-# LANGUAGE OverloadedStrings #-}
module Site.Fields (
  postCtx, archiveCtx
  ) where

import           Data.Monoid (mappend, mconcat)
import           Hakyll

postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

archiveCtx :: Context String
archiveCtx = mconcat
  [ listField "posts" postCtx posts
  , constField "title" "Archive"
  , defaultContext
  ] where posts = recentFirst =<< loadAll "posts/*"
