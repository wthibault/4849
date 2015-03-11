function love.load()
   love.graphics.setBackgroundColor ( 255,255,255 )

   music = love.audio.newSource("overbeated.ogg") -- if "static" is omitted, LÖVE will stream the file from disk, good for longer music tracks
   music:play()

   listener={}
   listener.listenerImage = love.graphics.newImage ( "listener.png" )
   listener.w = listener.listenerImage:getWidth()
   listener.h = listener.listenerImage:getHeight()
   listener.x = 320
   listener.y = 240
   listener.angle = 0

   sound = love.audio.newSource("bing.wav", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
   sound:setDirection( 0, 1, 0 ) -- "down"

   -- setup listener
   love.audio.setOrientation ( 0,-1,0,  0,0,1 ) -- forward and up vectors
   love.audio.setPosition ( listener.x, listener.y, 0 )
   love.audio.setVelocity ( 0, 100, 0 )
end

function love.mousepressed( x, y, button )
   sound:stop()
   -- set source  position (doesn't seem to work on macosx?)
   sound:setPosition ( x, y, 0 )
   sound:setPitch ( y / 240.0 )
   sound:setVolume ( x / 320.0 )
   sound:play()
end

function love.draw()
--   love.graphics.setColorMode("replace")
   love.graphics.draw(listener.listenerImage, 
		      listener.x, listener.y, 
		      math.rad(listener.angle), 
		      1, 1, 
		      listener.w/2, listener.h/2)
end

