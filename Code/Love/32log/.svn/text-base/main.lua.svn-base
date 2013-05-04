-- Entity pattern using '32 lines of goodness'
-- from 
-- https://love2d.org/wiki/32_lines_of_goodness

-- vector=require "vector"  -- hump vector class (diff style class than 32log!)
require "32log"


bullets = {}
targets = {}
score = 0
COLLISION_DISTANCE = 10

------------------- Vector ----------------------
class "Vector" 
{
   x = 0;
   y = 0;
}
function Vector:__init ( x, y )
   self.x = x
   self.y = y
end
function Vector:scalarMult ( a )
   return Vector:new(self.x * a, self.y)
--   self.x = self.x * a
--   self.y = self.y * a
end
function Vector:add ( v )
   return Vector:new( self.x + v.x, self.y + v.y )
--   self.x = self.x + v.x
--   self.y = self.y + v.y
end
function Vector:sub ( v )
   return Vector:new( self.x - v.x, self.y - v.y )
--   self.x = self.x - v.x
--   self.y = self.y - v.y
end
function Vector:len()
   return math.sqrt(self.x*self.x + self.y*self.y)
end
------------------- Entity ----------------------

class "Entity" {
   pos = Vector:new(0,0);
   vel = Vector:new(0,0);
}

function Entity:__init ( x,y, vx, vy )
   self.pos = Vector:new(x,y)
   self.vel = Vector:new(vx,vy)
end

function Entity:update(dt)
   local delta = Vector:new(self.vel.x, self.vel.y)
   delta = delta:scalarMult(dt)
   self.pos = delta:add ( self.pos )
--   self.pos = self.pos + self.vel * dt
end

function Entity:draw()
--   local x,y = self.pos.unpack()
   love.graphics.circle ( 'line', self.pos.x, self.pos.y, 10 )
end

-------------------- Bullet -----------------------

class "Bullet" : extends (Entity) {
				  }

function Bullet:__init(x,y,vx,vy)
--   self.super.pos = Vector:new(x,y)
--   self.super.vel = Vector:new(vx,vy)
   self.super.__init(self,x,y,vx,vy)
end
function Bullet:update(dt)
   self.super.update(dt)
   -- check for collision
   for k,target in pairs(targets) do
--      local d = target.pos - self.pos
      local d = Vector:new(target.x,target.y)
      d:sub ( self.pos )
--      if len(d) < COLLISION_DISTANCE then
      if d:len() < COLLISION_DISTANCE then
	 targets[k]:damage()
--	 self = nil -- ??? delete self ???
      end
   end
end

function Bullet:draw()
--   local x,y = self.pos.unpack()
   local x,y = self.super.x, self.super.y
   love.graphics.circle ( 'fill', x, y, 1 )
end

------------------- LØVE callbacks ---------------------
function love.load()
   targets.atarget = Entity:new(300,50,0,0)
   bullets.abullet = Bullet:new(300,599,0,0)
end

function love.update(dt)
   for k,v in pairs(targets) do
      v:update(dt)
   end
   for k,v in pairs(bullets) do
      v:update(dt)
   end
end

function love.draw()
   for k,v in pairs(targets) do
      v:draw()
   end
   for k,v in pairs(bullets) do
      v:draw()
   end
end