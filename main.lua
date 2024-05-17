--- tutorial from Gabe Stein
--- https://www.youtube.com/watch?v=v_6kfmXxAjg

require "car"

WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

local gWorld = love.physics.newWorld(0,0)
local car = Car:New(WINDOW_WIDTH/2-10, WINDOW_HEIGHT/2,gWorld)
local mapTexture = love.graphics.newImage("assets/track.jpg")


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("car")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,{fullscreen=false, vsync=true})
end

function love.update(dt)
    car:Update(dt)
    gWorld:update(dt)
end

function love.draw()
    love.graphics.draw(mapTexture)
    car:Render()
end

