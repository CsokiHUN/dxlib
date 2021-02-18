Panel = {
    create = function(args, parent)
        local _Panel = setmetatable(args, { __index = Panel })
        _Panel.typ = "panel"
        _Panel.move = false

        _Panel.parent = parent or false
        _Panel.color = args.color or tocolor(255, 255, 255)

        if args.title then 
            args.title.position = args.title.position or Vector2()
            args.title.size = args.title.size or args.size

            args.title = Label.create(args.title, _Panel)
        end

        table.insert(createdElements, _Panel)
        return _Panel
    end,

    draw = function(self)
        dxDrawRectangle(self:getPosition(), self.size, self.color)

        if self.title then 
            self.title:draw()
        end
    end,

    hover = function(self)  
        return isMouseInPosition(self:getPosition(), self.size)
    end,

    getPosition = function(self)
        return self.parent and self.parent:getPosition() + (self.position or Vector2()) or self.position
    end,

    setPosition = function(self, position)
        if self.parent then 
            self.parent:setPosition(position)
        else 
            self.position = position
        end
    end
}