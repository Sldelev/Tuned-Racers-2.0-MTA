addEvent("tunrc_Core.buy_house", true)
addEventHandler("tunrc_Core.buy_house", root, function (success)
	if success then
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("houses_message_title"), 
			exports.tunrc_Lang:getString("houses_message_buy_success")
		)
	else
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("houses_message_title"), 
			exports.tunrc_Lang:getString("houses_message_buy_fail")
		)
	end
end)

addEvent("tunrc_Houses.sell", true)
addEventHandler("tunrc_Houses.sell", root, function (success)
	if success then
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("houses_message_title"), 
			exports.tunrc_Lang:getString("houses_message_sell_success")
		)
	else
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("houses_message_title"), 
			exports.tunrc_Lang:getString("houses_message_sell_fail")
		)
	end
end)