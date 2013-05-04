function outside ()
   print ("You are standing outside a house. You need to find a bathroom.")
   local move = io.read()
   if move == 'east' then return entry()
   else
      print ('Stragely, you cannot move that way.')
      return outside()
   end
end

function entry ()
   print ('You are in an entryway with lots of marble statues of insects.')
   print ('You are getting worried about finding the bathroom in time.')
   local move = io.read()
   if move == 'north' then return parlor()
   elseif move == 'west' then return outside()
   else
      print ('The statues block your way.')
      return entry ()
   end
end

function parlor ()
   print ('You are in an elegant mid-twentieth century livingroom.')
   print ('There are few pieces of low furniture on the warm cork floor.')
   print ('You are starting to have to seriosly hold it in.')
   local move = io.read()
   if move == 'east' then return hallway()
   elseif move == 'south' then return entry()
   else
      print ('The furniture beckons you but you need a bathroom quick.')
      return parlor()
   end
end

function hallway ()
   print ('You are in a hallway with a cold stone floor and several dusty suits of armor.')
   print ('Your posture is starting to be affected by your overfull bladder.')
   local move = io.read()
   if move == 'east' then return bedroom()
   elseif move == 'west' then return parlor()
   else
      print ('The suit of armor you bumped into puts up a cloud of dust and you sneeze violently.')
      print ('Almost lost it there.')
      return hallway()
   end
end

function bedroom ()
   print ('You are in a dark bedroom with a futon on the floor and some clothes scattered about.')
   print ('Your spirits are brightened with hope, but its becoming hard to walk.')
   local move = io.read()
   if move == 'north' then return bathroom()
   elseif move == 'west' then return hallway()
   else
      print ('You get your feet tangled in the discarded clothing since you can barely lift your feet.')
      print ('You are getting desperate.')
      return bedroom()
   end
end

function bathroom()
   print ('You stumble into a filthy bathroom.')
   print ('You quickly don\'t care.')
end


