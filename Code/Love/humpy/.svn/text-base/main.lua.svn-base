hump={}
hump.vector = require "vector"

function love.load()
   player={}
   player.velocity=hump.vector(10,30)
   player.position = hump.vector(320,240)
   
   A = hump.vector(100,200)
   B = hump.vector(300,350)
   C = hump.vector(150,450)

   BC = C - B
   AB = B - A

   AC = AB + BC

   twoA = 2 * A


   print ( 'A', A )
   print ( 'twoA', twoA )
   print ( 'B', B )
   print ( 'C', C )
   print ( 'AB', AB  )
   print ( 'BC', BC )
   print ( 'AC', AC )

end

function love.update(dt)
	 acceleration = hump.vector(0,-9)
	 player.velocity = player.velocity + acceleration * dt
	 player.position = player.position + player.velocity * dt
end

function drawLine ( A, B )
	 x1,y1 = A:unpack()
	 x2,y2 = B:unpack()
	 love.graphics.line ( x1, y1, x2, y2 )
end
   
function love.draw()
	 image = love.graphics.newImage("masonic-eye.jpg")
	 love.graphics.print(tostring(player.position), 300,200)
	 love.graphics.print(tostring(player.velocity), 300,240)
	 love.graphics.draw(image,player.position:unpack())

	 love.graphics.setLineWidth ( 7.0 )
	 love.graphics.setColor ( 255,0,0 )
	 drawLine ( A, B )
	 drawLine ( B, C )
	 
	 love.graphics.setLineWidth ( 1.0 )
	 love.graphics.setColor ( 0,255, 0 )
	 drawLine ( A, A+AB )
	 drawLine ( B, B+BC )
	 drawLine ( A, A+AC )
end
