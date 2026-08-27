#!/usr/bin/env runghc


-- ================================================================
-- GHC OPTIONS
-- ================================================================


{-# OPTIONS_GHC -Wno-tabs #-} -- Make GHC stop nagging about tabs


-- ================================================================
-- IMPORTS
-- ================================================================


-- import Control.Monad (filterM) --> TODO: Delete later if still unused
import System.Directory (listDirectory, doesDirectoryExist)
import System.FilePath ((</>))

import Text.Pretty.Simple (pPrint)


-- ================================================================
-- CONSTANTS
-- ================================================================


outputFileCSV :: FilePath = "jellyfin-videos.csv" -- NB: Not yet in use
outputFileRaw :: FilePath = "jellyfin-videos.txt" -- NB: Not yet in use


-- ================================================================
-- DATA TYPES FOR PATH LEVELS
-- ================================================================


data Category = Films | FilmsShort | Series
	deriving (Eq, Bounded, Enum)

instance Show Category where
	show Films      = "Films"
	show FilmsShort = "Films-Short"
	show Series     = "Series"


data Progress = C | I | O | U
	deriving (Eq, Show, Bounded, Enum)


data Type = Documentary | Fiction | AnyType
	deriving (Eq, Bounded, Enum)

instance Show Type where
	show Documentary = "Documentary"
	show Fiction     = "Fiction"
	show AnyType     = "Any"


data Style = Animated | LA | AnyStyle
	deriving (Eq, Bounded, Enum)

instance Show Style where
	show Animated = "Animated"
	show LA       = "LA"
	show AnyStyle = "Any"


data Source = Rip | Network | Dailymotion | InternetArchive | YouTube
	deriving (Eq, Bounded, Enum)

instance Show Source where
	show Rip             = "Rip"
	show Network         = "Network"
	show Dailymotion     = "Dailymotion"
	show InternetArchive = "Internet-Archive"
	show YouTube         = "YouTube"


-- ================================================================
-- SPECS FOR PATHS
-- ================================================================


data PathRecords = PathRecords
	{ categoryDir :: !Category
	, progressDir :: !Progress
	, typeDir     :: !Type
	, styleDir    :: !Style
	, sourceDir   :: !Source
	}
	deriving Show


-- ================================================================
-- PATH BUILDER
-- ================================================================


buildPathRecords :: Category -> [PathRecords]
buildPathRecords cat =
	[ PathRecords
		{ categoryDir = cat
		, progressDir = p
		, typeDir     = t
		, styleDir    = s
		, sourceDir   = src
		}
	| p   <- ([minBound .. maxBound] :: [Progress])
	, t   <- ([minBound .. maxBound] :: [Type])
	, s   <- ([minBound .. maxBound] :: [Style])
	, src <- ([minBound .. maxBound] :: [Source]) ]


joinPaths :: PathRecords -> FilePath
joinPaths PathRecords
	{ categoryDir = cat, progressDir = p, typeDir = t, styleDir = s, sourceDir = src } =
	  show cat    </>    show p      </>  show t  </>  show s   </>  show src


-- ================================================================
-- MAIN
-- ================================================================


main :: IO ()
main = do

	putStrLn "main : calling `buildPathRecords Films`"
	putStrLn ""
	let result = buildPathRecords Films -- TODO: Replace later with next two lines
	putStrLn "main : pPrint : result <- buildPathRecords Films" -- TODO: Replace later with next two lines
	-- let result = concatMap buildPathRecords ([minBound .. maxBound] :: [Category])
	-- putStrLn "main : pPrint : result = concatMap buildPathRecords ([minBound .. maxBound] :: [Category])"
	pPrint result
	putStrLn ""

	putStrLn "main : calling `map joinPaths result`"
	let joinedPaths = map joinPaths result
	putStrLn "main : pPrint : joinedPath = map joinPaths result"
	pPrint joinedPaths
	putStrLn ""

	return ()


-- ================================================================
