Shader "Custom/Textured With Detail"
{
    Properties
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
		_DetailTex("Detail Texture", 2D) = "gray" {}
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

			sampler2D _DetailTex;
			float4 _DetailTex_ST;

			struct MyVertexProgram_INPUT {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct MyVertexProgram_OUTPUT {
				float4 position : SV_POSITION;
				float3 localPosition : TEXCOORD0;
				float2 uv : TEXCOORD1;
				float2 uvDetail : TEXCOORD2;
			};

			MyVertexProgram_OUTPUT MyVertexProgram(MyVertexProgram_INPUT IN) {
				MyVertexProgram_OUTPUT OUT;
				OUT.position = UnityObjectToClipPos(IN.position);
				OUT.localPosition = IN.position.xyz;
				OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
				OUT.uvDetail = TRANSFORM_TEX(IN.uv, _DetailTex);

				return OUT;
			}

			float4 MyFragmentProgram(MyVertexProgram_OUTPUT OUT) : SV_TARGET{
				float4 color = tex2D(_MainTex, OUT.uv)* _Tint;
				color *= tex2D(_DetailTex, OUT.uvDetail) * unity_ColorSpaceDouble;
				return color;
			}

			ENDCG
        }
    }
}
