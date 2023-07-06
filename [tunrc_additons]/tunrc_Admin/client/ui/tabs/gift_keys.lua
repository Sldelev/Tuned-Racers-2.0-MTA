local ui = {}
local carNamesList = {}
local addDiffToCreated = false
local selectOnChange = false

local function onTabOpened()
	ui.carsSelect:clear()
	carNamesList = {}
	for name, model in pairs(exports.tunrc_Shared:getVehiclesTable()) do
		local readableName = exports.tunrc_Shared:getVehicleReadableName(name)
		ui.carsSelect:addItem(readableName)
		table.insert(carNamesList, name)
	end

	triggerServerEvent("tunrc_Admin.requireGiftKeysList", resourceRoot)
end

addEvent("tunrc_Admin.requireGiftKeysList", true)
addEventHandler("tunrc_Admin.requireGiftKeysList", resourceRoot, function (keysList)
	if type(keysList) ~= "table" then
		return
	end
	local oldKeys = {}
	if addDiffToCreated then
		for i = 0, ui.keysList:getRowCount() do
			table.insert(oldKeys, ui.keysList:getItemText(i, 1))
		end
		ui.createdKeysList.text = "-- Keys list"
	end

	ui.keysList:clear()
	for i, key in ipairs(keysList) do
		local user = key.user_id
		if not user then
			user = "none"
		end
		if addDiffToCreated and key.key then
			local found = false
			for j, oldKey in ipairs(oldKeys) do
				if oldKey == key.key then
					found = true
					break
				end
			end
			if not found then
				ui.createdKeysList.text = ui.createdKeysList.text .. key.key .. "\n"
			end
		end
		local carName = exports.tunrc_Shared:getVehicleReadableName(key.car) or key.car
		ui.keysList:addRow(key.key, key.money, key.xp, carName)
	end	

	if type(selectOnChange) == "number" then
		selectOnChange = math.min(selectOnChange, #keysList - 1)
		ui.keysList:setSelectedItem(selectOnChange, 1)
	end

	selectOnChange = false
	addDiffToCreated = false
end)

addEvent("tunrc_Admin.updatedKeys", true)
addEventHandler("tunrc_Admin.updatedKeys", resourceRoot, function ()
	onTabOpened()
end)


addEventHandler("onClientResourceStart", resourceRoot, function ()
	ui.panel = admin.ui.addTab("keys", "Gift keys")

	ui.keysList = GuiGridList(0.34, 0.07, 0.65, 0.84, true, ui.panel)
	ui.keysList:addColumn("Key", 0.18)
	ui.keysList:addColumn("Money", 0.2)
	ui.keysList:addColumn("XP", 0.2)
	ui.keysList:addColumn("Car", 0.35)
	ui.keysList:setSelectionMode(1)

	ui.searchKeyEdit = GuiEdit(0.34, 0.01, 0.65, 0.05, "", true, ui.panel)
	ui.refreshButton = GuiButton(0.34, 0.84 + 0.07, 0.325, 0.07, "Refresh", true, ui.panel)
	ui.removeButton = GuiButton(0.34 + 0.325, 0.84 + 0.07, 0.325, 0.07, "Remove key", true, ui.panel)
	
	local y = 0.015
	GuiLabel(0.02, y, 0.5, 0.05, "Key", true, ui.panel)
	y = y + 0.05
	ui.keyEdit = GuiEdit(0.02, y, 0.3, 0.05, "Key", true, ui.panel)

	y = y + 0.05
	ui.moneyEdit = GuiEdit(0.02, y, 0.3, 0.05, "Money", true, ui.panel)

	y = y + 0.05
	ui.xpEdit = GuiEdit(0.02, y, 0.3, 0.05, "XP", true, ui.panel)	

	y = y + 0.05
	ui.carsSelect = GuiComboBox(0.02, y, 0.3, 0.35, "None", true, ui.panel)

	y = y + 0.12
	GuiLabel(0.02, y, 0.5, 0.05, "Keys count", true, ui.panel)
	y = y + 0.05
	ui.minusButton = GuiButton(0.02, y, 0.03, 0.05, "-", true, ui.panel)
	ui.countEdit = GuiEdit(0.05, y, 0.09, 0.05, "1", true, ui.panel)
	ui.plusButton = GuiButton(0.14, y, 0.03, 0.05, "+", true, ui.panel)
	y = y + 0.08
	ui.createButton = GuiButton(0.02, y, 0.15, 0.07, "Create", true, ui.panel)

	y = y + 0.08			
	GuiLabel(0.02, y, 0.5, 0.05, "Created keys list:", true, ui.panel)
	y = y + 0.05
	ui.createdKeysList = GuiMemo(0.02, y, 0.3, 0.27, "", true, ui.panel)
	ui.createdKeysList:setReadOnly(true)

	addEventHandler("onClientGUITabSwitched", ui.panel, onTabOpened, false)
	addEventHandler("tunrc_Admin.panelOpened", resourceRoot, onTabOpened)	

	addEventHandler("onClientGUIClick", ui.minusButton, function ()
		ui.countEdit.text = tostring(math.max(1, (tonumber(ui.countEdit.text) or 0) - 1))
	end, false)
	addEventHandler("onClientGUIClick", ui.plusButton, function ()
		ui.countEdit.text = tostring((tonumber(ui.countEdit.text) or 0) + 1)
	end, false)

	addEventHandler("onClientGUIClick", ui.createButton, function ()
		local key = ui.keyEdit.text or "TRC"
		if key == 0 then key = "TRC" end
		local money = tonumber(ui.moneyEdit.text) or 0
		if money == 0 then money = nil end
		local xp = tonumber(ui.xpEdit.text) or 0
		if xp == 0 then xp = nil end
		local car
		if ui.carsSelect.selected >= 0 then
			car = carNamesList[ui.carsSelect.selected + 1]
		end
		local count = tonumber(ui.countEdit.text) or 0
		if count == 0 then count = nil end
		addDiffToCreated = true
		triggerServerEvent("tunrc_Admin.createGiftKeys", resourceRoot, {
			key = key,
			money = money,
			xp = xp,
			car = car,
			count = count
		})
	end, false)	

	addEventHandler("onClientGUIClick", ui.removeButton, function ()
		local row = ui.keysList:getSelectedItem()
		if row < 0 then
			return
		end
		local keys = {ui.keysList:getItemText(row, 1)}
		if #keys > 0 then			
			selectOnChange = row
			triggerServerEvent("tunrc_Admin.removeGiftKeys", resourceRoot, keys)
		end
	end, false)

	addEventHandler("onClientGUIClick", ui.refreshButton, onTabOpened)	
end)