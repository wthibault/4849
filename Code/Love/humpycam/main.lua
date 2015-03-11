camera = require ( 'camera' )
vector = require ( 'vector' )
gamestate = require ( 'gamestate' )

time = 0

player = {}
player.pos = vector ( 2,2 )
player.radius = 1

goal={}
goal.pos = vector ( 15, 15 )
goal.radius = 1
buzzer = love.audio.newSource("buzzer.ogg", "static")


tiles={
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,2,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,2,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,2,2,2,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
   }
tiles.width = 20
tiles.height = 20
tiles.size = 32
tiles.path = 2
tiles.wall = 1
tiles.marker = 3
tiles.extra = 4

function tiles:indexOf (col,row) 
      return  (row-1)*self.height + col 
end

function tiles:mapToWorld ( col, row )
end
------------------------------------
--
-- hump gamestate
--
menu = {}
game = {}

function menu:draw()
    love.graphics.print("Last Elapsed Time:", 200,180)
    love.graphics.print(time, 200,200)
    love.graphics.print("Press Enter to continue", 10, 10)
end

function menu:keypressed(key, code)
   print('menu:keypressed')
    if key == 'return' then
        gamestate.switch(game)
    end
end

--------------------------------------------------------------------------

function love.load() 
   if arg[#arg] == "-debug" then require("mobdebug").start() end
   math.randomseed(os.time())
   makeTiles()
   tiles:makeRandomMaze()
   cam = camera.new(100,100,1,0)
   -- cam.pos = player.pos * tiles.size + vector(tiles.size/2, tiles.size/2)
   -- cam:lookAt ( cam.pos.x, cam.pos.y )
   gamestate.registerEvents()
   gamestate.switch(menu)
end

function updateCam ( x, y, dt )
    local offset = vector (x,y) * dt
    cam.pos = cam.pos + offset
    cam:lookAt ( cam.pos.x, cam.pos.y )
  end

function game:enter()
   tiles:makeRandomMaze()
  player.pos = vector(2,2)
  local findThePath = function (pos) 
     while tiles:getTile(pos:unpack()) == tiles.wall do 
	pos = pos + vector(1,1) end
  end
--  while tiles[tiles:indexOf(player.pos:unpack()) == wall] do player.pos = player.pos + vector(1,1) end
--  while tiles[tiles:indexOf(player.pos:unpack()) == wall] do player.pos = player.pos + vector(1,1) end
  findThePath(player.pos)
  findThePath(goal.pos)
  cam.pos = player.pos * tiles.size + vector(tiles.size/2, tiles.size/2)
  time = 0
end

function game:update(dt)
   time = time + dt
   player.radius = tiles.size/2 * math.sin ( 4 * time )
   goal.radius = tiles.size/2 * math.sin ( 10 * time )
   local speed = 100
   if love.keyboard.isDown('right') then updateCam ( speed,0, dt ) end
   if love.keyboard.isDown('left') then updateCam ( -speed,0, dt ) end
   if love.keyboard.isDown('up') then updateCam ( 0,-speed, dt ) end
   if love.keyboard.isDown('down') then updateCam ( 0,speed, dt ) end
end

function game:draw()
   cam:lookAt ( cam.pos:unpack() )
   cam:attach()
   drawWorld()
   cam:detach()
   drawHud()
end

function isLegalTile ( x, y )
  return tiles:getTile(x,y) ~= tiles.wall
end

function game:keypressed(key)
   local pos = player.pos
   local offset 
   if key == "d" then offset = vector(1,0) end
   if key == "a" then offset = vector(-1,0) end
   if key == "w" then offset = vector (0,-1) end
   if key == "s" then offset = vector ( 0,1 ) end
   if key == "escape" then love.event.push('quit') end

   if offset then
      pos = pos + offset
      if isLegalTile ( pos:unpack() ) then
	 player.pos = pos
	 cam.pos = pos * tiles.size
      else love.audio.play(buzzer)
      end
 
      if player.pos == goal.pos then
	 gamestate.switch(menu)
      end
   end
end


------------------------------------------------

------------------------------------------------

function drawWorld()
   drawBackground()
   drawNPCs()
   drawPlayer()
end

function drawHud()
   love.graphics.setColor(255,255,255)
   love.graphics.printf ("Camera Cam", 25, 25, 800, "center")
end

function drawBackground()
   for row = 1,tiles.height do
      for col = 1, tiles.width do
        drawTile ( row, col )
      end
   end
end

function drawTile( row, col )
   local i = tiles:indexOf ( col,row ) -- (row-1)*tiles.height + col
   local x = col * tiles.size
   local y = row * tiles.size
   --[[if tiles[i] == 1 then
     love.graphics.setColor ( 255,0,0 )
   end
   if tiles[i] == 2 then
    love.graphics.setColor ( 0,0,255 )
   end
   love.graphics.rectangle ( 'fill', x, y, tiles.size, tiles.size )
   ]]--
   
   love.graphics.draw ( atlas, quads[tiles[i]], x, y )
end

function drawNPCs()
  local pos = goal.pos * tiles.size + vector(tiles.size/2, tiles.size/2)
  love.graphics.setColor(255,0,0)
  love.graphics.circle('fill', pos.x, pos.y, goal.radius, 16)
end

function drawPlayer()
  local pos = player.pos * tiles.size + vector(tiles.size/2, tiles.size/2)
  love.graphics.setColor(0,255,0)
  love.graphics.circle('fill', pos.x, pos.y, player.radius, 16)
end

--------------------------------------------------

function makeTiles()
   -- make quads
   atlas = love.graphics.newImage('64X64.png')
   quads = { love.graphics.newQuad ( 0,0,    32,32, 64,64 ), 
             love.graphics.newQuad ( 0, 32,  32,32, 64, 64 ),
             love.graphics.newQuad ( 32, 0,  32,32, 64, 64 ),
             love.graphics.newQuad ( 32, 32, 32,32, 64, 64 )
      }
   
end


function tiles:setTile ( x, y, id )
   if id then
      self[self:indexOf(x,y)] = id
   else
      print('added nil to tile ',x,y)
   end
end

function tiles:getTile ( x, y )
   return self[self:indexOf(x,y)]
end

function tiles:makeRandomMaze()
   -- since walls are needed, we'll look for unvisted neighbors that are TWO rows/cols
   --   away, and then mark it and the one between it and the current point as "path" tiles.

   -- recursive subdivision
   -- clear map, set all as path tiles
   for x = 1,self.width do
      for y = 1, self.height do
	 if x == 1 or x == self.width or y == 1 or y == self.height then
	    self:setTile( x, y, self.wall )
	 else
	    self:setTile ( x, y, self.path )
	 end
      end
   end
--   tiles:buildMaze ( 1, self.width, 1, self.height )
   tiles:buildMaze ( 2, self.width-1, 2, self.height-1 )
end

function tiles:goodWallPosition ( wallPos, axis, minx, maxx, miny, maxy )
   local minCorner = vector ( minx, miny )
   local maxCorner = vector ( maxx, maxy )
   local otheraxis = axis=='x' and 'y' or 'x'
   local P0 = vector ( 0,0 )
   local P1 = vector ( 0,0 )
   P0[axis] = wallPos
   P0[otheraxis] = minCorner[otheraxis]-1
   P1[axis] = wallPos
   P1[otheraxis] = maxCorner[otheraxis]+1


   local tile0 = self:getTile(P0:unpack())
   local tile1 = self:getTile(P1:unpack())
   local isWall0 = tile0==self.wall
   local isWall1 = tile1==self.wall

   -- debug
   self:setTile(P0.x, P0.y, self.extra)
   self:setTile(P1.x, P1.y, self.extra)

   return isWall0 and isWall1
end

function tiles:buildMaze ( minx, maxx, miny, maxy )
   local dx = maxx - minx
   local dy = maxy - miny
   local axis
   local minSize = 4
   if ( dx <= minSize or dy <= minSize ) then return end
   -- pick a random split point
   local mi
   local ma
   if dx > dy then
      mi = minx
      ma = maxx
      axis = 'x'
   else
      mi = miny
      ma = maxy
      axis = 'y'
   end

--   local div = math.random ( mi+2, ma-2 )

   local div
   local tries = 0
   repeat
      div = math.random ( mi+2, ma-2 )
      tries = tries + 1
   until tiles:goodWallPosition ( div, axis, minx, maxx, miny, maxy ) or tries > 100

   if tries > 100 then print ("100 tries!") return end

   -- set them as walls
   --  and pick a random pos along wall and set as path
   if dx > dy then
      x = div
      for y = miny,maxy do
	 tiles:setTile(x,y, self.wall)
      end
      -- put a door at a random spot along the wall
      local doorPos = math.random(miny+1, maxy-1)

      tiles:setTile(x, doorPos, self.marker)
      
      -- recurse on each side
      tiles:buildMaze ( minx, div-1, miny, maxy )
      tiles:buildMaze ( div+1, maxx, miny, maxy )
   else
      y = div
      for x = minx,maxx do
	 tiles:setTile(x,y,self.wall)
      end
      local doorPos = math.random(miny+1, maxy-1)
      tiles:setTile(doorPos, y, self.marker)
      -- recurse on each side
      tiles:buildMaze ( minx, maxx, miny, div-1 )
      tiles:buildMaze ( minx, maxx, div+1, maxy )
   end
end
