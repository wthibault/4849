-- test the bsp and id3 bsp modules

bsp=require('bsp')
id3bsp=require('id3bsp')
vector=require('vector')

function makeRandomPoints ( n )
   n = n or 100000

   local pts = {}
   for i=1,n do
      table.insert(pts, vector.new(math.random(0,100),math.random(0,100)))
   end
   return pts
end

function findWithin ( pts, pt, r )
   found={}
   for i,p in ipairs(pts) do
      if p:dist(pt) < r then
	 table.insert(found,p)
      end
   end
   return found
end

function testMany(kind,tree,n)
   for i = 1, n do
      local pt = vector.new(math.random(1,100)-50, math.random(1,100)-50)
      local r = math.random(1,25)
      local got = kind.withinDisk ( tree, pt, r )
   end
end

function test()
   local pts = makeRandomPoints()

   local now, backwhen

   backwhen = os.clock()
   local t = bsp.build(pts)
   now = os.clock()
   print ('build bsp took ' , (now - backwhen))

   backwhen = os.clock()  
   local id3t = id3bsp.build(pts)
   now = os.clock()
   print ('build id3bsp took ', (now-backwhen))

   -- try to get all the points
   print('testing big query:')
   local got = bsp.withinDisk ( t, vector.new(50,50), 100 )
   if #got ~= #pts then
      print('FAIL BSP big query')
   else
      print('PASS BSP big query')
   end
   --id3
   got = id3bsp.withinDisk ( id3t, vector.new(50,50), 100 )
   if #got ~= #pts then
      print('FAIL ID3BSP big query')
   else
      print('PASS ID3BSP big query')
   end


   -- try to get some
   print('testing small query:')
   local pt = vector.new(50,50)
   local r = 10
   local gotBsp = bsp.withinDisk ( t, pt, r )
   local gotId3Bsp = id3bsp.withinDisk ( id3t, pt, r)
   local gotbruteforce = findWithin(pts, pt, r)
   if #gotBsp ~= #gotbruteforce then
      print('FAIL BSP small query')
   else
      print('PASS BSP small query')
   end
    if #gotId3Bsp ~= #gotbruteforce then
      print('FAIL ID3BSP small query')
   else
      print('PASS ID3BSP small query')
   end


 -- try a bunch
   print('testing many queries:')
   local many = 1000
   backwhen = os.clock()
   testMany(bsp,t,many)
   now = os.clock()
   testMany(id3bsp,id3t,many)
   local hereandnow = os.clock()
   print('bsp time:', now-backwhen)
   print('id3bsp time: ', hereandnow-now)

end

math.randomseed(os.time())
test()