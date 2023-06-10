local MIN_DIMENSION = 0
local MAX_DIMENSION = 999

addCommandHandler("dt", function (player, commandName, dimension)
  if player then
    if player:getData("doCore.state") or player:getData("activeUI") or not exports.tunrc_Core:isPlayerLoggedIn(player) then
      return
    end
    dimension = tonumber(dimension)
    local r, g, b = 255, 165, 0
    if type(dimension) ~= "number" then
      exports.tunrc_Chat:message(player, "global", ("Использование: /dt [%d-%d]"):format(MIN_DIMENSION, MAX_DIMENSION), r, g, b)
      exports.tunrc_Chat:message(player, "global", "Меняет измерение, в котором вы находитесь.", r, g, b)
      exports.tunrc_Chat:message(player, "global", "Чтобы вернуться в общее измерение, введите /dt 0.", r, g, b)
    elseif dimension < MIN_DIMENSION or dimension > MAX_DIMENSION then
      exports.tunrc_Chat:message(player, "global", "Введён неверный номер измерения.", r, g, b)
      exports.tunrc_Chat:message(player, "global", ("Использование: /dt [%d-%d]"):format(MIN_DIMENSION, MAX_DIMENSION), r, g, b)
    elseif dimension == player.dimension then
      exports.tunrc_Chat:message(player, "global", ("Вы уже находитесь в измерении %d."):format(dimension), r, g, b)
      exports.tunrc_Chat:message(player, "global", ("Использование: /dt [%d-%d]"):format(MIN_DIMENSION, MAX_DIMENSION), r, g, b)
    else
      if player.vehicle and player.vehicleSeat == 0 then
        player.vehicle:setDimension(dimension)
        for seat, occupant in pairs(player.vehicle:getOccupants()) do
          occupant:setDimension(dimension)
          if dimension == 0 then
            exports.tunrc_Chat:message(occupant, "global", "Вы были перемещены в общее измерение.", r, g, b)
          else
            exports.tunrc_Chat:message(occupant, "global", ("Вы были перемещены в измерение %d."):format(dimension), r, g, b)
          end
        end
      else
        player:setDimension(dimension)
        if dimension == 0 then
          exports.tunrc_Chat:message(player, "global", "Вы были перемещены в общее измерение.", r, g, b)
        else
          exports.tunrc_Chat:message(player, "global", ("Вы были перемещены в измерение %d."):format(dimension), r, g, b)
        end
      end
    end
  end
end)
