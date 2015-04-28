--[[

	Finite State Machine example
	Bill Thibault Spring 2014

	States are tables with methods for "enter", "exit", and "execute"

	The Corona game object controlled by the FSM is kept in the FSM's "owner" field.
	The "owner" of the FSM is then passed to the enter, exit, and execute functions
	to allow the state's code to operate on the game object.

	The "execute" method is called every frame (from Runtime's enterFrame event).
	This function should update the owner as(if) needed, 
	and then check for state transitions that are triggered by arbitrary code.

	For state transitions triggered by Corona events such as "touch" or "collision",
	the appropriate listener should be added to the owner object in the "enter" method,
	and the handler removed in the "exit" handler.

	To change an FSM's state, call the FSM object's changeState() method, passing in the new state.

	On each frame, if the per-frame execute() method is used, call the FSM's update() method
	which will call the current state's "execute" method () after checking if the function exists).

	In this example, the "happyState" changes the object's color for a certain duration,
	then changes to the "sadState", which transitions back to "happyState" on a touch event.


	
]]

fsm = require("fsm")


-- print ("npc", npc)
-- print ("npc.fsm.owner", npc.fsm.owner)


-- declare  states here for forward referencing

happyState = {}
sadState = {}

-------------------
-- happyState
-------------------

function happyState:enter ( owner )
	-- register event (table) listeners, initialize state
	owner.startTime = system.getTimer()
	owner.duration = 3 * 1000
	owner.x = owner.homex
	owner.y = owner.homey
end

function happyState:exit ( owner )
	-- unsubscribe event listeners, cleanup
end

function happyState:execute ( owner )
	-- called every frame
	-- first, execute in current state
	local timeInState = system.getTimer() - owner.startTime
	local relativeTime = timeInState / owner.duration
	owner:setFillColor( 1 - relativeTime, math.random(), math.random() )
	owner.y = owner.homey + 400*relativeTime
	owner.x = owner.x + 40 * math.sin ( 2*math.pi * 4*relativeTime)
	owner.rotation = owner.rotation + 3
	-- then, check for state change
	if  timeInState > owner.duration then
		owner.fsm:changeState(sadState)
	end
end


-----------------------------
-- sadState
-----------------------------


function sadState:enter ( owner )
	--print ('sadState:enter()' .. owner.name )

	function owner:touch ( event )
		self.fsm:changeState(happyState)
	end

	owner:setFillColor(1,0,0,1)
	owner:addEventListener("touch", owner )
end
function sadState:exit ( owner )
	--print ('sadState:exit()' .. owner.name )
	owner:removeEventListener("touch", owner )
	return true
end
function sadState:execute ( owner )
	--print ('sadState:execute()')
end

--------------------------------------------------

entities={}

local function makeNPC ( x, y )
	local npc = display.newRect ( x, y, 100,100 )
	npc.name = "npc"
	npc.fsm = fsm.new(npc)
	npc.homex = x
	npc.homey = y
	npc.fsm:changeState ( happyState )
	return npc
end

numNPCs = 10
for i=1,numNPCs do
	local npc = makeNPC(math.random()*400+100, math.random()*400)
	table.insert(entities, npc)
end

--
-- update() is the global enterFrame listener
--  it calls execute on all the fsm's of current entities
-- (you don't need to call fsm:update() like this if all your execute()'s are empty)
--
function update ( event )
	for i=1,#entities do
		entities[i].fsm:update(event)
	end
end


Runtime:addEventListener("enterFrame", update)

