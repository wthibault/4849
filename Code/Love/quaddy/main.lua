tiles = { 
  1,2,3,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  2,3,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  3,4,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  4,1,2,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2
  }

tiles.width = 25
tiles.height = 19
tiles.size = 32
tiles.indexOf = function(x,y) return (y-1)*tiles.width+x end

function tiles:getTile(x,y)
  return self[self.indexOf(x,y)]
end





quads = { 
  love.graphics.newQuad ( 0,0,  32,32,  64,64 ),
  love.graphics.newQuad ( 0,32,  32,32,  64,64 ),
  love.graphics.newQuad ( 32,0,  32,32,  64,64 ),
  love.graphics.newQuad ( 32,32,  32,32,  64,64 )
  }

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  image = love.graphics.newImage ( "64X64.png")
  if not image then print('newImage failed') end
end

function love.draw()
  for y = 1, tiles.height do
    for x = 1, tiles.width do
      screenX = (x-1)*tiles.size
      screenY = (y-1)*tiles.size
      love.graphics.drawq ( image, quads[tiles:getTile(x,y)], screenX, screenY )
    end
  end
end