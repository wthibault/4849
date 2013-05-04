vector = require "vector"
require 'middleclass'
Stateful = require "stateful"
bsp = require "bsp"

numNPCs = 100


-- This example shows using 'middleclass' objects and 'stateful.lua' to 
-- get FSMs using the Strategy pattern.



Game = class('Game')
Game.static.theGame = nil  -- the Singleton

function Game:initialize()
   Game.theGame = self
   self.bullets = {}
   self.npcs = {}
   self.sunPosition = vector(love.graphics.getWidth()/2, 
			love.graphics.getHeight()/2 )
   self.gravConstant = 50.0
   self.maxSpeed = 200
   self.bulletTree = nil
   self.npcTree = nil
   self.bulletRadius = 16
   self.npcRadius = 50
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
function Entity:initialize(pos0,vel0)
   self.pos = vector(pos0.x, pos0.y)
   self.vel = vector(vel0.x, vel0.y)
   -- use this pattern for ids, but never loop on indices, always use pairs not ipairs
   -- the # op give next open slot, may be gaps due to attrition
   self.id = #(Entity.ents)+1
   Entity.ents[#(Entity.ents)+1] = self
   
end
function Entity:update(dt)
   -- default update uses gravity acceleration to sun
   self.vel = self.vel + Game.theGame:acceleration ( self.pos, dt )
   if self.vel:len() > Game.theGame.maxSpeed then
      self.vel = self.vel / self.vel:len() * Game.theGame.maxSpeed
   end
   self.pos = self.pos + self.vel * dt
end

function Entity:checkFirstCollisionBruteForce(colliders)
   -- return id of collided object (first one found) in supplied table of entities
   -- return nil if no collision found
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
function Entity:checkFirstCollision(colliderTree)
   -- return id of collided object (first one found) in supplied table of entities
   -- return nil if no collision found
   local collisions = bsp.withinDisk ( colliderTree, self.pos, self.radius )
   if collisions then
      for k,entpos in pairs(collisions) do
	 if entpos ~= self.pos then
	    local d = entpos - self.pos
	    if d:len() < (Game.theGame.npcRadius + self.radius) then
	       -- print("hit it", 100,50)
	       return k
	    end
	 end
      end
   end
   return nil
end
---------------------------------------

Bullet = class('Bullet', Entity)
function Bullet:initialize ( pos, vel )
   Entity.initialize(self, pos, vel )
   self.radius = Game.theGame.bulletRadius
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

NPC = class ('NPC', Entity)
NPC:include(Stateful)

function NPC:initialize ( pos, vel )
   Entity.initialize(self,pos,vel)
   self.radius = Game.theGame.npcRadius
   self.health = 100
   Game.theGame.npcs[#(Game.theGame.npcs)+1] = self
end
function NPC:update(dt)
end
function NPC:draw()
   love.graphics.setColor ( self.health,self.health, 255, 64 )
   love.graphics.circle ( 'fill', self.pos.x, self.pos.y, self.radius, 32 )
end
function NPC:damage()
   -- print("damage",self.health)
   self.health = self.health - 20
   if self.health < 0 then
      return true
   end
   return false
end

-- steering - avoid bullets
function NPC:Avoid(them)
   -- find the closest one and avoid it
   -- return a vector for forace
   -- uses bsp tree
   local forceConstant = 5
   local minDist = 100
   local closest;
   local d;
   if them then

      local near = bsp.withinDisk ( Game.theGame.bulletTree, self.pos, minDist )
      if near then
	 for k,it in pairs(near) do
	    d = self.pos - it
	    local dist = d:len()
	    if dist < minDist then
	       minDist = dist
	       closest = it
	    end
	 end
      end

      if closest then
        local steeringForce = (self.pos - closest) * 
              forceConstant / minDist*minDist
        return steeringForce
      end
   end
   return nil
end

-- steering - avoid bullets
function NPC:AvoidBruteForce(them)
   -- find the closest one and avoid it
   -- return a vector for forace
   -- XXX needs spatial index
   local forceConstant = 5
   local minDist = 100
   local closest;
   local d;
   if them then
      for k,it in pairs(them) do
        d = self.pos - it.pos
        local dist = d:len()
        if dist < minDist then
          minDist = dist
          closest = it
        end
      end
      if closest then
        local steeringForce = (self.pos - closest.pos) * 
              forceConstant / minDist*minDist
        return steeringForce
      end
   end
   return nil
end
   
--- NPC states --- 
-- With stateful classes, you can override a method that belongs to the stateful class
-- by defining a method of the same name in the state, and passing the State to the addState method.
-- States also get enteredState() and exitedState() callbacks when the state changes.

-- The Idle state draws itself as a large stationary disk.
-- If it gets hit, or too much time elapses, it changes state to Moving
Idle = NPC:addState('Idle')
function Idle:enteredState()
   self.radius = Game.theGame.npcRadius
   self.startTime = love.timer.getTime()
   self.timeout = 15
--   self.sound = love.audio.newSource("bing.wav", "static") 
--   love.audio.play(self.sound)
   self.vel = vector(0,0)
end
function Idle:update(dt)
   if self.health < 100 or (love.timer.getTime() - self.startTime) > self.timeout then
      self:gotoState('Moving')
   end
end
function Idle:exitedState()
--   love.audio.stop(self.sound)
end

-- The Moving state changes its radius and starts a timer to revert to Idle in 10 seconds
-- Moving also overrides the draw method by changing the radius,  
-- calling the old "owner's" draw method and then drawing a 'tail'
-- we also apply a steering force to our velocity before the entity update
Moving = NPC:addState('Moving')
function Moving:enteredState()
   self.radius = 8
   self.startTime = love.timer.getTime()
   self.revertTime = 10
--   self.sound = love.audio.newSource("upsy.wav", "static") 
--   love.audio.play(self.sound)
end
function Moving:update(dt)
   elapsedTime = love.timer.getTime() - self.startTime -- time since we entered the state
   self.radius =  4+4 *math.abs(math.sin(9*math.pi * elapsedTime)) -- 9Hz flutter
   local steeringForce = self:Avoid ( Game.theGame.bullets )
   if steeringForce then
      self.vel = self.vel + steeringForce * dt
   end
   Entity.update(self,dt)
   if elapsedTime > self.revertTime then
      self.health = 100
      self:gotoState('Idle')
   end
end
function Moving:draw()
   NPC.draw ( self )
   local ahead = self.pos - self.vel * 0.15
   love.graphics.line ( self.pos.x, self.pos.y, ahead.x, ahead.y )
end
function Moving:exitedState()
--   love.audio.stop(self.sound)
end

----------------------------------------


function love.load()
   if arg[#arg] == "-debug" then require("mobdebug").start() end 
   Game.theGame = Game:new()
--   love.graphics.setBackgroundColor(54, 172, 248,255)
   love.graphics.setBackgroundColor(0,0,0,255)
   local w = love.graphics.getWidth()
   local h = love.graphics.getHeight()
--   love.graphics.setMode(w,h,true)
   for i=1,numNPCs do
      local target = NPC:new ( vector(w/2,i * h/numNPCs) , vector(100,0) )
      target:gotoState('Idle')
   end
   -- for demo, start with a bullet or more
   math.randomseed(os.time())
   xSpacing = math.random() * 20.0
   ySpacing = math.random() * 40.0
   for i=1,numNPCs*2 do
      local b = Bullet:new(vector( xSpacing*i,ySpacing*i ), vector (100,0) )
   end
end

function love.mousepressed(x,y,button)
   local b = Bullet:new(vector(x,y), vector(100,0))
end


function love.draw()
   love.graphics.setColorMode('replace')
   love.graphics.setBlendMode('alpha')

   love.graphics.setColor ( 255,255,0,255 )
   love.graphics.circle ( 'fill', Game.theGame.sunPosition.x, Game.theGame.sunPosition.y, 10 )

--   for i,ent in ipairs(Entity.ents) do
--      ent:draw()
--   end
   for i,ent in pairs(Game.theGame.npcs) do
      ent:draw()
   end
   for i,ent in pairs(Game.theGame.bullets) do
      ent:draw()
   end
end


function love.update(dt)
   -- build bsp trees
   function buildFromPos(t)
      local pts={}
      for i,b in pairs(t) do
	 if b then table.insert(pts,b.pos) end
      end
      print('building bsp tree with', #pts, 'points')
      return bsp.build(pts)
   end

   Game.theGame.bulletTree = buildFromPos(Game.theGame.bullets)
   Game.theGame.npcTree = buildFromPos(Game.theGame.npcs)


   -- update the ents
   for i,ent in pairs(Entity.ents) do
      ent:update(dt)
   end

   -- collide bullets with npcs
   for i,bullet in pairs(Game.theGame.bullets) do
--      local hit = bullet:checkFirstCollision(Game.theGame.npcs)
      local hit = bullet:checkFirstCollision(Game.theGame.npcTree)
      if hit then
	 if Game.theGame.npcs[hit]:damage() then
	    Game.theGame.npcs[hit] = nil
	 end
	 -- delete bullet
	 Game.theGame.bullets[i] = nil 
      end
   end

end

