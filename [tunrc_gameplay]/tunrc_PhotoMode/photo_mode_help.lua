PhotoModeHelp = {}

local helpLines = {
	nil,
	{keys = {"Q", "E"}, 														locale = "photo_mode_help_roll"},
	{keys = {"W", "A", "S", "D"}, 												locale = "photo_mode_help_move"},
	{keys = {"Alt", "Shift"}, 													locale = "photo_mode_help_speed"},
	{keys = {"controls_mouse"}, 												locale = "photo_mode_help_look"},
	{keys = {"controls_mouse_wheel"}, 											locale = "photo_mode_help_zoom"},
	{keys = {"controls_space", "Ctrl"}, 										locale = "photo_mode_help_updown"},
	{keys = {CONTROLS.TOGGLE_SMOOTH:upper()}, 									locale = "photo_mode_help_smooth"},
	{keys = {CONTROLS.NEXT_TIME:upper(), CONTROLS.PREVIOUS_TIME:upper()},		locale = "photo_mode_help_time"},
	{keys = {CONTROLS.NEXT_WEATHER:upper(), CONTROLS.PREVIOUS_WEATHER:upper()},	locale = "photo_mode_help_weather"},
	{keys = {"["},																locale = "photo_mode_help_tips"},
	{keys = {"N"},																locale = "photo_mode_help_hide"},
	{keys = {"3"},																locale = "photo_mode_help_composition"},
	{keys = {PHOTO_MODE_KEY:upper()},													locale = "photo_mode_help_exit"}
}

local weatherLine = ""

local LINE_HEIGHT = 25
local LINE_OFFSET = 3
local HORIZONTAL_OFFSET = 2
local EDGE_OFFSET = 10

local screenSize = Vector2(guiGetScreenSize())
local font
local themeColor = {}
local targetAlpha = 0
local alpha = targetAlpha
local ComposHelp = 0
local Active = true

function PhotoModeHelp.start()
	font = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 14)
	ComposHelp1 = DxTexture("assets/1.png")
	ComposHelp2 = DxTexture("assets/2.png")
	targetAlpha = 255
	alpha = 0

	-- Add screenshot keys to help
	local screenshotBoundKeys = getBoundKeys("screenshot")
	if screenshotBoundKeys then
		local screenshotKeys = {}
		for key, state in pairs(screenshotBoundKeys) do
			table.insert(screenshotKeys, key)
		end

		if #screenshotKeys > 0 then
			helpLines[1] = {keys = screenshotKeys, locale = "photo_mode_help_shoot"}
		end
	end

	-- Get localized description
	for i, line in ipairs(helpLines) do
		for j, key in ipairs(line.keys) do
			helpLines[i].keys[j] = exports.tunrc_Lang:getString(key)
		end
		line.text = exports.tunrc_Lang:getString(line.locale)
	end
end

function PhotoModeHelp.stop()
	if isElement(font) then
		destroyElement(font)
	end
end

function ComposHelpToggle()
	if ComposHelp == 0 then
		ComposHelp = 1
	elseif ComposHelp == 1 then
		ComposHelp = 2
	elseif ComposHelp == 2 then
		ComposHelp = 0
	end
end

function HelpToggle()
	if Active == true then
		Active = false
	else
		Active = true
	end
end

local function drawHelp()
	local y = EDGE_OFFSET

	for i, line in ipairs(helpLines) do
		local x = EDGE_OFFSET
		textWidth = dxGetTextWidth(line.text, 1, font) + 10
		for j, key in ipairs(line.keys) do
			local keyWidth = dxGetTextWidth(key, 1, font) + 10		
			exports.tunrc_Garage:dxDrawRoundedRectangle(
				x,
				y,
				textWidth + keyWidth + 10,
				LINE_HEIGHT,
				5,
				alpha,
				true, -- postgui
				false,
				true, -- shadow
				false
			 )
			exports.tunrc_Garage:TrcDrawText(key, x, y, x + keyWidth, y + LINE_HEIGHT, alpha, font)

			x = x + keyWidth + HORIZONTAL_OFFSET + 2
		end
		exports.tunrc_Garage:TrcDrawText(" | " .. line.text, x, y, x + textWidth, y + LINE_HEIGHT, alpha, font)

		y = y + LINE_HEIGHT + LINE_OFFSET + 3
	end
end

local function drawParams()
	local parameters = {
		{
			name = "photo_mode_param_time", value = ("%02d:%02d"):format(getTime())
		},
		{
			name = "photo_mode_param_weather",
			lvalue = (currentWeather == 0) and "photo_mode_param_weather_unknown" or weatherList[currentWeather].name
		},
		{
			name = "photo_mode_param_fov",
			lvalue = getCameraFov()
		},
		{
			name = "photo_mode_param_roll",
			lvalue = string.format("%u", getCameraRoll())
		}
	}

	local y = screenSize.y - 25 - ((LINE_HEIGHT + LINE_OFFSET) * #parameters)
	local x = EDGE_OFFSET
	for i, param in pairs(parameters) do
		local x = EDGE_OFFSET
		local value
		
		if param.lvalue then
			value = exports.tunrc_Lang:getString(param.lvalue)
		else
			value = param.value
		end

		local name = exports.tunrc_Lang:getString(param.name)
		local nameWidth = dxGetTextWidth(name, 1, font) + 10
		local valueWidth = dxGetTextWidth(value, 1, font) + 10
		exports.tunrc_Garage:dxDrawRoundedRectangle(
				x,
				y,
				nameWidth + valueWidth + 10,
				LINE_HEIGHT,
				5,
				alpha,
				true, -- postgui
				false,
				true, -- shadow
				false
			 )

		exports.tunrc_Garage:TrcDrawText(name, x, y, x + nameWidth, y + LINE_HEIGHT, alpha, font)

		x = x + nameWidth + HORIZONTAL_OFFSET
		exports.tunrc_Garage:TrcDrawText(value, x, y, x + valueWidth, y + LINE_HEIGHT, alpha, font)

		y = y + LINE_HEIGHT + LINE_OFFSET
	end
	
	if ComposHelp == 0 then
		return
	elseif ComposHelp == 1 then
		dxDrawImage (0, 0, screenSize.x, screenSize.y, ComposHelp1, 0, 0, 0 )
	elseif ComposHelp == 2 then
		dxDrawImage (0, 0, screenSize.x, screenSize.y, ComposHelp2, 0, 0, 0 )
	end
end


function PhotoModeHelp.draw()
	if not Active then
		return
	end
	alpha = alpha + (targetAlpha - alpha) * 0.1
	themeColor.r, themeColor.g, themeColor.b = exports.tunrc_UI:getThemeColor()

	drawHelp()
	drawParams()
end
