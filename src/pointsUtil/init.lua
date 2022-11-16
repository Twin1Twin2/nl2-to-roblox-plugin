
local root = script.Parent

local modules = root.modules
local Result = require(modules.Result)

local getCFrameFromInstance = require(script.getCFrameFromInstance)
local getVector3FromInstance = require(script.getVector3FromInstance)

--- Utility for points
--- @class PointsUtil

--- @interface PointInstancesResult
--- @within PointsUtil
--- .startIndex number
--- .endIndex number
--- .duplicatePoints {number}
--- .invalidIndexes {number}
--- .missingPoints {number}

type PointInstancesResult = {
	startIndex: number,
	endIndex: number,

	duplicatePoints: {number},
	invalidIndexes: {string},

	missingPoints: {number},
}

local function serializePointInstancesResult(result: PointInstancesResult)
	return ("startIndex: %i; endIndex: %i; duplicatePoints: %i; invalidIndexes: %i; missingPoints: %i"):format(result.startIndex, result.endIndex, #result.duplicatePoints, #result.invalidIndexes, #result.missingPoints)
end

--- Converts an Instance's children into an array of Instances
--- Instances must be named in order starting from either 0 or 1
--- @function getPointInstances
--- @within PointsUtil
--- @param instance Instance
--- @return Result<{Instance}, PointInstancesResult>
local function getPointInstances(instance: Instance, startsAtZero: boolean?)
	local numPoints = #instance:GetChildren()

	if numPoints == 0 then
		return Result.ok({})
	end

	startsAtZero = instance:FindFirstChild("0") ~= nil

	local startIndex = startsAtZero == true and 0 or 1
	local endIndex = startsAtZero == true and numPoints - 1 or numPoints

	local pointInstanceMap = {} -- new Map<number, Instance>()

	local duplicatePoints = {} -- as number[]
	local invalidIndexes = {} -- as string[]

	for _, child in ipairs(instance:GetChildren()) do
		local index = tonumber(child.Name)
		if index == nil then
			table.insert(invalidIndexes, child.Name)
			break
		end

		-- check if int, not float
		if math.floor(index) ~= index then
			table.insert(invalidIndexes, child.Name)
			break
		end

		local otherPoint = pointInstanceMap[index]
		if otherPoint ~= nil then
			table.insert(duplicatePoints, index)
			break
		end

		if index < startIndex or index > endIndex then
			table.insert(invalidIndexes, child.Name)
		end

		pointInstanceMap[index] = child
	end

	local pointInstances = {} -- as Instance[]
	local missingPoints = {} -- as number[]

	-- look for missing points
	for index = startIndex, numPoints, 1 do
		local pointInstance = pointInstanceMap[index]

		if pointInstance == nil then
			table.insert(missingPoints, index)
		else
			pointInstances[index - startIndex + 1] = pointInstance
		end
	end

	if #duplicatePoints > 0 or #invalidIndexes > 0 or #missingPoints > 0 then
		return Result.err({
			startIndex = startIndex,
			endIndex = endIndex,

			duplicatePoints = duplicatePoints,
			invalidIndexes = invalidIndexes,

			missingPoints = missingPoints,
		})
	end

	return Result.ok(pointInstances)
end

--- @interface PointIndexError
--- @within PointsUtil
--- .name string
--- .error string

type PointIndexError = {
	name: string,
	error: string,
}

local function serializePointIndexError(result: PointIndexError)
	return ("%s %s"):format(result.name, result.error)
end

local function serializeGetPointsResult(indexErrors: {PointIndexError})
	local s = ""

	for _, indexError in ipairs(indexErrors) do
		s = s .. ("\n%s"):format(serializePointIndexError(indexError))
	end

	return s
end

--- Converts a array of Instances into an array of T
--- @function getPoints
--- @within PointsUtil
--- @param pointInstances {Instance}
--- @param getData (instance: Instance) -> T
--- @return Result<{T}, {PointIndexError}>
local function getPoints<T>(pointInstances: {Instance}, getData: (instance: Instance) -> Result.Result)
	local points: {T} = {}
	local invalidPoints: {PointIndexError} = {}

	for _, pointInstance in ipairs(pointInstances) do
		local getDataResult = getData(pointInstance)

		if getDataResult:isErr() then
			table.insert(invalidPoints, {
				name = pointInstance.Name,
				error = getDataResult:unwrapErr(),
			})
		else
			table.insert(points, getDataResult:unwrap())
		end
	end

	if #invalidPoints > 0 then
		return Result.err(invalidPoints)
	end

	return Result.ok(points)
end

--- Converts a array of Instances into an array of Vector3s
--- @function getVector3Points
--- @within PointsUtil
--- @param pointInstances {Instance}
--- @return Result<{Vector3}, {PointIndexError}>
local function getVector3Points(pointInstances: {Instance})
	return getPoints(pointInstances, getVector3FromInstance)
end

--- Gets Points (a list of Vector3 positions in order) from an Instance
--- @function getPointsFromInstance
--- @within PointsUtil
--- @param instance Instance
--- @return Result<{Vector3}, string>
--- @error "could not get points!" -- Something went wrong when getting an ordered list of points
--- @error "could not convert all points to Vector3s!" -- A point Instance could not be converted to a Vector3. See `getVector3FromInstance` for valid Instances
local function getVector3PointsFromInstance(instance: Instance)
	local pointInstancesResult = getPointInstances(instance)
	if pointInstancesResult:isErr() then
		return Result.err(("could not get points from Instance! %s"):format(serializePointInstancesResult(pointInstancesResult:unwrapErr())))
	end

	local pointInstances = pointInstancesResult:unwrap()

	local pointsResult = getVector3Points(pointInstances, getVector3FromInstance)
	if pointsResult:isErr() then
		return Result.err(
			("could not convert all points to Vector3s! Errors: %s"):format(serializeGetPointsResult(pointsResult:unwrapErr()))
		)
	end

	return pointsResult
end

--- Converts a array of Instances into an array of CFrames
--- @function getCFramePoints
--- @within PointsUtil
--- @param pointInstances {Instance}
--- @return Result<{CFrame}, {PointIndexError}>
local function getCFramePoints(pointInstances: {Instance})
	return getPoints(pointInstances, getCFrameFromInstance)
end

--- Gets Points (a list of CFrame positions in order) from an Instance
--- @function getPointsFromInstance
--- @within PointsUtil
--- @param instance Instance
--- @return Result<{CFrame}, string>
--- @error "could not get points!" -- Something went wrong when getting an ordered list of points
--- @error "could not convert all points to CFrames!" -- A point Instance could not be converted to a CFrame. See `getCFrameFromInstance` for valid Instances
local function getCFramePointsFromInstance(instance: Instance)
	local pointInstancesResult = getPointInstances(instance)
	if pointInstancesResult:isErr() then
		return Result.err(("could not get points from Instance! %s"):format(serializePointInstancesResult(pointInstancesResult:unwrapErr())))
	end

	local pointInstances = pointInstancesResult:unwrap()

	local pointsResult = getCFramePoints(pointInstances, getCFrameFromInstance)
	if pointsResult:isErr() then
		return Result.err(
			("could not convert all points to CFrames! Errors: %s"):format(serializeGetPointsResult(pointsResult:unwrapErr()))
		)
	end

	return pointsResult
end

return {
	getPointInstances = getPointInstances,
	serializePointInstancesResult = serializePointInstancesResult,

	getPoints = getPoints,

	getVector3Points = getVector3Points,
	getCFramePoints = getCFramePoints,
	serializeGetPointsResult = serializeGetPointsResult,

	getVector3PointsFromInstance = getVector3PointsFromInstance,
	getCFramePointsFromInstance = getCFramePointsFromInstance,

	getCFrameFromInstance = getCFrameFromInstance,
	getVector3FromInstance = getVector3FromInstance,
}