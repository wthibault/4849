hump={}
hump.vector = require "vector"

function flyStrategy ( self, dt )
   self.vel = hump.vector(1, 0.0 )
   self.vel:rotate_inplace ( self.angle )
   self.pos = self.pos + self.vel * dt
end

function love.load()

   entities = {}

   shipImage = love.graphics.newImage("listener.png")

   initPos=hump.vector(320,240)
   initVel=hump.vector(0,1)
   ship = createNewShip(initPos,initVel)
end

function love.mousepressed(x,y,button)
   if button == 'l' then
      ship.strategy = nil
   else
      ship.strategy = flyStrategy
   end
end


function love.draw()
--   love.graphics.setColorMode("replace")

for i = 1,#entities do
   if entities[i].id then
    entities[i]:draw()
 end
 love.graphics.print(tostring(i), 400, 200 )
end

end

function checkForCollision ( ent )
   -- return id of collided object (first found)
   for i = 1,#entities do
      if i ~= ent.id and entities[i].id then
       d = entitites[i].pos - ent.pos
       if d:len() < COLLISION_DISTANCE then
          print("hit it", 100,50)
          return i
       end
    end
 end
 return nil
end


function createNewBullet ( pos, vel )
   local bullet = {}
   bullet.pos = pos
   bullet.vel = vel
   bullet.id = #entities+1
   entities[#entities+1] = bullet
   print("new bullet at ", pos.x, pos.y, vel.x, vel.y)

   bullet.update = function (dt) 
   if bullet.updateStrategy then
    bullet.updateStrategy(bullet,dt)
 else
    bullet.pos = bullet.pos + bullet.vel * dt
 end
 
 local hit = checkForCollision ( bullet )
 if hit then
	 -- delete self from entities, explosion 
	 bullet.id = nil
	 -- damage the hit target
	 print("pow", bullet.pos )
   end
      -- also check for off-screen...
   end

   bullet.draw = function ()
   love.graphics.draw(bulletImage, bullet.pos.x, bullet.pos.y)
end

return bullet
end

function createNewShip ( pos, vel )
   ship = {}
   ship.pos = pos
   ship.vel = vel
   ship.angle = 0
   ship.id = #entities+1
   entities[#entities+1] = ship

   ship.update = function (dt)
   if ship.updateStrategy then
    ship.updateStrategy(ship,dt)
 else
    ship.pos = ship.pos + ship.vel * dt
    ship.angle = ship.angle + 0.2
 end
 
 local hit = checkForCollision ( ship )
 if hit then
	 -- delete self from entities, explosion 
	 ship.id = nil
	 print("pow", 320,240)
   end
      -- also check for off-screen...
   end

   ship.draw = function ()
   love.graphics.draw(shipImage, ship.pos.x, ship.pos.y, 
     ship.angle,1,1,
     shipImage:getWidth()/2,shipImage:getHeight()/2)
end

return ship
end

function love.update(dt)
   for i=1,#entities do
      entities[i].update(dt)
   end
end
