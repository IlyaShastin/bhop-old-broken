
--
-- File contains all enums associated with the directory loader.
--

AddCSLuaFile()
local ENUMS = {}

-----------------------------------------------------------------
-- Colors used when printing text to console.
-----------------------------------------------------------------
ENUMS.COLORS = {
    TRANSPARENT                    = Color(   0,   0,   0,   0 ),
    DARKRED                        = Color( 160,   0,   0, 255 ),
    DARKGREEN                      = Color(   0, 160,   0, 255 ),
    DARKBLUE                       = Color(   0,   0, 160, 255 ),
    DARKYELLOW                     = Color( 160, 160,   0, 255 ),
    DARKPURPLE                     = Color( 160,   0, 160, 255 ),
    DARKCYAN                       = Color(   0, 160, 160, 255 ),
    SILVER                         = Color( 192, 192, 192, 255 ),
    GREY                           = Color( 160, 160, 160, 255 ),
    RED                            = Color( 255,   0,   0, 255 ),
    GREEN                          = Color(   0, 255,   0, 255 ),
    BLUE                           = Color(   0,   0, 255, 255 ),
    YELLOW                         = Color( 255, 255,   0, 255 ),
    PURPLE                         = Color( 255,   0, 255, 255 ),
    CYAN                           = Color(   0, 255, 255, 255 ),
    WHITE                          = Color( 255, 255, 255, 255 ),
    BLACK                          = Color(   0,   0,   0, 255 )
}
-----------------------------------------------------------------
-- Used for deciding where files will be loaded.
-----------------------------------------------------------------
ENUMS.INCLUDE = {
    SERVER                         = 1, -- Send to server
    CLIENT                         = 2, -- Send to client
    SHARED                         = 3, -- Send to server & client
    SMART                          = 4  -- File prefix/directory dependent
}

-- Convert include enum into a string.
ENUMS.INCLUDE.TOSTRING = {
    [ ENUMS.INCLUDE.SERVER ]       = 'SERVER',
    [ ENUMS.INCLUDE.CLIENT ]       = 'CLIENT',
    [ ENUMS.INCLUDE.SHARED ]       = 'SHARED',
    [ ENUMS.INCLUDE.SMART ]        = 'SMART'
}

-- Convert include enum into a color.
ENUMS.INCLUDE.TOCOLOR = {
    [ ENUMS.INCLUDE.SERVER ]       = ENUMS.COLORS.YELLOW,
    [ ENUMS.INCLUDE.CLIENT ]       = ENUMS.COLORS.DARKCYAN,
    [ ENUMS.INCLUDE.SHARED ]       = ENUMS.COLORS.PURPLE,
    [ ENUMS.INCLUDE.SMART ]        = ENUMS.COLORS.GREEN
}

-----------------------------------------------------------------
-- Used to determine where to send a file based on its prefix.
-----------------------------------------------------------------
ENUMS.PREFIXES = {
    [ 'sv_' ]                      = ENUMS.INCLUDE.SERVER,
    [ 'cl_' ]                      = ENUMS.INCLUDE.CLIENT,
    [ 'sh_' ]                      = ENUMS.INCLUDE.SHARED
}

-----------------------------------------------------------------
-- Used when printing debug text to console.
-----------------------------------------------------------------
ENUMS.CONSOLE = {
    INFO                           = 1, -- 
    DEBUG                          = 2, -- [DEBUG]
    WARN                           = 3, -- [WARN]
    ERROR                          = 4, -- [ERROR]
    FATAL                          = 5  -- [FATAL]
}

ENUMS.CONSOLE.TOSTRING = {
    [ ENUMS.CONSOLE.INFO ]         = '',
    [ ENUMS.CONSOLE.DEBUG ]        = 'DEBUG',
    [ ENUMS.CONSOLE.WARN ]         = 'WARN',
    [ ENUMS.CONSOLE.ERROR ]        = 'ERROR',
    [ ENUMS.CONSOLE.FATAL ]        = 'FATAL'
}

ENUMS.CONSOLE.TOCOLOR = {
    [ ENUMS.CONSOLE.INFO ]         = ENUMS.COLORS.GREEN,
    [ ENUMS.CONSOLE.DEBUG ]        = ENUMS.COLORS.BLUE,
    [ ENUMS.CONSOLE.WARN ]         = ENUMS.COLORS.YELLOW,
    [ ENUMS.CONSOLE.ERROR ]        = ENUMS.COLORS.RED,
    [ ENUMS.CONSOLE.FATAL ]        = ENUMS.COLORS.DARKRED
}

return ENUMS
