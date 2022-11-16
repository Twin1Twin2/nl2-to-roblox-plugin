
local S = "\t"	-- csv separator
local F = "%.6f" -- float value
local LINE_FORMAT = "\n"	-- new line
	.. "%d" .. S	-- index
	.. F .. S		-- X
	.. F .. S		-- Y
	.. F .. S		-- Z
	.. F .. S		-- frontX
	.. F .. S		-- frontY
	.. F .. S		-- frontZ
	.. F .. S		-- leftX
	.. F .. S		-- leftY
	.. F .. S		-- leftZ
	.. F .. S		-- upX
	.. F .. S		-- upY
	.. F			-- upZ

return function(points: table, scale: number)
	assert(type(points) == "table",
		"Arg [1] is not an table!")
	assert(type(scale) == "number" and scale > 0,
		"Arg [2] is not a number > 0")

	local function cframeToNL2CSVLine(index: number, cframe: CFrame)
		local x, y, z, riX, upX, baX, riY, upY, baY, riZ, upZ, baZ = cframe:GetComponents()

		x = x * scale
		y = y * scale
		z = z * scale

		return string.format(
			LINE_FORMAT,
			index,
			x,
			y,
			z,
			-baX,
			-baY,
			-baZ,
			-riX,
			-riY,
			-riZ,
			upX,
			upY,
			upZ
		)
	end

	local numPoints = #points
	local index = 1
	local moduleIndex = 1
	local hasFinished = false
	local MAX_POINTS_PER_MODULE = 500

	local exportFolder = Instance.new("Folder")

	repeat
		local moduleName = tostring(moduleIndex)

		local exportFile = Instance.new("ModuleScript")
		exportFile.Name = moduleName
		exportFile.Parent = exportFolder

		local moduleData = ""

		if moduleIndex == 1 then
			moduleData = [["No."	"PosX"	"PosY"	"PosZ"	"FrontX"	"FrontY"	"FrontZ"	"LeftX"	"LeftY"	"LeftZ"	"UpX"	"UpY"	"UpZ"]]
		end

		for _ = 1, MAX_POINTS_PER_MODULE, 1 do
			local cframe = points[index]

			moduleData = moduleData .. cframeToNL2CSVLine(index, cframe)

			index = index + 1

			if index > numPoints then
				hasFinished = true
				break
			end
		end

		exportFile.Source = moduleData

		moduleIndex = moduleIndex + 1
	until hasFinished == true

	return exportFolder
end
