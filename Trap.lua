Trap = Class{}

function Trap:init(world, obj)
    self.body = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height, {collision_class = 'Traps'})
    self.body:setType('static')
end