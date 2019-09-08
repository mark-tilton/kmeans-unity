Shader "Unlit/KMeansShader"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            float4 _Vertices[100];
            float _Classes[100];
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

            fixed4 frag (v2f i) : SV_Target
            {
                float closestPoints[3];
                for(int di = 0; di < closestPoints.Length; di++)
                {
                    closestPoints[di] = -1;
                }
                // Loop through each point and store the closest n indices
                for (int pointIndex = 0; pointIndex < _PointCount; pointIndex += 1)
                {
                    float distanceToPoint = distance(_Vertices[pointIndex], i.worldPos);
                    int ip = -1;
                    // Loop through the closest n indices to see if this point is closer
                    for(int di = 0; di < closestPoints.Length; di++)
                    {
                        if(closestPoints[di] == -1 
                        || distanceToPoint < distance(_Vertices[closestPoints[di]], i.worldPos))
                        {
                            // Insert the current point at this location.
                            ip = di;
                        }
                    }
                    if(ip != -1)
                    {
                        for(int ii = 0; ii < ip; ii++)
                        {
                            closestPoints[ii] = closestPoints[ii + 1];
                        }
                        closestPoints[ip] = pointIndex;
                    }
                }

                int votes[100];
                for(int vi = 0; vi < _PointCount; vi++)
                {
                    votes[vi] = 0;
                }
                for(int ci = 0; ci < closestPoints.Length; ci++)
                {
                    int closestPointIndex = closestPoints[ci];
                    int classOfClosestPoint = _Classes[closestPointIndex];
                    votes[classOfClosestPoint]++;
                }
                int maxVotes = 0;
                int bestClass = -1;
                for(int vi = 0; vi < _PointCount; vi++)
                {
                    if(votes[vi] > maxVotes)
                    {
                        bestClass = vi;
                        maxVotes = votes[vi];
                    }
                }
                float4 color;
                if(bestClass == 0)
                {
                    return float4(1, 0.4, 0.4, 1);
                }
                if(bestClass == 1)
                {
                    return float4(0.4, 0.4, 1, 1);
                }
                if(bestClass == 2)
                {
                    return float4(1, 1, 0.4, 1);
                }
                return float4(1, 1, 1, 1);
            }
            ENDCG
        }
    }
}
