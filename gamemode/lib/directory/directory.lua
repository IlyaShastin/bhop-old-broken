
--[[----------------------------------------------------------------------------

    Directory Loader (v1.0.0)
        - Simple library to include Lua directories to streamline development.

    Ilya Shastin
    ilya@shast.in

----------------------------------------------------------------------------]]--
AddCSLuaFile()

local directory = {}
local log       = include 'log.lua'
local E         = include 'enums.lua'

local string_GetFileFromFilename = string.GetFileFromFilename
local string_sub                 = string.sub
local include                    = include
local AddCSLuaFile               = AddCSLuaFile
local file_Find                  = file.Find
local hook_Run                   = hook.Run
local pairs                      = pairs


local function AddCSLuaIncludeFile( location )
    if SERVER then 
        AddCSLuaFile( location )
    elseif CLIENT then
        include( location )
    end
end

local function determineFileDomain( location )
    local filename = string_GetFileFromFilename( location )
    local prefix   = string_sub( filename, 1, 3 )
    local domain   = E.PREFIXES[ prefix ]

    if not domain then
        log.error( 
            E.COLORS.WHITE, 'Invalid prefix of ',
            E.COLORS.GREY,  '\'' .. prefix .. '\'',
            E.COLORS.WHITE, ' for file ',
            E.COLORS.GREY,  '\'' .. filename .. '\'',
            E.COLORS.WHITE, '. File was not included!'
        )

        return 
    end

    return domain
end

function directory.include( dir, domain, recursive )
    local files, folders = file_Find( dir .. '/*', 'LUA' )
    domain = domain or E.INCLUDE.SMART

    log.info(
        E.INCLUDE.TOCOLOR[ domain ], E.INCLUDE.TOSTRING[ domain ],
        E.COLORS.GREY,               ' \'' .. dir .. '\' ',
        E.COLORS.GREY,               '(' .. #files .. ') ',
        E.COLORS.WHITE,              'FILES ',
        E.COLORS.GREY,               '(' .. #folders .. ') ',
        E.COLORS.WHITE,              'SUB-DIRECTORIES.'
    )

    for k, file in pairs( files ) do
        directory.includeFile( dir .. '/' .. file, domain )
    end

    log.addDirectory( dir, domain )

    if recursive then
        for k, folder in pairs( folders ) do
            directory.include( dir .. '/' .. folder, domain, recursive )
        end
    end
end

function directory.includeServer( location, recursive )
    directory.include( location, E.INCLUDE.SERVER, recursive )
end

function directory.includeServerRecursive( location )
    directory.includeServer( location, true )
end


function directory.includeClient( location, recursive )
    directory.include( location, E.INCLUDE.CLIENT, recursive )
end

function directory.includeClientRecursive( location )
    directory.includeClient( location, true )
end


function directory.includeShared( location, recursive )
    directory.include( location, E.INCLUDE.SHARED, recursive )
end

function directory.includeSharedRecursive( location )
    directory.includeShared( location, true )
end


function directory.includeSmart( location, recursive )
    directory.include( location, E.INCLUDE.SMART, recursive )
end

function directory.includeSmartRecursive( location, recursive )
    directory.includeSmart( location, true )
end


function directory.includeFile( location, domain )
    if domain == E.INCLUDE.SERVER then
        if SERVER then include( location ) end

    elseif domain == E.INCLUDE.CLIENT then
        if SERVER then 
            AddCSLuaFile( location )
        elseif CLIENT then
            include( location )
        end

    elseif domain == E.INCLUDE.SHARED then
        if SERVER then 
            AddCSLuaFile( location )
        end
        include( location )

    elseif domain == E.INCLUDE.SMART then
        local newDomain = determineFileDomain( location )
        directory.includeFile( location, newDomain )
        return

    else
        return

    end

    log.info(
        E.COLORS.WHITE,              '>>> ',
        E.INCLUDE.TOCOLOR[ domain ], E.INCLUDE.TOSTRING[ domain ],
        E.COLORS.GREY,               ' \'' .. location ..  '\'',
        E.COLORS.WHITE,              ' included.'
    )

    log.addFile( location, domain )
end

hook.Add( 'PreGamemodeLoaded', 'directoryLoaderPreInit', function()
    log.info( 'Beginning to include directories and files!' )
    log.start()

    hook_Run( 'LoadDirectories', E.INCLUDE )

    log.stop()
    log.info( 'Finished including directories and files!' )

    log.debug(
        E.COLORS.GREY,                         '(' .. log.getFileCount() .. ' TOTAL)',
        E.INCLUDE.TOCOLOR[ E.INCLUDE.CLIENT ], '(' .. #log.files[ E.INCLUDE.CLIENT ] .. ')',
        E.INCLUDE.TOCOLOR[ E.INCLUDE.SERVER ], '(' .. #log.files[ E.INCLUDE.SERVER ] .. ')',
        E.INCLUDE.TOCOLOR[ E.INCLUDE.SHARED ], '(' .. #log.files[ E.INCLUDE.SHARED ] .. ')',
        E.COLORS.WHITE,                        ' files and ',
        E.COLORS.GREY,                         '(' .. log.getDirectoryCount() .. ' TOTAL)',
        E.INCLUDE.TOCOLOR[ E.INCLUDE.CLIENT ], '(' .. #log.directories[ E.INCLUDE.CLIENT ] .. ')',
        E.INCLUDE.TOCOLOR[ E.INCLUDE.SERVER ], '(' .. #log.directories[ E.INCLUDE.SERVER ] .. ')',
        E.INCLUDE.TOCOLOR[ E.INCLUDE.SHARED ], '(' .. #log.directories[ E.INCLUDE.SHARED ] .. ')',
        E.INCLUDE.TOCOLOR[ E.INCLUDE.SMART ],  '(' .. #log.directories[ E.INCLUDE.SMART ] .. ')',
        E.COLORS.WHITE,                        ' directories loaded in ',
        E.COLORS.GREY,                         log.getTime() .. ' SECONDS.'
    )
end )

return directory
