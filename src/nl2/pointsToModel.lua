
return function(points: {CFrame}, scale: number, distance: number)
	assert(type(points) == "table", "Arg [1] is not a table!")
	assert(type(scale) == "number" and scale > 0, "Arg [2] is not a number > 0!")
	assert(type(distance) == "number" and distance > 0, "Arg [3] is not a number > 0!")

	local model = Instance.new("Model")

	local partLength = scale * distance

	for index, cframe in pairs(points) do
		local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cframe:GetComponents()
		local scaledCFrame = CFrame.new(
			x * scale, y * scale, z * scale,	--pos
			r00, r01, r02, r10, r11, r12, r20, r21, r22 --rot
		)

		local point = Instance.new("Part")

		point.Name = tostring(index)
		point.Anchored = true
		point.Size = Vector3.new(3, 0.4, partLength)
		point.BrickColor = BrickColor.new("Medium stone grey")
		point.FrontSurface = Enum.SurfaceType.Hinge
		point.CFrame = scaledCFrame

		point.Parent = model
	end

	return model
end