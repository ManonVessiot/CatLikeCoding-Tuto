Shader "Custom/Texture Splatting"
{
    Properties
    {
		_MainTex("Texture", 2D) = "white" {}
		[NoScaleOffset] _Texture1("Texture 1", 2D) = "white" {}
		[NoScaleOffset] _Texture2("Texture 2", 2D) = "white" {}
		[NoScaleOffset] _Texture3("Texture 3", 2D) = "white" {}
		[NoScaleOffset] _Texture4("Texture 4", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _Texture1, _Texture2, _Texture3, _Texture4;

			struct MyVertexProgram_INPUT {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct MyVertexProgram_OUTPUT {
				float4 position : SV_POSITION;
				float3 localPosition : TEXCOORD0;
				float2 uv : TEXCOORD1;
				float2 uvSplat : TEXCOORD2;
			};

			MyVertexProgram_OUTPUT MyVertexProgram(MyVertexProgram_INPUT IN) {
				MyVertexProgram_OUTPUT OUT;
				OUT.position = UnityObjectToClipPos(IN.position);
				OUT.localPosition = IN.position.xyz;
				OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
				OUT.uvSplat = IN.uv;

				return OUT;
			}

			float4 MyFragmentProgram(MyVertexProgram_OUTPUT OUT) : SV_TARGET{
				float4 splat = tex2D(_MainTex, OUT.uvSplat);
				return tex2D(_Texture1, OUT.uv) * splat.r +
					tex2D(_Texture2, OUT.uv) * splat.g +
					tex2D(_Texture3, OUT.uv) * splat.b +
					tex2D(_Texture4, OUT.uv) * (1 - splat.r - splat.g - splat.b);
			}

			ENDCG
        }
    }
}
