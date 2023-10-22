function map()
	txd = engineLoadTXD ( "1.txd" )
		engineImportTXD ( txd, 1764)
		engineImportTXD ( txd, 1763)
		engineImportTXD ( txd, 1762)
		engineImportTXD ( txd, 1761)
		engineImportTXD ( txd, 1760)
		engineImportTXD ( txd, 1759)
		engineImportTXD ( txd, 1758)
		engineImportTXD ( txd, 1757)
		engineImportTXD ( txd, 1756)
      	engineImportTXD ( txd, 1755)
      	engineImportTXD ( txd, 1754)		
			

 		
		
		
		
		
		
	col = engineLoadCOL ( "1.col" )
	col1 = engineLoadCOL ( "2.col" )
	col2 = engineLoadCOL ( "3.col" )
	col3 = engineLoadCOL ( "4.col" )
	col4 = engineLoadCOL ( "5.col" )
	col5 = engineLoadCOL ( "6.col" )
	col6 = engineLoadCOL ( "7.col" )
	col7 = engineLoadCOL ( "8.col" )
	col8 = engineLoadCOL ( "9.col" )
    col9 = engineLoadCOL ( "10.col" )
    col10 = engineLoadCOL ( "11.col" )	

	

	dff = engineLoadDFF ( "1.dff", 0 )
	dff1 = engineLoadDFF ( "2.dff", 0 )
	dff2 = engineLoadDFF ( "3.dff", 0 )
	dff3 = engineLoadDFF ( "4.dff", 0 )
	dff4 = engineLoadDFF ( "5.dff", 0 )
	dff5 = engineLoadDFF ( "6.dff", 0 )
	dff6 = engineLoadDFF ( "7.dff", 0 )
	dff7 = engineLoadDFF ( "8.dff", 0 )
  	dff8 = engineLoadDFF ( "9.dff", 0 )
	dff9 = engineLoadDFF ( "10.dff", 0)
	dff10 = engineLoadDFF ( "11.dff", 0)	
	
	



	
	engineReplaceCOL ( col, 1764)
	engineReplaceCOL ( col1, 1763)
	engineReplaceCOL ( col2, 1762)
	engineReplaceCOL ( col3, 1761)
	engineReplaceCOL ( col4, 1760)
	engineReplaceCOL ( col5, 1759)
	engineReplaceCOL ( col6, 1758)
	engineReplaceCOL ( col7, 1757)
	engineReplaceCOL ( col8, 1756)
   	engineReplaceCOL ( col9, 1755)
	engineReplaceCOL ( col10, 1754)


	

	
	

	
	
	engineReplaceModel ( dff, 1764)
	engineReplaceModel ( dff1, 1763)
	engineReplaceModel ( dff2, 1762)
	engineReplaceModel ( dff3, 1761)
	engineReplaceModel ( dff4, 1760)
	engineReplaceModel ( dff5, 1759)
	engineReplaceModel ( dff6, 1758)
	engineReplaceModel ( dff7, 1757)
	engineReplaceModel ( dff8, 1756)
   	engineReplaceModel ( dff9, 1755)
	engineReplaceModel ( dff10, 1754)



	


	
	engineSetModelLODDistance(1764, 2000)
	engineSetModelLODDistance(1763, 2000)
	engineSetModelLODDistance(1762, 2000)
	engineSetModelLODDistance(1761, 2000)
	engineSetModelLODDistance(1760, 2000)
	engineSetModelLODDistance(1759, 2000)
	engineSetModelLODDistance(1758, 2000)
	engineSetModelLODDistance(1757, 2000)
	engineSetModelLODDistance(1756, 2000)
	engineSetModelLODDistance(1755, 2000)
	engineSetModelLODDistance(1754, 2000)	

	
	

	
end

setTimer ( map, 1000, 1)
addCommandHandler("reloadmap",map)

local objects = getElementsByType ( "object", resourceRoot ) 
for theKey,object in ipairs(objects) do 
	local id = getElementModel(object)
	local x,y,z = getElementPosition(object)
	local rx,ry,rz = getElementRotation(object)
	local scale = getObjectScale(object)
	objLowLOD = createObject ( id, x,y,z,rx,ry,rz,true )
	setObjectScale(objLowLOD, scale)
	setLowLODElement ( object, objLowLOD )
	engineSetModelLODDistance ( id, 3000 )
	setElementStreamable ( object , false)
end

