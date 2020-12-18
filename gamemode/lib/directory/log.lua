AddCSLuaFile()

--
-- Simple logging system to keep track of loaded files
--

-- Convar to control the level of debug messages to print to console.
CreateConVar( 'directory_loader_log_level', 1, FCVAR_ARCHIVE, 'Adjust the level of debug text to be printed for files being loaded.' )

local E = include 'enums.lua'

local table_insert  = table.insert
local string_format = string.format
local math_Round    = math.Round
local GetConVar     = GetConVar
local os_time       = os.time
local os_date       = os.date
local SysTime       = SysTime
local MsgC          = MsgC
local Msg           = Msg

local log = {
    startTime = 0,
    stopTime  = 0,

    files = {
        [ E.INCLUDE.SERVER ] = {},
        [ E.INCLUDE.CLIENT ] = {},
        [ E.INCLUDE.SHARED ] = {}
    },

    directories = {
        [ E.INCLUDE.SERVER ] = {},
        [ E.INCLUDE.CLIENT ] = {},
        [ E.INCLUDE.SHARED ] = {},
        [ E.INCLUDE.SMART ]  = {}
    }
}

function log.start()
    log.startTime = SysTime()
end

function log.stop()
    log.stopTime = SysTime()
end

function log.addFile( location, domain )
    table_insert( log.files[ domain ], {
        location = location,
        domain   = domain,
        time     = os_time()
    } )
end

function log.addDirectory( dir, domain )
    table_insert( log.directories[ domain ], {
        location = location,
        domain   = domain,
        time     = os_time()
    } )
end

function log.getCount( tbl )
    local count = 0

    for _, v in pairs( tbl ) do
        count = count + #v
    end

    return count
end

function log.getFileCount()
    return log.getCount( log.files )
end

function log.getDirectoryCount()
    return log.getCount( log.directories )
end

function log.getTime()
    return math_Round( log.stopTime - log.startTime, 6 )
end

function log.print( level, ... )
    --if level > GetConVar( 'directory_loader_log_level' ):GetInt() then return end

    MsgC( E.COLORS.CYAN, '[DIR-LOADER]' )

    if level != E.CONSOLE.INFO then
        local levelColor  = E.CONSOLE.TOCOLOR[ level ]
        local levelString = E.CONSOLE.TOSTRING[ level ]
        MsgC( levelColor, string_format( '[%-6s%s]', levelString, os_date( '%H:%M:%S', os_time() ) ) )
    end

    Msg( ' ' )
    MsgC( color_white, ... )
    Msg( '\n' )
end

function log.info( ... )
    log.print( E.CONSOLE.INFO, ... )
end

function log.debug( ... )
    log.print( E.CONSOLE.DEBUG, ... )
end

function log.warn( ... )
    log.print( E.CONSOLE.WARN, ... )
end

function log.error( ... )
    log.print( E.CONSOLE.ERROR, ... )
end

function log.fatal( ... )
    log.print( E.CONSOLE.FATAL, ... )
end

return log
