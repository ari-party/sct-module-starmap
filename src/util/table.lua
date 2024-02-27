local TableUtil = {}

--- Value is in table
---@param array table<any>
---@param target any
---@return boolean
function TableUtil.contains( array, target )
    for _, value in ipairs( array ) do
        if value == target then
            return true
        end
    end

    return false
end

return TableUtil
