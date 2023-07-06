picups = {}
blips = {}
money = 0
--1248
function random_keis_create ()
	rand = math.random(1,#list_spawn)
	randMoney = math.random(1,250)
	
	for k,v in pairs (list_spawn) do
		if k == rand then
			picups = createPickup ( v[1], v[2], v[3] + 0.5, 3, 1248 )--+ 0.5, 2
			blips = createBlip ( v[1], v[2], v[3], 0)
			blips:setData("text", "tunrc_fun_candy")
			exports.tunrc_Chat:message(root, "global","#550000" .. "В мире заспавнилась конфетка и появилась отметка на карте.")
			money = randMoney
		end
	end
	addEventHandler( "onPickupHit", picups, function(player)
		destroyElement(picups)
		destroyElement(blips)
		exports.tunrc_Core:givePlayerMoney(player, money)
		exports.tunrc_Chat:message(root, "global","#550000" .. "Игрок "..getPlayerName(player).." нашел конфетку и получил "..money .."$")
		setTimer(random_keis_create, 60000 * times, 1)
	end)
end
random_keis_create ()
