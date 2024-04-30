local wheelsID = {
	1025,
	1073,
	1074,
	1075,
	1076,
	1077
}

local calipersID = {
	1028,
	1029
}

local tiresID = {
	1057,
	1058
}

function WheelStart()
	local wheeltxd = engineLoadTXD("wheels.txd")
	engineImportTXD(wheeltxd, unpack(wheelsID))
	engineImportTXD(wheeltxd, unpack(calipersID))
	engineImportTXD(wheeltxd, unpack(tiresID))

exports['Crypt-reload']:load(
	{
		--{ файл, режим, параметры, ... };
		{ 'caliper.dff', 'dff', 1028 };
		{ 'caliper2.dff', 'dff', 1029 };
		
		{ 'advrcngt.dff', 'dff', 1025 };
		{ 'advrrciii.dff', 'dff', 1073 };
		{ 'advrcrgii.dff', 'dff', 1074 };
		{ 'zerinrgiii.dff', 'dff', 1075 };
		{ 'zerrgd.dff', 'dff', 1076 };
		{ 'bnkm1r.dff', 'dff', 1077 };
		
		{ 'tire1.dff', 'dff', 1057 };
		{ 'tire2.dff', 'dff', 1058 };
	}
)
end
addEventHandler( "onClientResourceStart", resourceRoot, WheelStart)