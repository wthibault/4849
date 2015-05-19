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
   end
   clients[clientId] = true
   if dtable.cmd == 'key' then
      -- print(dtable.key)
   elseif dtable.cmd == 'move' then
      -- print(dtable.x, dtable.y, dtable.dx, dtable.dy)
      cursors[clientId] = vector(dtable.x, dtable.y)
      cursors[clientId].id = clientId
   end
end

function onDisconnect(clientId)
   print("Disconnect from " .. clientId)
end

function love.load()
   cursors = {}
   clients = {}
   server = lube.udpServer()
   server.callbacks.recv = onReceive
   server.callbacks.connect = onConnect
   server.callbacks.disconnect = onDisconnect
   server:listen(31337)
   print('listening')
end

function love.update(dt)
   server:update(dt)
   for client,val in pairs(clients) do
      server:send(ser(cursors), client)
   end
end

function love.draw()
   love.graphics.print("SERVER", 100,100)
   for k,v in pairs(cursors) do
      love.graphics.print(v.id, v.x, v.y)
   end
end
