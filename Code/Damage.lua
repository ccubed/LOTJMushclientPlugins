-- lotj damage plugin

local Tracker = {}
local energy = 0
local energymax = 0
local energystate = 0

function addDamage (thename, theoutput, wildcards, line)

	if next(Tracker) == nil then
		--empty table
		Tracker[1] = wildcards[1]
	else
		--not empty
		Tracker[table.getn(Tracker)+1]=wildcards[1]
	end

end

function DamStat (thename, theoutput, wildcards)

	if energystate ~= 2 then
		Send("eq")
		os.execute("sleep 2")
		Execute("damstat")
		
	else 
	
		local avg = 0
		local total = 0
		local low = Tracker[1]
		local high = Tracker[1]
	
		for i = 1, table.getn(Tracker), 1 do
		
			total = total + tonumber(Tracker[i])
			if Tracker[i] > high then
				high = Tracker[i]
			end
			if Tracker[i] < low then
				low = Tracker[i]
			end
		
		end
		
		avg = total / table.getn(Tracker)
	
		ColourNote("Orange","","Calculated Battle Stats.")
		ColourNote("Orange","","------------------------")
		ColourNote("Orange","","High: "..high)
		ColourNote("Orange","","Low: "..low)
		ColourNote("Orange","","Total Damage: "..total)
		ColourNote("Orange","","Average Damage: "..avg)
		ColourNote("Orange","","Energy Max: "..energymax)
		ColourNote("Orange","","Energy Now: "..energy)
		ColourNote("Orange","","Difference: "..energymax - energy)
		ColourNote("Orange","","Series:")
		for i = 1, table.getn(Tracker), 1 do
		
			ColourNote("Orange","",i..") "..Tracker[i])
		
		end
		
	end

end

function Energy (thename, theoutput, wildcards, line)

	if energystate == 0 then
		--getting base
		energymax = wildcards[3]
		energystate = 1
	elseif energystate == 1 then
		--getting end
		energy	= wildcards[3]
		energystate = 2
	end

end

function Reset (thename, theoutput, wildcards)

	energystate = 0
	energy = 0
	energymax = 0
	Tracker = {}

end