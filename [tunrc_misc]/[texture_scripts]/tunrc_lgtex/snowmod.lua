-----------------------------------------------------------
local snowTextures = {
{"img/null.png", "splash_up"},
{"img/null.png", "splash_up1"},
{"img/null.png", "splash_up2"},
{"img/lght.png", "coronaheadlightline"},
{"img/coronastar.png", "coronastar"}
}
-----------------------------------------------------------
local isActive = false
local isBeingDestroyed = false
local snowElements = {}

Async:setPriority(50, 30)

function enablelgt()
    if isActive or isBeingDestroyed then
        return false
    end
    isActive = true

    Async.instance.threads = {}
    Async:iterate(1, #snowTextures, function(i)
        local shader = dxCreateShader("snowmod.fx")
        engineApplyShaderToWorldTexture(shader, snowTextures[i][2])
        table.insert(snowElements, shader)
        local texture = dxCreateTexture(snowTextures[i][1])
        dxSetShaderValue(shader, "gTexture", texture)     
        table.insert(snowElements, texture)   
        setFogDistance(100)		
    end)
end
addEventHandler("onClientResourceStart", resourceRoot, enablelgt)

function disablelgt()
    if not isActive or isBeingDestroyed then
        return false
    end

    isBeingDestroyed = true
    isActive = false
    Async.instance.threads = {}
    Async:foreach(snowElements, function (element)
        if isElement(element) then
            destroyElement(element)
        end    
    end,
    function ()
        isBeingDestroyed = false
        snowElements = {}
    end)
end
addEventHandler("onClientResourceStop", resourceRoot, disablelgt)