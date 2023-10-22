local ID = 914 -- Айди объекта на который заменяется клуб
function GarageModel()
		local txd = engineLoadTXD ( 'Garage_alt.txd' ) -- txd файл
        engineImportTXD ( txd, ID ) -- заменяем текстуру
 
        local dff = engineLoadDFF ( 'Garage_alt.dff', 0 ) -- dff файл
        engineReplaceModel ( dff, ID ) -- заменяем модель
 
        local col = engineLoadCOL ( 'Garage_alt.col' ) -- col файл
        engineReplaceCOL ( col, ID ) -- заменяем коллизию модели
		engineSetModelLODDistance(ID , 3000)

		local model = createObject(ID, 1586, 2252.5, 3698, 0, 0, 160)
		setElementDimension (model, -1)
end
addEventHandler ( 'onClientResourceStart', resourceRoot, GarageModel)