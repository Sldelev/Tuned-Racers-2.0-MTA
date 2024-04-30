bihoku = createColCuboid ( -4886, -3412, 2100, 300, 400, 200.0 )

MapsFiles = {
	{ obj1, "bihoku1", 1700, -4739.7998, -3162.2002, 2126.3}, --формат данных в таблице {любое название для создания объекта, название дфф+кол файла, айди на который заменяется дфф+кол, координаты в формате xyz}
    { obj2, "bihoku2", 1701, -4740.7998, -3299, 2126.3},
    { obj3, "bihoku3", 1702, -4761.2002, -3202.8999, 2120},
}

function dimensionChecker (theElement, matchingDimension)
	setTimer(function ()
		if ( theElement == localPlayer ) then
			txd = engineLoadTXD ( "bihoku.txd" )
			
			for i, mapinfo in pairs(MapsFiles) do
				engineImportTXD ( txd, mapinfo[3])
				engineReplaceModel ( engineLoadDFF(mapinfo[2] .. ".dff",0), mapinfo[3])
				engineReplaceCOL ( engineLoadCOL(mapinfo[2] .. ".col",0), mapinfo[3])
				engineSetModelLODDistance(mapinfo[3],3000)
				mapinfo[1] = createObject(mapinfo[3], mapinfo[4], mapinfo[5], mapinfo[6], 0, 0, 0)
				setElementDimension (mapinfo[1], -1)
			end
		end
	end, 450, 1)
end
addEventHandler ("onClientColShapeHit", bihoku, dimensionChecker)

function onClientColShapeLeave( theElement, matchingDimension )
    if ( theElement == localPlayer ) then
		for i, mapinfo in pairs(MapsFiles) do
			engineRestoreModel (mapinfo[3])			
			engineRestoreCOL (mapinfo[3])
			destroyElement(mapinfo[1])
		end
    end
end
addEventHandler("onClientColShapeLeave", bihoku, onClientColShapeLeave)	