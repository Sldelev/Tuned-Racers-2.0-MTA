local MIN_SKIN_ID = 0
local MAX_SKIN_ID = 312

addCommandHandler("skin", function (player, commandName, skin)
  if player then
    if player:getData("doCore.state") or player:getData("activeUI") or not exports.tunrc_Core:isPlayerLoggedIn(player) then
      return
    end
    skin = tonumber(skin)
    local r, g, b = 255, 165, 0
    if type(skin) ~= "number" then
      exports.tunrc_Chat:message(player, "global", ("Использование: /skin [%d-%d]"):format(MIN_SKIN_ID, MAX_SKIN_ID), r, g, b)
      exports.tunrc_Chat:message(player, "global", "Изменяет ваш скин.", r, g, b)
    elseif skin < MIN_SKIN_ID or skin > MAX_SKIN_ID then
      exports.tunrc_Chat:message(player, "global", "Неверный ID скина.", r, g, b)
      exports.tunrc_Chat:message(player, "global", ("Использование: /skin [%d-%d]"):format(MIN_SKIN_ID, MAX_SKIN_ID), r, g, b)
    elseif skin == player.model then
      exports.tunrc_Chat:message(player, "global", ("У вас уже установлен скин %d."):format(skin), r, g, b)
      exports.tunrc_Chat:message(player, "global", ("Использование: /skin [%d-%d]"):format(MIN_SKIN_ID, MAX_SKIN_ID), r, g, b)
    else
      player:setModel(skin)
      player:setData("skin", skin)
      exports.tunrc_Chat:message(player, "global", ("Установлен скин %d."):format(skin), r, g, b)
    end
  end
end)
