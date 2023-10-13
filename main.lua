PUSH = require "push"
CLASS = require "class"

require "Bird"
require "Pipe"
require "PipePair"
require "StateMachine"
require "states/BaseState"
require "states/PlayState"
require "states/TitleScreenState"
require "states/ScoreState"
require "states/CountdownState"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 500
VIRTUAL_HEIGHT = 300

local background = love.graphics.newImage("background.png")
local ground = love.graphics.newImage("ground.png")

-- scrolling for parallax effect
local backgroundScroll = 0
local groundScroll = 0

-- speed of scrolling of the images
local BACKGROUNDSCROLLSPEED = 30
local GROUNDSCROLLSPEED = 60

-- set background back to x = 0 after it reaches the end of the image
local BACKGROUNDLOOPINGPOINT = 413
local GROUNDLOOPINGPOINT = 514

-- Load when starting the game
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    math.randomseed(os.time())
    love.window.setTitle("Happy Bird")

    -- initialize fonts
    SMALLFONT = love.graphics.newFont("fonts/font.ttf", 8)
    MEDIUMFONT = love.graphics.newFont("fonts/flappy.ttf", 14)
    HAPPYFONT = love.graphics.newFont("fonts/flappy.ttf", 28)
    HUGEFONT = love.graphics.newFont("fonts/flappy.ttf", 56)
    love.graphics.setFont(HAPPYFONT)

    -- initialize sounds
    SOUNDS = {
        ["jump"] = love.audio.newSource("sounds/jump.wav", "static"),
        ["hurt"] = love.audio.newSource("sounds/hurt.wav", "static"),
        ["score"] = love.audio.newSource("sounds/score.wav", "static"),
        ["music"] = love.audio.newSource("sounds/music.mp3", "static")
    }

    SOUNDS["music"]:setLooping(true)
    SOUNDS["music"]:play()

    -- Initialize at the virtual resolution
    PUSH:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- Initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ["title"] = function () return TitleScreenState() end,
        ["play"] = function () return PlayState() end,
        ["score"] = function () return ScoreState() end,
        ["countdown"] = function () return CountdownState() end
    }
    gStateMachine:change("title")

    -- Initialize table of keys pressed and table of mouse input
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    PUSH:resize(w, h)
end

function love.update(dt)
    -- scroll background and ground
    backgroundScroll = (backgroundScroll + BACKGROUNDSCROLLSPEED * dt) % BACKGROUNDLOOPINGPOINT
    groundScroll = (groundScroll + GROUNDSCROLLSPEED * dt) % GROUNDLOOPINGPOINT

    -- update the state machine, which defers to the right state
    gStateMachine:update(dt)

    -- reset input tables
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

-- Draw the images on the screen
function love.draw()
    PUSH:start()

    -- draw background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    PUSH:finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end