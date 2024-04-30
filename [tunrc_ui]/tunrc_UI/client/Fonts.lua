Fonts = {}

local SIZE_NORMAL = 16
local SIZE_LARGE = 20
local SIZE_LARGER = 26
local SIZE_VERYBIGBOY = 34
local SIZE_LIZE_DICK = 56
local SIZE_SMALL = 14
local SIZE_VERYSMALL = 10
local SIZE_NOTVERYSMALL = 12

addEventHandler("onClientResourceStart", resourceRoot, function ()
	Fonts.default = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_NORMAL)
	Fonts.defaultBold = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_NORMAL, true)
	
	Fonts.UIdefaultVerySmall = exports.tunrc_Assets:createFont("Trc_font_UI.ttf", SIZE_VERYSMALL)
	Fonts.UIdefaultSmall = exports.tunrc_Assets:createFont("Trc_font_UI.ttf", SIZE_SMALL)
	Fonts.UIdefault = exports.tunrc_Assets:createFont("Trc_font_UI.ttf", SIZE_NORMAL)
	Fonts.UIdefaultBold = exports.tunrc_Assets:createFont("Trc_font_UI_Bold.ttf", SIZE_NORMAL)
	Fonts.UIdefaultLarger = exports.tunrc_Assets:createFont("Trc_font_UI.ttf", SIZE_LARGER)
	Fonts.UIdefaultLargerBold = exports.tunrc_Assets:createFont("Trc_font_UI_Bold.ttf", SIZE_LARGER)
	Fonts.UIdefaultBigBoy = exports.tunrc_Assets:createFont("Trc_font_UI.ttf", SIZE_VERYBIGBOY)
	Fonts.UIdefaultBigBoyBold = exports.tunrc_Assets:createFont("Trc_font_UI_Bold.ttf", SIZE_VERYBIGBOY)

	Fonts.defaultSmall = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_SMALL)
	Fonts.defaultLarge = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_LARGE)
	Fonts.defaultLarger = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_LARGER)
	Fonts.defaultBigBoy = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_VERYBIGBOY)
	Fonts.defaultBigLarger = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", SIZE_LIZE_DICK)
	
	Fonts.light = exports.tunrc_Assets:createFont("Roboto-Light.ttf", SIZE_NORMAL)
	Fonts.lightLarger = exports.tunrc_Assets:createFont("Roboto-Light.ttf", SIZE_LARGER)
	Fonts.lightBigBoy = exports.tunrc_Assets:createFont("Roboto-Light.ttf", SIZE_VERYBIGBOY)
	Fonts.lightSmall = exports.tunrc_Assets:createFont("Roboto-Light.ttf", SIZE_SMALL)
	Fonts.lightVerySmall = exports.tunrc_Assets:createFont("Roboto-Light.ttf", SIZE_VERYSMALL)
	Fonts.lightNotVerySmall = exports.tunrc_Assets:createFont("Roboto-Light.ttf", SIZE_NOTVERYSMALL)

	Fonts.listItemText = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", 13)
end)