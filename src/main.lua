---@alias system { affiliation: table, aggregated_danger: number, aggregated_economy: number, aggregated_population: number, code: string, description: string, id: number, name: string, status: string, type: string }
---@alias object { affiliation: table, age: number, code: string, designation: string, id: number, sensor_danger: number, sensor_economy: number, sensor_population: number, size: number, star_system: table, star_system_id: number, subtype: table, type: string }

local Starmap = {
    children = require( 'lib.children' ),
    findStructure = require( 'lib.findStructure' ),
    link = require( 'lib.link' ),
    pathTo = require( 'lib.pathTo' ),
    systemObjects = require( 'lib.systemObjects' )
}

local t = require( 'translate' )
local stringUtil = require( 'util.string' )

---@param frame table https://www.mediawiki.org/wiki/Extension:Scribunto/Lua_reference_manual#Frame_object
function Starmap.main( frame )
    local args = frame:getParent().args

    local structure = Starmap.findStructure(
        args[ 2 ] or 'object',
        stringUtil.trim( args[ 1 ] )
    )

    if structure then
        local location = structure.code
        local system = nil
        if structure.star_system then system = structure.star_system.code end

        return Starmap.link( location, system )
    end

    return ''
end

function Starmap.test( type, name )
    local targetObject = Starmap.findStructure( type, name )

    if targetObject then mw.log( Starmap.pathTo( targetObject ) ) end
end

return Starmap
