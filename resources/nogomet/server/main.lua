local Min = 0
local Lopta = nil

RegisterNetEvent("SpawnLoptu")
AddEventHandler("SpawnLoptu", function(net)
	TriggerClientEvent("EoTiLopta", -1, net)
end)

RegisterNetEvent("nogomet:pozovi")
AddEventHandler("nogomet:pozovi", function(id, tim)
	TriggerClientEvent("nogomet:pozvao", id, tim)
end)

RegisterNetEvent("nogomet:SaljiPoruku")
AddEventHandler("nogomet:SaljiPoruku", function(poruka)
	TriggerClientEvent("nogomet:PoslaoPoruku", -1, poruka)
end)

RegisterNetEvent("nogomet:pokreni")
AddEventHandler("nogomet:pokreni", function(vr, nid, vani1, vani2, vani3, vani4, vani5, vani6, gol1, gol2)
	--[[local loptee = "p_ld_soc_ball_01"
	Lopta = CreateObjectNoOffset(GetHashKey(loptee), 771.25549316406, -233.44470214844, 65.214479064941,true,false)
	while not DoesEntityExist(Lopta) do
		Wait(100)
	end
	local netid = NetworkGetNetworkIdFromEntity(Lopta)]]
	local lopta = NetworkGetEntityFromNetworkId(nid)
	local coords = GetEntityCoords(lopta)
	print(json.encode(coords))
	Citizen.CreateThread(function ()
		local Cekaj = false
		while Min > 0 do
			coords = GetEntityCoords(lopta)
			if _pointInPoly(coords, vani1) or _pointInPoly(coords, vani2) or _pointInPoly(coords, vani3) or _pointInPoly(coords, vani4) or _pointInPoly(coords, vani5) or _pointInPoly(coords, vani6) then
				print("vani")
				TriggerClientEvent("nogomet:LoptaVani", -1)
			end
			if _pointInPoly(coords, gol1) and not Cekaj then
				Cekaj = true
				print("gol 1")
				TriggerClientEvent("nogomet:Gol", -1, 1)
				Citizen.Wait(100)
				Cekaj = false
			end
			if _pointInPoly(coords, gol2) and not Cekaj then
				Cekaj = true
				TriggerClientEvent("nogomet:Gol", -1, 2)
				print("gol 2")
				Citizen.Wait(100)
				Cekaj = false
			end
			Citizen.Wait(200)
		end
	end)
	TriggerClientEvent("nogomet:start", -1, vr)
	PratiKraj(vr)
end)

