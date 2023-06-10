-----------------------------------------------------------
local snowTextures = {
{"img/flame.png", "sphere"},
--{"img/flame.png", "coronastar"},
--{"img/flame.png", "coronaheadlightline"}
}
-----------------------------------------------------------
local CONFIG_PROPERTY_NAME = "graphics.flame"

local isActive = false
local isBeingDestroyed = false
local snowElements = {}

Async:setPriority(50, 30)

function enableflame()
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
addEventHandler("onClientResourceStart", resourceRoot, enableSnow)

function disableflame()
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

addEventHandler("onClientResourceStart", resourceRoot, function()
    if exports.tunrc_Config:getProperty(CONFIG_PROPERTY_NAME) then
        enableflame()
    else
        disableflame()
    end
end)

addEvent("tunrc_Config.update", false)
addEventHandler("tunrc_Config.update", root, function (key, value)
   if key == CONFIG_PROPERTY_NAME then
        if value then
            enableflame()
        else
            disableflame()
        end
    end
end)