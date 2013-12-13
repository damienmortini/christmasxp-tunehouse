# window.DEBUG = true
# window.HQ = true

window.Signal = signals.Signal

window.SoundsMatrix = new SoundsMatrix()

window.World = Sketch.create
	type: Sketch.WEBGL

World.onMouseDown = new Signal()

World.setup = ->
	@scene = new Scene(@canvas)

	# SOUNDS
	# for i in [0...4]
	# 	SoundsMatrix.loadSound "drum#{i + 1}", 'wav'
	# for i in [0...4]
	# 	SoundsMatrix.loadSound "tone#{i + 1}", 'ogg'
	# SoundsMatrix.loadSound 'voice-cannot-pass', 'mp3'
	# for i in [0...9]
	# 	SoundsMatrix.loadSound "chimney#{i + 1}", 'wav'

	@stop()
	
	@scene.onLoad.add World.sceneLoaded.bind(@)

World.sceneLoaded = ->
	@start()

World.update = ->
	progress = (@millis % 15000) / 15000

	SoundsMatrix.update(progress)
	@scene.update(progress)

World.draw = ->
	@scene.draw()

World.resize = ->
	@scene.resize()

World.mousedown = ->
	@onMouseDown.dispatch()

# update = ->
# 	requestAnimationFrame(update)
# 	progress = (Date.now() % 16000) / 16000

# 	SoundsMatrix.update(progress)
# 	World.scene.update(progress)

# update()
