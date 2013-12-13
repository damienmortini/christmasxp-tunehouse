class SwitchableObject extends InteractiveObject
	constructor: (mesh) ->
		super(mesh)
		@soundPositions = []
		SoundsMatrix.loadSound @name

	collide: =>
		super()
		@activated = !@activated
		SoundsMatrix.toggleSoundAt(@name, @soundPositions)
		null