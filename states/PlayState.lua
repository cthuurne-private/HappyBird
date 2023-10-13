PlayState = CLASS{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipes = {}
    self.spawnTimer = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastYPosition = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        if self.score <= 5 then
            local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastYPosition + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastYPosition = y

            table.insert(self.pipes, PipePair(y, self.score))
            self.spawnTimer = 0
        elseif self.score > 5 and self.score <= 10  then
            local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastYPosition + math.random(-35, 35), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastYPosition = y

            table.insert(self.pipes, PipePair(y, self.score))
            self.spawnTimer = 0
        else
            local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastYPosition + math.random(-45, 45), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastYPosition = y

            table.insert(self.pipes, PipePair(y, self.score))
            self.spawnTimer = 0
        end
    end

    -- for all pipes in the scene
    for p, pipePair in pairs(self.pipes) do
        -- score a point if the pipe has gone past the bird to the left all the way
        if not pipePair.scored then
            if pipePair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                SOUNDS["score"]:play()
                pipePair.scored = true
            end
        end

        pipePair:update(dt)
    end

    -- remove any flagged pipes. We need this second loop, rather than deleting in the previous loop, 
    -- because modifying the table in-place without explicit keys will result in skipping the next pipe. 
    -- Basically, the looping construct in Lua doesn't work well with removing items in-place. Dont loop and remove at the same time.
    for p, pipePair in pairs(self.pipes) do
        if pipePair.remove then
            table.remove(self.pipes, p)
        end
    end

    self.bird:update(dt)

    -- simple collission between bird and all pipes in pairs
    for k, pair in pairs(self.pipes) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                SOUNDS["hurt"]:play()
                gStateMachine:change("score", { score = self.score })
            end
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine.change("score", { score = self.score })
    end
end

function PlayState:render()
    for p, pair in pairs(self.pipes) do
        pair:render()
    end

    love.graphics.setFont(HAPPYFONT)
    love.graphics.print("Score: " .. tostring(self.score), 8, 8)

    self.bird:render()
end