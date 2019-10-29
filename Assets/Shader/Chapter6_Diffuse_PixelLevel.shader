Shader "SGF/Diffuse/DiffusePixelLevel"
{
    Properties
    {
        _Diffuse("Diffuse",Color) = (1.0,1.0,1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           

            //#include "UnityCG.cginc"
            #include "Lighting.cginc"
            
            fixed4 _Diffuse;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 worldNormal : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (a2v v)
            {
                v2f o ;
                // Transform the vertex from object space to projection space
                // 讲顶点坐标投射到屏幕上
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // 法线转世界坐标
                o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);
                
                
                //// Get ambient term
                //// 获取环境光
                //fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                //// Transform the normal from object space to the world space
                //// 转换法线自身坐标到世界坐标
                //fixed3 worldNormal = normalize(mul(v.normal,(float3x3) unity_WorldToObject));
                //// Get the light direction int world space
                ////  从世界空间中获取灯光方向
                //fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                //// Compute diffuse term
                //// 计算扩散项
                //fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));
                
                //o.color = ambient + diffuse;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            
                // Get ambient term
                // 获取环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                fixed3 worldNormal = normalize(i.worldNormal);
                
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate (dot( worldNormal,worldLightDir));
                
                fixed3 color = ambient + diffuse;
               
                return fixed4(color, 1);
            }
            ENDCG
        }
        
       
    }
    // 失败使用默认shader
    FallBack "Diffuse"
}
