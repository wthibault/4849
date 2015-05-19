-- camdemo
-- uses HUMP camera and vector to follow player
--
camera = require 'camera'
vector = require 'vector'
config = require 'config'

function love.load()

	level={}
	level.maxX = 10000
	level.maxY = love.window.getHeight()/2
	level.obstacles = {}
	for i=1,100 do
		level.obstacles[i] = vector(love.math.random(0,level.maxX), level.maxY)
		level.obstacles[i].radius = love.math.random(5,10)
	end

	cam = camera.new()
	player = {accel=config.gravityAccel, 
				pos=vector(love.window.getWidth()/2,level.maxY-100),
			    vel = vector(0,0)}
	

end


function love.update(dt)
	player.vel = player.vel + player.accel + config.gravityAccel
	player.pos = player.pos + player.vel
	player.vel = player.vel * 0.99

	-- constrain to playing field
	player.pos.y = math.min (player.pos.y, level.maxY)
	if player.pos.y == level.maxY then
		player.vel.y = 0
	end

	-- follow player with camera
	cam.pos.x = player.pos.x

end

function draw()

	-- draw playfield
	love.graphics.setColor ( 255,255,255 )
	love.graphics.line ( 0, level.maxY, level.maxX, level.maxY)

	-- draw obstacles
	love.graphics.setColor ( 255,0,0 )
	for i = 1,#level.obstacles do
		local o = level.obstacles[i]
		love.graphics.circle("fill", o.x, o.y, o.radius)
	end
	love.graphics.circle("fill", level.maxX, level.maxY, 500) -- boss

	-- draw player
	love.graphics.setColor ( 0,255, 0 )
	love.graphics.circle("fill", player.pos.x, player.pos.y, 15 )
end

function love.draw()
	-- draw the scene using the camera
	cam:draw(draw)
	
	-- HUD
	love.graphics.print ( tostring(player.accel), 10,10 )
end

function love.keypressed(key,isrpt)
	if key == 'left' then
		player.accel = player.accel + config.leftAccel
	elseif key == 'right' then
		player.accel = player.accel + config.rightAccel
	elseif key == 'up' then 
		player.accel = player.accel + config.jumpAccel
	end
end

function love.keyreleased(key)
	if key == 'left' then
		player.accel = player.accel - config.leftAccel
	elseif key == 'right' then
		player.accel = player.accel - config.rightAccel
	elseif key == 'up' then 
		player.accel = player.accel - config.jumpAccel
	end
end


