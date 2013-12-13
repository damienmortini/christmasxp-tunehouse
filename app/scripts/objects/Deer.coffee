class Deer extends InteractiveObject
	constructor: (mesh) ->
		super(mesh)

		SoundsMatrix.loadSound @name

		@isRunning = false
		@speed = 0
		@angleOffset = 0

		@mesh.material.vertexColors = THREE.FaceColors
		@mesh.material.morphTargets = true
		@mesh.material.morphNormals = true
		@mesh.material.transparent = true
		# @mesh.material.blending = THREE.AdditiveBlending
		@mesh.scale.set( 0.025, 0.025, 0.025 )

		for face in @mesh.geometry.faces
			face.color.r = random(.2, 1)
			face.color.g = random(.2, 1)
			face.color.b = random(.2, 1)
		
		@mesh.geometry.faces

		@object.position.set(0, .4, -40)


		@light = new THREE.PointLight(0xffffff, 1, 20)
		@object.add @light

		@reset()

		null

	run: (color) =>
		if @isRunning
			return
		@speed = random(1.5, 2)
		@angleOffset = random(-.03, .03)

		TweenLite.to @mesh.material, .5, {opacity: 1}
		TweenLite.to @light, .5, {intensity: 1}

		@light.color.set color
		@emissiveColor.set color
		@glowEmissiveColor.set color

		@isRunning = true

		null

	update: =>
		if @isRunning
			@mesh.updateAnimation( World.dt * @speed )
			if @object.position.z > 0
				@object.rotation.y += @angleOffset * @speed
			@object.position.z += Math.cos(@object.rotation.y) * @speed * .2
			@object.position.x += Math.sin(@object.rotation.y) * @speed * .2
			if @object.position.distanceTo(World.scene.camera.position) > 60
				@reset()

		null

	reset: =>
		@isRunning = false
		@object.position.set(0, .4, -40)
		@object.rotation.y = 0
		@mesh.material.opacity = 0
		@light.intensity = 0