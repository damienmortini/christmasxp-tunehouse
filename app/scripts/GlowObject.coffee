class GlowObject
	constructor: (@mesh) ->
		color = @mesh.material.color or @mesh.material.materials[0].color or 0x000000
		@material = new THREE.MeshPhongMaterial({
			color: color
			shading: THREE.FlatShading
		})

		if @mesh.material.materials?
			@mesh.material.materials[0] = @material
		else
			@mesh.material = @material

		@emissiveColor = new THREE.Color(0x000000)
		@glowEmissiveColor = @material.color.clone()
		null

	updateMaterial: =>
		@emissiveColor = @material.emissive.clone()
		@glowEmissiveColor = @material.color.clone()
		null

	prepareGlowPass: =>
		@material.emissive.set @glowEmissiveColor
		null

	prepareNormalPass: =>
		@material.emissive.set @emissiveColor
		null