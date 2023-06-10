Drift = RaceGamemode:subclass "Drift"

function Drift:init(...)
    self.super:init(...)
    self.ghostmodeEnabled = true
end

function Drift:raceStarted(...)
    self.super:raceStarted(...)
    
    DriftPoints.start()
end

function Drift:raceStopped()
	setTimer(function()
		DriftPoints.stop()
	end, 100, 1)
end

function Drift:clientFinished()
    exports.tunrc_DriftPoints:finishCurrentDrift()
    FinishScreen.show(true)
    toggleAllControls(false)
    triggerServerEvent("Race.clientFinished", RaceClient.raceElement)
end

function Drift:raceFinished(...)
    self.super:raceFinished(...)
    exports.tunrc_DriftPoints:finishCurrentDrift()
end

function Drift:updatePosition()
    local players = RaceClient.getPlayers()
    if type(players) ~= "table" then
        return false
    end
    local myScore = localPlayer:getData("raceDriftScore")
    if not myScore then
        return false
    end
    local rank = 1
    for i, player in ipairs(players) do
        if isElement(player) and player ~= localPlayer then
            local playerScore = player:getData("raceDriftScore")
            if playerScore and playerScore > myScore then
                rank = rank + 1
            end
        end
    end

    self.rank = rank
end