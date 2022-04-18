local Spring = Spring
local alwaysColor, losColor, radarColor, jamColor, radarColor2 = Spring.GetLosViewColors()

return {
	definitions = {
		Spring.GetConfigInt("HighResInfoTexture") and "#define HIGH_QUALITY" or "",
	},
	vertex = [[#version 130
		varying vec2 texCoord;
		void main() {
			texCoord = gl_MultiTexCoord0.st;
			gl_Position = vec4(gl_Vertex.xyz, 1.0);
		}
	]],
	fragment = [[#version 130
	#ifdef HIGH_QUALITY
		#extension GL_ARB_texture_query_lod : enable
	#endif
		uniform float time;
		uniform vec4 alwaysColor;
		uniform vec4 losColor;
		uniform vec4 radarColor1;
		uniform vec4 radarColor2;
		uniform vec4 jamColor;
		uniform sampler2D tex0;
		uniform sampler2D tex1;
		uniform sampler2D tex2;
		uniform sampler2D tex3;
		varying vec2 texCoord;
	#ifdef HIGH_QUALITY
		//! source: http://www.ozone3d.net/blogs/lab/20110427/glsl-random-generator/
		float rand(const in vec2 n)
		{
			return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
		}
		vec4 getTexel(in sampler2D tex, in vec2 p)
		{
			int lod = int(textureQueryLOD(tex, p).x);
			vec2 texSize = vec2(textureSize(tex, lod));
			vec2 off = vec2(time);
			vec4 c = vec4(0.0);
			for (int i = 0; i<4; i++) {
				off = (vec2(rand(p.st + off.st), rand(p.ts - off.ts)) * 2.0 - 1.0) / texSize;
				c += texture2D(tex, p + off);
			}
			c *= 0.25;
			return smoothstep(0.5, 1.0, c);
		}
	#else
		#define getTexel texture2D
	#endif

		const mat2 m = mat2(0.707107, -0.707107, 0.707107, 0.707107);

		float diagLines1(vec2 uv) {
			float col = 1.0;

			uv = m * uv;
			uv *= 2048.0;
			uv += 2.0 * vec2(-time, -time);

			float c = sin(uv.x) * 0.15;
			col -= c;
			col = pow(col, 2.75);

			return col;
		}
		
		float diagLines2(vec2 uv) {
			float col = 1.0;

			uv = m * uv;
			uv *= 2048.0;
			uv += 2.0 * vec2(-time, -time);

			float c = sin(uv.x) * 0.20;
			col -= c;
			col = pow(col, 4.0);

			return col;
		}

		float radarAnim(vec2 uv) {
			float d = distance(vec2(0.5), uv);
			float d0 = 0.1 * time;
			float dt1 = 1.0 - smoothstep(0.0, 0.1, fract(4.0 * (d0 - d)));
			dt1 = pow(dt1, 8.0);

			return mix(1.0, 8.0, dt1);
		}

		float hex2(vec2 p, float width, float coreSize) {
			p.x *= 0.57735 * 2.0;
			p.y += mod(floor(p.x), 2.0) * 0.5;
			p = abs((mod(p, 1.0) - 0.5));
			float val = abs(max(p.x * 1.5 + p.y, p.y * 2.0) - 1.0);
			return smoothstep(coreSize, width, val);
		}

		void main() {
			gl_FragColor  = vec4(0.0);
			
			float height = texture2D(tex3, texCoord).x;
			float heightStatus = smoothstep(-3.0, 0.0, height);

			vec2 radarJammer = getTexel(tex2, texCoord).rg;

			float radarFull = step(0.8, radarJammer.r);
			float radarEdge = float(radarJammer.r > 0.0 && radarJammer.r <= 0.9);

			vec4 radarColor = mix(radarColor2 * radarEdge, radarColor1 * radarFull, radarJammer.r);

			gl_FragColor += jamColor * radarJammer.g;
			gl_FragColor += radarColor;// * hex2(64.0 * texCoord, 0.025, 0.2) * radarAnim(texCoord);

			float los = getTexel(tex0, texCoord).r;
			float airlos = getTexel(tex1, texCoord).r;
			float losStatus = mix(los, airlos, 0.2);

			gl_FragColor += losColor * losStatus;

			//gl_FragColor.rgb += alwaysColor.rgb * mix(hex2(64.0 * texCoord, 0.025, 0.2), 1.0, max(radarFull, losStatus));

			float terraIncognitaStatus = 1.0 - max(radarFull, losStatus);
			float terraIncognitaEffect = mix(diagLines2(texCoord), diagLines1(texCoord), heightStatus);
			
			gl_FragColor.rgb += alwaysColor.rgb * mix(1.0, terraIncognitaEffect, terraIncognitaStatus);

			gl_FragColor.a = 0.03;
		}
	]],
	uniformFloat = {
		alwaysColor = alwaysColor,
		losColor    = losColor,
		radarColor1 = radarColor,
		jamColor    = jamColor,
		radarColor2 = radarColor2,
	},
	uniformInt = {
		tex0 = 0,
		tex1 = 1,
		tex2 = 2,
		tex3 = 3,
	},
	textures = {
		[0] = "$info:los",
		[1] = "$info:airlos",
		[2] = "$info:radar",
		[3] = "$heightmap",
	},
}
