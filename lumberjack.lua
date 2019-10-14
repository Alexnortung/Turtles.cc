-- this program will cut down trees that are lined up in a straight line
local treeDistance = 5
local trees = 5
local x, y, z = 0, 0, 0 -- relative coordinates for the turtle
local facingDirection = 0 -- 0 is towards positive x

function ternary ( cond , T , F )
    if cond then return T else return F end
end

local function turnLeft(turns)
    turns = turns or 1
    for i = 0, turns do
        turtle.turnLeft()
        facingDirection = (facingDirection - 1) % 4
    end
end

local function turnRight(turns)
    turns = turns or 1
    for i = 0, turns do
        turtle.turnRight()
        facingDirection = (facingDirection + 1) % 4
    end
end

local function forward(steps)
    steps = steps or 1
    for i = 0, steps do
        turtle.forward()
    end
    local addSteps = ternary(facingDirection >= 2, -steps, steps)
    if facingDirection % 2 == 0 then
        x = x + addSteps
    else
        z = z + addSteps
    end
end

local function up(steps)
    steps = steps or 1
    for i = 0, steps do
        turtle.up();
        y = y + 1
    end
end

local function down(steps)
    steps = steps or 1
    for i = 0, steps do
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
        if fData.name == "oak_sapling" then
            goAbove()
        else
            -- dig the bootom and move under the other logs
            local treeFinished = false
            turtle.dig()
            forward()

            while treeFinished == false do
                turtle.digUp()
                up()
                local success, data = turtle.inspectUp()
                if success and data.name == "oak_log" then
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

