local data = mw.loadJsonData( 'Module:Starmap/starmap.json' )
local pluralize = require( 'util.pluralize' )

--- Look for a structure in starmap
--- A structure can be an astronomical anomaly
---@param structureType string The type of structure (system/object)
---@param structureName string The name/code/designation of the structure in Star Citizen
---@return nil | system | object
return function ( structureType, structureName )
    local structures = data[ pluralize( structureType ) ]
    if structures == nil then return nil end -- Invalid type

    structureName = mw.ustring.lower( structureName )

    for _, structure in ipairs( structures ) do
        if mw.ustring.lower( structure.name or '' ) == structureName or mw.ustring.lower( structure.designation or '' ) == structureName or mw.ustring.lower( structure.code or '' ) == structureName then
            return structure
        end
    end

    return nil -- Not found
end
