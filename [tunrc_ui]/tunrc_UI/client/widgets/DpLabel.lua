--- Виджет текстового поля
-- @module tunrc_UI.DpLabel

DpLabel = {}

function DpLabel.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end
	
	local widget = TextField.create(properties)
	widget.font = Fonts.defaultSmall
	widget.color = properties.color or Colors.color("white")
	widget.darkToggle = properties.darkToggle
	
	if properties.fontType and Fonts[properties.fontType] then
		widget.font = Fonts[properties.fontType]
	end
	return widget
end