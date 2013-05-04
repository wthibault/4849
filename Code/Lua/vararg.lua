
function summation (...)
   local sum = 0
   for i,v in ipairs{...} do
      print (v)
      if type(v)=='number' then
	 sum = sum + v
      end
   end
   return sum
end

sum = summation(1,2,3,4)
print ('sum = ', sum)

function argsim ( ... )
   local a, b, c = ...
   print (a,b,c)
   return a,b
end

function foo1 ( ... )
   print ('calling foo with args', ... )
   foo ( ... )
end



   


