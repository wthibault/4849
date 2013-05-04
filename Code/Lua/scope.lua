#!/usr/bin/env lua

x = 10
local i = 1 

while i <= x do
   local x = i*2
   print(x)
   i = i + 1
end

if i > 10 then
   local x
   x = 20
   print (x+2)    -- would print 22
else
   print (x)      -- 10 (global)
end

print (x) -- 10 (global)
