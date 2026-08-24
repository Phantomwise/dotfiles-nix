#!/usr/bin/env runghc


-- ================================================================
-- GHC OPTIONS
-- ================================================================


{-# OPTIONS_GHC -Wno-tabs #-} -- Make GHC stop nagging about tabs


-- ================================================================
-- IMPORTS
-- ================================================================


import Control.Monad (filterM)
import System.Directory (listDirectory, doesDirectoryExist)
import System.FilePath ((</>))

import Text.Pretty.Simple (pPrint)


-- ================================================================
-- CONSTANTS
-- ================================================================


outputFileCSV :: FilePath = "jellyfin-videos.csv"
outputFileRaw :: FilePath = "jellyfin-videos.txt"


-- ================================================================
-- DATA TYPES FOR PATH LEVELS
-- ================================================================


data Category = Films | FilmsShort | Series
	deriving (Eq, Bounded, Enum)

instance Show Category where
	show Films      = "Films"
	show FilmsShort = "Films-Short"
	show Series     = "Series"


data Completion = C | I | O | U
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


data LevelSpec = LevelSpec
	{ levelName    :: !String
	, validEntries :: ![String]
	}


filmsPathSpec :: [LevelSpec]
filmsPathSpec =
	[ LevelSpec { levelName = "Type",       validEntries = map show ([minBound .. maxBound] :: [Type]) }
	, LevelSpec { levelName = "Style",      validEntries = map show ([minBound .. maxBound] :: [Style]) }
	, LevelSpec { levelName = "Source",     validEntries = map show ([minBound .. maxBound] :: [Source]) }
	]

shortsPathSpec :: [LevelSpec]
shortsPathSpec =
	[ LevelSpec { levelName = "Type",       validEntries = map show ([minBound .. maxBound] :: [Type]) }
	, LevelSpec { levelName = "Style",      validEntries = map show ([minBound .. maxBound] :: [Style]) }
	, LevelSpec { levelName = "Source",     validEntries = map show ([minBound .. maxBound] :: [Source]) }
	]

seriesPathSpec :: [LevelSpec]
seriesPathSpec =
	[ LevelSpec { levelName = "Completion", validEntries = map show ([minBound .. maxBound] :: [Completion]) }
	, LevelSpec { levelName = "Type",       validEntries = map show ([minBound .. maxBound] :: [Type]) }
	, LevelSpec { levelName = "Style",      validEntries = map show ([minBound .. maxBound] :: [Style]) }
	, LevelSpec { levelName = "Source",     validEntries = map show ([minBound .. maxBound] :: [Source]) }
	]


-- ================================================================
-- RECORDS FOR ...
-- ================================================================


data FilmsStructure = FilmsStructure
	{ filmsType       :: !Type
	, filmsStyle      :: !Style
	, filmsSource     :: !Source
	}
	-- Add completion later, it has been added to the filesystem and the folders have been moved

data FilmsShortStructure = FilmsShortStructure
	{ shortsType       :: !Type
	, shortsStyle      :: !Style
	, shortsSource     :: !Source
	}
	-- Add completion later, it has been added to the filesystem and the folders have been moved

data SeriesStructure = SeriesStructure
	{ seriesCompletion :: !Completion
	, seriesType       :: !Type
	, seriesStyle      :: !Style
	, seriesSource     :: !Source
	}


-- ================================================================
-- MAIN
-- ================================================================


main :: IO ()
main = do
	la <- listDirectory "." -- Lists all files in the current working directory
	ld <- filterM doesDirectoryExist la -- Filter for directories
	putStrLn "pPrint ld"
	pPrint ld
	putStrLn ""

	let cat = [minBound .. maxBound] :: [Category]
	putStrLn "pPrint cat"
	pPrint cat
	putStrLn ""

	lcat <- mapM listCategoryContent cat
	putStrLn "pPrint lcat"
	pPrint lcat
	putStrLn ""


listCategoryContent :: Category -> IO [FilePath]
listCategoryContent c = do
	let dir = show c
	entries <- listDirectory dir
	dirs <- filterM (doesDir1Exist dir) entries
	return dirs


doesDir1Exist :: FilePath -> FilePath -> IO Bool
doesDir1Exist dir1 dir2 = doesDirectoryExist (dir1 </> dir2)


-- ================================================================
