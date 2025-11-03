-- This robot is a lumberjack.
-- Usage: lumberjack <size>
-- Searches a N x N area for a log.

local args = { ... }
if #args < 1 then
	print("Usage: lb2 <size>")
	return
end

local n = tonumber(args[1])
if not n or n < 1 then
	print("Size must be a positive number")
	return
end

local function searchForLog()
	local success, data = turtle.inspect()
	if success and data.name and data.name:find("log") then
		print("Found log: " .. data.name)
		return true, data
	end
	return false
end

local function cutUpTree()
	local mx, my, mz = 0, 0, 0
	local dx, dy = 1, 0

	local function goUp()
		my = my + 1
		turtle.digUp()
		turtle.up()
	end

	local function returnDown()
		while my > 0 do
			my = my - 1
			turtle.digDown()
			turtle.down()
		end
	end

	local function chopOneLevel()
		local success, data = turtle.inspectUp()
		local moreTrunk = success and data.name:find("log")

		goUp()

		for i = 1, 4 do
			local success, data = turtle.inspect()
			if success and data.name:find("log") then
				turtle.dig()
				turtle.forward()
				chopOneLevel()

				returnDown()
				turtle.turnLeft()
			end
		end

		if not moreTrunk then
			returnDown()
			return
		end
	end

	chopOneLevel()
end

local function cutTree()
	-- Cut the initial log
	turtle.dig()
	turtle.forward()

	cutUpTree()
end

local function searchSquare(size)
	local x, y = 0, 0
	local dx, dy = 1, 0
	local steps = 1
	local turn_count = 0

	for _ = 1, size * size do
		local found, data = searchForLog()
		if found then
			cutTree()
			return
		end

		if x + dx >= size or x + dx < 0 or y + dy >= size or y + dy < 0 or turn_count >= steps then
			turtle.turnRight()
			turn_count = 0
			if dx == 1 then
				dy = 1
				dx = 0
			elseif dy == 1 then
				dx = -1
				dy = 0
			elseif dx == -1 then
				dy = -1
				dx = 0
			elseif dy == -1 then
				dx = 1
				dy = 0
				steps = steps + 1
			end
		end

		if not turtle.forward() then
			print("Cannot move forward, stopping.")
			return
		end

		x = x + dx
		y = y + dy
		turn_count = turn_count + 1
	end
end

print("Searching for a log in a " .. n .. "x" .. n .. " area...")
searchSquare(n)
print("Search complete.")
