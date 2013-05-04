function love.load()
   stars = {} -- table which will hold our stars
   max_stars = 100 -- how many stars we want
   for i=1, max_stars do -- generate the coords of our stars
      local x = math.random(5, love.graphics.getWidth()-5) -- generate a "random" number for the x coord of this star
      local y = math.random(5, love.graphics.getHeight()-5) -- both coords are limited to the screen size, minus 5 pixels of padding
      stars[i] = {x, y} -- stick the values into the table
   end
   love.graphics.setPointSize ( 3 )
   love.graphics.setPointStyle ( "smooth" )
end
function love.draw()
   for i=1, #stars do -- loop through all of our stars
      love.graphics.point(stars[i][1], stars[i][2]) -- draw each point
   end
end
