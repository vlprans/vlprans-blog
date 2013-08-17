{-# LANGUAGE OverloadedStrings #-}

module Site.Filters (
  sassCompiler, lessCompiler, compileCssWith
  ) where

import Hakyll

type CssCompiler = Compiler (Item String)

sassCompiler :: CssCompiler
sassCompiler =
  getResourceString >>=
  withItemBody (unixFilter "sass" ["-s", "--scss"])

lessCompiler :: CssCompiler
lessCompiler =
  getResourceString >>=
  withItemBody (unixFilter "lessc" ["-","--yui-compress","-O2"])

compileCssWith :: CssCompiler -> Rules ()
compileCssWith compiler = do
  route $ setExtension "css"
  compile $ compiler >> compressCssCompiler
