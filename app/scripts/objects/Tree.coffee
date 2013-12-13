class Tree extends SwitchableObject
	constructor: (mesh) ->
		super(mesh)
		@material = mesh.material = new THREE.MeshPhongMaterial
			vertexColors: THREE.FaceColors
		for face in mesh.geometry.faces
			face.color.setHex random(0xffffff)
		@glowEmissiveColor.set 0x000000
		@emissiveColor.set 0x000000
		@collidableObjects = [mesh]
		@soundPositions = [0, 32]
		null

	collide: =>
		super()
		@emissiveColor.set if @activated then 0xffffff else 0x000000
		@glowEmissiveColor.set if @activated then 0xffffff else 0x000000
		null