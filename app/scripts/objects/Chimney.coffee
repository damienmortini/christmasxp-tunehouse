class Chimney extends SwitchableObject
	constructor: (mesh) ->
		super(mesh)
		color = new THREE.Color().setHSL((@name.match(/[0-9]/)[0] - 1) / 60, 1, .75)
		mesh.material = @material = new THREE.MeshPhongMaterial
			vertexColors: THREE.FaceColors
			color: color
		for face in mesh.geometry.faces
			face.color.set color
			face.color.r += random(-.5, .5)
			face.color.g += random(-.5, .5)
			face.color.b += random(-.5, .5)
		@glowEmissiveColor.set 0x000000
		@emissiveColor.set 0x000000

		@soundPlaying = false

		geometry = new THREE.Geometry()
		i = 0
		while i < 20
		  vector = new THREE.Vector3(Math.random() * .8 - .4, Math.random() * .8 - .4, Math.random() * .8 - .4)
		  geometry.vertices.push vector
		  i++
		i = 0
		while i < geometry.vertices.length - 2
		  j = i + 1
		  while j < geometry.vertices.length - 1
		    k = j + 1
		    while k < geometry.vertices.length
		      geometry.faces.push new THREE.Face3(i, j, k)  if Math.random() < .1
		      k++
		    j++
		  i++
		geometry.computeFaceNormals()
		for face in geometry.faces
			face.color.set color
			face.color.r += random(-.2, .8)
			face.color.g += random(-.2, .8)
			face.color.b += random(-.2, .8)
		@smoke = new THREE.Mesh(geometry, @material.clone())
		@smoke.material.emissive.set 0x888888
		@smoke.position = @mesh.position.clone()
		@smoke.position.y -= 1
		@object.add @smoke

		@collidableObjects = [@mesh]
		@soundPositions = [0, 16, 32, 48]
		
		# @collide()
		null

	update: =>
		if SoundsMatrix.playbackPosition % 16 is 0
			if @activated and !@soundPlaying
				@activate()
				@soundPlaying = true
			else if !@activated and @soundPlaying
				@deactivate()
				@soundPlaying = false
		if @soundPlaying
			for vertice in @smoke.geometry.vertices
				# vertice.y += random(.5)
				vertice.y += (10 - vertice.y) * random(.2)
				if vertice.y > 8
					vertice.y = 0
		else
			for vertice in @smoke.geometry.vertices
				vertice.y += (0 - vertice.y) * .5
		@smoke.geometry.verticesNeedUpdate = true
		null

	activate: =>
		# if @activated
		# 	for vertice in @smoke.geometry.vertices
		# 		vertice.y = random(10)

	deactivate: =>
		@emissiveColor.set 0x000000
		@glowEmissiveColor.set 0x000000

	collide: =>
		super()
		if @activated
			@emissiveColor.set 0x888888
			@glowEmissiveColor.set 0x888888
		else
			@emissiveColor.set 0x000000
			@glowEmissiveColor.set 0x000000

		
		# SoundsMatrix.toggleSoundAt(@name, [0, 16, 32, 48])
		null