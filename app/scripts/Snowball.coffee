class Snowball
	constructor: () ->
		# @color = random(0xffffff)

		@object = new THREE.Object3D()
		@object.position.set(0, 1, 16)

		@isThrown = false

		geometry =  new THREE.SphereGeometry( .1, 4, 4)
		material = new THREE.MeshBasicMaterial(
			color: new THREE.Color(0xffffff)
			transparent: true
			# blending: THREE.AdditiveBlending
		)

		@light = new THREE.PointLight(0x000000, 1, 10 )
		@mesh = new THREE.Mesh(geometry, material)
		@object.add(@mesh)
		@object.add(@light)

		null

	throw: (@intersect, @interactiveObject) =>
		if @isThrown
			return
		if @tween?
			@tween.kill()
		if @tween2?
			@tween2.kill()
		if @tween3?
			@tween3.kill()
			
		@object.position.set(0, 1, 16)
		@light.distance = 10
		duration = @intersect.distance * .03
		@tween = TweenLite.to @object.position, duration, {
			x: @intersect.point.x
			y: @intersect.point.y
			z: @intersect.point.z
			easing:Linear.EaseIn
			onComplete:@blow
		}
		if @interactiveObject? and @interactiveObject instanceof SwitchableObject
			@light.color.set(@interactiveObject.color || @interactiveObject.mesh.material.color)
			@mesh.material.color.set(@interactiveObject.color || @interactiveObject.mesh.material.color)
			@tween2 = TweenLite.to @light, .1, {distance:15, delay: duration - .1, ease:Quad.easeIn}
			@tween3 = TweenLite.to @light.color, .2, {r:0, g:0, b:0, delay: duration, ease:Quad.easeIn}
		else
			if @interactiveObject? and @interactiveObject.color?
				@light.color.set @interactiveObject.color
			else
				@light.color.setHSL(random(), 1, .5)
			@mesh.material.color.set(@light.color)
			@tween2 = TweenLite.to @light.color, .2, {r:0, g:0, b:0, delay: duration - .2, ease:Quad.easeOut}

		if @interactiveObject? and @interactiveObject.name is 'corridor'
			@tween2.kill()
			@tween2 = TweenLite.to @light.color, .6, {r:0, g:0, b:0, delay: duration - .8, ease:Quad.easeOut}
			TweenLite.to @mesh.material.color, .6, {r:0, g:0, b:0, delay: duration - .8, ease:Quad.easeOut}

		@isThrown = true

	blow: =>
		# vertices = @mesh.geometry.vertices
		# for vertice in vertices
		# 	v = new THREE.Vector3().copy(vertice).sub(new THREE.Vector3())
		# 	r = random(1, 2)
		# 	v.x *= r
		# 	v.y *= r
		# 	v.z *= r
		# 	vertice.add(v)
		# @mesh.geometry.verticesNeedUpdate = true

		# @light.color.setHex(0x000000)
		

		# @object.position.set(0, 1, 16)

		

		if @interactiveObject? and @interactiveObject instanceof InteractiveObject
			@interactiveObject.collide(@intersect)

		@isThrown = false

		null
			
		
