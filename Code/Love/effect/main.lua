vector = require 'vector'

function love.load ()
   canvas = love.graphics.newCanvas()

   local vertices = {
      {
	 -- top-left corner
	 0,0, -- position of the vertex
	 0, 0, -- texture coordinate at the vertex position
	 255, 0, 0, -- color of the vertex
      },
      {
	 -- top-right corner (green-tinted)
	 love.graphics.getWidth(), 0, 
	 1, 0,               -- texture coordinates are in the range of [0, 1]
	 0, 255, 0
      },
      {
	   -- bottom-right corner (blue-tinted)
	 love.graphics.getWidth(), love.graphics.getHeight(),
	 1, 1,
	 0, 0, 255
      },
      {
	 -- bottom-left corner (yellow-tinted)
	 0, love.graphics.getHeight(),
	 0, 1,
	 255, 255, 0
      },
    }
   
   -- the Mesh DrawMode "fan" works well for 4-vertex Meshes.
   mesh = love.graphics.newMesh(vertices, canvas, "fan")
   

   local passthrucode = [[

      vec4 effect( vec4 color, 
		   Image texture, 
		   vec2 texture_coords, 
		   vec2 screen_coords )
      {
         return Texel(texture, texture_coords);
      }
   ]]


-- Simple 3x3 box blur
local simple_blur = [[

    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc) {
        float intensity = 1.0;
        vec2 offset = vec2(1.0)/love_ScreenSize.xy;
        color = Texel(tex, tc);

        color += Texel(tex, tc + intensity*vec2(-offset.x, offset.y));
        color += Texel(tex, tc + intensity*vec2(0.0, offset.y));
        color += Texel(tex, tc + intensity*vec2(offset.x, offset.y));

        color += Texel(tex, tc + intensity*vec2(-offset.x, 0.0));
        color += Texel(tex, tc + intensity*vec2(0.0, 0.0));
        color += Texel(tex, tc + intensity*vec2(offset.x, 0.0));

        color += Texel(tex, tc + intensity*vec2(-offset.x, -offset.y));
        color += Texel(tex, tc + intensity*vec2(0.0, -offset.y));
        color += Texel(tex, tc + intensity*vec2(offset.x, -offset.y));

        return color/9.0;
    }
]]

   local pixelcode = [[


      vec4 effect( vec4 color, 
		   Image texture, 
		   vec2 texture_coords, 
		   vec2 screen_coords )
      {
        float incr = 1.0 / love_ScreenSize.x;
        float offsets[3];
        float weights[3];
       
        offsets[0] = -1 * incr;
        offsets[1] = 0.0;
        offsets[2] =  1 * incr;

        weights[0] = -1.0;
        weights[1] = 2.0;
        weights[2] = -1.0;

        vec4 outcolor = vec4(0.0, 0.0, 0.0, 0.0);

        float sum = 0;
        for (int i = 0; i < 3; i++) {
          sum += weights[i];
          outcolor += weights[i] * Texel ( texture, 
                                           texture_coords + vec2(offsets[i],0.0) );
        }
        return outcolor/sum;
      }
    ]]
   
   local vertexcode = [[

        vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            return transform_projection * vertex_position;
        }
    ]]
   
   shaders = {}
   shaders.effect = love.graphics.newShader(pixelcode, vertexcode)
   shaders.passthru = love.graphics.newShader(passthrucode, vertexcode)
   shaders.blur = love.graphics.newShader(simple_blur, vertexcode)
   currentShader = 'passthru'

   pos = vector.new ( love.graphics.getWidth()/2, love.graphics.getHeight()/2 )
   vel = vector.new ( 1.5, 2.1 )
   time = 0

   font = love.graphics.newFont(24)
end


function love.keypressed ( char, isrepeat )
   if currentShader == 'passthru' then
      currentShader = 'blur'
   elseif currentShader == 'blur' then
      currentShader = 'effect'
   else
      currentShader = 'passthru'
   end
end


function love.update ( dt )
   time = time + dt
   pos = pos + vel
   if pos.x > love.graphics.getWidth() or pos.x < 0 then
      vel.x = vel.x * -1
   end
   if pos.y > love.graphics.getHeight() or pos.y < 0 then
      vel.y = vel.y * -1
   end
end



function love.draw ()
   love.graphics.setCanvas ( canvas )
     canvas:clear()

     love.graphics.setColor(255,255,255)
     for i=1,80 do
	love.graphics.line (i*10,0, i*20,love.graphics.getHeight())
	love.graphics.line (0,i*5, love.graphics.getWidth(), i*45)
     end

     love.graphics.setColor(255,255,0)
     love.graphics.circle ( 'fill', 
			    pos.x, pos.y,
			    love.graphics.getHeight()/20,
			    20 )

     love.graphics.setFont ( font )
     love.graphics.print ( currentShader, 
			   love.graphics.getWidth()/2,
			   love.graphics.getHeight()/2, 
			   0,
                           1,1 )
   love.graphics.setCanvas()

   love.graphics.setShader(shaders[currentShader])
     love.graphics.draw(mesh)
   love.graphics.setShader()
end
