local data = mw.loadJsonData( 'Module:Starmap/starmap.json' )
local findStructure = require( 'lib.findStructure' )

--- Get the objects of a system
---@param systemName string The type of structure (system/object)
---@deprecated
return function ( systemName )
    local system = findStructure( 'system', systemName )
    if system == nil then return nil end -- System doesn't exist

    systemName = mw.ustring.lower( systemName )

    local objects = data.objects
    local systemObjects = {}

    for _,
    ---@type object
    object in ipairs( objects ) do
        if object.star_system_id == system.id then
            table.insert( systemObjects, object )
        end
    end

    return systemObjects
end
