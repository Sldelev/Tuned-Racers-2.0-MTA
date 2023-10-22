primring = createColCuboid ( 2430, -310, 7300, 600, 250, 200.0 )

function dimensionChecker (theElement, matchingDimension)
setTimer(function ()
    if ( theElement == localPlayer ) then -- Checks whether the entering element is in the same dimension as the collision shape.
        txd = engineLoadTXD ( "primring.txd" )

engineImportTXD ( txd, 1700)
engineImportTXD ( txd, 1701	)
engineImportTXD ( txd, 1702	)
engineImportTXD ( txd, 1703	)

dff = engineLoadDFF("prim1.dff",0)
dff1 = engineLoadDFF("prim2.dff",0)
dff2 = engineLoadDFF("prim3.dff",0)
dff3 = engineLoadDFF("prim4.dff",0)

engineReplaceModel ( dff, 1700)
engineReplaceModel ( dff1,1701)
engineReplaceModel ( dff2,1702)
engineReplaceModel ( dff3,1703)

col = engineLoadCOL("prim1.col",0)
col1 = engineLoadCOL("prim2.col",0)
col2 = engineLoadCOL("prim3.col",0)
col3 = engineLoadCOL("prim4.col",0)

engineReplaceCOL ( col, 1700)
engineReplaceCOL ( col1,1701)
engineReplaceCOL ( col2,1702)
engineReplaceCOL ( col3,1703)

engineSetModelLODDistance(1700,3000)
engineSetModelLODDistance(1701,3000)
engineSetModelLODDistance(1702,3000)
engineSetModelLODDistance(1703,3000)
		end
	end, 450, 1)
end
addEventHandler ("onClientColShapeHit", primring, dimensionChecker)

function onClientColShapeLeave( theElement, matchingDimension )
    if ( theElement == localPlayer ) then  -- Checks whether the leaving element is the local player
engineRestoreModel (1700)
engineRestoreModel (1701)
engineRestoreModel (1702)
engineRestoreModel (1703)
		
engineRestoreCOL (1700)
engineRestoreCOL (1701)
engineRestoreCOL (1702)
engineRestoreCOL (1703)
    end
end
addEventHandler("onClientColShapeLeave", primring, onClientColShapeLeave)	