meihan = createColCuboid ( 2700, 300, 7150, 250, 400, 200 )

function dimensionChecker (theElement, matchingDimension)
setTimer(function ()
    if ( theElement == localPlayer ) then -- Checks whether the entering element is in the same dimension as the collision shape.
        txd = engineLoadTXD ( "meihan.txd" )

engineImportTXD ( txd, 1700)
engineImportTXD ( txd, 1701	)

dff = engineLoadDFF("meihan1.dff",0)
dff1 = engineLoadDFF("meihan2.dff",0)

engineReplaceModel ( dff, 1700)
engineReplaceModel ( dff1,1701)

col = engineLoadCOL("meihan1.col",0)
col1 = engineLoadCOL("meihan2.col",0)

engineReplaceCOL ( col, 1700)
engineReplaceCOL ( col1,1701)

engineSetModelLODDistance(1700,3000)
engineSetModelLODDistance(1701,3000)
		end
	end, 450, 1)
end
addEventHandler ("onClientColShapeHit", meihan, dimensionChecker)

function onClientColShapeLeave( theElement, matchingDimension )
    if ( theElement == localPlayer ) then  -- Checks whether the leaving element is the local player
engineRestoreModel (1700)
engineRestoreModel (1701)
		
engineRestoreCOL (1700)
engineRestoreCOL (1701)
    end
end
addEventHandler("onClientColShapeLeave", meihan, onClientColShapeLeave)	