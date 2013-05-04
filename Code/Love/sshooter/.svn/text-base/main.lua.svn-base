COLLISION_DISTANCE = 10

function love.load()
   love.graphics.setBackgroundColor ( 255,255,255 )
   love.graphics.setColor ( 0,0,0 )

   music = love.audio.newSource("overbeated.ogg")
   music:play()

   entities = {}

   listener={}
   listener.listenerImage = love.graphics.newImage ( "ent.png" )
   listener.w = listener.listenerImage:getWidth()
   listener.h = listener.listenerImage:getHeight()
   listener.x = 320
   listener.y = 240
   listener.angle = 0

   bulletImage = love.graphics.newImage("listener.png")
   targetImage = love.graphics.newImage("ent.png")

   sound = love.audio.newSource("bing.wav", "static")
   sound:setDirection( 0, 1, 0 ) -- "down the screen. i guess"

   -- setup listener
   love.audio.setOrientation ( 0,-1,0,  0,0,1 ) -- forward and up vectors
   love.audio.setPosition ( listener.x, listener.y, 0 )
   love.audio.setVelocity ( 0, 100, 0 )

   -- setup targets
   tpos={x=320,y=240}
   tvel={x=-0.5,y=0}
   createNewTarget(tpos,tvel)
end

function love.mousepressed( x, y, button )
   sound:stop()

   sound:setPosition ( x, y, 0 )
   sound:setPitch ( y / 240.0 )
   sound:setVolume ( x / 320.0 )
   sound:play()

   pos = {x=0, y=0}
   vel = {x=x, y=y}

   createNewBullet ( pos, vel )
end

function love.draw()
   love.graphics.setColorMode("replace")
   love.graphics.setColor(0,0,0)

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
	 local dx = entities[i].pos.x - ent.pos.x
	 local dy = entities[i].pos.y - ent.pos.y
	 if math.sqrt( dx*dx + dy*dy ) < COLLISION_DISTANCE then
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
      bullet.pos.x = bullet.pos.x + bullet.vel.x * dt
      bullet.pos.y = bullet.pos.y + bullet.vel.y * dt
      
      local hit = checkForCollision ( bullet )
      if hit then
	 -- delete self from entities, explosion 
	 bullet.id = nil
	 -- damage the hit target
	 print("pow", bullet.pos.x, bullet.pos.y)
      end
      -- also check for off-screen...
   end

   bullet.draw = function ()
      love.graphics.draw(bulletImage, bullet.pos.x, bullet.pos.y)
   end

   return bullet
end

function createNewTarget ( pos, vel )
   target = {}
   target.pos = pos
   target.vel = vel
   target.angle = 0
   target.id = #entities+1
   entities[#entities+1] = target

   target.update = function (dt)
      target.pos.x = target.pos.x + target.vel.x * dt
      target.pos.y = target.pos.y + target.vel.y * dt
      target.angle = target.angle + 0.2
      
      local hit = checkForCollision ( target )
      if hit then
	 -- delete self from entities, explosion 
	 target.id = nil
	 print("pow", 320,240)
      end
      -- also check for off-screen...
   end

   target.draw = function ()
      love.graphics.draw(targetImage, target.pos.x, target.pos.y, 
			 target.angle,1,1,
			 targetImage:getWidth()/2,targetImage:getHeight()/2)
   end

   return target
end

function love.update(dt)
   for i=1,#entities do
      entities[i].update(dt)
   end
end
