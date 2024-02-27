local util = require( 'Module:Util' )

---@param str string
---@return string
return function ( str )
    return util.pluralize( { args = { str } } )
end
