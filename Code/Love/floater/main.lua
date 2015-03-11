vector = require "vector"
require 'middleclass'

Game = class('Game')
Game.static.theGame = nil
function Game:initialize()
   Game.theGame = self
   self.bullets = {}
   self.targets = {}
   self.sunPosition = vector(love.graphics.getWidth()/2, 
			love.graphics.getHeight()/2 )
   self.gravConstant = 100.0
   self.maxSpeed = 20
end
function Game:acceleration ( pos,dt )
   local d = self.sunPosition - pos
   local distSquared = d:len()
   d = d * dt
   d = d * self.gravConstant / distSquared
   return d
end

-------------------------------

Entity = class('Entity')
Entity.static.ents = {}
Entity.static.inverseEnts = {}
Entity.static.uniquifier = 0
function Entity:initialize(pos0,vel0)
   self.pos = vector(pos0.x, pos0.y)
   self.vel = vector(vel0.x, vel0.y)
--   self.id = Entity.uniquifier
   Entity.uniquifier = Entity.uniquifier + 1
   Entity.inverseEnts[self] = self.id
   self.id = #(Entity.ents)+1
   Entity.ents[#(Entity.ents)+1] = self

end
function Entity:deleteEnt ( ent )
--   Entity.ents[Entity.inverseEnts[ent]] = nil
end
function Entity:update(dt)
   self.vel = self.vel + Game.theGame:acceleration ( self.pos, dt )
   self.pos = self.pos + self.vel * dt
end
function Entity:checkFirstCollision(colliders)
   -- return id of collided object (first found)
   --   print('got here with ', #colliders, ' colliders')
   for k,ent in pairs(colliders) do
      if ent.id ~= self.id and ent then
	 d = ent.pos - self.pos
	 if d:len() < (ent.radius + self.radius) then
	    -- print("hit it", 100,50)
	    return k
	 end
      end
   end
   return nil
end
---------------------------------------

Bullet = class('Bullet', Entity)
function Bullet:initialize ( pos, vel )
   Entity.initialize(self, pos, vel )
   self.radius = 16
   Game.theGame.bullets[#(Game.theGame.bullets)+1] = self
end
function Bullet:update(dt)
   Entity.update(self,dt)
end
function Bullet:draw()
   love.graphics.setPointSize ( self.radius * 2 )
   love.graphics.setColor ( 255,100,100,100 )
   love.graphics.point(self.pos.x, self.pos.y)
end
   
----------------------------------------
Target = class ('Target', Entity)
function Target:initialize ( pos, vel )
   Entity.initialize(self,pos,vel)
   self.radius = 50
   self.health = 100
   Game.theGame.targets[#(Game.theGame.targets)+1] = self
end
function Target:update(dt)
end
function Target:draw()
   love.graphics.setColor ( self.health,self.health, 255, 64 )
   love.graphics.circle ( 'fill', self.pos.x, self.pos.y, self.radius, 32 )
end
function Target:damage()
   -- print("damage")
   self.health = self.health - 20
   if self.health < 0 then
      --Target:deleteEnt(self.id)
      return true
   end
   return false
end
   
----------------------------------------


function love.load()
   Game.theGame = Game:new()
   love.graphics.setBackgroundColor(54, 172, 248,255)
   local w = love.graphics.getWidth()
   local h = love.graphics.getHeight()
   local numTargets = 10
   for i=1,numTargets do
      local target = Target:new ( vector(w/2,i * h/numTargets) , vector(0,0) )
   end
end

function love.mousepressed(x,y,button)
   local b = Bullet:new(vector(x,y), vector(100,0))
end


function love.draw()
   love.graphics.setBlendMode('alpha')
--   for i,ent in ipairs(Entity.ents) do
--      ent:draw()
--   end
   for i,ent in pairs(Game.theGame.targets) do
      ent:draw()
   end
   for i,ent in pairs(Game.theGame.bullets) do
      ent:draw()
   end
end


function love.update(dt)
   for i,ent in pairs(Entity.ents) do
      ent:update(dt)
   end
   -- collide bullets with targets
   for i,bullet in pairs(Game.theGame.bullets) do
      local hit = bullet:checkFirstCollision(Game.theGame.targets)
      if hit then
	 if Game.theGame.targets[hit]:damage() then
	    Game.theGame.targets[hit] = nil
	 end
	 -- delete bullet
	 Game.theGame.bullets[i] = nil 
      end
   end
end

