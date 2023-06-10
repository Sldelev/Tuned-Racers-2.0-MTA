Fonts = {}

local SIZE_NORMAL = 16
local SIZE_LARGE = 20
local SIZE_LARGER = 26
local SIZE_SMALL = 14

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Fonts.default = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_NORMAL)
	Fonts.defaultBold = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_NORMAL, true)

	Fonts.defaultSmall = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_SMALL)
	Fonts.defaultLarge = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_LARGE)
	Fonts.defaultLarger = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_LARGER)
	
	Fonts.light = exports.tunrc_Assets:createFont("Roboto-Light.ttf", SIZE_NORMAL)
	Fonts.lightSmall = exports.tunrc_Assets:createFont("Roboto-Light.ttf", SIZE_SMALL)

	Fonts.listItemText = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 13)
end)