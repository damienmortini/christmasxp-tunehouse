class Roof extends GlowObject
	constructor: (mesh) ->
		super(mesh)
		@emissiveColor.set 0x111111
		@glowEmissiveColor.set 0x333333