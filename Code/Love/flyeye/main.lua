function love.load()
   if arg[#arg] == "-debug" then require("mobdebug").start() end 
   skyeye = love.graphics.newImage("masonic-eye.jpg")
   width = skyeye:getWidth()
   height = skyeye:getHeight()
   angle = 0
   rotvel = 10
end

function love.update(dt)
   angle = angle + rotvel * dt
end

function love.draw()
   love.graphics.draw( skyeye, 400, 300, math.rad(angle), 1, 1, width / 2, height / 2)
end