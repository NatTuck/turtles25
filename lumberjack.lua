-- This robot is a lumberjack.
-- Usage: lumberjack <size>
-- Searches a N x N area for a log.

local args = { ... }
if #args < 1 then
    print("Usage: lumberjack <size>")
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

local function cutTree()
    -- Cut the initial log
    turtle.dig()
    
    -- Track movement for return journey
    local upMoves = 0
    local path = {}
    
    -- Cut trunk going up
    while turtle.detectUp() do
        turtle.digUp()
        turtle.up()
        upMoves = upMoves + 1
        table.insert(path, "up")
    end
    
    -- Check adjacent blocks at each level
    local function checkAdjacent()
        for _ = 1, 4 do
            turtle.turnLeft()
            if turtle.detect() then
                turtle.dig()
            end
        end
    end
    
    -- Check top level
    checkAdjacent()
    
    -- Return to base and check each level
    for _ = 1, upMoves do
        turtle.down()
        table.insert(path, "down")
        checkAdjacent()
    end
    
    -- Return to starting position and orientation
    for _, move in ipairs(path) do
        if move == "up" then
            turtle.down()
        elseif move == "down" then
            turtle.up()
        end
    end
    
    -- Reset orientation to face original direction
    for _ = 1, 4 do
        turtle.turnLeft()
    end
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
