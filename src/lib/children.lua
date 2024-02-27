local data = mw.loadJsonData( 'Module:Starmap/starmap.json' )

--- Get the objects of a system
---@param id number The structure id
---@param isSystem boolean If the id is a system's
---@deprecated
return function ( id, isSystem )
    if id == nil then return nil end

    local objects = data.objects
    local children = {}

    local targetKey = 'parent_id'
    if isSystem == true then targetKey = 'star_system_id' end

    for _, object in ipairs( objects ) do
        if object[ targetKey ] == id then
            table.insert( children, object )
        end
    end

    return children
end
