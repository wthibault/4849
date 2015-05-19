-- camdemo
-- uses HUMP camera and vector to follow player
--
camera = require 'camera'
vector = require 'vector'
config = require 'config'

function love.load()

	level={}
	level.maxX = 20000
	level.maxY = love.window.getHeight()/2
	level.obstacles = {}
	for i=1,100 do
		level.obstacles[i] = vector(love.math.random(0,level.maxX), level.maxY)
		level.obstacles[i].radius = love.math.random(5,10)
	end

	cam = camera.new()

	bgcam = camera.new()
	bgcam.zoom = config.bgzoom
	bgcam2 = camera.new()
	bgcam2.zoom = 0.9 * config.bgzoom

	player = {accel=config.gravityAccel, 
				pos=vector(love.window.getWidth()/2,level.maxY-100),
			    vel = vector(0,0),
				radius = 20}
	

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

	-- background too
	bgcam.pos.x = player.pos.x
	bgcam2.pos.x = player.pos.x

	local t = love.timer.getTime()
	love.graphics.setBackgroundColor ( 	127 + 64 * (math.sin(t)+1),
										127 + 64 * (math.sin(1.6*t)+1),
										127 + 64 * (math.sin(3.14159*t)+1)) 

end

function drawBackground(seed)
	-- draw background
	love.math.setRandomSeed ( seed )
	for i=1,300 do
		love.graphics.setColor ( love.math.random(100,255),
								love.math.random(100,255),
								love.math.random(100,255))
		love.graphics.circle ( "fill", love.math.random(-300,level.maxX),
										love.math.random(-love.window.getHeight(),love.window.getHeight()*2),
										200 )
	end
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
	love.graphics.circle("fill", player.pos.x, player.pos.y-player.radius, player.radius )
end

function love.draw()
	-- draw the background with a zoomed camera
	bgcam2:draw(function () drawBackground(57) end)
	bgcam:draw(function () drawBackground(99) end)

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