function _windingNumber(point, poly)
	local wn = 0 -- winding number counter

	-- loop through all edges of the polygon
	for i = 1, #poly - 1 do
		wn = _wn_inner_loop(poly[i], poly[i + 1], point, wn)
	end
	-- test last point to first point, completing the polygon
	wn = _wn_inner_loop(poly[#poly], poly[1], point, wn)

	-- the point is outside only when this winding number wn===0, otherwise it's inside
	return wn ~= 0
end

function _isLeft(p0, p1, p2)
	local p0x = p0.x
	local p0y = p0.y
	return ((p1.x - p0x) * (p2.y - p0y)) - ((p2.x - p0x) * (p1.y - p0y))
end
  
function _wn_inner_loop(p0, p1, p2, wn)
	local p2y = p2.y
	if (p0.y <= p2y) then
		if (p1.y > p2y) then
		if (_isLeft(p0, p1, p2) > 0) then
			return wn + 1
		end
		end
	else
		if (p1.y <= p2y) then
		if (_isLeft(p0, p1, p2) < 0) then
			return wn - 1
		end
		end
	end
	return wn
end

function _pointInPoly(point, poly)
	local x = point.x
	local y = point.y
	local min = poly.min
	local minX = min.x
	local minY = min.y
	local max = poly.max

	-- Checks if point is within the polygon's bounding box
	if x < minX or
		x > max.x or
		y < minY or
		y > max.y then
		return false
	end

	-- Checks if point is within the polygon's height bounds
	local minZ = poly.minZ
	local maxZ = poly.maxZ
	local z = point.z
	if (minZ and z < minZ) or (maxZ and z > maxZ) then
		return false
	end

	-- Returns true if the grid cell associated with the point is entirely inside the poly
	local grid = poly.grid
	if grid then
		local gridDivisions = poly.gridDivisions
		local size = poly.size
		local gridPosX = x - minX
		local gridPosY = y - minY
		local gridCellX = (gridPosX * gridDivisions) // size.x
		local gridCellY = (gridPosY * gridDivisions) // size.y
		local gridCellValue = grid[gridCellY + 1][gridCellX + 1]
		if gridCellValue == nil and poly.lazyGrid then
		gridCellValue = _isGridCellInsidePoly(gridCellX, gridCellY, poly)
		grid[gridCellY + 1][gridCellX + 1] = gridCellValue
		end
		if gridCellValue then return true end
	end

	return _windingNumber(point, poly.points)
end

-- Grid creation functions
-- Calculates the points of the rectangle that make up the grid cell at grid position (cellX, cellY)
function _calculateGridCellPoints(cellX, cellY, poly)
	local gridCellWidth = poly.gridCellWidth
	local gridCellHeight = poly.gridCellHeight
	local min = poly.min
	-- min added to initial point, in order to shift the grid cells to the poly's starting position
	local x = cellX * gridCellWidth + min.x
	local y = cellY * gridCellHeight + min.y
	return {
		vector2(x, y),
		vector2(x + gridCellWidth, y),
		vector2(x + gridCellWidth, y + gridCellHeight),
		vector2(x, y + gridCellHeight),
		vector2(x, y)
	}
end


function _isGridCellInsidePoly(cellX, cellY, poly)
	gridCellPoints = _calculateGridCellPoints(cellX, cellY, poly)
	local polyPoints = {table.unpack(poly.points)}
	-- Connect the polygon to its starting point
	polyPoints[#polyPoints + 1] = polyPoints[1]

	-- If none of the points of the grid cell are in the polygon, the grid cell can't be in it
	local isOnePointInPoly = false
	for i=1, #gridCellPoints - 1 do
		local cellPoint = gridCellPoints[i]
		local x = cellPoint.x
		local y = cellPoint.y
		if _windingNumber(cellPoint, poly.points) then
		isOnePointInPoly = true
		-- If we are drawing the grid (poly.lines ~= nil), we need to go through all the points,
		-- and therefore can't break out of the loop early
		if poly.lines then
			if not poly.gridXPoints[x] then poly.gridXPoints[x] = {} end
			if not poly.gridYPoints[y] then poly.gridYPoints[y] = {} end
			poly.gridXPoints[x][y] = true
			poly.gridYPoints[y][x] = true
		else break end
		end
	end
	if isOnePointInPoly == false then
		return false
	end

	-- If any of the grid cell's lines intersects with any of the polygon's lines
	-- then the grid cell is not completely within the poly
	for i=1, #gridCellPoints - 1 do
		local gridCellP1 = gridCellPoints[i]
		local gridCellP2 = gridCellPoints[i+1]
		for j=1, #polyPoints - 1 do
		if _isIntersecting(gridCellP1, gridCellP2, polyPoints[j], polyPoints[j+1]) then
			return false
		end
		end
	end

	return true
end

-- Detects intersection between two lines
function _isIntersecting(a, b, c, d)
	-- Store calculations in local variables for performance
	local ax_minus_cx = a.x - c.x
	local bx_minus_ax = b.x - a.x
	local dx_minus_cx = d.x - c.x
	local ay_minus_cy = a.y - c.y
	local by_minus_ay = b.y - a.y
	local dy_minus_cy = d.y - c.y
	local denominator = ((bx_minus_ax) * (dy_minus_cy)) - ((by_minus_ay) * (dx_minus_cx))
	local numerator1 = ((ay_minus_cy) * (dx_minus_cx)) - ((ax_minus_cx) * (dy_minus_cy))
	local numerator2 = ((ay_minus_cy) * (bx_minus_ax)) - ((ax_minus_cx) * (by_minus_ay))

	-- Detect coincident lines
	if denominator == 0 then return numerator1 == 0 and numerator2 == 0 end

	local r = numerator1 / denominator
	local s = numerator2 / denominator

	return (r >= 0 and r <= 1) and (s >= 0 and s <= 1)
end

RegisterNetEvent("nogomet:Zaustavi")
AddEventHandler("nogomet:Zaustavi", function()
	TriggerClientEvent("nogomet:stop", -1)
	Min = 0
end)

RegisterNetEvent("nogomet:SyncSpawnove")
AddEventHandler('nogomet:SyncSpawnove', function(tim, br)
	TriggerClientEvent("nogomet:VratioSpawnove", -1, tim, br)
end)

RegisterNetEvent("nogomet:SyncajScore")
AddEventHandler('nogomet:SyncajScore', function(tim1, tim2)
	TriggerClientEvent('nogomet:VratiScore', -1, tim1, tim2)
end)

RegisterNetEvent("nogomet:SyncTimove")
AddEventHandler('nogomet:SyncTimove', function(t1, t2)
	TriggerClientEvent('nogomet:VratiTimove', -1, t1, t2)
end)

function PratiKraj(vr)
	Min = vr
	Citizen.CreateThread(function()
		while Min > 0 do
			Citizen.Wait(1000)
			Min = Min-1
			TriggerClientEvent('nogomet:VrimeKraj', -1, Min)
		end
	end)
end