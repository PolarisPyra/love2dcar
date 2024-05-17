Car = {}
Car.__index = Car

local carTexture = love.graphics.newImage('assets/car.png')

-- helper function for dot product
function DotProduct(x1,y1,x2,y2)
    return x1 * x2 + y1 *y2 
end

function Car:GetLateralVelocity(velocityX, velocityY)
    local rightX, rightY = self.body:getWorldVector(1,0) -- get right side 
    local dot = DotProduct(rightX,rightY,velocityX,velocityY) -- get dot product 
    return dot * rightX, dot * rightY
end


function Car:New(x, y, world)
    local this = {
        x = x,
        y = y,
        r = 0,
        body = love.physics.newBody(world, x, y, "dynamic"),
        texture = carTexture,
        w = carTexture:getWidth(),
        h = carTexture:getHeight(),
    }

    this.shape = love.physics.newRectangleShape(this.w, this.h)
    this.fixture = love.physics.newFixture(this.body, this.shape)
    this.body:setLinearDamping(0.8)

    setmetatable(this, self)
    return this
end

function Car:Update(dt)
    local forwardForce = 1000
    local turnSpeed = math.rad(30)
    local maxTurn = 100
    local velocityX, velocityY = self.body:getLinearVelocity()
    local currentSpeed = math.sqrt(velocityX * velocityX + velocityY * velocityY)
    local turnPercentage = math.min(1, currentSpeed / maxTurn)
    local forwardX, ForwardY = self.body:getWorldVector(0, -1)
    local dx, dy = forwardForce * forwardX, forwardForce * ForwardY
    -- impulse 
    local impulseX,impulseY = self:GetLateralVelocity(velocityX, velocityY)
    impulseX = impulseX * -1 * self.body:getMass()
    impulseY = impulseY * -1 * self.body:getMass()
    self.body:applyLinearImpulse(impulseX, impulseY, self.body:getWorldCenter())


    if love.keyboard.isDown("w") then
        self.body:applyForce(dx, dy)
    end

    self.body:setAngularVelocity(0)
    if love.keyboard.isDown("s") then
        self.body:applyForce(-dx, -dy)
    end

    if love.keyboard.isDown("a") then
        self.body:setAngularVelocity(-turnSpeed * turnPercentage)
    end

    if love.keyboard.isDown("d") then
        self.body:setAngularVelocity(turnSpeed * turnPercentage)
    end

    self.x, self.y = self.body:getPosition()
    self.r = self.body:getAngle()
end

function Car:Render()
    local ox, oy = self.w * 0.5, self.h * 0.5
    love.graphics.draw(self.texture, self.x, self.y, self.r, 1, 1, ox, oy)
end
