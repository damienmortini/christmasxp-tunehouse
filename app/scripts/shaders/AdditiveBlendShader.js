AdditiveBlendShader = {
	
	uniforms: {
		"tDiffuse": { type: "t", value: null },
		"tDiffuse2": { type: "t", value: null }
	},

	vertexShader: [
		"varying vec2 vUv;",
		"void main() {",
			"vUv = uv;",
			"gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );",
		"}"
	].join("\n"),

	fragmentShader: [
		"uniform sampler2D tDiffuse;",
		"uniform sampler2D tDiffuse2;",

		"varying vec2 vUv;",

		"void main() {",
			"gl_FragColor = (texture2D( tDiffuse, vUv ) * texture2D( tDiffuse2, vUv ) + texture2D( tDiffuse, vUv ) + texture2D( tDiffuse2, vUv )) * .5;",
		"}"
	].join("\n")

};
