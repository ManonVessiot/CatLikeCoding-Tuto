Shader "Unlit/My First Lighting Shader"
{
    Properties
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		_Smoothness("Smoothness", Range(0, 1)) = 0.5
		_Metallic("Metallic", Range(0, 1)) = 0
    }
    SubShader
    {
        Pass
        {
			Tags {
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM

			#pragma target 3.0

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityPBSLighting.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Smoothness;
			float _Metallic;

			struct MyVertexProgram_INPUT {
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct MyVertexProgram_OUTPUT {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			MyVertexProgram_OUTPUT MyVertexProgram(MyVertexProgram_INPUT IN) {
				MyVertexProgram_OUTPUT OUT;
				OUT.position = UnityObjectToClipPos(IN.position);
				OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
				OUT.normal = UnityObjectToWorldNormal(IN.normal);
				OUT.worldPos = mul(unity_ObjectToWorld, IN.position);
				return OUT;
			}

			float4 MyFragmentProgram(MyVertexProgram_OUTPUT OUT) : SV_TARGET{
				OUT.normal = normalize(OUT.normal);
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 viewDir = normalize(_WorldSpaceCameraPos - OUT.worldPos);

				float3 lightColor = _LightColor0.rgb;

				float3 albedo = tex2D(_MainTex, OUT.uv).rgb * _Tint.rgb;
				float3 specularTint;
				float oneMinusReflectivity;
				albedo = DiffuseAndSpecularFromMetallic(
					albedo, _Metallic, specularTint, oneMinusReflectivity
				);

				UnityLight light;
				light.color = lightColor;
				light.dir = lightDir;
				light.ndotl = DotClamped(OUT.normal, lightDir);

				UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;
				
				return UNITY_BRDF_PBS(albedo, specularTint,
					oneMinusReflectivity, _Smoothness,
					OUT.normal, viewDir,
					light, indirectLight);
			}

			ENDCG
        }
    }
}
