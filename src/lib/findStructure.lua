local data = mw.loadJsonData( 'Module:Starmap/starmap.json' )
local pluralize = require( 'util.pluralize' )

--- Look for a structure in starmap
--- A structure can be an astronomical anomaly
---@param structureType string The type of structure (system/object)
---@param structureIdentifier string The name/code/designation/id of the structure in Star Citizen
---@return nil | system | object
return function ( structureType, structureIdentifier )
    local structures = data[ pluralize( structureType ) ]
    if structures == nil then return nil end -- Invalid type

    structureIdentifier = mw.ustring.lower( structureIdentifier )

    for _, structure in ipairs( structures ) do
        if
            mw.ustring.lower( structure.name or '' ) == structureIdentifier or
            mw.ustring.lower( structure.designation or '' ) == structureIdentifier or
            mw.ustring.lower( structure.code ) == structureIdentifier or
            structure.id == structureIdentifier
        then
            return structure
        end
    end

    return nil -- Not found
end
