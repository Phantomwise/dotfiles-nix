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
-- SPECS FOR CATEGORIES
-- ================================================================


-- Match each Category to its LevelSpec record
categorySpec :: Category -> [LevelSpec]
categorySpec Films      = filmsPathSpec
categorySpec FilmsShort = shortsPathSpec
categorySpec Series     = seriesPathSpec


-- ================================================================
-- SPECS FOR PATHS
-- ================================================================


data LevelSpec = LevelSpec
	{ levelName    :: !String
	, validEntries :: ![String]
	}
	deriving Show
	-- NB: Not yet in use


filmsPathSpec :: [LevelSpec]
filmsPathSpec =
	[ LevelSpec { levelName = "Category",   validEntries = [show Films] }
	, LevelSpec { levelName = "Progress",   validEntries = map show ([minBound .. maxBound] :: [Progress]) } -- TODO: Add Progress folder to the filesystem
	, LevelSpec { levelName = "Type",       validEntries = map show ([minBound .. maxBound] :: [Type]) }
	, LevelSpec { levelName = "Style",      validEntries = map show ([minBound .. maxBound] :: [Style]) }
	, LevelSpec { levelName = "Source",     validEntries = map show ([minBound .. maxBound] :: [Source]) }
	]
	-- NB: Not yet in use

shortsPathSpec :: [LevelSpec]
shortsPathSpec =
	[ LevelSpec { levelName = "Category",   validEntries = [show FilmsShort] }
	, LevelSpec { levelName = "Progress",   validEntries = map show ([minBound .. maxBound] :: [Progress]) } -- TODO: Add Progress folder to the filesystem
	, LevelSpec { levelName = "Type",       validEntries = map show ([minBound .. maxBound] :: [Type]) }
	, LevelSpec { levelName = "Style",      validEntries = map show ([minBound .. maxBound] :: [Style]) }
	, LevelSpec { levelName = "Source",     validEntries = map show ([minBound .. maxBound] :: [Source]) }
	]
	-- NB: Not yet in use

seriesPathSpec :: [LevelSpec]
seriesPathSpec =
	[ LevelSpec { levelName = "Category",   validEntries = [show Series] }
	, LevelSpec { levelName = "Progress",   validEntries = map show ([minBound .. maxBound] :: [Progress]) }
	, LevelSpec { levelName = "Type",       validEntries = map show ([minBound .. maxBound] :: [Type]) }
	, LevelSpec { levelName = "Style",      validEntries = map show ([minBound .. maxBound] :: [Style]) }
	, LevelSpec { levelName = "Source",     validEntries = map show ([minBound .. maxBound] :: [Source]) }
	]
	-- NB: Not yet in use


-- ================================================================
-- RECORDS FOR ...
-- ================================================================


data FilmsStructure = FilmsStructure
	{ filmsType       :: !Type
	, filmsStyle      :: !Style
	, filmsSource     :: !Source
	}
	-- Add completion later, it has been added to the filesystem and the folders have been moved
	-- NB: Not yet in use

data FilmsShortStructure = FilmsShortStructure
	{ shortsType       :: !Type
	, shortsStyle      :: !Style
	, shortsSource     :: !Source
	}
	-- Add completion later, it has been added to the filesystem and the folders have been moved
	-- NB: Not yet in use

data SeriesStructure = SeriesStructure
	{ seriesProgress :: !Progress
	, seriesType       :: !Type
	, seriesStyle      :: !Style
	, seriesSource     :: !Source
	}
	-- NB: Not yet in use


-- ================================================================
-- CATEGORIES SCANNER
-- ================================================================


scanCategory :: [LevelSpec] -> IO [FilePath]
scanCategory sps = do
	putStrLn "scanCategory : pPrint : sps"
	pPrint sps
	putStrLn ""
	putStrLn ""
	putStrLn "scanCategory : call `buildPaths sps`"
	putStrLn ""
	let paths = buildPaths [""] sps -- TODO: Find out why it doesn't work with an empty list and needs a list with one empty String instead
	putStrLn "scanCategory : pPrint : paths = buildPaths sps"
	pPrint paths
	putStrLn ""
	return paths


-- ================================================================
-- PATH BUILDERS
-- ================================================================


buildPaths :: [FilePath] -> [LevelSpec] -> [FilePath]
buildPaths arg [] = arg
buildPaths arg (sp:rest) =
	let result     = joinPaths arg (validEntries sp) -- Join the path produced by the previous step (initially empty) with the validEntries for the current step (head of the list)
	    resultRest = buildPaths result rest             -- Call itself with the previous step + rest as arguments
	in resultRest


joinPaths :: [FilePath] -> [String] -> [FilePath]
joinPaths prev new = [ x </> y | x <- prev, y <- new ] -- Take two lists and get all the concatenation variations with </> joining them


-- ================================================================
-- MAIN
-- ================================================================


main :: IO ()
main = do
	la <- listDirectory "." -- Lists all files in the current working directory
	ld <- filterM doesDirectoryExist la -- Filter for directories
	putStrLn "main : pPrint : ld"
	pPrint ld
	putStrLn ""

	let cat = [minBound .. maxBound] :: [Category]
	putStrLn "main : pPrint : cat"
	pPrint cat
	putStrLn ""

	lcat <- mapM listCategoryContent cat
	putStrLn "main : pPrint : lcat"
	pPrint lcat
	putStrLn ""

	putStrLn "main : calling `scanCategory filmsPathSpec`"
	putStrLn ""
	result <- scanCategory filmsPathSpec
	putStrLn "main : pPrint : result <- scanCategory filmsPathSpec"
	pPrint result
	putStrLn ""

	return ()
	

listCategoryContent :: Category -> IO [FilePath]
listCategoryContent c = do
	let dir = show c
	entries <- listDirectory dir
	dirs <- filterM (doesDir1Exist dir) entries
	return dirs


doesDir1Exist :: FilePath -> FilePath -> IO Bool
doesDir1Exist dir1 dir2 = doesDirectoryExist (dir1 </> dir2)


-- ================================================================
