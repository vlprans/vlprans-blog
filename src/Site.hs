{-# LANGUAGE OverloadedStrings #-}

import           Data.Monoid (mappend)
import           Hakyll
import           Site.Filters
import           Site.Fields


myHakyllConf :: Configuration
myHakyllConf = defaultConfiguration
  { providerDirectory = "resources"
  }

main :: IO ()
main = hakyllWith myHakyllConf $ do
    match "images/*" $ do
      route   idRoute
      compile copyFileCompiler

    match "js/*.js" $ do
      route   idRoute
      compile copyFileCompiler

    match "styles/*.css" $ compileCssWith compressCssCompiler
    match "styles/*.less" $ compileCssWith lessCompiler

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/layout.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                  listField "posts" postCtx (return posts) `mappend`
                  constField "title" "Archives"            `mappend`
                  defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/layout.html" archiveCtx
                >>= relativizeUrls

    create ["index.html"] $ do
        route idRoute
        compile $ do
            makeItem ""
                >>= loadAndApplyTemplate "templates/index.html" archiveCtx
                >>= loadAndApplyTemplate "templates/layout.html" archiveCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler
