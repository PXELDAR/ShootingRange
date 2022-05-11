-----------------------------------------------------------------------------------

function love.load()
    _target = {}
    _target.x = 300
    _target.y = 300
    _target.radius = 50
    _target.drawMode = "fill"

    _score = 0
    _scoreText = "Score: "
    _timer = 0
    _timerText = "Timer: "
    _gameState = 1
    _beginText = "Click anywhere to begin!"

    _gameFont = love.graphics.newFont(40)

    _sprites = {}
    _sprites.sky = love.graphics.newImage("assets/sky.png")
    _sprites.target = love.graphics.newImage("assets/target.png")
    _sprites.crosshair = love.graphics.newImage("assets/crosshair.png")
    
    love.mouse.setVisible(false)
end

-----------------------------------------------------------------------------------

function love.update(dt)
    countdown(dt)
end

-----------------------------------------------------------------------------------

function love.draw()
    love.graphics.draw(_sprites.sky, 0, 0)
    
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(_gameFont)
    love.graphics.print(_scoreText .. _score, 5, 5)
    love.graphics.print(_timerText .. math.ceil(_timer), 300, 0)

    if (_gameState == 1) then
        love.graphics.printf(_beginText, 0, 250, love.graphics.getWidth(), "center")
    end

    if (_gameState == 2) then
        -- Subtract target radius for offset
        love.graphics.draw(_sprites.target, _target.x - _target.radius, _target.y - _target.radius)
    end

    -- Sprite is 40x40 so we subtract half of it for offset
    love.graphics.draw(_sprites.crosshair, love.mouse.getX() - 20, love.mouse.getY() - 20)
 
end

-----------------------------------------------------------------------------------

function love.mousepressed(x, y, button, isTouch, presses)
    if (button == 1) and _gameState == 2 then
        local mouseToTargetDistance = distanceBetween(x, y, _target.x, _target.y)
        if(mouseToTargetDistance < _target.radius) then
            onTargetHit()
        else
            onTargetMiss()
        end
    elseif (button == 1) and ( _gameState == 1) then
        startGame()
    end
end

-----------------------------------------------------------------------------------

function countdown(dt)
    if ( _timer > 0) then
        _timer = _timer - dt
    end

    if (_timer < 0) then
        switchToMainMenu()
    end
end

-----------------------------------------------------------------------------------

function startGame()
    _gameState = 2
    _timer = 10
    _score = 0
end

-----------------------------------------------------------------------------------

function switchToMainMenu()
    _timer = 0
    _gameState = 1
end

-----------------------------------------------------------------------------------

function onTargetHit()
    _score = _score + 1
    _target.x = math.random(_target.radius, love.graphics.getWidth() - _target.radius)
    _target.y = math.random(_target.radius, love.graphics.getHeight() - _target.radius)
end

-----------------------------------------------------------------------------------

function onTargetMiss()
    _score = _score - 1

    if(_score < 0) then
        _score = 0
    end
end

-----------------------------------------------------------------------------------

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-----------------------------------------------------------------------------------
