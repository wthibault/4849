a={'dog','cat',5, {1,2,3}, shoppinglist='socks', 
   setdate=function(dt) date=dt end}

for i,v in ipairs(a) do
   print (i, v)
   if v == 5 then
      break
   end
end

printKeys = function (t)
   print ('keys until 5=')
   for k in pairs(t) do
      print (k)
      if ( t[k] == 5 ) then
	 return
      end
   end
end

printKeys(a)
