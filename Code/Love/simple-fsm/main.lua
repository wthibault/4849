--[[

	Finite State Machine example
	Bill Thibault Spring 2014, Love version Spring 2015.

	States are tables with methods for "enter", "exit", and "execute"

	The entity controlled by the FSM is kept in the FSM's "owner" field.
	The "owner" of the FSM is then passed to the enter, exit, and execute functions
	to allow the state's code to operate on the specific entity.

	The "execute" method is called from fsm:update(dt)
	This function should update the owner as(if) needed, 
	and then check for state transitions that are triggered the current game state.

	To change an FSM's state, call the FSM object's changeState() method, passing in the new state.

	On each frame, if the per-frame execute() method is used, call the FSM's update() method
	which will call the current state's "execute" method () after checking if the function exists).

	In this example, the "happyState" changes the object's color for a certain duration,
	then changes to the "sadState", which transitions back to "happyState" when the user clicks on it.


	
]]

fsm    = require 'fsm'
vector = require 'vector'

happyState = {}
sadState = {}

-------------------
-- happyState
-------------------

function happyState:enter ( owner )
	owner.startTime = love.timer.getTime()
	owner.duration = 3
	owner.pos = owner.home:clone()
	owner.happiness = 1
end

function happyState:exit ( owner )

end

function happyState:execute ( owner )
	-- first, execute in current state
	local timeInState = love.timer.getTime() - owner.startTime
	local relativeTime = timeInState / owner.duration
	owner.happiness = ( 1 - relativeTime )
	owner.pos.y = owner.home.y + 40*relativeTime
	owner.pos.x = owner.pos.x + 4 * math.sin ( 2*math.pi * 4*relativeTime)
	-- then, check for state change
	if  timeInState > owner.duration then
		owner.fsm:changeState(sadState)
	end
end


-----------------------------
-- sadState
-----------------------------


function sadState:enter ( owner )
	owner.happiness = 0
end
function sadState:exit ( owner )
end
function sadState:execute ( owner )
end

--------------------------------------------------
-- LOVE callbacks

function love.load()
	entities={}
	score = 0

	local function makeNPC ( x, y )
		local npc = {}
		npc.happiness = 0
		npc.fsm = fsm.new(npc)
		npc.home = vector.new(x,y)
		npc.pos = npc.home:clone()
		npc.fsm:changeState ( happyState )
		npc.draw = function (self)
				love.graphics.setColor ( self.happiness*255, 
										 self.happiness*255, 
										 255-self.happiness*255)
			    love.graphics.circle( 'fill', self.pos.x, self.pos.y, 10 )
			end
		return npc
	end

	numNPCs = 10
	for i=1,numNPCs do
		local npc = makeNPC(math.random()*400+100, math.random()*400)
		table.insert(entities, npc)
	end
end


function love.update ( dt )
	for k,ent in pairs(entities) do
		ent.fsm:update(dt)
	end
end

function love.draw ()
	for k,ent in pairs(entities) do
		ent:draw()
	end
	love.graphics.print ( string.format("%10d", score), 20,20 )
end


function love.mousepressed ( x, y, button )
	for k,ent in pairs(entities) do
		if (ent.pos - vector(x,y)):len() < 10 then
			score = score + ent.happiness * 100 + 1
			ent.fsm:changeState ( happyState )
		end
	end
end

