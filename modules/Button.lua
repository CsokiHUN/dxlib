Button = {
    create = function(args, parent)
        args.color = args.color or {255, 255, 255}
        args.hoveredColor = args.hoveredColor or {args.color[1], args.color[2], args.color[3], math.min(255, (args.color[4] or 255) * 2)}
        args.parent = parent or false

        local _Button = setmetatable(args, { __index = Button })
        _Button.typ = "button"
        _Button.currentColor = _Button.color

        table.insert(createdElements, _Button)
        return _Button
    end,

    draw = function(self)
        local position = self:getPosition()

        if self.hovered then 
            self.currentColor = self.hoveredColor
        else 
            self.currentColor = self.color
        end

        dxDrawRectangle(position, self.size, tocolor(unpack(self.currentColor)))

        if self.text then 
            local align = self.align or { x = "center", y = "center" }

            dxDrawText(self.text.value, position, self.size, self.text.color or tocolor(255, 255, 255), 1, self.text.font or "default-bold", align.x or "center", align.y or "center")
        end
    end,

    hover = function(self)
        return isMouseInPosition(self:getPosition(), self.size)
    end,

    getPosition = function(self)
        return self.parent and self.parent:getPosition() + (self.position or Vector2()) or self.position
    end,
}

-- addEvent("Button.onClick", false)