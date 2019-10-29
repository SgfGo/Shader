// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "SGF/Chapter5-SimpleShader"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _Color("Color Tint",Color) = (1.0,1.0,1.0,1.0)
    }
    
    SubShader
    {
        //Tags { "RenderType"="Opaque" }
        //LOD 100

        Pass
        {
            CGPROGRAM

            // 顶点着色器
            #pragma vertex vert
            // 片元着色器
            #pragma fragment frag
            
            // 在CG代码中,我们需要定义一个与属性名称和类型都匹配的变量
            fixed4 _Color;
            
            struct a2v
            {
                // Position 语义告诉unity,用模型空间的顶点坐标填充vertex变量
                float4 vertex : POSITION;
                // NORMAL 语义告诉unity 用模型空间的发现方向填充normal变量
                float3 normal :NORMAL;
                // TEXCOORD 语义告诉unity，用模型的第一套纹理坐标填充texcoord变量
                float4 texcoord : TEXCOORD0;
                
            };
            
            struct v2f
            {
                // SVPOSITION 告诉unity pos包含了顶点的裁剪空间中的位置信息
                float4 pos : SV_POSITION;
                // Color0 语义可以用于存储颜色信息
                fixed3 color : COLOR0;
            };
            
            v2f vert(a2v v)
            {
            
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); 
                // v.normal 包含了顶点的法线方向 其分量范围在[-1.0,1.0]
                // 下面的代码把分量范围映射到[0.0,1.0]
                // 存贮到o.color中传递给片元着色器
                
                o.color = v.normal * 0.5 + fixed3(0.5,0.5,0.5);
                
                return o;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                fixed3 c = i.color;
                //使用_Color属性来控制输出颜色
                c *= _Color.rgb;
                return fixed4(c,1);
                
            }

          
            ENDCG
        }
    }
}
