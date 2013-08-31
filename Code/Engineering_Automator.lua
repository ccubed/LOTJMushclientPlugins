-- Engineering Automator 2.0
-- Engineering Script
-- Made by CCubed AKA Gizmo
-- Purpose: Simple automator for tasks. Allows you to continue to make an item after sux, sux fail or initial fail messages. 
-- Not meant for Armor or buildship. Will stop once it hits a no materials left message

-- Stack: Stores command groups in the format: {{"command",number}}
local Stack = {}
local Run = 0
local Times = 0
local Position = 1
local Loop = false

function AddCommand (thename, theoutput, wildcards) -- The Command to be Repeated

	-- Format: ecadd
	local tempcmd = utils.inputbox("Engineering Command to Automate?", "Command", "EX: makemedpac &cMed&Wpac&w", "Courier", 9)
	local temptimes = tonumber(utils.inputbox("How many times should we perform this command? (0 or 1 for just once)", "Repeat Times", "0", "Courier", 9))
	
	if (tempcmd ~= nil and temptimes ~= nil) and (string.find(tempcmd,"%a+") and string.find(temptimes,"%d+")) then
	
		if next(Stack) == nil then
			--empty table
			Stack[1]={tempcmd,temptimes}
		else
			--not empty
			Stack[table.getn(Stack)+1]={tempcmd,temptimes}
		end
		ColourNote("Orange","","Added command " .. tempcmd .. " to be repeated " .. temptimes .. " times.")
		
	else
	
		ColourNote("Orange","","Error in Previous Entry. Not Added.")
		
	end
	
end

function On (thename, theoutput, wildcards) -- Turn on the Automator
	
	if next(Stack) ~= nil then
		
		--Table has something in it, we can do stuff
		if Times == 0 then --If times is 0, make it 1. Otherwise, it should stay the same because we're continuing from a previous run
			Times = 1
		end
		Execute(Stack[Position][1])
		Run = 1
				
	else
		
		--Table is empty. Bad player
		ColourNote("Orange","","The command stack is empty. Use ecadd to add commands.")
	
	end

end

function Off (thename, theoutput, wildcards) -- Turn off the Automator

	Run = 0 --Pause the automator. No longer clears the stack in case you want to continue later.
	ColourNote("Orange","","Engineering Command Automator Paused.")

end -- will run to completetion of current item if used in the middle of making something

function Continue (thename, theoutput, wildcards, line) -- Continue on making stuffs
	
	if Run == 1 then

		if Stack[Position][2] > 1 then
		
			-- We're doing this a certain number of times. Check running times
			if Times < Stack[Position][2] then --We still have work to do
			
				Times = Times + 1
				Execute(Stack[Position][1])
				
			else
			
				--No more work
				Times = 1
				ColourNote("Orange","","Moving to next step.")
				if table.getn(Stack)>1 and Position<table.getn(Stack) then
					
					--We have a next command
					Position = Position + 1
					Times = 1
					Execute(Stack[Position][1])
					
				else
					
					--We don't
					if Loop then
					
						--Do we loop?
						Position = 1
						Times = 1
						Execute(Stack[Position][1])
						
					else
					
						Run = 0
						Stack = {}
						Position = 1
						ColourNote("Orange","","Engineering Automation Finished.")
						Loop = false
					
					end
				
				end
				
			end
			
		else
		
			-- The number part is either 0 or 1 which means we're only doing it once
			if table.getn(Stack)>1 and Position<table.getn(Stack) then
			
				-- We have a next command
				ColourNote("Orange","","Moving to next step.")
				Times = 1
				Position = Position + 1
				Execute(Stack[Position][1])
				
			else
			
				if Loop then
				
					Position = 1
					Times = 1
					Execute(Stack[Position][1])
					
				else
				
					Run = 0
					Stack = {}
					Position = 1
					Loop = false
					ColourNote("Orange","","Engineering Automation Finished.")
					
				end
					
			end
					
		end
		
	end

end -- end of continue

function looptoggle (thename, theoutput, wildcards)

	if Loop then
	
		Loop = false
		ColourNote("Orange","","Engineering Command Automator Looping Disabled.")
		
	else
	
		Loop = true
		ColourNote("Orange","","Engineering Command Automator Looping Enabled.")
		
	end
	
end

function clearstack (thename, theoutput, wildcards)

	Stack = {}
	Run = 0
	Times = 0
	Position = 1
	Loop = false
	ColourNote("Orange","","Stack Cleared.")
	
end

function showstack (thename, theoutput, wildcards)

	if next(Stack) ~= nil then

		ColourNote("Orange","","Engineering Command Automator Stack Queue\n")
		
		local i = 0
	
		for i = 1, table.getn(Stack), 1 do
	
			ColourNote("Orange","",Stack[i][1] .. " to be performed " .. Stack[i][2] .. " times.")
	
		end
	
		if Loop then
	
			ColourNote("Orange","","\nLooping is Enabled.")
		
		end
	
	else
	
		ColourNote("Orange","","No Current Stack.")
		
	end
	
end