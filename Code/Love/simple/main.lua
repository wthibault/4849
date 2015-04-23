function love.load()
   player={}
   player.vx = 15.2
   player.vy = -33.3
   player.x = 320
   player.y = 240
   image = love.graphics.newImage("masonic-eye.jpg")
end

function love.update(dt)
   player.x = player.x + player.vx * dt
   player.y = player.y + player.vy * dt
end

function love.draw()
   love.graphics.print( string.format("%.2d",player.x), 300,200 )
   love.graphics.print( string.format("%.2d",player.y), 300,220 )
   love.graphics.draw ( image, player.x, player.y)
end

function love.mousepressed ( x, y, button )
   if button == 'l' then
      player.x = x
      player.y = y
   end
end
