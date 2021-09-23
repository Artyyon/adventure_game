WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576

WIDTH = 426  --640
HEIGTH = 240 --360

wf = require 'libraries/windfield'
push = require 'libraries/push'
Class = require 'libraries/class'
sti = require 'libraries/sti'
Camera = require 'libraries/camera'
require 'Player'
require 'Map'
require 'Trap'
require 'Enemy'
require 'Cup'
require 'Escape'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(WIDTH, HEIGTH, WINDOW_WIDTH, WINDOW_HEIGHT)

    love.window.setTitle("Adventure Game")

    bg_music = love.audio.newSource('song/watery_cave.mp3', 'stream')
    love.audio.play(bg_music)
    love.audio.setVolume(0.3)
    music_state = true

    sounds = {
        win = love.audio.newSource('song/win.wav', 'stream'),
        lose = love.audio.newSource('song/lose.wav', 'stream'),
        coin = love.audio.newSource('song/coin.wav', 'stream'),
        jump = love.audio.newSource('song/jump.wav', 'stream')
    }

    world = wf.newWorld(0, 800, false)
    world:setQueryDebugDrawing(true)
    world:addCollisionClass('Player')
    world:addCollisionClass('Plataform')
    world:addCollisionClass('Traps')
    world:addCollisionClass('Enemy')
    world:addCollisionClass('Cup')
    world:addCollisionClass('Escape')

    map = Map(world)
    player = Player(world)
    cup = Cup(world)

    enemy = {}
    for _,obj in ipairs(map.gameMap.layers['enemy'].objects) do
        table.insert(enemy, Enemy(world, obj))
    end
    trap = {}
    for _,obj in ipairs(map.gameMap.layers['traps'].objects) do
        table.insert(trap, Trap(world, obj))
    end

    

    local ob
    for _,obj in ipairs(map.gameMap.layers['exit'].objects) do
        ob = obj
    end
    Escape = Escape(world, ob)

    cam = Camera()

    spriteCup = love.graphics.newImage('sprites/Cup.png')

    bigFont = love.graphics.newFont("fonts/AncientModernTales-a7Po.ttf", 70)
    smallFont = love.graphics.newFont("fonts/AncientModernTales-a7Po.ttf", 30)
    littleFont = love.graphics.newFont("fonts/AncientModernTales-a7Po.ttf", 15)

    state = 'init'
end

function love.update(dt)
    if not bg_music:isPlaying( ) then
		love.audio.play(bg_music)
	end
    if state == 'playing' then
        world:update(dt)
        cup:update(dt)
        player:update(dt)
        for _, e in ipairs(enemy) do
            e:update(dt)
        end
        map:update(dt)
        Escape:update(dt)
    end
end

function love.draw()
    if state == 'playing' then
        love.graphics.setColor(0/255, 206/255, 209/255)
        push:start()
        cam:attach()
        map:draw()
        --world:draw() -- debug (comentar para desativar)
        love.graphics.setColor(1, 1, 1)
        cup:draw()
        player:draw()
        for _, e in ipairs(enemy) do
            e:draw()
        end
        cam:lookAt(player.x + WIDTH - 100, player.y + HEIGTH/2 + 40)
        cam:detach()
        push:finish()

        love.graphics.draw(spriteCup, 5, 5, 0, 2, 2)
        love.graphics.setFont(smallFont)
        love.graphics.setColor(255/255, 223/255, 0/255)
        love.graphics.printf(cup.colleted .. "/6",45, 6, 200,"left")
        love.graphics.setColor(1, 1, 1)
    end
    
    if state == 'game_over' then
        -- 34, 20, 43
        love.graphics.clear(131/255, 131/255, 131/255)
    
        love.graphics.setFont(bigFont)
        love.graphics.setColor(252/255, 23/255, 35/255)
        love.graphics.printf('You Died', 0, 192, 1024, 'center')
        
        love.graphics.setFont(littleFont)
        love.graphics.setColor(6/255, 251/255, 255/255)
        love.graphics.printf('Press SPACE to start', 0, 192 + 70, 1024, 'center')
        love.graphics.setColor(1, 1, 1)
    end

    if state == 'init' then
        -- 34, 20, 43
        love.graphics.clear(131/255, 131/255, 131/255)
    
        love.graphics.setFont(bigFont)
        love.graphics.setColor(6/255, 251/255, 255/255)
        love.graphics.printf('Adventure Game', 0, 192, 1024, 'center')
        
        love.graphics.setFont(littleFont)
        love.graphics.setColor(6/255, 251/255, 255/255)
        love.graphics.printf('Press SPACE to start', 0, 192 + 70, 1024, 'center')
        love.graphics.setColor(1, 1, 1)
    end

    if state == 'finished' then
        -- 34, 20, 43
        love.graphics.clear(131/255, 131/255, 131/255)
    
        love.graphics.setFont(bigFont)
        love.graphics.setColor(6/255, 251/255, 255/255)
        love.graphics.printf('Congratulations!', 0, 192, 1024, 'center')

        love.graphics.setFont(smallFont)
        love.graphics.setColor(6/255, 251/255, 255/255)
        love.graphics.printf(cup.colleted .. ' cups out of 6 collected', 0, 192 + 90, 1024, 'center')
        
        love.graphics.setFont(littleFont)
        love.graphics.setColor(6/255, 251/255, 255/255)
        love.graphics.printf('Press SPACE to start', 0, 192 + 140, 1024, 'center')
        love.graphics.setColor(1, 1, 1)
    end
end

function  love.keypressed(key)
    if key == 'w' then
        player:jump()
    elseif key == 'space' then
        if state == 'init' or state == 'game_over' or state == 'finished' then
            state = 'playing'
            player:reset()
            cup:restart()
        end
    end
end