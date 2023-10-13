Pipe = CLASS{}

local PIPE_IMAGE = love.graphics.newImage("pipe.png")
--local PIPE_SCROLL = -60

PIPE_SCROLLSPEED = 60
PIPE_HEIGHT = 430
PIPE_WIDTH = 70

function Pipe:init(topbottom, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT
    self.orientation = topbottom
end

function Pipe:update(dt)
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x,
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),     -- if top, shift the pipe down by its height, bcs the pipe will be mirrored
    0,                                                                  -- rotation
    1,                                                                  -- X scale
    self.orientation == 'top' and -1 or 1)                              -- Y scale
end