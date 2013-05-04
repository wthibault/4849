function newCounter()
   local i = 0
   return function ()
               i = i+1
               return i
	  end
end

c1 = newCounter()
print(c1())
print(c1())
print(c1())


c2 = newCounter()
print(c2())
print(c1())
print(c2())

do
  local oldSin = math.sin
  local k = math.pi/180
  math.sin = function (x) return oldSin(x*k) end
end


