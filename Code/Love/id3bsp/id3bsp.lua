-- a bsp tree for points with circular range queries

local ID3BSP = {}
ID3BSP.__index=ID3BSP


function ID3BSP.calcEntropy(splitter, pts, axis)
  -- two classes: infront and behind the splitter, along the axis
  local n = #pts
  local infront = 0
  local behind = 0
  for i=1,n do
    if pts[i][axis] < splitter[axis] then
      behind = behind + 1
    else
      infront = infront + 1
    end
  end
  behind = behind / n
  infront = infront / n
  local e = - behind * math.log (behind) - infront * math.log (infront)
  return e
end

function ID3BSP.pickSplitter (pts,axis)
   --return pts[math.random(1,#pts)]
   -- randomly choose some points as possible splitters
   local splitters = {}
   local numSplitters = 5
   for i=1,numSplitters do
    splitters[#splitters+1] = pts[math.random(1,#pts)]:clone()
   end
   -- compute the entropy of each split
   local minEntropy = 10000000
   local minSplitter = splitters[1]
   entropy = {}
   for i=1,numSplitters do
    entropy[i] = ID3BSP.calcEntropy(splitters[i], pts, axis)
    if entropy[i] < minEntropy then
      minEntropy = entropy[i]
      minSplitter = splitters[i]:clone()
    end
   end
   -- return the point whose split minimizes entropy
   return minSplitter:clone()
end

function ID3BSP.build ( pts, axis )
  axis = axis or 'x'

  if #pts == 0 then
    return nil
  end

  -- pick splitter
  local splitter = ID3BSP.pickSplitter(pts, axis)

  -- partition the points
  local back = {}
  local front = {}
  local inplane = {}

  for i = 1, #pts do
    if pts[i][axis] < splitter[axis] then
      table.insert ( back, pts[i] )
    elseif pts[i][axis] > splitter[axis] then
      table.insert ( front, pts[i] )
    else
      table.insert(inplane,pts[i])
    end
  end

  -- set axis for next level of tree
  axis = axis == 'x' and 'y' or 'x'

  -- return an internal ID3BSP tree node, recurse for children
  local retval =  { splitter= splitter,
    inplane = inplane,
    left    = ID3BSP.build ( back, axis ),
    right   = ID3BSP.build ( front, axis )   }
  return retval
end

function ID3BSP.concat ( t1, t2 )
  -- add the integer-indexed elements of t2 to the end of t1
  if t1 and t2 then
    for _,vec in pairs(t2) do
      table.insert ( t1, vec )
    end
    return t1
  elseif t1==nil and t2 ~= nil then
    return t2
  elseif t1~=nil and t2==nil then
    return t1
  else
    return nil
  end
end

function ID3BSP.inCircle ( pt,r,pts )
  local found = {}
  for _,p in pairs(pts) do
    local dx=p.x-pt.x
    local dy=p.y-pt.y
    if dx*dx + dy*dy < r*r then
      table.insert ( found, p )
    end
  end
  return found
end

function ID3BSP.withinDisk ( bsp, pt, r, axis )
  axis = axis or 'x'

  local found
  local nextAxis=axis=='x' and 'y' or 'x'
  if bsp then
    if bsp.splitter[axis] < pt[axis] - r then
      found = ID3BSP.withinDisk ( bsp.right, pt, r, nextAxis )
    elseif bsp.splitter[axis] > pt[axis] + r then
      found = ID3BSP.withinDisk ( bsp.left, pt, r, nextAxis )
    else
      found = ID3BSP.concat ( ID3BSP.concat ( ID3BSP.withinDisk ( bsp.left, pt, r, nextAxis ),
          ID3BSP.withinDisk ( bsp.right, pt, r, nextAxis ) ),
        ID3BSP.inCircle ( pt, r, bsp.inplane ) )
    end
  end
  return found
end

-- the module
return ID3BSP
