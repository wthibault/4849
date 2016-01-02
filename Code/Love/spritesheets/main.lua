local anim8 = require 'anim8'
local vector = require 'vector'
local config = require 'config'

local explodeSpriteSheet,explodeAnimation
local runcycleSpriteSheet,runcycleAnimation

function explosionDone(self,loops)
   self:pauseAtEnd()
   exploding = false
   playerAlive = false
end

function love.load()
   xmin = config.margin
   ymin = config.margin
   xmax = love.graphics.getWidth() - config.margin
   ymax = love.graphics.getHeight() - config.margin
   
   explodeSpriteSheet = love.graphics.newImage(config.explodeSheetFilename)
   local g = anim8.newGrid(64,64, 
			   explodeSpriteSheet:getWidth(), 
			   explodeSpriteSheet:getHeight())
   explodeAnimation = anim8.newAnimation( g('1-5','1-5'), 0.05,
					  explosionDone )
   explodeAnimation:pauseAtStart()

   runcycleSpriteSheet = love.graphics.newImage(config.walkSheetFilename)
   local rg = anim8.newGrid(config.spriteWidth, config.spriteHeight,
			    runcycleSpriteSheet:getWidth(),
			    runcycleSpriteSheet:getHeight())
   runcycleAnimation = anim8.newAnimation ( rg('1-9','7-7'), 0.1 )
   
   manstart = vector.new( (xmax+xmin)/2, (ymax+ymin)/2 )
   manpos = manstart:clone()

   exploding = false
   playerAlive = true

   love.graphics.setBackgroundColor ( 255,255,255 )


end

function love.update(dt)
   runcycleAnimation:update(dt)
   if manpos.x >= xmax-config.spriteWidth then
      runcycleAnimation:pause()
      if not exploding then
	 exploding = true
	 explodeAnimation:resume()
      end
   else
      manpos = manpos + vector.new(1,0)
   end

   if exploding then
      explodeAnimation:update(dt)
   end
end

function love.draw()
   love.graphics.setColor ( 255,0,0 )
   love.graphics.rectangle ( 'line', xmin, ymin, xmax-xmin, ymax-ymin )

   love.graphics.setColor ( 255,255,255 )
   if playerAlive then
      runcycleAnimation:draw(runcycleSpriteSheet, manpos:unpack())
   end
   if exploding then
      explodeAnimation:draw (explodeSpriteSheet, manpos:unpack())
   end
end
