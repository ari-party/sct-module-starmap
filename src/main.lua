local Starmap = {}

local Array = require('Module:Array')
local TNT = require('Module:Translate'):new()
local data = mw.loadJsonData('Module:Starmap/starmap.json')
local config = mw.loadJsonData('Module:Starmap/config.json')

local util = require("util")

local lang
if config.module_lang then
    lang = mw.getLanguage(config.module_lang)
else
    lang = mw.getContentLanguage()
end
local langCode = lang:getCode()

--- Wrapper function for Module:Translate.translate
---@param key string The translation key
---@param addSuffix? boolean Adds a language suffix if config.smw_multilingual_text is true
---@return string If the key was not found in the .tab page, the key is returned
local function t(key, addSuffix, ...)
    return TNT:translate('Module:Starmap/i18n.json', config, key, addSuffix, { ... }) or key
end

---@alias system { affiliation: table, aggregated_danger: number, aggregated_economy: number, aggregated_population: number, code: string, description: string, id: number, name: string, status: string, type: string }
---@alias object { affiliation: table, age: number, code: string, designation: string, id: number, sensor_danger: number, sensor_economy: number, sensor_population: number, size: number, star_system: table, star_system_id: number, subtype: table, type: string }

--- Create a starmap link from arguments
---@param location string Location param
---@param system? string System param, only added if the `location` argument is present
function Starmap.link(location, system)
    local str = config.starmap .. '?'

    if location then str = str .. 'location=' .. location end
    if location and system then str = str .. '&' .. 'system=' .. system end

    return str
end

--- Look for a structure in starmap
--- A structure can be an astronomical anomaly
---@param structureType string The type of structure (system/object)
---@param structureName string The name/code/designation of the structure in Star Citizen
---@return nil | system | object
function Starmap.findStructure(structureType, structureName)
    local structures = data[config.type_plural[structureType]]
    if structures == nil then return nil end -- Invalid type

    structureName = string.lower(structureName)

    for _, structure in ipairs(structures) do
        if string.lower(structure.name or '') == structureName or string.lower(structure.designation or '') == structureName or string.lower(structure.code or '') == structureName then
            return structure
        end
    end

    return nil -- Not found
end

--- E.g.: [[Planet]], [[Star]], [[System]]
---@param target table Target structure
---@return string
function Starmap.pathTo(target, dontCapitalize)
    local links = {}

    local function processStructure(structure)
        if not structure then return end
        local parent = structure.parent or structure.star_system
        if not parent then return end

        local parentType = "object"
        if Array.contains(util.cuteArray(config.systems), parent.type) then parentType = "system" end

        parent = Starmap.findStructure(parentType, parent.code)

        if parentType == 'system' then
            ---@type system
            ---@diagnostic disable-next-line: assign-type-mismatch
            parent = parent

            local linkContent = config.link_overwrites[parent.code] or
                util.removeParentheses(parent.name) .. ' system'
            table.insert(links, string.format(t('in_system'), '[[' .. linkContent .. ']]'))
        else
            ---@type object
            ---@diagnostic disable-next-line: assign-type-mismatch
            parent = parent

            if parent.type == 'STAR' then
                local designation = util.removeParentheses(parent.designation)

                local linkContent = config.link_overwrites[parent.code] or
                    designation .. ' (star)|' .. designation .. ' star'

                table.insert(links, string.format(t('orbits_star'), '[[' .. linkContent .. ']]'))
            else
                local linkContent = config.link_overwrites[parent.code] or
                    -- LuaLS doesn't see the field??
                    ---@diagnostic disable-next-line: undefined-field
                    util.removeParentheses(parent.name or parent.designation)

                table.insert(links, '[[' .. linkContent .. ']]')
            end

            processStructure(parent)
        end
    end

    processStructure(target)

    local sentence = table.concat(links, ', ')
    if dontCapitalize then
        return sentence
    else
        -- Variable defined because string.gsub is a tuple
        local str = string.gsub(sentence, '^%l', string.upper)
        return str
    end
end

--- Get the objects of a system
---@param systemName string The type of structure (system/object)
---@deprecated
function Starmap.systemObjects(systemName)
    local system = Starmap.findStructure('system', systemName)
    if system == nil then return nil end -- System doesn't exist

    systemName = string.lower(systemName)

    local objects = data.objects
    local systemObjects = {}

    for _,
    ---@type object
    object in ipairs(objects) do
        if object.star_system_id == system.id then
            table.insert(systemObjects, object)
        end
    end

    return systemObjects
end

---@param frame table https://www.mediawiki.org/wiki/Extension:Scribunto/Lua_reference_manual#Frame_object
function Starmap.main(frame)
    local args = frame:getParent().args

    local structure = Starmap.findStructure(args[2] or 'object', util.trim(args[1]))

    if structure then
        local location = structure.code
        local system = nil
        if structure.star_system then system = structure.star_system.code end

        return Starmap.link(location, system)
    end

    return ''
end

function Starmap.test(type, name)
    local targetObject = Starmap.findStructure(type, name)

    if targetObject then mw.log(Starmap.pathTo(targetObject)) end
end

return Starmap
