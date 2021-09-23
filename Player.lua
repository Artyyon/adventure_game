Player = Class{}
anim8 = require 'libraries/anim8'

function Player:init(word)
    local gameMap = sti('maps/map1.lua')

    -- Origin on the map
    self.oX = 0
    self.oY = 0

    self.x = 0
    self.y = 0

    for _,obj in ipairs(gameMap.layers['player'].objects) do
        self.x, self.y = obj.x, obj.y
    end

    self.oX = self.x
    self.oY = self.y

    self.speed = 100

    self.spritesheet = love.graphics.newImage('sprites/Archaeologist Sprite Sheet.png')

    self.w = self.spritesheet:getWidth() / 8
    self.h = self.spritesheet:getHeight() / 7
    local g = anim8.newGrid(self.w, self.h, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.animations = {}
    self.animations.idle = anim8.newAnimation(g('1-8', 1), 0.3)
    self.animations.run = anim8.newAnimation(g('1-8', 2), 0.1)
    self.animations.jump = anim8.newAnimation(g('2-4', 2), 0.2)

    self.curAnimation = self.animations.idle

    self.cw = 14
    self.ch = 20

    self.body = world:newRectangleCollider(self.x, self.y, self.cw, self.ch, {collision_class='Player'})
    self.body:setFixedRotation(true)

    self.direction = 1
    self.grounded = false

    self.isdead = false
end

function Player:update(dt)
    if self.isdead then
        return
    end
    self.x, self.y = self.body:getPosition()
    if love.keyboard.isDown('a') then
        self.x = self.x - self.speed * dt
        self.curAnimation = self.animations.run
        self.direction = -1
    elseif love.keyboard.isDown('d') then
        self.x = self.x + self.speed * dt
        self.curAnimation = self.animations.run
        self.direction = 1
    else
        self.curAnimation = self.animations.idle
    end

    self.body:setX(self.x)

    colliders = world:queryRectangleArea(self.x - self.cw/2, self.y + self.ch/2, self.cw, 4, {'Plataform'})
    if #colliders > 0 then
        self.grounded = true
    else
        self.grounded = false
    end

    if self.grounded == false then
        self.curAnimation = self.animations.jump
    end

    if self.body:enter('Traps') then
        self.body:destroy()
        self.isdead = true
        state = 'game_over'
        love.audio.play(sounds.lose)
    end

    if self.body:enter('Enemy') then
        self.body:destroy()
        self.isdead = true
        state = 'game_over'
        love.audio.play(sounds.lose)
    end

    self.curAnimation:update(dt)
end

function Player:jump()
    if self.isdead then
        return
    end
    if self.grounded then
        self.body:applyLinearImpulse(0, -190)
        love.audio.play(sounds.jump)
    end
end

function Player:draw()
    if self.isdead then
        return
    end
    self.curAnimation:draw(self.spritesheet, self.body:getX(), self.body:getY(), 0, self.direction, 1, self.w/2-1, self.h-10)
end

function Player:reset()
    if self.isdead then
        self.body = world:newRectangleCollider(self.oX, self.oY, self.cw, self.ch, {collision_class='Player'})
        self.body:setFixedRotation(true)
        self.isdead = false
    else
        self.body:setX(self.oX)
        self.body:setX(self.oY)
    end
    
end