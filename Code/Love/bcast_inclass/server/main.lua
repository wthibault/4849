--[[

  ####   ######  #####   #    #  ######  #####
 #       #       #    #  #    #  #       #    #
  ####   #####   #    #  #    #  #####   #    #
      #  #       #####   #    #  #       #####
 #    #  #       #   #    #  #   #       #   #
  ####   ######  #    #    ##    ######  #    #

]]--
require 'middleclass'
require 'middleclass-commons'
require 'LUBE'
vector = require 'vector'
ser = require 'ser'

function onConnect(clientId)
   print("Connection from " .. clientId)
end

function onReceive(data, clientId)
   --   print("Recv from " .. clientId .. ": " .. data)
   dtable = loadstring(data)()
   if not clients[clientId] then
      print('new client: ', clientId)
      cursors[clientId] = vector(dtable.x, dtable.y)
      cursors[clientId].score = 0
      cursors[clientId].id = clientId
      lastCollision[clientId] = nil
   end
   clients[clientId] = true
   if dtable.cmd == 'key' then
      -- print(dtable.key)
   elseif dtable.cmd == 'move' then
      -- print(dtable.x, dtable.y, dtable.dx, dtable.dy)
      cursors[clientId].x = dtable.x
      cursors[clientId].y = dtable.y
      cursors[clientId].id = clientId
      
   end
end

function onDisconnect(clientId)
   print("Disconnect from " .. clientId)
end

function love.load()
   cursors = {}
   clients = {}
   lastCollision={}
   server = lube.udpServer()
   server.callbacks.recv = onReceive
   server.callbacks.connect = onConnect
   server.callbacks.disconnect = onDisconnect
   server:listen(31337)
   print('listening')
end

function love.update(dt)
   server:update(dt)
   -- increment scores of colliders
   for c1,v1 in pairs(cursors) do
      for c2,v2 in pairs(cursors) do
         if (c1 ~= c2) and (lastCollision[c1] ~= c2) and ((v1-v2):len() < 20) then
            v1.score = v1.score + 1
            lastCollision[c1] = c2
         end
      end
   end

   for client,val in pairs(clients) do
      server:send(ser(cursors), client)
   end
end

function printScores()
   a={}
   for k,v in pairs(cursors) do
      table.insert (a, {k,v.score})
   end
   if #a == 0 then
      return
   end
   table.sort(a, function (a,b) return a[2]>b[2] end)
   px = 200
   py = 50
   offset = 15
   love.graphics.print('HIGH SCORES', px, py )
   for i,v in ipairs(a) do
      love.graphics.print (v[1], px, py + i*offset)
      love.graphics.print (v[2], px+150, py+i*offset)
   end
end

function love.draw()
   love.graphics.print("SERVER", 100,100)
   for k,v in pairs(cursors) do
      love.graphics.print(v.id, v.x, v.y)
      love.graphics.print(v.score, v.x, v.y+10)
   end
   printScores()
end
