local config = mw.loadJsonData( 'Module:Starmap/config.json' )
local t = require( 'translate' )
local tableUtil = require( 'util.table' )
local stringUtil = require( 'util.string' )
local findStructure = require( 'lib.findStructure' )
local inSystem = require( 'lib.inSystem' )

--- E.g.: [[Planet]], orbits [[Star]], in [[System]]
---@param target table Target structure
---@return string?
return function ( target )
    local links = {}

    local function processStructure( structure )
        if not structure then return end
        local parent = structure.parent or structure.star_system
        if not parent then return end

        local parentType = 'object'
        if tableUtil.contains( config.systems, parent.type ) then parentType = 'system' end

        parent = findStructure( parentType, parent.code )

        if parentType == 'system' then
            ---@type system
            ---@diagnostic disable-next-line: assign-type-mismatch
            parent = parent

            table.insert( links, inSystem( parent ) )
        else
            ---@type object
            ---@diagnostic disable-next-line: assign-type-mismatch
            parent = parent

            if parent.type == 'STAR' then
                local designation = stringUtil.removeParentheses( parent.designation )

                local linkContent = config.link_overwrites[ parent.code ] or
                    designation .. ' (star)|' .. designation .. ' star'

                table.insert( links, mw.ustring.format( t( 'orbits_star' ), '[[' .. linkContent .. ']]' ) )
            else
                local linkContent = config.link_overwrites[ parent.code ] or
                    -- LuaLS doesn't see the field??
                    ---@diagnostic disable-next-line: undefined-field
                    stringUtil.removeParentheses( parent.name or parent.designation )

                table.insert( links, '[[' .. linkContent .. ']]' )
            end

            processStructure( parent )
        end
    end

    processStructure( target )

    local sentence = table.concat( links, ', ' )
    sentence = mw.ustring.gsub( sentence, '^%l', mw.ustring.upper )
    return sentence
end
