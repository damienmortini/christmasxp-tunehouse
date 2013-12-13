class House extends GlowObject
	constructor: (mesh) ->
		super(mesh)
		# @material.specular.set 0xffffff
		# @material.shininess = 0
		@material.color.set 0xffcccc
		# @updateMaterial()
		@glowEmissiveColor.set 0x111111

		materials = [@material, new THREE.MeshBasicMaterial(
			color: 0x887700
			side: THREE.BackSide
		)]
		for face in mesh.geometry.faces
			backFace = face.clone()
			backFace.materialIndex = 1
			mesh.geometry.faces.push backFace
			# @mesh.geometry.faceVertexUvs[0].push geometry.faceVertexUvs[0][i].slice(0)
		mesh.material = new THREE.MeshFaceMaterial(materials)