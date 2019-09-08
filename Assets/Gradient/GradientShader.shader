Shader "Unlit/GradientShader"
{
    Properties
    {
        _Radius ("Radius", Float) = 4
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            float4 _Vertices[100];
            float _PointCount;

            #pragma target 4.0
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 position : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 worldPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.position);
                o.worldPos = mul(unity_ObjectToWorld, v.position);
                return o;
            }

            float3 HUEtoRGB(in float H)
            {
                float R = abs(H * 6 - 3) - 1;
                float G = 2 - abs(H * 6 - 2);
                float B = 2 - abs(H * 6 - 4);
                return saturate(float3(R,G,B));
            }

            float3 HSLtoRGB(in float h, in float s, in float l)
            {
                float3 RGB = HUEtoRGB(h);
                float C = (1 - abs(2 * l - 1)) * s;
                return (RGB - 0.5) * C + l;
            }

            float _Radius;

            fixed4 frag (v2f i) : SV_Target
            {
                float distances[2];
                for(int di = 0; di < distances.Length; di++)
                {
                    distances[di] = 10000;
                }
                for (int pointIndex = 0; pointIndex < _PointCount; pointIndex += 1)
                {
                    float d = distance(_Vertices[pointIndex], i.worldPos);
                    int ip = -1;
                    for(int di = 0; di < distances.Length; di++)
                    {
                        if(d < distances[di])
                        {
                            ip = di;
                        }
                    }
                    if(ip != -1)
                    {
                        for(int ii = 0; ii < ip; ii++)
                        {
                            distances[ii] = distances[ii + 1];
                        }
                        distances[ip] = d;
                    }
                }
                float3 rgb = HSLtoRGB(distances[0] / _Radius, 1.0, 0.5);
                return float4(rgb.xyz, 1);
            }
            ENDCG
        }
    }
}
