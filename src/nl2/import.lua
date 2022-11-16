
local modules = script.Parent.Parent.modules
local Result = require(modules.Result)

return function(csvString: string)
	if typeof(csvString) ~= "string" then
		return Result.err("Arg [1] is not a string!")
	end

	local function getCFrameFromLine(line: string)
		local no, posX, posY, posZ, frX, frY, frZ, leX, leY, leZ, upX, upY, upZ
			= string.match(line, "(%d+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)\t([%d.-]+)")
		if no == nil then
			return Result.err("Unable to load line!")
		end

		no = tonumber(no)

		posX = tonumber(posX)
		posY = tonumber(posY)
		posZ = tonumber(posZ)

		frX = tonumber(frX)
		frY = tonumber(frY)
		frZ = tonumber(frZ)

		leX = tonumber(leX)
		leY = tonumber(leY)
		leZ = tonumber(leZ)

		upX = tonumber(upX)
		upY = tonumber(upY)
		upZ = tonumber(upZ)

		local cframe = CFrame.new(
			posX, posY, posZ,	--pos
			-leX, upX, -frX,
			-leY, upY, -frY,
			-leZ, upZ, -frZ
		)

		return Result.ok({
			index = no,
			cframe = cframe,
		})
	end

	local points = {}
	local lineIndex = 0
	local hasErrored = false

	for line in string.gmatch(csvString, "[^\r\n]+") do
		lineIndex += 1

		if lineIndex == 1 then -- skip line one
			continue
		end

		local getCFrameData = getCFrameFromLine(line)
		if getCFrameData:isErr() then
			hasErrored = true
			warn(("Unable to convert line %d!"):format(lineIndex))
		else
			local cframeData = getCFrameData:unwrap()
			points[cframeData.index] = cframeData.cframe
		end
	end

	if hasErrored then
		return Result.err("Could not import")
	end

	return Result.ok(points)
end