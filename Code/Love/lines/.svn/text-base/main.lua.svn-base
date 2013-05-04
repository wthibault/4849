function love.load()
   points = { 0, 0 }
end
function love.draw()
   x, y = love.mouse.getPosition()
   love.graphics.setColor ( 255, 0, 0 )
   love.graphics.line ( 320, 240, x, y )
   points[#points + 1] =  x
   points[#points + 1] =  y
   love.graphics.setColor ( 0, 255, 0 )
   love.graphics.line ( points )
end

