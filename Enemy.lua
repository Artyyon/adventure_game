Enemy = Class{}

function Enemy:init(world, obj)
    self.x = obj.x
    self.y = obj.y

    self.spritesheet = love.graphics.newImage('sprites/Slime Sprite Sheet.png')

    self.w = self.spritesheet:getWidth() / 8
    self.h = self.spritesheet:getHeight() / 5
    local g = anim8.newGrid(self.w, self.h, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.animations = {}
    self.animations.mov = anim8.newAnimation(g('1-4', 1), 0.2)

    self.body = world:newRectangleCollider(self.x, self.y, self.w - 20, self.h - 22, {collision_class='Enemy'})

    self.curAnimation = self.animations.mov

    local gameMap = sti('maps/map1.lua')

    self.limits = {}
    for _,obj in ipairs(gameMap.layers['limit_enemy'].objects) do
        table.insert(self.limits, obj.x)
    end

    self.limits[1] = self.limits[1] + 16

    self.x = 0
    self.y = 0

    self.direction = 1
    self.speed = 30
end

function Enemy:update(dt)
    self.x, self.y = self.body:getPosition()
    if self.limits[1] < (self.x-7) and self.limits[2] > (self.x+7) then
        self.x = self.x + self.direction * self.speed * dt
    else
        self.direction = self.direction * (-1)
        self.x = self.x + self.direction * self.speed * dt
    end
    self.body:setX(self.x)
    
    self.curAnimation:update(dt)
end

function Enemy:draw()
    self.curAnimation:draw(self.spritesheet, self.body:getX(), self.body:getY(), 0, self.direction, 1, self.w/2, self.h-5)
end