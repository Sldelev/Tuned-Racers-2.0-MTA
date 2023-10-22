-- {цена, уровень, донат-валюта}
local vehiclesDesc = {
	tunrc_zr350 = "Ебанутая прошмандовка начального плана",
	tunrc_warrener_hkr = "Ахуеть какая малышечка для вашего отца(ххахаха он же ушёл)"
}

function getVehicleDescription(name)
    if name then
        return vehiclesDesc[name]
    end
end
