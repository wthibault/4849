function stackblower (n)
   if n > 0 then
      return n * stackblower(n-1)
   else
      return 1
   end
end

function fact (n)
   if n > 0 then
      return n*fact(n-1)
   else
      return 1
   end
end


   