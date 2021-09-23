Cup = Class{}

function Cup:init(world)
    self.world = world

    self.sprite= love.graphics.newImage('sprites/Cup.png')
    self.w = self.sprite:getWidth()
    self.h = self.sprite:getHeight()

    self.tableCup = {}
    for _,obj in ipairs(map.gameMap.layers['cup'].objects) do
        local body = world:newRectangleCollider(obj.x, obj.y, self.w, self.h, {collision_class='Cup'})
        body:setType('static')
        table.insert(self.tableCup, body)
    end

    self.colleted = 0
end

function Cup:update(dt)
    for i,obj in ipairs(self.tableCup) do
        if obj:enter('Player') then
            obj:destroy()
            self.colleted = self.colleted + 1
            table.remove(self.tableCup, i)
            love.audio.play(sounds.coin)
        end
    end
end

function Cup:draw()
    for _, obj in ipairs(self.tableCup) do
        love.graphics.draw(self.sprite, obj:getX()-self.w/2, obj:getY()-self.h/2)
    end
end

function Cup:numberOfElements()
    return #self.tableCup
end

function Cup:restart()
    -- Limpa a lista
    for i,obj in ipairs(self.tableCup) do
        obj:destroy()
    end
    self.tableCup = {}
    -- Reconstroi a lista
    for _,obj in ipairs(map.gameMap.layers['cup'].objects) do
        local body = world:newRectangleCollider(obj.x, obj.y, self.w, self.h, {collision_class='Cup'})
        body:setType('static')
        table.insert(self.tableCup, body)
    end
    self.colleted = 0
end