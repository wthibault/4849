--[[
  ####   #          #    ######  #    #   #####
 #    #  #          #    #       ##   #     #
 #       #          #    #####   # #  #     #
 #       #          #    #       #  # #     #
 #    #  #          #    #       #   ##     #
  ####   ######     #    ######  #    #     #
]]--
require 'middleclass'
require 'middleclass-commons'
require 'LUBE'
local ser = require 'ser'
local config = require 'config'

function rcvCallback(data)
   --data is the data received, do anything you want with it
   --   print('rcvCallback:', data)
   cursors = loadstring(data)()
end

function love.load()
        --do anything else you need to do here
   time = 0
   cursors = {}
   colors={}
   client = lube.udpClient()
   client.callbacks.recv = rcvCallback
   local conn = client:connect('localhost', 31337)
   if conn then print ('connected:', conn) end

   canvas = love.graphics.newCanvas ( love.window.getWidth(), love.window.getHeight() )
   --
   --
   --


    local vertices = {
        {
	   -- top-left corner (red-tinted)
            0, 0, -- position of the vertex
            0, 0, -- texture coordinate at the vertex position
            255, 0, 0, -- color of the vertex
        },
        {
	   -- top-right corner (green-tinted)
	   love.window.getWidth(), 0,
	   1, 0, -- texture coordinates are in the range of [0, 1]
            0, 255, 0
        },
        {
	   -- bottom-right corner (blue-tinted)
	   love.window.getWidth(), love.window.getHeight(),
            1, 1,
            0, 0, 255
        },
        {
	   -- bottom-left corner (yellow-tinted)
	   0, love.window.getHeight(),
            0, 1,
            255, 255, 0
        },
    }
   
    -- the Mesh DrawMode "fan" works well for 4-vertex Meshes.
    mesh = love.graphics.newMesh(vertices, image, "fan")



   local pixelcode = [[

      extern number time;

      vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
      {
            // for rendering text, the texture holds the character glyph
            vec4 outcolor = Texel(texture,texture_coords);
            outcolor.r = abs(sin(time));
            outcolor.g = abs(cos(1.609*time));
            return outcolor;
      }
    ]]

    local fxcode = [[

      extern number xcenter;
      extern number ycenter;

      vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
      {
            vec2 offset = texture_coords - vec2 ( xcenter, ycenter );
            offset *= 0.001;
            vec4 outcolor = 0.99*Texel(texture,texture_coords+offset);
            outcolor.a = 0.25;
            return outcolor;
      }
    ]]

   
   local vertexcode = [[

        vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            return transform_projection * vertex_position;
        }
    ]]
   
   shader = love.graphics.newShader(pixelcode, vertexcode)
   fx = love.graphics.newShader(fxcode, vertexcode)
   fx:send("xcenter", 0.5)
   fx:send("ycenter", 0.5)

end

function love.update(dt)
   time = time + dt
   client:update(dt)
   shader:send("time", time)

   for k,v in pairs(cursors) do
      if not colors[k] then
        colors[k] = {love.math.random(100,255),
                      love.math.random(100,255),
                      love.math.random(100,255)}
      end
    end
end

function love.draw()



  love.graphics.setCanvas ( canvas )
  love.graphics.setBlendMode ( 'alpha')
  love.graphics.setShader(shader)
  love.graphics.setColor(0,0,0,255)
  love.graphics.print("CLIENT", 100,100)
  love.graphics.setShader()

  for k,v in pairs(cursors) do
      love.graphics.setColor(colors[k][1], colors[k][2], colors[k][3], 200 )
      love.graphics.circle("fill", v.x, v.y, 20)
      love.graphics.setColor(255,255,255,255)
      love.graphics.print(v.score, v.x-6, v.y-6)
  end



  love.graphics.setBlendMode('alpha')
  love.graphics.setShader(fx)
  for i=1,10 do
    love.graphics.draw(canvas)
  end
  love.graphics.setShader()

  love.graphics.setCanvas()
  love.graphics.draw(canvas)

end

function love.keypressed( _key, _isrepeat )
   local msg = ser ( {cmd='key', key=_key} )
   client:send(msg)
end

function love.mousemoved ( _x, _y, _dx, _dy )
   local msg = ser ( {cmd='move', x=_x, y=_y, dx=_dx, dy=_dy} )
   client:send(msg)
end

