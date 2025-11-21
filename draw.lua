local base = "https://raw.githubusercontent.com/NatTuck/patterns/refs/heads/main/"
local addr = base .. "pic.txt"

local function refuel()
	turtle.select(1)
	turtle.refuel(32)
end

local function drawLine(line)
	for i = 1, string.len(line) do
		local color = line:sub(i, i)
		turtle.select(4 + tonumber(color))
		turtle.placeDown()
		turtle.forward()
	end
end

local function drawImage(conn)
	while true do
		local line = conn.readLine()
		if line == nil then
			return
		end
		drawLine(line)
		turtle.turnRight()
		turtle.forward()
		turtle.turnRight()
		turtle.forward()

		line = conn.readLine()
		if line == nil then
			return
		end
		drawLine(string.reverse(line))
		turtle.turnLeft()
		turtle.forward()
		turtle.turnLeft()
		turtle.forward()
	end
end

refuel()

local req = http.get(addr)
drawImage(req)
req.close()
