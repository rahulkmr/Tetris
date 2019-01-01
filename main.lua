

pieceStructures = {
    {
        {
            {' ', ' ', ' ', ' '},
            {'i', 'i', 'i', 'i'},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 'o', 'o', ' '},
            {' ', 'o', 'o', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', 'j', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {'j', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'j', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', 'j', ' '},
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'l', 'l', 'l', ' '},
            {'l', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', ' ', 'l', ' '},
            {'l', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'l', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {' ', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', ' ', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 's', 's', ' '},
            {'s', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'s', ' ', ' ', ' '},
            {'s', 's', ' ', ' '},
            {' ', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {' ', 'z', 'z', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'z', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {'z', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
}


function newPiece()
    pieceRotation = 1
    pieceX = 3
    pieceY = 0
    pieceType = table.remove(sequence)
    timerLimit = 0.5
    if #sequence == 0 then
        newSequence()
    end
end

function newSequence()
    sequence = {}
    for pieceTypeIndex = 1, #pieceStructures do
        local position = love.math.random(#sequence + 1)
        table.insert(
            sequence,
            position,
            pieceTypeIndex
        )
    end
end

function love.load()
    love.graphics.setBackgroundColor(255, 255, 255)
    newSequence()
    newPiece()

    pieceXCount = 4
    pieceYCount = 4

    timer = 0

    gridXCount = 15
    gridYCount = 30

    inert = {}
    for y = 1, gridYCount do
        inert[y] = {}
        for x = 1, gridXCount do
            inert[y][x] = ' '
        end
    end

end


function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    elseif key == 'w' then
        local testRotation = pieceRotation + 1
        if testRotation > #pieceStructures[pieceType] then
            testRotation = 1
        end

        if canPieceMove(pieceX, pieceY, testRotation) then
            pieceRotation = testRotation
        end
    elseif key == 'a' then
        local testX = pieceX - 1
        if canPieceMove(testX, pieceY, pieceRotation) then
            pieceX = testX
        end
    elseif key == 'd' then
        local testX = pieceX + 1
        if canPieceMove(testX, pieceY, pieceRotation) then
            pieceX = testX
        end
    elseif key == 'c' then
        while canPieceMove(pieceX, pieceY + 1, pieceRotation) do
            pieceY = pieceY + 1
            timer = timerLimit
        end
    end
end


function love.draw()
    local function drawBlock(block, x, y)
        local colors = {
            [' '] = {.87, .87, .87},
            i = {.47, .76, .94},
            j = {.93, .91, .42},
            l = {.49, .85, .76},
            o = {.92, .69, .47},
            s = {.83, .54, .93},
            t = {.97, .58, .77},
            z = {.66, .83, .46},
        }
        local color = colors[block]
        love.graphics.setColor(color)

        local blockSize = 20
        local blockDrawSize = blockSize - 1
        love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
        )
    end

    for y = 1, gridYCount do
        for x = 1, gridXCount do
            drawBlock(inert[y][x], x, y)
        end
    end

    for y = 1, pieceYCount do
        for x = 1, pieceXCount do
            local block = pieceStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                drawBlock(block, x + pieceX, y + pieceY)
            end
        end
    end
end

function canPieceMove(testX, testY, testRotation)
    for x = 1, pieceXCount do
        for y = 1, pieceYCount do
            local newX = testX + x
            local newY = testY + y
            if pieceStructures[pieceType][testRotation][y][x] ~= ' ' and
                (newX < 1 or newX > gridXCount or newY > gridYCount or
                 inert[newY][newX] ~= ' ') then
                    return false
            end
        end
    end

    return true
end


function love.update(delta)
    timer = timer + delta
    if timer >= timerLimit then
        timer = timer - timerLimit
        local testY = pieceY + 1
        if canPieceMove(pieceX, testY, pieceRotation) then
            pieceY = testY
        else
            for y = 1, pieceYCount do
                for x = 1, pieceXCount do
                    local block = pieceStructures[pieceType][pieceRotation][y][x]
                    if block ~= ' ' then
                        inert[pieceY + y][pieceX + x] = block
                    end
                end
            end
            newPiece()
        end
    end
end