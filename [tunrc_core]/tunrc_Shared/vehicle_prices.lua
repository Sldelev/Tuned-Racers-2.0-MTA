-- {цена, уровень, донат-валюта}
local vehiclesPrices = {
    -- 1 класс
	tunerc_elegy = {5000, 1},
	tunerc_jester = {5500, 1},
	tunerc_alpha = {4500, 1},
	tunerc_euros = {6000, 1},
	tunerc_club = {4000, 1},
	tunerc_bravura = {4200, 1},
	tunerc_buffalo = {5500, 1},
	tunerc_sentinel = {4800, 1},
	tunerc_banshee = {6500, 1},
	tunerc_zr350 = {5400, 1},
}

function getVehiclePrices(name)
    if name then
        return vehiclesPrices[name]
    end
end
