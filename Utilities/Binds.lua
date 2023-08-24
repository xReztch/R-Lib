--!strict

local binds = {__binds = {}, __fireRequests = {}}

setmetatable(binds.__fireRequests, {
	__newindex = function(self, _bindName, params)
		if binds.__binds[_bindName] then
			binds.__binds[_bindName](unpack(params)) 
		end
	end,
})


function binds:Fire(identifier, ...)
	if binds.__binds[identifier] then
		binds.__fireRequests[identifier] = {...}
	end
end


function binds:Bind(bindTable)
	for _bindName, _function in bindTable do
		if typeof(_function) == "function" then
			if not binds.__binds[_bindName] then
				binds.__binds[_bindName] = _function
			else
				warn(`Already Have Bind Named "{_bindName}", Try Unbind.`)
			end
		else
			error(`{_function}'s Not A Function!`)
		end
	end
end


function binds:Unbind(_bindName)
	if binds.__binds[_bindName] then
		binds.__binds[_bindName] = nil
	else
		warn(`No bind named {_bindName}`)
	end
end

return binds