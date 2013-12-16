# window.DEBUG = true
# window.HQ = true

window.Signal = signals.Signal

window.SoundsMatrix = new SoundsMatrix()

window.World = Sketch.create
	type: Sketch.WEBGL
	autostart: false

World.onMouseDown = new Signal()

World.setup = ->
	@scene = new Scene(@canvas)

	@scene.onLoad.add World.onSceneLoad.bind(@)
	SoundsMatrix.onLoad.add World.onSoundsLoad.bind(@)
	SoundsMatrix.onProgress.add World.onSoundsProgress.bind(@)

World.onSceneLoad = ->
	@sceneLoaded = true
	if @soundsLoaded
		@start()

World.onSoundsLoad = ->
	@soundsLoaded = true
	if @sceneLoaded
		document.getElementsByClassName('loader')[0].classList.add 'hide'
		@canvas.classList.add 'show'
		@start()

World.onSoundsProgress = (progress) ->
	document.getElementsByClassName('percentage')[0].style.width = Math.floor(progress * 100) + '%';

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
