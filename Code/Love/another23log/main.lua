-- Entity pattern using '32 lines of goodness'
-- from 
-- https://love2d.org/wiki/32_lines_of_goodness

require "32log"
vector=require "vector"  -- hump vector class (diff style class than 32log!)


bullets = {}
targets = {}
score = 0
COLLISION_DISTANCE = 10

------------------- Entity ----------------------

class "Entity" {
   pos = vector(0,0);
   vel = vector(0,0);
}

function Entity:__init ( p, v )
   self.pos = p
   self.vel = v
end

function Entity:update(dt)
   self.pos = self.pos + self.vel * dt
end

function Entity:draw()
   local x,y = self.pos.unpack()
   love.graphics.circle ( 'line', x, y, 10 )
end

-------------------- Bullet -----------------------

class "Bullet" : extends (Entity) {
				  }

function Bullet:update(dt)
   self.super.update(dt)
   -- check for collision
   for k,target in pairs(targets) do
      local d = target.pos - self.pos
      if len(d) < COLLISION_DISTANCE then
	 targets[k]:damage()
	 self = nil -- ??? delete self ???
      end
   end
end

function Bullet:draw()
   local x,y = self.pos.unpack()
   love.graphics.circle ( 'fill', x, y, 1 )
end