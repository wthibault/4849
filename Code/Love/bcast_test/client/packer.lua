local PACKER = {}

function PACKER.pack ( aValue )
   local msg = ''
   if type(aValue) == 'table' then
      msg = '{'
      for k,v in pairs(aValue) do
	 msg = msg .. k .. '=' .. PACKER.pack(v) .. ','
      end
      msg = msg .. '}'
   else
      msg = msg .. tostring ( aValue )
   end
   return msg
end


-- from http://stackoverflow.com/questions/6075262/lua-table-tostringtablename-and-table-fromstringstringtable-functions
function PACKER.pack (val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
       tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

       for k, v in pairs(val) do
	  tmp =  tmp .. PACKER.pack(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

       tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
       tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
       tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
       tmp = tmp .. (val and "true" or "false")
    else
       tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

function PACKER.unpack ( msg )
   return loadstring ( msg )
end

return PACKER

