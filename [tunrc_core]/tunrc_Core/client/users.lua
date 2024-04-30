-- Result event:
-- tunrc_Core.registerResponse
function register(username, password, ...)
	if type(username) ~= "string" or type(password) ~= "string" then
		return false
	end	
	local success, errorType = checkUsername(username)
	if not success then
		return false, errorType
	end
	success, errorType = checkPassword(password)
	if not success then
		return false, errorType
	end	
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end
	triggerServerEvent("tunrc_Core.registerRequest", resourceRoot, username, password, ...)
	return true
end

-- Result event:
-- tunrc_Core.passwordChangeResponse
function changePassword(password)
	if type(password) ~= "string" then
		return false, "bad_password"
	end
	success, errorType = checkPassword(password)
	if not success then
		return false, errorType
	end
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end	
	triggerServerEvent("tunrc_Core.passwordChangeRequest", resourceRoot, password)
	return true
end

-- Result event:
-- tunrc_Core.loginResponse
function login(username, password)
	if type(username) ~= "string" or type(password) ~= "string" then
		return false
	end
	if AccountsConfig.HASH_PASSWORDS_CLIENTSIDE then
		password = sha256(password)
	end
	
	triggerServerEvent("tunrc_Core.loginRequest", resourceRoot, username, password)
	return true
end

-- Result event:
-- tunrc_Core.loginResponse
function logout(reason)
	triggerServerEvent("tunrc_Core.logoutRequest", resourceRoot)
	return true
end