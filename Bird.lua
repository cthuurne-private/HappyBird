Bird = CLASS{}

local GRAVITY = 20
local JUMP_DISTANCE = 5

function Bird:init()
    self.image = love.graphics.newImage("bird.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed("space") or love.mouse.wasPressed(1) then
        SOUNDS["jump"]:play()
        self.dy = -JUMP_DISTANCE
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference global pipe width and height values.

    the + 2 value are left (x) and top (y) offsets for the bird while the - 4 are right (x) and bottom (y) offsets. 
    This will change the hitbox size of the bird to be smaller than its actual image, which will make collisions more forgiving.
]]
function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height -4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end