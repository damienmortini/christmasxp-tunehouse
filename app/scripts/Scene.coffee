class Scene

	objectsClass: 
		house: House
		roof: Roof
		tree: Tree
		backgroundtrees: BackgroundTrees
		corridor: Corridor
		chimney1: Chimney
		chimney2: Chimney
		chimney3: Chimney
		chimney4: Chimney
		chimney5: Chimney
		chimney6: Chimney
		chimney7: Chimney
		chimney8: Chimney
		chimney9: Chimney
		ground: Ground

	constructor: (canvas) ->

		@interactiveObjects = []
		@collidableObjects = []
		@glowObjects = []
		
		@renderer = new THREE.WebGLRenderer({canvas: canvas})

		@onLoad = new Signal()

		@camera = new THREE.PerspectiveCamera( 50, window.innerWidth / window.innerHeight, 1, 10000 )
		@camera.position.z = 16
		@camera.position.y = 3
		@camera.fov = 50

		@lookAtVector = new THREE.Vector3(0, 3, 0)

		@snowballs = []

		loader = new THREE.JSONLoader()
		loader.load "models/elk_life.js", @deerLoaded
		
		null

	deerLoaded: (geometry) =>
		@deerGeometry = geometry
		geometry.computeMorphNormals()
		loader = new THREE.SceneLoader()
		loader.load 'models/house3.js', @sceneLoaded
			
	sceneLoaded: (result) =>
		@scene = result.scene

		@controls = new THREE.TrackballControls @camera
		@raycaster = new THREE.Raycaster()
		@projector = new THREE.Projector()

		@scene.rotation.set(0, 0, 0)
		@scene.matrixAutoUpdate = true
		# @scene.fog = new THREE.Fog(0x000000, 30, 55)

		tempMeshs = []
		for child in @scene.children
			if child instanceof THREE.Mesh
				tempMeshs.push child

		for mesh in tempMeshs
			if @objectsClass[mesh.name]?
				specialObject = new @objectsClass[mesh.name](mesh)
				if specialObject.onLoad?
					specialObject.onLoad.add @addSpecialObject
				else
					@addSpecialObject specialObject
				if specialObject.light?
					@scene.add specialObject.light
				

		light = new THREE.PointLight(0xeeeeff, .2)
		light.position.x = 10
		light.position.z = 10
		light.position.y = 10
		@scene.add light

		light = new THREE.PointLight(0xeeeeff, .1)
		light.position.x = -10
		light.position.z = 10
		light.position.y = 10
		@scene.add light

		l = if window.HQ then 5 else 3
		for i in [0...l]
			snowball = new Snowball()
			@snowballs.push snowball
			@scene.add snowball.object

		@addSpecialObject new Sky()

		@createPads()

		@initComposers()

		@onLoad.dispatch()

		World.onMouseDown.add @onClick

		null

	createPads: =>
		padContainerLeft = new THREE.Object3D()
		padContainerRight = new THREE.Object3D()
		color = 0
		for i in [0...4]
			color = new THREE.Color().setHSL(random(), 1, .5)
			for j in [0...8]
				pad = @addSpecialObject new Pad({x:j, y:i, color:color, name:'drum' + (i + 1)})
				pad.object.position.x = j - 3.5
				pad.object.position.y = i + .5
				padContainerLeft.add pad.object
		for i in [0...4]
			color = new THREE.Color().setHSL(random(), 1, .5)
			for j in [0...8]
				pad = @addSpecialObject new Pad({x:j, y:i, color:color, name:'tone' + (i + 1)})
				pad.object.position.x = j - 3.5
				pad.object.position.y = i + .5
				padContainerRight.add pad.object
		padContainerRight.position.z = padContainerLeft.position.z = .1
		padContainerLeft.position.x = -6
		padContainerRight.position.x = 6
		@scene.add(padContainerLeft)
		@scene.add(padContainerRight)

	addSpecialObject: (specialObject) =>
		if specialObject instanceof InteractiveObject
			@interactiveObjects.push specialObject
		if specialObject instanceof GlowObject
			@glowObjects.push specialObject
		if specialObject.collidableObjects?
			for collidableObject in specialObject.collidableObjects
				@collidableObjects.push collidableObject
		else if specialObject.mesh
			@collidableObjects.push specialObject.mesh
		if specialObject.glowObjects?
			for glowObject in specialObject.glowObjects
				@glowObjects.push glowObject
		@scene.add specialObject.object
		# if specialObject instanceof SwitchableObject
		# 	specialObject.collide()
		return specialObject

	initComposers: =>
		parameters = { minFilter: THREE.LinearFilter, magFilter: THREE.LinearFilter, format: THREE.RGBFormat, stencilBuffer: false }

		@composer1 = new THREE.EffectComposer @renderer, new THREE.WebGLRenderTarget(600, 400, parameters)

		renderPass = new THREE.RenderPass @scene, @camera
		@composer1.addPass renderPass

		brightnessContrastShaderPass = new THREE.ShaderPass THREE.BrightnessContrastShader
		brightnessContrastShaderPass.uniforms[ 'contrast' ].value = .8;
		@composer1.addPass brightnessContrastShaderPass

		bloomPass = new THREE.BloomPass(2)
		@composer1.addPass bloomPass

		copyShaderPass = new THREE.ShaderPass THREE.CopyShader
		# copyShaderPass.renderToScreen = true
		@composer1.addPass copyShaderPass

		@composer2 = new THREE.EffectComposer @renderer

		renderPass = new THREE.RenderPass @scene, @camera
		@composer2.addPass renderPass

		additiveBlendShaderPass = new THREE.ShaderPass AdditiveBlendShader
		additiveBlendShaderPass.uniforms[ 'tDiffuse2' ].value = @composer1.renderTarget2
		@composer2.addPass additiveBlendShaderPass

		fxaaShaderPass = new THREE.ShaderPass(THREE.FXAAShader)
		fxaaShaderPass.uniforms['resolution'].value.set(1 / window.innerWidth, 1 / window.innerHeight)
		@composer2.addPass fxaaShaderPass

		copyShaderPass = new THREE.ShaderPass THREE.CopyShader
		copyShaderPass.renderToScreen = true
		@composer2.addPass copyShaderPass
		null

	onClick: =>
		vector = new THREE.Vector3 World.mouse.x / (World.width * .5) - 1, -World.mouse.y / (World.height * .5) + 1, 1
		@projector.unprojectVector vector, @camera

		@raycaster.set @camera.position, vector.sub(@camera.position).normalize()
		intersect = @raycaster.intersectObjects(@collidableObjects)[0]

		if !intersect
			return

		interactiveObject = null
		for object in @interactiveObjects
			if object.collidableObjects.indexOf(intersect.object) != -1
				interactiveObject = object

		@snowballs[0].throw(intersect, interactiveObject)
		@snowballs.push(@snowballs.shift())
		null
		
	update: (progress) =>
		for object in @interactiveObjects
			object.update(progress)

		# @camera.position.x += (((World.mouse.x - World.width * .5) * .005) - @camera.position.x) * .01
		# @camera.lookAt(@lookAtVector)

		# @controls.update()

		# console.log World.dt

		null

	draw: =>
		for object in @glowObjects
			object.prepareGlowPass()
		@composer1.render()
		for object in @glowObjects
			object.prepareNormalPass()
		@composer2.render()

		null

	resize: =>
		@camera.aspect = window.innerWidth / window.innerHeight
		@camera.updateProjectionMatrix()
		@renderer.setSize window.innerWidth, window.innerHeight 
		null

