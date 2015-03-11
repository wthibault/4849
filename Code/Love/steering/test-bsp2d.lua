bsp = require 'bsp2d'
vector = require 'vector'

-- create a box , the test some rays at it.
--

p = { vector.new(0,0),
      vector.new(10,0),
      vector.new(10,10),
      vector.new(0,10) }

segs = { {p[1],p[2]},
	 {p[2],p[3]},
	 {p[3],p[4]},
	 {p[4],p[1]} }

tree = bsp.build(segs)

print('tree = ')
bsp.printTree(tree)

print ("Test 1: ")
ray = { vector.new(-5,5), vector.new(1000,5) }
intersection = bsp.segIntersect ( ray, tree )
if intersection and intersection.x == 0 and intersection.y == 5 then
   print ("PASS")
else
   print ("FAIL")
end


print("Test 2:")
ray = { vector.new(-5,-5), vector.new( 1000,1000 ) }
intersection = bsp.segIntersect ( ray, tree )
if intersection and intersection.x == 0 and intersection.y == 0 then
   print ("PASS")
else
   print ("FAIL")
end

if 1 then
   print("Test 3:")
   local p = { vector.new(0,1), vector.new(0,0) }
   local segs= { {p[1],p[2]} }
   local tree = bsp.build(segs)
   bsp.printTree(tree)
   local ray = { vector.new(-5,-5), vector.new( 1000,1000 ) }
   local intersection = bsp.segIntersect ( ray, tree )
   if intersection and intersection.x == 0 and intersection.y == 0 then
      print ("PASS")
   else
      print ("FAIL")
   end
end

if 1 then
   print("Test 4:")
   local p = { vector.new(0,0), vector.new(0,1) }
   local segs= { {p[1],p[2]} }
   local tree = bsp.build(segs)
   bsp.printTree(tree)
   local ray = { vector.new(5,5), vector.new( -1000,-1000 ) }
   local intersection = bsp.segIntersect ( ray, tree )
   if intersection and intersection.x == 0 and intersection.y == 0 then
      print ("PASS")
   else
      print ("FAIL")
   end
end


if 1 then
   print("Test 5:")
   local p = { vector.new(0,0), vector.new(0,1), vector.new(-1,0) }
   local segs= { {p[1],p[2]}, {p[1],p[3]} }
   local tree = bsp.build(segs)
   bsp.printTree(tree)
   local ray = { vector.new(5,5), vector.new( -1000,-1000 ) }
   local intersection = bsp.segIntersect ( ray, tree )
   if intersection and intersection.x == 0 and intersection.y == 0 then
      print ("PASS")
   else
      print ("FAIL")
   end
end

if 1 then
   print("Test 5:")
   local p = { vector.new(0,0), vector.new(0,1), vector.new(-1,0) }
   local segs= { {p[1],p[2]}, {p[1],p[3]} }
   local tree = bsp.build(segs)
   bsp.printTree(tree)
   local ray = { vector.new(5,5), vector.new( -1000,-1000 ) }
   local intersection = bsp.segIntersect ( ray, tree )
   if intersection and intersection.x == 0 and intersection.y == 0 then
      print ("PASS")
   else
      print ("FAIL")
   end
end






