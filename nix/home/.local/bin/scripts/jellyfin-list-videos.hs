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


data Type = Documentary | Fiction | Any
	deriving (Eq, Show)


data Style = Animated | LA | Any
	deriving (Eq, Show)


data Source = Rip | Network | Dailymotion | InternetArchive | YouTube
	deriving (Eq)

instance Show Source where
	show Rip             = "Rip"
	show Network         = "Network"
	show Dailymotion     = "Dailymotion"
	show InternetArchive = "Internet-Archive"
	show YouTube         = "YouTube"


-- ================================================================
