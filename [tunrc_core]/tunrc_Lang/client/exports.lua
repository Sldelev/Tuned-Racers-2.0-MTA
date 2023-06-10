function set(language)
	return exports.tunrc_Config:setProperty("ui.language", language)
end
setLanguage = set

function get(...)
	success, result = pcall(Language.get, ...)
	if success then
		return result
	else
		return false
	end
end
getLanguage = get

function getString(...)
	success, result = pcall(Language.getString, ...)
	if success then
		return result
	else
		return false
	end
end

function chatMessage(...)
	success, result = pcall(Language.chatMessage, ...)
	if success then
		return result
	else
		return false
	end
end

function getAllStrings(...)
	success, result = pcall(Language.getAllStrings, ...)
	if success then
		return result
	else
		return false
	end
end

-- Number format
local thousandSeparators = {
	english = ',',
	russian = ' ',
}

function numberFormat(value, sep)
	if sep == nil then
		if thousandSeparators[Language.get()] then
			sep = thousandSeparators[Language.get()]
		else
			sep = thousandSeparators.english
		end
	end
	local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
	return left .. (num:reverse():gsub('(%d%d%d)','%1' .. sep):reverse()) .. right
end
