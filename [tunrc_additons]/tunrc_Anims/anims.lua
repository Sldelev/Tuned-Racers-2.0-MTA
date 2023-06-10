local anims = {
	wave = {"PED", "IDLE_TAXI", false},
	lay = {"INT_HOUSE", "wash_up"},
	sit = {"GANGS", "LEANIDLE"},
	sit_relax = {"INT_House", "LOU_Loop"},
	fucku = {"ped", "fucku", false},
	serious = {"CAR", "FIXN_CAR_LOOP"},

	hello = {"ped", "endchat_03", false},
	no = {"SWAT", "JMP_WALL1M_180", false},
	bye = {"DEALER", "DEALER_IDLE_01"},
	smoke_a = {"SMOKING", "M_smkstnd_loop"},
	smoke_b = {"SMOKING", "M_smklean_loop"},
	drink_a = {"BD_FIRE", "BD_PANIC_LOOP"},
	drink_b = {"BOMBER", "BOM_PLANT_LOOP"},
	dance_a = {"RAPPING", "RAP_A_LOOP"},

	--Ped > IDLE_Chat
}

addEvent("tunrc_Anims.playAnim", true)
addEventHandler("tunrc_Anims.playAnim", root, function (name)
	if not anims[name] then
		return
	end
	local loop = true
	if anims[name][3] == false then
		loop = false
	end
	client:setAnimation(anims[name][1], anims[name][2], 0, loop, false)
end)