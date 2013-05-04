function love.load()
   bullets = {}
   targets = { {x=300,y=50}, {x=400,y=50}, {x=500,y=50} }
end

function love.keypressed ( key, unicode )
   if key == ' ' then
      bullets[#bullets+1] = {x=400,y=599,vx=0, vy=-1}
   end
end

function love.update(dt)
   for k,bullet in pairs(bullets) do
--      bullets[i].x = bullets[i].x + bullets[i].vx
--      bullets[i].y = bullets[i].y + bullets[i].vy
      bullet.x = bullet.x + bullet.vx
      bullet.y = bullet.y + bullet.vy
      
      for t,target in pairs(targets) do
	 local dx = target.x - bullet.x
	 local dy = target.y - bullet.y
	 if math.sqrt(dx*dx+dy*dy) < 10 then
	    bullets[k] = nil
	    targets[t] = nil
	    break
	 end
      end
   end
end

function love.draw()
   for k,v in pairs(targets) do
      love.graphics.circle("fill", v.x, v.y, 10 )
   end
   for k,v in pairs(bullets) do
      love.graphics.circle("fill", v.x,v.y, 1)
   end
end
