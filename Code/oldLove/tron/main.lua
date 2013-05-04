function love.load()
--   image = love.graphics.newImage("cake.jpg")
   local f = love.graphics.newFont(12)
   love.graphics.setFont(f)
   love.graphics.setColor(0,0,0,255)
   love.graphics.setBackgroundColor(255,255,255)
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end