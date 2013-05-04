love.filesystem.require("LUBE.lua") --load the file, obviously

function rcvCallback(data)
    --data is the data received, do anything you want with it
end

function load()
    --do anything else you need to do here
    lube.client.Init() --initialize
    lube.client.setHandshake("Hi!") --this is a unique string that will be sent when connecting and disconnecting
    lube.client.setCallback(rcvCallback) --set rcvCallback as the callback for received messages
    lube.client.connect(ip, port) --change ip and port into.. an ip and a port
end

function update(dt)
    lube.client.update() --usually you call this before anything else, so you always work with updated variables
    --anything else
end

function draw()
    --nothing special here
end

