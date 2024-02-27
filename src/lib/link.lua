local config = mw.loadJsonData( 'Module:Starmap/config.json' )

--- Create a starmap link from arguments
---@param locationName string Location param
---@param systemName? string System param, only added if the `location` argument is present
return function ( locationName, systemName )
    local str = config.starmap .. '?'

    if locationName then str = str .. 'location=' .. locationName end
    if locationName and systemName then str = str .. '&' .. 'system=' .. systemName end

    return str
end
