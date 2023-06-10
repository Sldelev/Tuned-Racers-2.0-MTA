-- this function is called whenever someone types 'createmarker' in the console:
function consoleCreateMarker ( thePlayer, commandName )
	if ( thePlayer ) then
	local x, y, z = getElementPosition ( thePlayer ) -- get the player's position
	local rx, ry, rz = getElementRotation ( thePlayer )
		outputConsole('<checkpoint id="checkpoint () (*)" type="checkpoint" color="#00F9" size="2.25" nextid="checkpoint () (*)" ' .. 'posX="'.. x .. '"' .. ' posY="' .. y .. '"' .. ' posZ="' .. z .. '"' .. ' rotX="' .. rx .. '"' .. ' rotY="' .. ry .. '"' .. ' rotZ="' .. rz .. '"' .. ' ></checkpoint>')
	end
end
addCommandHandler ( "createcoords", consoleCreateMarker )

function consoleCreateMarkerVeh ( thePlayer, commandName )
	if ( thePlayer ) then
	local x, y, z = getElementPosition ( thePlayer ) -- get the player's position
	local rx, ry, rz = getElementRotation ( thePlayer )
		outputConsole('<spawnpoint id="spawnpoint (Infernus) (*)" vehicle="411" '..'posX="'.. x .. '"' .. ' posY="' .. y .. '"' .. ' posZ="' .. z .. '"' .. ' rotX="' .. rx .. '"' .. ' rotY="' .. ry .. '"' .. ' rotZ="' .. rz .. '"' .. ' ></spawnpoint>' )
	end
end
addCommandHandler ( "createcoordsveh", consoleCreateMarkerVeh )