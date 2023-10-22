Assets = {}
local stickersLoaded = false

function Assets.start()
	Assets.textures = {
		logo = exports.tunrc_Assets:createTexture("logo_square_simple.png", "dxt5"),
		arrow = exports.tunrc_Assets:createTexture("arrow.png", "dxt5"),
		circle = DxTexture("assets/images/circle_button.png"),
		slider = DxTexture("assets/images/slider.png"),
		sliderCircle = DxTexture("assets/images/slider_circle.png"),

		colorsHue = DxTexture("assets/images/hue.png"),
		colorsSaturation = DxTexture("assets/images/saturation.png"),
		colorsBrightness = DxTexture("assets/images/brightness.png"),
		colorsOpacity = DxTexture("assets/images/opacity.png"),

		stickersColorIcon = DxTexture("assets/images/icons/color.png"),
		stickersMoveIcon = DxTexture("assets/images/icons/move.png"),
		stickersRotateIcon = DxTexture("assets/images/icons/rotate.png"),
		stickersScaleIcon = DxTexture("assets/images/icons/scale.png"),

		tuningComponentsIcon = DxTexture("assets/images/icons/components.png"),
		tuningColorIcon = DxTexture("assets/images/icons/color.png"),
		tuningVinylsIcon = DxTexture("assets/images/icons/vinyls.png"),
		tuningSettingsIcon = DxTexture("assets/images/icons/settings.png"),
		
		garage_menu_go_city = exports.tunrc_Assets:createTexture("garage_icons/garage_menu_go_city.png", "dxt5"),
		garage_menu_customize = exports.tunrc_Assets:createTexture("garage_icons/garage_menu_customize.png", "dxt5"),
		garage_menu_sell = exports.tunrc_Assets:createTexture("garage_icons/garage_menu_sell.png", "dxt5"),
		
		component1 = exports.tunrc_Assets:createTexture("garage_icons/garage_menu_sell.png", "dxt5"),
		
		buttonCircle = DxTexture("assets/images/button_circle.png"),
		levelIcon = exports.tunrc_Assets:createTexture("level.png"),

		stickersSection1 = DxTexture("assets/images/icons/section1.png"),
		stickersSection2 = DxTexture("assets/images/icons/section2.png"),
		stickersSection3 = DxTexture("assets/images/icons/section3.png"),
		stickersSection4 = DxTexture("assets/images/icons/section4.png"),
		stickersSection5 = DxTexture("assets/images/icons/section5.png"),
		stickersSection6 = DxTexture("assets/images/icons/section6.png"),
		stickersSection7 = DxTexture("assets/images/icons/section7.png"),
		stickersSection8 = DxTexture("assets/images/icons/section8.png"),
		stickersSection9 = DxTexture("assets/images/icons/section9.png"),
		stickersSection10 = DxTexture("assets/images/icons/section10.png"),
		stickersSection11 = DxTexture("assets/images/icons/section11.png"),
		stickersSection12 = DxTexture("assets/images/icons/section12.png"),
	}

	Assets.fonts = {}
	local fontsBySize = {}
	local function loadFont(name, size)
		if fontsBySize[size] then
			Assets.fonts[name] = fontsBySize[size]
			return fontsBySize[size]
		end
		Assets.fonts[name] = exports.tunrc_Assets:createFont("Roboto-Regular.ttf", size)
		fontsBySize[size] = Assets.fonts[name]
		return Assets.fonts[name]
	end

	loadFont("menu", 22)
	loadFont("carNameText", 48)
	loadFont("colorMenuHeader", 20)
	loadFont("colorMenuPrice", 18)
	loadFont("componentName", 30)
	loadFont("componentNameInfo", 15)
	loadFont("menuLabel", 18)
	loadFont("helpText", 16)
	loadFont("moneyText", 24)
	loadFont("levelText", 14)
	loadFont("controlIconButton", 18)
	loadFont("stickersGridText", 12)
	loadFont("tuningPanelText", 14)
	loadFont("tuningPanelKey", 11)
	loadFont("componentItem", 16)
	loadFont("componentItemInfo", 13)
	loadFont("stickerPreviewHelp", 12)
	loadFont("helpPanelText", 14)

	triggerEvent("tunrc_Garage.assetsLoaded", resourceRoot)

	local texturesCount = 0
	for k, v in pairs(Assets.textures) do
		texturesCount = texturesCount + 1
	end
end

function Assets.loadSticker(id)
	local assetName = "sticker_" .. tostring(id)
	if Assets.textures[assetName] then
		return Assets.textures[assetName]
	end
	Assets.textures[assetName] = exports.tunrc_Stickers:createTexture("stickers/" .. id .. "prev.png", "dxt5")
	if not isElement(Assets.textures[assetName]) then
		outputDebugString("No preview for sticker " .. tostring(id))
		Assets.textures[assetName] = exports.tunrc_Stickers:createTexture("stickers/" .. id .. ".png", "dxt5")
	end
	return Assets.textures[assetName]
end

function Assets.stop()
	local texturesCount = 0
	for name, texture in pairs(Assets.textures) do
		if isElement(texture) then
			destroyElement(texture)
			texturesCount = texturesCount + 1
		end
	end

	for name, font in pairs(Assets.fonts) do
		if isElement(font) then
			destroyElement(font)
		end
	end
end
