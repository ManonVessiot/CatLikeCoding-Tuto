Shader "Unlit/My First Shader"
{
    Properties
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct MyVertexProgram_INPUT {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct MyVertexProgram_OUTPUT {
				float4 position : SV_POSITION;
				float3 localPosition : TEXCOORD0;
				float2 uv : TEXCOORD1;
			};

			MyVertexProgram_OUTPUT MyVertexProgram(MyVertexProgram_INPUT IN) {
				MyVertexProgram_OUTPUT OUT;
				OUT.position = UnityObjectToClipPos(IN.position);
				OUT.localPosition = IN.position.xyz;
				OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);

				return OUT;
			}

			float4 MyFragmentProgram(MyVertexProgram_OUTPUT OUT) : SV_TARGET{
					return tex2D(_MainTex, OUT.uv)* _Tint;
			}

			ENDCG
        }
    }
}
