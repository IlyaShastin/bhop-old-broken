--[[----------------------------------------------------------------------------

    Directory Loader (v1.0.0)
        - Simple library to include Lua directories to streamline development.

    Ilya Shastin
    ily@shast.in

----------------------------------------------------------------------------]]--
AddCSLuaFile()

local directory = {}
local log = inlcude( 'log.lua' )
local E = include( 'enum.lua' )


local function AddCSLuaIncludeFile( location )
    if SERVER then
        AddCSLuaFile( location )
    elseif CLIENT then 
        include( location )
    end
end

local function DetermineFileDomain( location )
    local filename = string.GetFileFromFilename( location )
    local prefix = string.sub( filename, 1, 3 )
    local domain = enum.PREFIXES[ prefix ]

    if not domain then
        return
    end

    return domain
end