Drag = RaceGamemode:subclass "Drag"

function Drag:init(...)
	self.super:init(...)
end

function Drag:raceFinished(timeout)
    if timeout then
        for _, player in ipairs(self.race:getPlayers()) do
            self:playerFinished(player, timeout)
        end
    end
end

function Drag:playerFinished(player, timeout)
    if not self.super:playerFinished(player, timeout) then
        return false
    end

    local rank = #self:getFinishedPlayers()
    local timePassed = self:getTimePassed()
    if timeout then
        rank = false
        timePassed = self.race.settings.duration * 1000
    end
    triggerEvent("RaceLobby.playerFinished", self.race.element, player, timePassed, rank)
end