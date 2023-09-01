module Test (koer, fibonacci) where

import GHC
-- import GHC.Utils.Outputable
-- import GHC.Utils.DynFlags
import GHC.Driver.Session (defaultFatalMessager, defaultFlushOut)
import GHC.Paths ( libdir )
import Foreign.C.Types

fibonacci :: Int -> Int
fibonacci n = fibs !! n
    where fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

fibonacci_hs :: CInt -> CInt
fibonacci_hs = fromIntegral . fibonacci . fromIntegral

foreign export ccall fibonacci_hs :: CInt -> CInt

koer :: IO SuccessFlag
koer = defaultErrorHandler defaultFatalMessager defaultFlushOut $ do
    runGhc (Just libdir) $ do
        dflags <- getSessionDynFlags
        setSessionDynFlags dflags
        target <- guessTarget "test_main.hs" Nothing Nothing
        setTargets [target]
        load LoadAllTargets

-- targetFile = "B.hs"

-- main :: IO ()
-- main = do
--    res <- example
--    str <- runGhc (Just libdir) $ do
--       dflags <- getSessionDynFlags
--       return $ showSDoc dflags $ ppr res
--    putStrLn str

-- example = defaultErrorHandler defaultFatalMessager defaultFlushOut $ do
--       runGhc (Just libdir) $ do
--         dflags <- getSessionDynFlags
--         let dflags' = foldl xopt_set dflags [Opt_Cpp, Opt_ImplicitPrelude, Opt_MagicHash]
--         setSessionDynFlags dflags'
--         target <- guessTarget targetFile Nothing Nothing
--           [target]
--         load LoadAllTargets
--         modSum <- getModSummary $ mkModuleName "B"
--         p <- parseModule modSum
--         t <- typecheckModule p
--         d <- desugarModule t
--         l <- loadModule d
--         n <- getNamesInScope
--         c <- return $ coreModule d

--         g <- getModuleGraph
--         mapM showModule g
--         return $ (parsedSource d,"/n-----/n",  typecheckedSource d)
