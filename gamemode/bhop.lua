--[[---------------------------------------------------------------------
    Bunny Hop (v1.0.0a)
        - A Garry's Mod gamemode based on use of skillful movement by
        strafing in the air to gain velocity.

    Ilya Shastin
    ilya@shast.in
---------------------------------------------------------------------]]--

GM.Author  = 'Ilya Shastin'
GM.Name    = 'Bunny Hop'
GM.Email   = 'ilya@shast.in'
GM.Website = 'https://shast.in'

BHOP       = BHOP       or {}
BHOP.ENUMS = BHOP.ENUMS or {}

local directory = include 'lib/directory/directory.lua'
local function root( path )
    return GM.FolderName .. '/gamemode/' .. path
end

directory.includeShared( root( 'bhop/constants/enums' ) ) 
directory.includeClient( root( 'bhop/constants/cvars' ) )

directory.includeSharedRecursive( root( 'bhop/config' ) )
directory.includeSharedRecursive( root( 'bhop/extensions') )
directory.includeSharedRecursive( root( 'bhop/player_classes' ) )
directory.includeSmartRecursive(  root( 'bhop/core' ) )
directory.includeSmartRecursive(  root( 'bhop/net' ) )
directory.includeServerRecursive( root( 'bhop/storage' ) )
directory.includeClientRecursive( root( 'bhop/vgui' ) )