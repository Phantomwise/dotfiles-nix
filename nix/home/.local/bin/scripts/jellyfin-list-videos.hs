#!/usr/bin/env runghc

-- ================================================================
-- IMPORTS
-- ================================================================


import System.Directory (listDirectory, doesDirectoryExist)

import Text.Pretty.Simple (pPrint)


-- ================================================================
-- CONSTANTS
-- ================================================================


outputFileCSV :: FilePath = "jellyfin-videos.csv"
outputFileRaw :: FilePath = "jellyfin-videos.txt"


-- ================================================================
-- DATA TYPES
-- ================================================================


data Category = Films | FilmsShort | Series
	deriving (Eq)

instance Show Category where
	show Films      = "Films"
	show FilmsShort = "Films-Short"
	show Series     = "Series"


data Completion = C | I | O | U
	deriving (Eq, Show)


data Type = Documentary | Fiction | AnyType
	deriving (Eq)

instance Show Type where
	show Documentary = "Documentary"
	show Fiction     = "Fiction"
	show AnyType     = "Any"


data Style = Animated | LA | AnyStyle
	deriving (Eq)

instance Show Style where
	show Animated = "Animated"
	show LA       = "LA"
	show AnyStyle = "Any"


data Source = Rip | Network | Dailymotion | InternetArchive | YouTube
	deriving (Eq)

instance Show Source where
	show Rip             = "Rip"
	show Network         = "Network"
	show Dailymotion     = "Dailymotion"
	show InternetArchive = "Internet-Archive"
	show YouTube         = "YouTube"


-- ================================================================
-- RECORDS
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
	ld <- listDirectory "."
	pPrint ld

-- ================================================================
