num = 0

function love.load()
	 image = love.graphics.newImage("masonic-eye.jpg")
	 local f = love.graphics.newFont(12)
	 love.graphics.setFont(f)
	 love.graphics.setColor(0,0,0,255)
	 love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
	 if love.keyboard.isDown("up") then
	    num = num + 100 * dt
	 end
end

function love.draw()
	 image = love.graphics.newImage("masonic-eye.jpg")
    love.graphics.print("Hello World", 400, 300)
    love.graphics.print(tostring(num), 300,200)
    love.graphics.draw(image,imgx,imgy)
end

function love.mousepressed(x, y, button)
   if button == 'l' then
      imgx = x -- move image to where mouse clicked
      imgy = y
   end
end