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

vector = require 'vector'

player = vector (10,10)

function tiles:getTile(x,y)
  return self[self.indexOf(x,y)]
end

function tiles:mapToScreen ( x, y )
  return (x-1)*self.size, (y-1)*tiles.size end


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
  gkey=' '
end

function love.draw()
  for y = 1, tiles.height do
    for x = 1, tiles.width do
      screenX, screenY = tiles:mapToScreen ( x, y )
      love.graphics.drawq ( image, quads[tiles:getTile(x,y)], screenX, screenY )
    end
  end
  love.graphics.print(gkey,300,400)
  love.graphics.setColor(255,0,0)
  local x,y = tiles:mapToScreen(player.x, player.y)
  local pos = vector(x,y)
  pos = pos + vector ( tiles.size/2, tiles.size/2)
  love.graphics.circle("fill", pos.x, pos.y, 16, 32)
  love.graphics.setColor(255,255,255)
end

function love.update(dt)
  if love.keyboard.isDown("right") then
    player.x = player.x + 1
  end
  if love.keyboard.isDown("up") then
    player.y = player.y - 1
  end
  
end


function love.keypressed(key)
  gkey = key
  if key == "left" then
    player.x = player.x - 1
  elseif key == "right" then
    player.x = player.x + 1
  elseif key == "up" then
    player.y = player.y - 1
  elseif key == "down" then
    player.y = player.y + 1
  end
end

