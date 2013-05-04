function love.load()
   points = { 0, 0 }
   
end
function love.draw()
   x, y = love.mouse.getPosition()
   love.graphics.setColor ( 255, 0, 0 )
   love.graphics.line ( 320, 240, x, y )
   points[#points + 1] =  x
   points[#points + 1] =  y
   love.graphics.setColor ( 255, 60, 47 )
   --   love.graphics.line ( points )
   love.graphics.circle ("fill", x, y, x/10, 50 )

   love.graphics.setColor( 77, 88, 200 )
   for i = 1,#points/2,2 do
      love.graphics.circle ( "fill", points[i], points[i+1], 12 )
   end
   
end

