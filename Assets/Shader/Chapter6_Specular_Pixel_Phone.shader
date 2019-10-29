// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "SGF/Specular/SpecularPixellevel"
{
    Properties
    {
        _Diffuse("Diffuse",Color) = (1,1,1,1)
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8,256)) = 20
    }
    
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            
            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            
            // 顶点着色器输出结构
            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 worldNormal : TEXCOORD0;
                fixed3 worldPos : TEXCOORD1;
            };
            
            // 顶点着色器
            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // 
                o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);
                
                
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                
                //// 环境光
                //fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                //// 法线坐标空间从自身坐标转世界空间
                //fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                
                //// 获取灯光方向
                //fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                
                //// Comput diffuse term
                //// 计算漫反射
                //fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLightDir));
                
                //// Get the reflect direction in the world space
                //// 从世界坐标空间 获取反射方向
                //fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));
                
                //// Get the view direction in world space
                //// 从世界坐标空间 获取显示方向
                //fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld,v.vertex).xyz);
                
                //// Comput specular term
                //fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)),_Gloss);
                
                //o.color = ambient + diffuse + specular;
               
                return o;
            }
            
            // 片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                
                // Comput diffuse term
                fixed3 diffuse = _LightColor0 * _Diffuse * saturate(dot(worldNormal,worldLightDir));
                
                fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));
                
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                
                // Comput Specular term
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir,viewDir)),_Gloss);
                
                
            
                return fixed4(ambient + diffuse + specular,1);
            }
            ENDCG
        }
    }
    
    FallBack "Specular"
}
