class Sky extends InteractiveObject
	constructor: ->
		mesh = new THREE.Mesh new THREE.PlaneGeometry(200, 100, 1, 1)
		mesh.position.z = -50
		super(mesh)
		# mesh.material = new THREE.MeshBasicMaterial
		# 	map: new THREE.ImageUtils.loadTexture('images/background.jpg')
		# 	color:0x888888
		# 	emissive: 0x000000
		mesh.material.map = new THREE.ImageUtils.loadTexture('images/background.jpg')
		mesh.material.specular.set 0x000000
		@emissiveColor = 0xffffff
		@glowEmissiveColor = 0xffffff
		@color = 0xffffff

		@collidableObjects = [@mesh]
