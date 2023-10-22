bihoku = createColCuboid ( -4886, -3412, 2100, 300, 400, 200.0 )

function dimensionChecker (theElement, matchingDimension)
setTimer(function ()
    if ( theElement == localPlayer ) then -- Checks whether the entering element is in the same dimension as the collision shape.
        txd = engineLoadTXD ( "bihoku.txd" )

engineImportTXD ( txd, 1700)
engineImportTXD ( txd, 1701	)
engineImportTXD ( txd, 1702	)

dff = engineLoadDFF("bihoku1.dff",0)
dff1 = engineLoadDFF("bihoku2.dff",0)
dff2 = engineLoadDFF("bihokutree.dff",0)

engineReplaceModel ( dff, 1700)
engineReplaceModel ( dff1,1701)
engineReplaceModel ( dff2,1702)

col = engineLoadCOL("bihoku1.col",0)
col1 = engineLoadCOL("bihoku2.col",0)
col2 = engineLoadCOL("bihokutree.col",0)

engineReplaceCOL ( col, 1700)
engineReplaceCOL ( col1,1701)
engineReplaceCOL ( col2,1702)

engineSetModelLODDistance(1700,3000)
engineSetModelLODDistance(1701,3000)
engineSetModelLODDistance(1702,3000)
		end
	end, 450, 1)
end
addEventHandler ("onClientColShapeHit", bihoku, dimensionChecker)

function onClientColShapeLeave( theElement, matchingDimension )
    if ( theElement == localPlayer ) then  -- Checks whether the leaving element is the local player
engineRestoreModel (1700)
engineRestoreModel (1701)
engineRestoreModel (1702)
		
engineRestoreCOL (1700)
engineRestoreCOL (1701)
engineRestoreCOL (1702)

    end
end
addEventHandler("onClientColShapeLeave", bihoku, onClientColShapeLeave)	