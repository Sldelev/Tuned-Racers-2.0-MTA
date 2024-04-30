garage ={ 
	position = Vector3(2267, -2016, 14),
	rotation = Vector3(0,0,180)
}
function getGarageLocation(player)
	if not isElement(player) then
		return false
	end
	return garage
end