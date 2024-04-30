UpgradesScreen = Screen:subclass "UpgradesScreen"

function UpgradesScreen:init(wheelsSide)
	self.disabled = false
	self.wheelsSide = wheelsSide
	self.menu = UpgradesMenu(
		GarageCar.getVehiclePos() + Vector3(1, -2, 0.3),
		-45
	)

	CameraManager.setState("previewUpgrades", false, 3)
	--local price = unpack(exports.tunrc_Shared:getTuningPrices("wheels_advanced"))
	self.super:init()
end

function UpgradesScreen:draw()
	self.super:draw()
	self.menu:draw(self.fadeProgress)
end

function UpgradesScreen:update(deltaTime)
	self.super:update(deltaTime)
	self.menu:update(deltaTime)
end

function UpgradesScreen:onKey(key)
	self.super:onKey(key)
	if self.disabled then
		return
	end

	if key == "enter" then
		if self.menu:hasUpgrade() then
			return
		end
		local upgradeName, price = self.menu:getSelectedUpgrade()
		if not upgradeName or not price then
			return
		end
		local this = self
		self.disabled = true
		Garage.buy(price, 0, function (success)
			if success then
				GarageCar.applyTuning(upgradeName, 1)
				GarageCar.resetTuning()
				this.screenManager:showScreen(ConfigurationsScreen("Upgrades"))
			end
		end)
	elseif key == "backspace" then
		self.disabled = true
		self.screenManager:showScreen(ConfigurationsScreen("Upgrades"))
	elseif key == "arrow_u" then
		self.menu:selectPrevious()
	elseif key == "arrow_d" then
		self.menu:selectNext()
	end
end