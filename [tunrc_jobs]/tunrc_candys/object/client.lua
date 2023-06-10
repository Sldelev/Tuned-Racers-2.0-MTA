addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object/object.txd',true)
engineImportTXD(txd, 1248)
local dff = engineLoadDFF('object/object.dff', 0)
engineReplaceModel(dff, 1248)
engineSetModelLODDistance(1248, 500)
end)