class Pad extends SwitchableObject
	constructor: (params) ->
		mesh = new THREE.Mesh(new THREE.PlaneGeometry( 1, 1, 1, 1 ))
		mesh.name = params.name
		super(mesh)
		@x = params.x
		@y = params.y

		for i in [0...8]
			@soundPositions.push i * 8 + @x

		@color = new THREE.Color().setHSL(@y * .25 + .15 + random(.1), 1, .75)

		@material = @mesh.material = new THREE.MeshPhongMaterial
			color: 0x111111
			blending: THREE.AdditiveBlending
			transparent: true
			vertexColors: THREE.FaceColors
		for face in @mesh.geometry.faces
			face.color.set @color
			face.color.r += random(-.2, .2)
			face.color.g += random(-.2, .2)
			face.color.b += random(-.2, .2)

		@updateMaterial()

		@mesh.scale.x = @mesh.scale.y = .95

		@collidableObjects = [@mesh]
		null

	update: =>
		if SoundsMatrix.playbackPosition % 8 is @x
			if @activated
				@glowEmissiveColor.set 0x444444
			else
				@glowEmissiveColor.set 0x111111
				@emissiveColor.set 0x111111
		else
			@glowEmissiveColor.set 0x000000
			if !@activated
				@emissiveColor.set 0x000000
		null

	collide: =>
		super()
		@mesh.material.color.set if @activated then @color else 0x111111
		@emissiveColor.set if @activated then 0x444444 else 0x000000
		if @activated
			TweenLite.from @mesh.scale, .1, {x:.01, y:.01}
		null