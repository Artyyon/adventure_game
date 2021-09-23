Map = Class{}

function Map:init(world)
    self.world = world
    self.gameMap = sti('maps/map1.lua')

    self.plataforms = {}
    self:createPlataform()
end

function Map:update(dt)
    self.gameMap:update(dt)
end

function Map:draw()
    self.gameMap:drawLayer(self.gameMap.layers['background'])
    self.gameMap:drawLayer(self.gameMap.layers['map1'])
    self.gameMap:drawLayer(self.gameMap.layers['details'])
end

function Map:createPlataform()
    local plataform
    for _,obj in ipairs(self.gameMap.layers['plataform'].objects) do
        plataform = self.world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height, {collision_class = 'Plataform'})
        plataform:setType('static')
        table.insert(self.plataforms, plataform)
    end
end