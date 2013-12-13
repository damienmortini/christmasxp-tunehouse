class InteractiveObject extends GlowObject
	constructor: (mesh) ->
		super(mesh)

		@object = new THREE.Object3D()
		@name = @mesh.name
		@collidableObjects = []

		@object.add @mesh

		null

	update: (progress) =>
		null

	collide: =>
		null