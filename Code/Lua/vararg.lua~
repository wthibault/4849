a={'dog','cat',5, {1,2,3}, shoppinglist='socks', 
   setdate=function(dt) date=dt end}

function summation (t)
   local sum = 0
   for k in pairs(t) do
      print (k)
      if type(k)=='number' then
	 sum = sum + k
      end
   end
   return sum
end

sum = summation(a)
print ('sum = ', sum)

function defaultArg (n)
   n = n or 1
   count = count + n
end
