local SPAM_INTERVAL = 15
local SPAM_COLOR = "#406C7F"
local spamMessages = {
    "*Группа вк :  #FFFFFFvk.com/tunrc",
    "*Автодонат на сайте : #FFFFFFhttps://tunedracershop.trademc.org"
}
local currentMessage = 1

setTimer(function ()
    message(root, "global", SPAM_COLOR .. tostring(spamMessages[currentMessage]))
    currentMessage = currentMessage + 1
    if currentMessage > #spamMessages then
        currentMessage = 1
    end
end, SPAM_INTERVAL * 1000 * 60, 0)