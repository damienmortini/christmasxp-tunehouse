class Corridor extends InteractiveObject
	constructor:(mesh) ->
		super(mesh)

		@sound = new Howl
			urls: ["sounds/deer.mp3"]
			volume: .5

		@color = new THREE.Color().setHSL(random(), 1, .75)
		
		@deers = []
		@glowObjects = []

		l = if window.HQ then 5 else 3
		for i in [0...l]
			deer = new Deer(new THREE.MorphAnimMesh(World.scene.deerGeometry))
			@deers.push deer
			@object.add(deer.object)
			@glowObjects.push deer

		@cameraFov = World.scene.camera.fov


		@collidableObjects = [@mesh]

		null

	update: (progress) =>
		for deer in @deers
			deer.update(progress)

		null
		
	collide: =>
		if @deers[0].isRunning
			return
		@deers[0].run(@color)
		@sound.play()

		# FOV Movement
		# runnersNumber = 0
		# for deer in @deers
		# 	if deer.isRunning
		# 		runnersNumber++
		# 		console.log runnersNumber
		# if runnersNumber is @deers.length
		# 	TweenLite.to World.scene.camera, .4, {fov:80, onUpdate:@onCameraTweenUpdate, onComplete:@onCameraTweenComplete, ease:Cubic.easeInOut}
		
		@deers.push(@deers.shift())
		@color.setHSL(random(), 1, .75)

		null

	onCameraTweenUpdate: =>
		World.scene.camera.updateProjectionMatrix()
		null

	onCameraTweenComplete: =>
		TweenLite.to World.scene.camera, 6, {fov:@cameraFov, onUpdate:@onCameraTweenUpdate, ease:Cubic.easeInOut}
		null