addEvent("tunrc_Core.login", true)
addEventHandler("tunrc_Core.login", root, function (result)
  if result then
    triggerClientEvent("tunrc_Greetings.onLogin", resourceRoot, source)
  end
end)
