--- Виджет поля ввода
-- @module tunrc_UI.DpInput


DpInput = {}

local inputColors = {
	dark = "gray",
	light = "gray_light"
}

function DpInput.create(properties)
	if type(properties) ~= "table" then
		properties = {}
	end

	local widget = Input.create(properties)
	local colorName = inputColors[exports.tunrc_Utils:defaultValue(properties.type, "dark")]

	return widget
end