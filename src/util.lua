local Util = {}

--- Remakes a table (for no metatable)
---@param array table
---@return table
function Util.cuteArray(array)
    local newArray = {}
    for _, val in ipairs(array) do
        table.insert(newArray, val)
    end
    return newArray
end

--- Remove parentheses and their content
---@param inputString string
---@return string
function Util.removeParentheses(inputString)
    -- Variable defined because string.gsub is a tuple
    local str = string.gsub(inputString, '%b()', '')
    return str
end

--- Trim a string
---@param str string
---@return string
function Util.trim(str)
    return string.match(str, '([^:%(%s]+)')
end

return Util
