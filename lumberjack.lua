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
        return true
    end
    return false
end

local function searchSquare(size)
    for i = 1, size do
        for j = 1, size do
            if searchForLog() then
                return
            end
            if j < size then
                if not turtle.forward() then
                    print("Cannot move forward, stopping.")
                    return
                end
            end
        end
        if i < size then
            turtle.turnRight()
            if not turtle.forward() then
                print("Cannot move forward, stopping.")
                return
            end
            turtle.turnRight()
            for k = 1, size do
                if k < size then
                    if not turtle.forward() then
                        print("Cannot move forward, stopping.")
                        return
                    end
                end
            end
            turtle.turnRight()
            turtle.turnRight()
        end
    end
end

print("Searching for a log in a " .. n .. "x" .. n .. " area...")
searchSquare(n)
print("Search complete.")
