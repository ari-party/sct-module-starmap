local StringUtil = {}

--- Remove parentheses and their content
---@param inputString string
---@return string
function StringUtil.removeParentheses( inputString )
    return string.match( string.gsub( inputString, '%b()', '' ), '^%s*(.*%S)' ) or ''
end

--- Trim a string
---@param str string
---@return string
function StringUtil.trim( str )
    return string.match( str, '([^:%(%s]+)' )
end

return StringUtil
