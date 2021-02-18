local sx, sy = guiGetScreenSize()

bindKey("m", "down", function() showCursor(not isCursorShowing()) end)

_dxDrawText = dxDrawText
dxDrawText = function(text, pos, size, ...)
    return _dxDrawText(text, pos, pos + size, ...)
end

getMousePosition = function()
    if not isCursorShowing() then 
        return false, false
    end

    local cursorX, cursorY = getCursorPosition()

    return cursorX * sx, cursorY * sy
end

isMouseInPosition = function(position, size)
    if not isCursorShowing() then 
        return false
    end

    local cursorX, cursorY = getMousePosition()

    return (cursorX >= position.x and cursorX <= (position.x + size.x)) and (cursorY >= position.y and cursorY <= (position.y + size.y))
end

------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------

createdElements = {}
hoveredElement = false
movedElement = false

addEventHandler("onClientRender", root, function()
    hoveredElement = false

    for _, element in pairs(createdElements) do 
        element:draw()

        element.hovered = false
        if type(element.hover) == "function" and element:hover() then 
            element.hovered = true
            hoveredElement = element
        end
    end
end)

addEventHandler("onClientCursorMove", root, function()
    local cursorX, cursorY = getMousePosition()

    if movedElement then 
        if movedElement.move then 
            if cursorX and cursorY then 
                movedElement:setPosition(Vector2(cursorX + movedElement.move.x, cursorY + movedElement.move.y))
            else 
                movedElement.move = false
            end
        end
    end
end)

addEventHandler("onClientClick", root, function(button, state, clickX, clickY, ...)
    if button == "left" then 
        if state == "down" then 
            if hoveredElement then 
                if hoveredElement.moveable then 
                    local position = hoveredElement:getPosition()
                    hoveredElement.move = Vector2(position.x - clickX, position.y - clickY)
                    movedElement = hoveredElement
                end
            end
        else 
            if movedElement then 
                movedElement.move = false
            end
        end
    end

    -- if hoveredElement and (hoveredElement.typ or "") == "button" then  
    --     outputChatBox(hoveredElement.typ)
    --     triggerEvent("Button.onClick", resourceRoot, hoveredElement, button, state, clickX, clickY, ...)
    -- end
end)

--TESZT
addEventHandler("onClientResourceStart", resourceRoot, function()
    local panel = Panel.create({
        title = { --Label
            text = "title",
            color = tocolor(255, 255, 255),
            font = "default-bold", -- * font kezelés
            align = { 
                x = "center",
                y = "top"
            }
        },
        position = Vector2(sx / 2, sy / 2),
        size = Vector2(120, 100),
        color = tocolor(0, 0, 0, 180),
        moveable = true,
    })

    local button = Button.create({
        position = Vector2(10, 20),
        size = Vector2(100, 25),
        text = {
            value = "send",
            color = tocolor(0, 0, 0),
        },
        color = {200, 0, 100, 150},
        hoveredColor = {0, 0, 100, 250}
    }, panel)

    local button2 = Button.create({
        position = Vector2(10, 50),
        size = Vector2(100, 25),
        text = {
            value = "quit",
            color = tocolor(0, 0, 0),
        },
        color = {0, 100, 100, 150},
        hoveredColor = {50, 50, 100, 250}
    }, panel)
end)
