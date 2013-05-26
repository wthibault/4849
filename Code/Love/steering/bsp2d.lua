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

function _sameVector ( a, b )
   return a == b
end

function _splitSeg ( N, D, seg )
   local r = seg[1]
   local d = seg[2]-seg[1]
   local denom = N*d
   local frontseg = nil
   local backseg = nil
   local dist1 = N*seg[1]+D

   if denom == 0 then
      -- line is parallel to the plane, figure out which side
      print("_splitSeg: parallel")
      if dist1 > 0 then 
	 frontseg = seg 
      else
	 backseg = seg
      end

   else

      local t = -(N*r+D)/denom

      if t <= -BSP.epsilon then 
	 print('_splitSeg: intersection behind ray tail')
	 -- intersection is before first endpoint of seg. doesn't count.
	 if dist1 > 0 then 
	    frontseg = seg 
	 else
	    backseg = seg
	 end
	 return frontseg, backseg
      end
	 
      local intpt = r + d*t
      local dist2 = N*seg[2]+D  -- second point

      local inplane1 = math.abs(dist1) < BSP.epsilon
      local inplane2 = math.abs(dist2) < BSP.epsilon
      local infront1 = dist1 > 0 and not inplane1
      local infront2 = dist2 > 0 and not inplane2
      local inback1 = dist1 < 0 and not inplane1
      local inback2 = dist2 < 0 and not inplane2

      
      if inplane1 and infront2 then
	 frontseg = seg
	 backseg = nil
      elseif inplane1 and inback2 then
	 frontseg = nil
	 backseg = seg
      elseif inplane2 and infront1 then
	 frontseg = seg
	 backseg = nil
      elseif inplane2 and inback1 then
	 frontseg = nil
	 backseg = seg
      elseif infront1 and inback2 then
	 frontseg = { seg[1], intpt }
	 backseg =  { intpt, seg[2] }
      elseif inback1 and infront2 then
	 frontseg = { intpt, seg[2] }
	 backseg = { seg[1], intpt }
      elseif inback1 and inback2 then
	 frontseg = nil
	 backseg = seg
      elseif infront1 and infront2 then
	 frontseg = seg
	 backseg = nil
      end

      -- if not inplane1 then
      -- 	 if dist2 > 0 then
      -- 	    frontseg = { intpt, seg[2] }
      -- 	    backseg  = { seg[1], intpt }
      -- 	 else
      -- 	    frontseg = { seg[1], intpt }
      -- 	    backseg  = { intpt, seg[2] }
      -- 	 end
      -- else
      -- 	 if math.abs(dist) < BSP.epsilon and math.abs(dist2) < BSP.epsilon then
      -- 	    return nil,nil
      -- 	 end
      -- end

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
function _printSeg (seg,indent)
   indent = indent or 0
   local pad = ''
   for i = 1,indent do
      pad = pad .. ' '
   end
   if seg then
      if (seg[1] and seg[2]) then
	 print(pad,seg[1], seg[2])
      end
      if (seg[1] and not seg[2]) then
	 print(pad,seg[1], 'nil')
      end
      if (seg[2] and not seg[1]) then
	 print(pad,'nil', seg[1])
      end
   else
      print (pad,'nil seg')
   end
end

function BSP.printTree ( tree, indent )
   local indent = indent or 0
   local pad = ''
   for i=1,indent do pad = pad .. ' ' end
   if tree == BSP.IN then
      print (pad,"IN")
   elseif tree == BSP.OUT then
      print (pad,"OUT")
   else
      print (pad,"N=",tree.N)
      print (pad,"D=",tree.D)
      print (pad,"left=")
      BSP.printTree ( tree.left, indent + 6)
      print (pad,"right=")
      BSP.printTree ( tree.right, indent + 6)
   end
end

-- line segment intersect bsp (tail should be in an "out" region,
-- returns a vector point for the closest intersection with bsp along seg (a pair of points)

function BSP.segIntersect ( seg, bsp, indent )
   local near,far
   local nearestInt = nil
   local frontSeg, backSeg
   local indent = indent or 0
   indent = indent + 6

   if seg then 
      local pad = ''
      for i=1,indent do pad = pad .. ' ' end


      print (pad,'entered segIntersect: ')
      _printSeg(seg, indent-2)

      if bsp == BSP.IN then
	 print (pad,'IN: returning ', seg[1])
	 return seg[1]
      elseif bsp == BSP.OUT then
	 print (pad,'out: returning nil')
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

      print(pad,'after split: ')
      _printSeg(nearSeg,indent)
      _printSeg(farSeg,indent)

      if near then
	 print (pad, 'checking nearseg ' )
	 _printSeg(nearSeg,indent)

	 nearestInt = BSP.segIntersect ( nearSeg, near, indent )
	 if nearestInt then
	    print (pad,'near side intersection: ', nearestInt)
	    return nearestInt
	 end
      end

      if far then
	 
	 print(pad, 'checking farseg')
	 _printSeg(farSeg,indent)
	 
	 nearestInt = BSP.segIntersect ( farSeg, far, indent )
	 if nearestInt then
	    print (pad,'far side intersection: ', nearestInt)
	    return nearestInt
	 else
	    print (pad,'no far side intersection, returning nil')
	    return nil
	 end
      else
	 print (pad,'no far side intersection either, returning nil')
	 return nil
      end
   else
      return nil
   end
end

-- the module
return BSP
