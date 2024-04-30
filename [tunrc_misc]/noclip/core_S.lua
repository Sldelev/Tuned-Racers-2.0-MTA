--// noclip by chris1384 (server-side)

--// prepare our acl groups, add another one if you want (keep in mind that only logged in players are detected!)
local aclGroups = 	{
						"Console", -- added cause players tend to add themselves into the Console group
						"Admin", 
						"SuperModerator", 
						"Moderator",
						--"Everyone" -- to enable it for everyone, just remove the first `--` 
					}
				
--// should the noclip command be available for unregistered players? (if set to true, the acl check will not be performed anymore!)
local allowGuests = false -- true or false

addCommandHandler("noclip", function(player) -- initializing the noclip command

	if player and isElement(player) and getElementType(player) == "player" then -- overkill condition, prevents triggering command from console
	
		if allowGuests == false then -- first check the allowGuests variable
		
			--// this method will always work if you update the acl
			
			local grant = false -- start our local grant variable as false (do not mess with this please)
			local account = getPlayerAccount(player) -- get player account
			
			if not isGuestAccount(account) then -- check if player is logged in
			
				local account_name = getAccountName(account) -- get his account's name
			
				for index, group in ipairs(aclGroups) do -- loop through our aclGroups table
				
					if isObjectInACLGroup("user."..account_name, aclGetGroup(group)) then -- check if the account name of the player is present in the Acl Group
					
						grant = true -- we won
						break -- no need for looping anymore since it got found
					
					end
					
				end
				
				-- after the loop, we will verify the state of the 'grant' variable
				
				if grant then -- if it changed to true
				
					triggerClientEvent(player, "command:noclip", player) -- trigger noclip
				
				else
				
					-- since the account was not found in the acl, there's nothing we can do to our player, except displaying a message
					
					outputChatBox("noclip: command not available") -- optional
				
				end
				
			else -- otherwise.. (if they're not logged in)
			
				outputChatBox("noclip: command available for registered only") -- optional, let the player know that they're dumb and not logged in
				
			end
				
		elseif allowGuests == true then -- if it does allow guests, we just skip the mess above and trigger the noclip as usual
		
			triggerClientEvent(player, "command:noclip", player) -- trigger noclip
		
		end -- anything beyond this point will not be triggered, since true and false are the only allowed values for allowGuests
	
	end

end)

