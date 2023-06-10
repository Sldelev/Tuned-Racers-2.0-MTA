local currentUsername, currentPassword

function startGameClick(username, password)
	if not username or string.len(username) < 1 then
		isAuthInProgress = false
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("login_panel_auth_error"),
			exports.tunrc_Lang:getString("login_panel_err_enter_username")
		)
		return
	end
	if not password or string.len(password) < 1 then
		isAuthInProgress = false
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("login_panel_auth_error"),
			exports.tunrc_Lang:getString("login_panel_err_enter_password")
		)
		return
	end
	if not exports.tunrc_Core:login(username, password) then
		isAuthInProgress = false
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("login_panel_auth_error"),
			exports.tunrc_Lang:getString("login_panel_err_login_unknown")
		)
		return
	end
	currentUsername = username
	currentPassword = password
end

addEvent("tunrc_Core.loginResponse", true)
addEventHandler("tunrc_Core.loginResponse", root, function (success, err)
	isAuthInProgress = false
	if not success then
		outputDebugString("Error: " .. tostring(err))
		local errorText = exports.tunrc_Lang:getString("login_panel_err_login_unknown")
		if err == "incorrect_password" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_bad_password")
		elseif err == "user_not_found" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_user_not_found")
		elseif err == "already_logged_in" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_account_in_use")
		elseif err == "account_banned" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_account_banned")
		end
		exports.tunrc_UI:showMessageBox(exports.tunrc_Lang:getString("login_panel_auth_error"),  errorText)
		return
	end
	setVisible(false)
	Autologin.remember(currentUsername, currentPassword)
	exports.tunrc_Utils:clearChat()
	exports.tunrc_Chat:message("global", exports.tunrc_Lang:getString("chat_message_login_success"), 0, 255, 0)
end)

function registerClick(username, password, passwordConfirm, ...)
  	if not username or string.len(username) < 1 then
		isAuthInProgress = false
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("login_panel_register_error"),
			exports.tunrc_Lang:getString("login_panel_err_enter_username")
		)
		return
	end
	if not password or string.len(password) < 1 then
		isAuthInProgress = false
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("login_panel_register_error"),
			exports.tunrc_Lang:getString("login_panel_err_enter_password")
		)
		return
	end
	if not passwordConfirm or string.len(passwordConfirm) < 1 then
		isAuthInProgress = false
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("login_panel_register_error"),
			exports.tunrc_Lang:getString("login_panel_err_enter_password_confirm")
		)
		return
	end
	if passwordConfirm ~= password then
		isAuthInProgress = false
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("login_panel_register_error"),
			exports.tunrc_Lang:getString("login_panel_err_passwords_do_not_match")
		)
		return
	end
	local success, errorType = exports.tunrc_Core:register(username, password, ...)
	if not success then
		isAuthInProgress = false
		local errorText = exports.tunrc_Lang:getString("login_panel_err_register_unknown")
		if errorType == "username_too_short" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_username_too_short")
		elseif errorType == "username_too_long" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_username_too_long")
		elseif errorType == "invalid_username" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_username_invalid")
		elseif errorType == "password_too_short" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_password_too_short")
		elseif errorType == "password_too_long" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_password_too_long")
		elseif errorType == "beta_key_invalid" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_beta_key_invalid")
		end
		exports.tunrc_UI:showMessageBox(
			exports.tunrc_Lang:getString("login_panel_register_error"),
			errorText
		)
		return
	end
	currentUsername = username
	currentPassword = password
end

addEvent("tunrc_Core.registerResponse", true)
addEventHandler("tunrc_Core.registerResponse", root, function (success, err)
	isAuthInProgress = false
	if not success then
		outputDebugString("Error: " .. tostring(err))
		local errorText = exports.tunrc_Lang:getString("login_panel_err_register_unknown")
		if err == "username_taken" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_username_taken")
		elseif err == "beta_key_invalid" then
			errorText = exports.tunrc_Lang:getString("login_panel_err_beta_key_invalid")
		end
		exports.tunrc_UI:showMessageBox(exports.tunrc_Lang:getString("login_panel_register_error"), errorText)
		return
	end
	clearRegisterForm()
	gotoLoginPanel(currentUsername, currentPassword)
	exports.tunrc_UI:showMessageBox("Drift Paradise", exports.tunrc_Lang:getString("login_panel_register_success"))
end)

-- Смена языка
addEvent("tunrc_UI.login.languageClick", false)
addEventHandler("tunrc_UI.login.languageClick", root, function(language)
	if language == "ru" then
		language = "russian"
	else
		language = "english"
	end
	exports.tunrc_Lang:setLanguage(language)
	localPlayer:setData("language", language)
	setVisible(false)
	setVisible(true)
end)
