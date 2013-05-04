slides={}

function makeSlide ( filename )
   local slide
   slide = {}
   slide.image = love.graphics.newImage(filename)
   slide.width = slide.image:getWidth()
   slide.height = slide.image:getHeight()
   slide.angle = 0
   slide.rotvel = 10
   slide.x = 400
   slide.y = 300
   slide.scale = 0.5
   return slide
end

function love.load()
   if arg[#arg] == "-debug" then require("mobdebug").start() end 
   slides[#slides+1] = makeSlide("Slide0000.jpg")   
   slides[#slides+1] = makeSlide("Slide0001.jpg")   
   --slides[#slides+1] = makeSlide("Slide0002.jpg")  
   slides[2].x = slides[2].x + 250
  -- slides[3].x = slides[2].x + 100
end

function love.update(dt)
   for i=1,#slides do
    --slides[i].angle = slides[i].angle + slides[i].rotvel * dt
    --slides[i].x = slides[i].x + 20 * dt
   end
end

function love.draw()
   for i=1,#slides do
     love.graphics.draw( slides[i].image, 
       slides[i].x, slides[i].y, 
       math.rad(slides[i].angle), 
       slides[i].scale, slides[i].scale, 
        slides[i].width / 2, slides[i].height / 2)
    end
end

-- Lua implementation of PHP scandir function
function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    for filename in popen('ls -a "'..directory..'"'):lines() do
        i = i + 1
        t[i] = filename
    end
    return t
end