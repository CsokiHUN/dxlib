Label = {
    create = function(args, parent)
        args.font = args.font or "default"

        local _Label = setmetatable(args, { __index = Label })
        _Label.typ = "label"
        _Label.parent = parent or false

        table.insert(createdElements, _Label)
        return _Label
    end,

    destroy = function(self)
        self = nil
    end,

    draw = function(self)
        local align = self.align or { x = "left", y = "right" }

        dxDrawText(self.text, self:getPosition(), self.size, self.color or tocolor(255, 255, 255), 1, self.font, align.x or "left", align.y or "top")
    end,

    hover = function(self)
        local size = Vector2(self.size.x, dxGetFontHeight(1, self.font))

        return isMouseInPosition(self:getPosition(), size)
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
    end,

    getSize = function(self)
        return self.size or Vector2(dxGetTextWidth(self.text, 1, self.font, true), dxGetFontHeight(1, self.font))
    end
}