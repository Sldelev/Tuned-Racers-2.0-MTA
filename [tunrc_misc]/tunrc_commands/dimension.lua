local MIN_DIMENSION = 0
local MAX_DIMENSION = 999

addCommandHandler("dt", function (commandName, dimension)
  if localPlayer then
    if localPlayer:getData("doCore.state") or localPlayer:getData("activeUI") then
      return
    end
    dimension = tonumber(dimension)
    local r, g, b = 255, 165, 0
    if type(dimension) ~= "number" then
      exports.tunrc_UI:showNotificationBox(
			exports.tunrc_Lang:getString("dimension_change"),
			exports.tunrc_Lang:getString("dimension_change_information")
		)
    elseif dimension < MIN_DIMENSION or dimension > MAX_DIMENSION then
		exports.tunrc_UI:showNotificationBox(
			exports.tunrc_Lang:getString("dimension_change"),
			exports.tunrc_Lang:getString("dimension_change_incorrect")
		)
    elseif dimension == localPlayer.dimension then
		exports.tunrc_UI:showNotificationBox(
			exports.tunrc_Lang:getString("dimension_change"),
			exports.tunrc_Lang:getString("dimension_change_in_dimension")
		)
    else
      if localPlayer.vehicle and localPlayer.vehicleSeat == 0 then
        localPlayer.vehicle:setDimension(dimension)
        for seat, occupant in pairs(localPlayer.vehicle:getOccupants()) do
          occupant:setDimension(dimension)
          if dimension == 0 then
            exports.tunrc_UI:showNotificationBox(
				exports.tunrc_Lang:getString("dimension_change"),
				exports.tunrc_Lang:getString("dimension_change_to_global")
			)
          else
            exports.tunrc_UI:showNotificationBox(
				exports.tunrc_Lang:getString("dimension_change"),
				exports.tunrc_Lang:getString("dimension_change_to") .. dimension
			)
          end
        end
      else
        localPlayer:setDimension(dimension)
        if dimension == 0 then
			exports.tunrc_UI:showNotificationBox(
				exports.tunrc_Lang:getString("dimension_change"),
				exports.tunrc_Lang:getString("dimension_change_to_global")
			)
        else
			exports.tunrc_UI:showNotificationBox(
				exports.tunrc_Lang:getString("dimension_change"),
				exports.tunrc_Lang:getString("dimension_change_to") .. dimension
			)
        end
      end
    end
  end
end)
