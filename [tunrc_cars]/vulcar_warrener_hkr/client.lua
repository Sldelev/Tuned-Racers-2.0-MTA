local ID = 549

function CarStart()
	local cartxd = engineLoadTXD("car.txd")
	engineImportTXD(cartxd, ID)
	
	exports['Crypt-reload']:load({{ 'car.dff', 'dff', ID };})
end
addEventHandler( "onClientResourceStart", resourceRoot, CarStart)