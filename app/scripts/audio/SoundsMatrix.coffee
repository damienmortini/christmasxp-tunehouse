class SoundsMatrix
	COLORS: ['red', 'green', 'blue', 'yellow', 'pink', 'cyan', 'magenta', 'gold', 'red', 'green', 'blue', 'yellow', 'pink', 'cyan', 'magenta', 'gold']

	constructor: ->
		@width = 64
		@height = 0

		@matrix = []
		for i in [0...@width]
			@matrix[i] = []

		@onLoad = new Signal()
		@onProgress = new Signal()

		@sounds = []
		@soundIds = {}
		@soundsLoaded = 0

		if window.DEBUG
			@CELL_SIZE = 10
			@canvas = document.createElement('canvas')
			@ctx = @canvas.getContext('2d')
			@canvas.width = @width * @CELL_SIZE
			@canvas.style.position = 'absolute'
			@canvas.style.top = @canvas.style.left = 0
			document.body.appendChild(@canvas)

		null

	loadSound: (name, volume = .5) =>
		if @soundIds[name]?
			return

		if name.indexOf('drum') is 0
			volume = .7

		@sounds.push new Howl
			urls: ["sounds/#{name}.mp3", "sounds/#{name}.ogg"]
			volume: volume
			onload: @onSoundLoad
		@soundIds[name] = @height

		@height = @sounds.length

		for i in [0...@width]
			@matrix[i][@height - 1] = false

		if window.DEBUG
			@canvas.height = @height * @CELL_SIZE

		null

	toggleSoundAt: (name, positions) =>
		y = @soundIds[name]

		for x in positions
			@matrix[x][y] = !@matrix[x][y]

		null

	update: (progress) ->
		newPlaybackPosition = floor(progress * @width)

		if newPlaybackPosition == @playbackPosition
			return

		@playbackPosition = newPlaybackPosition

		for i in [0...@height]
			if @matrix[@playbackPosition][i]
				@sounds[i].play()

		if window.DEBUG
			@ctx.fillStyle = 'white'
			@ctx.fillRect 0, 0, @canvas.width, @canvas.height
			@ctx.fillStyle = 'rgba(0, 0, 0, .5)'
			@ctx.fillRect progress * @canvas.width, 0, @CELL_SIZE, @canvas.height
			for i in [0...@width]
				for j in [0...@height]
					if @matrix[i][j]
						@ctx.fillStyle = @COLORS[j]							
						@ctx.fillRect i * @CELL_SIZE, j * @CELL_SIZE, @CELL_SIZE, @CELL_SIZE

		null

	onSoundLoad: =>
		@soundsLoaded++
		percentageLoaded = @soundsLoaded / @sounds.length
		@onProgress.dispatch(percentageLoaded)
		if percentageLoaded is 1
			@onLoad.dispatch()
		null
