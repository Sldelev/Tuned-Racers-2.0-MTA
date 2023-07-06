Config ={}

Config.MIN_SUSPENSION_DEFAULT = 0.001
Config.MAX_SUSPENSION_DEFAULT = 0.35

Config.MIN_STEER_DEFAULT = 35
Config.MAX_STEER_DEFAULT = 75

function GetMaxSuspensionValue()
	return Config.MAX_SUSPENSION_DEFAULT
end

function GetMinSuspensionValue()
	return Config.MIN_SUSPENSION_DEFAULT
end

function GetMaxSteerValue()
	return Config.MAX_STEER_DEFAULT
end

function GetMinSteerValue()
	return Config.MIN_STEER_DEFAULT
end