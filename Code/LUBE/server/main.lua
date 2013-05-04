require "hump.class"
require "LUBE.lua"

function connCallback(ip, port) --when a client connects
    --do something
end

function rcvCallback(data, ip, port) --same as in client, but also receives ip and port of sender
end

function disconnCallback(ip, port) --when a client disconnects
end

function love.load()
    --anything
    lube.Server.init(1500) --again, change port
    lube.Server.setCallback(rcvCallback, connCallback, disconnCallback) --set the callbacks
    lube.Server.setHandshake("Hi!") --should be the same as the client
end

function love.update(dt)
    lube.Server.update() --same story as client
end

function love.draw()
end
