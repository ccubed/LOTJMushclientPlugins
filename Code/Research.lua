-- LOTJ SCRIPTS
-- By Gizmo (AKA CCubed on LOTJ)

--
--	RESEARCH SECTION - Supports Research Queues
--	See ResearchHelp
--
local ResearchList = {}

function SetResearch (name, output, wildcards)
	if next(ResearchList) == nil then
		ResearchList[1] = wildcards[1]
		Send("research " .. ResearchList[1])
	else
		ResearchList[table.getn(ResearchList)+1] = wildcards[1]
	end
	ColourNote("orange","","Added " .. wildcards[1] .. " to the Research Queue.")	
end

function ResumeResearch (name, output, wildcards, line)
	if next(ResearchList) ~= nil then
		Send("research "..ResearchList[1])
	end
end

function AlertResearchMax (name, output, wildcards, line)
	if table.getn(ResearchList) > 1 then
		-- More than one item in list
		ColourNote("orange","",ResearchList[1].." researched to max.")
		table.remove(ResearchList,1)
		ColourNote("orange","","Beginning Research on " .. ResearchList[1])
		Send("research " .. ResearchList[1])
	else
		-- Only one item in list
		table.remove(ResearchList,1)
		ColourNote("orange","","No more research topics in list.")
	end	
end

function StopResearch (name, output, wildcards)
	ResearchList = {}
	Send("get random thing that can't exist")
end

function RQueue (name, output, wildcards)
	if next(ResearchList) ~= nil then --something is in the table?
		ColourNote("orange", "", "Currently Researching: " .. ResearchList[1])
		if table.getn(ResearchList) > 1 then --do we have a queue?
			ColourNote("orange", "", "Current Research Queue:")
			for i=2,table.getn(ResearchList),1 do
				ColourNote("orange", "", ResearchList[i])
			end
		end 
	else
		ColourNote("orange", "", "No Research Queue.")
	end
end

function ResearchHelp (name, output, wildcards)
	ColourNote("orange", "", "CCubed's Research Script Help")
	ColourNote("orange", "", "sr <topic> - Adds a Research Topic to your current Queue or Starts Researching Something")
	ColourNote("orange", "", "rstop - Stops all Research and deletes queue")
	ColourNote("orange", "", "rqueue - Show Research Queue")
	ColourNote("orange", "", "rhelp - Show this text")
end