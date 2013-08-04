{-# LANGUAGE OverloadedStrings #-}

module Site.Filters (
  sassCompiler, sassRules
  ) where

import Hakyll

sassCompiler :: Compiler (Item String)
sassCompiler =
  getResourceString >>=
  withItemBody (unixFilter "sass" ["-s", "--scss"])

sassRules :: Rules ()
sassRules = do
  route $ setExtension "css"
  compile $ sassCompiler >> compressCssCompiler
