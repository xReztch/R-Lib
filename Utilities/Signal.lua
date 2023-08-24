local binds = require(script.Parent.Binds);

local httpService = game:GetService("HttpService");
local insert = table.insert;


local signal = {__connections = {}, __fireRequests = {}};
signal.__index = signal;


setmetatable(signal.__fireRequests, {
	__newindex = function(self, identifier, params)
		if signal.__connections[identifier] then
			binds:Fire(identifier, params);
		end;
	end;
});


function signal.new()
	local generatedId = httpService:GenerateGUID(false);
	
	local self = setmetatable({}, signal);
	self.id = generatedId;
	
	
	return self;
end;


function signal:Fire(...: any?)
	if #{...} > 0 then
		signal.__fireRequests[self.id] = {...};
	else
		warn("Signal:Fire(params) Parameters Is Empty!");
	end;
end;


function signal:Connect(func)
	if typeof(func) == "function" then
		signal.__connections[self.id] = self.id;
		return binds:Bind({
			[self.id] = function(params)
				func(params);
			end;
		});
	else
		warn(":Connect() Parameter It's Not An Function! (or empty)");
	end;
end;



function signal:Wait()
	if not signal.__connections[self.id] then
		signal.__connections[self.id] = self.id;
		
		local finish = false
		local params = nil
		
		binds:Bind({
			[self.id] = function(args)
				binds:Unbind(self.id);
				signal.__connections[self.id] = nil;
				
				finish = true
				
				
				params = args
			end;
		});
		
		local conn
		conn = game:GetService("RunService").Stepped:Connect(function()
			if finish and params then
				conn:Disconnect()
				return params;
			end
		end);
	else
		warn("U Trying :Wait Method But Signal Already In Connections.")
	end
end;


function signal:Disconnect()
	if self["id"] and signal.__connections[self.id] then
		binds:Unbind(self.id)
		signal.__connections[self.id] = nil;
	end;
end;

return signal;