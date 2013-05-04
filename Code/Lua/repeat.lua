
-- print first non-empty line
repeat
   line = io.read()
until line ~= ''
print (line)

x = 99
local sqr = x/2
repeat
   sqr = ( sqr + x/sqr) / 2
   local error = math.abs ( sqr^2 - x )
until error < x/ 10000              -- error in scope here
print ('x',x)
print ('sqr',sqr)