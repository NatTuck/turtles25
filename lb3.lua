-- This robot is a lumberjack.
-- Usage: lumberjack <size>
-- Searches a N x N area for a log.

local args = { ... }
if #args < 1 then
	print("Usage: lb3 <size>")
	return
end

local size = tonumber(args[1])
if not size or size < 1 then
	print("Size must be a positive number")
	return
end

print("size = " .. size)

-- position relative to starting position
local px, pz, py = 0, 0, 0
local dx, dz = 1, 0

local function turnRight()
	turtle.turnRight()
	if dx == 1 and dz == 0 then
		print("Turning from +x to +z")
		dx, dz = 0, 1
	elseif dx == 0 and dz == 1 then
		print("Turning from +z to -x")
		dx, dz = -1, 0
	elseif dx == -1 and dz == 0 then
		print("Turning from -x to -z")
		dx, dz = 0, -1
	elseif dx == 0 and dz == -1 then
		print("Turning from -z to +x")
		dx, dz = 1, 0
	end
	print("New direction: " .. dx .. ", " .. dz)
end

local function turnLeft()
	turnRight()
	turnRight()
	turnRight()
end

local function goForward()
	local success, data = turtle.inspect()
	if success and data.name:find("log") then
		print("Found log at " .. px .. ", " .. pz)
		return true
	else
		turtle.forward()
		px = px + dx
		pz = pz + dz
		return false
	end
end

local function scanForward(nn)
	for row = 1, nn do
		local foundLog = goForward()
		if foundLog then
			print("Done")
			return true
		end
	end

	return false
end

local function findTree()
	for colPair = 1, (math.ceil(size / 2)) do
		if scanForward(size) then
			return
		end

		turnRight()
		if scanForward(1) then
			return
		end
		turnRight()

		if scanForward(size) then
			return
		end
		turnLeft()

		if scanForward(1) then
			return
		end
		turnLeft()
	end
end

findTree()

print("End of program.")
