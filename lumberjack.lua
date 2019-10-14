-- this program will cut down trees that are lined up in a straight line
local treeDistance = 4 -- blocks between trees
-- local trees = 5
local x, y, z = 0, 0, 0 -- relative coordinates for the turtle
local facingDirection = 0 -- 0 is towards positive x
local state = 0 -- 0 cutting trees; 1 planting; 2 waiting

function ternary ( cond , T , F )
    if cond then return T else return F end
end

local function turnLeft(turns)
    turns = turns or 1
    for i = 1, turns do
        turtle.turnLeft()
        facingDirection = (facingDirection - 1) % 4
    end
end

local function turnRight(turns)
    turns = turns or 1
    for i = 1, turns do
        turtle.turnRight()
        facingDirection = (facingDirection + 1) % 4
    end
end

local function forward(steps)
    steps = steps or 1
    for i = 1, steps do
        turtle.forward()
    end
    local addSteps = ternary(facingDirection >= 2, -steps, steps)
    if facingDirection % 2 == 0 then
        x = x + addSteps
    else
        z = z + addSteps
    end
end

local function back(steps)
    steps = steps or 1
    for i = 1, steps do
        turtle.back()
    end
    local addSteps = ternary(facingDirection >= 2, -steps, steps)
    if facingDirection % 2 == 0 then
        x = x - addSteps
    else
        z = z - addSteps
    end
end

local function up(steps)
    steps = steps or 1
    for i = 1, steps do
        turtle.up();
        y = y + 1
    end
end

local function down(steps)
    steps = steps or 1
    for i = 1, steps do
        turtle.down();
        y = y - 1
    end
end

local function goAbove()
    up()
    forward(2)
    down()
end

local function cutTree()
    -- this function should be called when the turtle is at the front of the root of the tree
    -- inspect if it is a sapling
    -- if not successful it means that there is no tree nor sapling
    local fSuccess, fData = turtle.inspect();

    if fSuccess then
        -- if sapliung move around
        if (fData.name == "minecraft:oak_sapling") or (fData.name == "minecraft:birch_sapling") then
            -- goAbove()
            state = 1
        else
            -- dig the bootom and move under the other logs
            -- print("tree detected")
            local treeFinished = false
            turtle.dig()
            forward()

            while treeFinished == false do

                turtle.digUp()
                up()
                local success, data = turtle.inspectUp()
                print(success, data.name)
                if success and (data.name == "minecraft:oak_log" or data.name == "minecraft:birch_log") then
                    --continue
                else
                    treeFinished = true
                end
            end
            down(y)
            forward()
        end
    else
        forward(2)
    end
end

local function decider()
    local fSuccess, fData = turtle.inspectDown()
    if state == 0 then
        -- check down
        -- check forward
        if fData.name == "minecraft:cobblestone" then
            -- change state
            state = 1
            back()
        elseif turtle.detect() then
            print("detected")
            cutTree()
        else
            forward()
        end
    elseif state == 1 then
        -- select sapling
        if fData.name == "minecraft:cobblestone" then
            state = 2
        elseif x % treeDistance == 0 then
            -- plant sapling
        end
        
        if state ~= 2 then
            back()
        end
    end
end

forward()
while state ~= 2 do
    decider()
end


-- cutTree()