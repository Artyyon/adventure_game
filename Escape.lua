Escape = Class{}

function Escape:init(world, obj)
    self.body = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height, {collision_class = 'Escape'})
    self.body:setType('static')
end

function Escape:update(dt)
    if self.body:enter('Player') and state == 'playing' then
        state = 'finished'
        love.audio.play(sounds.win)
    end
end