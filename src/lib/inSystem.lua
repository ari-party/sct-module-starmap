local config = mw.loadJsonData( 'Module:Starmap/config.json' )
local t = require( 'translate' )
local stringUtil = require( 'util.string' )

---@param system system
---@return string
return function ( system )
    local linkContent = config.link_overwrites[ system.code ] or
        stringUtil.removeParentheses( system.name ) .. ' system'

    return mw.ustring.format( t( 'in_system' ), '[[' .. linkContent .. ']]' )
end
