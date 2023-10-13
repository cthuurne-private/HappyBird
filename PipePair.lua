PipePair = CLASS{}

function PipePair:init(y, score)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    -- instantiate two pipes that belong to this pair
    local GAP = math.random(90, 110)

    if score > 20 then
        GAP = math.random(80, 100)
    end

    self.pipes = {
        ["upper"] = Pipe("top", self.y),
        ["lower"] = Pipe("bottom", self.y + PIPE_HEIGHT + GAP)
    }

    self.remove = false
    self.scored = false
end

function PipePair:update(dt)
    -- remove pipes or move them right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SCROLLSPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for p, pipe in pairs(self.pipes) do
        pipe:render()
    end
end