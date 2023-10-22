-- {цена, уровень, донат-валюта}
local vehiclesPrices = {
    -- 1 класс
	tunrc_zr350 = {12500, 5,false, 125},	
	tunrc_warrener_hkr = {10200, 5,false, 102},
	tunrc_remus = {17000, 10,false, 170},
}

function getVehiclePrices(name)
    if name then
        return vehiclesPrices[name]
    end
end
