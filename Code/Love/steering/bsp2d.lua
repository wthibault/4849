-- a bsp tree for line segments bounding convex "in" polygons
-- supports ray queries

local vector = require 'vector'

local BSP = {}
BSP.__index=BSP
BSP.IN = {}
BSP.OUT = {}

-- a segment is a pair of 2d points(vectors), 
-- oriented so the "in" side is to the left.
-- a splitting line is represented as a normal vector 
-- and a scalar D = -(N*P0), so the 
-- distance from the plane of a point x is N*x+D

BSP.epsilon = 0.00001

function _splitSeg ( N, D, seg )
   local r = seg[1]
   local d = seg[2]-seg[1]
   local denom = N*d
   local frontseg = nil
   local backseg = nil
   local dist = N*seg[1]+D

   if denom == 0 then
      -- line is parallel to the plane, figure out which side

      if dist > 0 then 
	 frontseg = seg 
      else
	 backseg = seg
      end
   else

      local t = -(N*r+D)/denom

      if t < 0 then 
	 print('arg')
	 -- intersection is before first endpoint of seg. doesn't count.
	 if dist > 0 then 
	    frontseg = seg 
	 else
	    backseg = seg
	 end
	 return frontseg, backseg
      end
	 
      local intpt = r + d*t
      local dist = N*seg[2]+D  -- second point
      if dist > 0 then
	 frontseg = { intpt, seg[2] }
	 backseg  = { seg[1], intpt }
      else
	 frontseg = { seg[1], intpt }
	 backseg  = { intpt, seg[2] }
      end
   end
   return frontseg, backseg
end   

function BSP.build ( segs )

   if #segs == 0 then
      return nil
   end

   -- pick splitter
   local splitter = segs[math.random(1,#segs)]

   -- partition the segments
   local back = {}
   local front = {}
   local inplane = {}
   local P0 = splitter[1]
   local P1 = splitter[2]
   local L = P1 - P0
   local N = vector.new(L.y, -L.x)
   N:normalize_inplace()
   local D = - ( N * P0 )

   for i = 1, #segs do
      local seg = segs[i]
      local d0 = N * seg[1] + D
      local d1 = N * seg[2] + D
      
      if ( math.abs(d0) < BSP.epsilon ) then d0 = 0 end
      if ( math.abs(d1) < BSP.epsilon ) then d1 = 0 end

      if d0 < 0 and d1 < 0 then
	 table.insert ( back, seg )
      elseif d0 > 0 and d1 > 0 then
	 table.insert ( front, seg )
      elseif d0 == 0 and d1 == 0 then
	 table.insert(inplane,seg)
      elseif d0 > 0 or d1 > 0 then
	 table.insert( front, seg )
      elseif d0 < 0 or d1 < 0 then
	 table.insert( back, seg )
      else
	 local frontseg, backseg
	 frontseg,backseg = _splitSeg ( N, D, seg )
	 table.insert ( front,  frontseg )
	 table.insert ( back, backseg )
      end
   end

   -- end the recursion for empty children, else recurse
   if #back == 0 then
      leftChild = BSP.IN
   else
      leftChild = BSP.build ( back )
   end

   if #front == 0 then
      rightChild = BSP.OUT
   else
      rightChild = BSP.build ( front )
   end


   -- return an internal BSP tree node
   local retval =  { N = N,
		     D = D,
		     inplane = inplane,
		     left    = leftChild,
		     right   = rightChild   }
   return retval
end


-- helper
function _printSeg (seg)
   if seg then
      if (seg[1] and seg[2]) then
	 print(seg[1], seg[2])
      end
      if (seg[1] and not seg[2]) then
	 print(seg[1], 'nil')
      end
      if (seg[2] and not seg[1]) then
	 print('nil', seg[1])
      end
   else
      print ('nil seg')
   end
end

-- line segment intersect bsp (tail should be in an "out" region,
-- returns a vector point for the closest intersection with bsp along seg (a pair of points)

function BSP.segIntersect ( seg, bsp )
   local near,far
   local nearestInt = nil
   local fronSeg, backSeg

--   print ('entered segIntersect: seg=',seg[1], seg[2])

   if bsp == BSP.IN then
      return seg[1]
   elseif bsp == BSP.OUT then
      return nil
   end

   frontSeg, backSeg = _splitSeg ( bsp.N, bsp.D, seg )

   local dist = bsp.N*seg[1]+bsp.D
   if dist < 0 then
      near = bsp.left
      far =  bsp.right
      nearSeg = backSeg
      farSeg = frontSeg
   else
      near = bsp.right
      far = bsp.left
      nearSeg = frontSeg
      farSeg = backSeg
   end

   print('after split, ', _printSeg(nearSeg), _printSeg(farSeg))

   if near then
      print ('checcing nearseg' , _printSeg(nearSeg) )
      nearestInt = BSP.segIntersect ( nearSeg, near )
      if nearestInt then
	 return nearestInt
      end
   else
--      print ('checcing inplane', _printSeg(seg) )
--      nearestInt = _segIntersect ( seg, bsp.inplane )
--      if nearestInt then
--	 return nearestInt
--      end
      if far then
	 print('checking farseg', _printSeg(farSeg) )
	 nearestInt = BSP.segIntersect ( farSeg, far )
	 if nearestInt then
	    return nearestInt
	 else
	    return nil
	 end
      else
	 return nil
      end
   end
end

-- the module
return BSP
