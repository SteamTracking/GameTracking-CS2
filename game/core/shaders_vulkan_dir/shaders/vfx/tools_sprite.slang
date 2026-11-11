//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Point rendering for tools";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: gs, ps, vs
}

MODES
{
	Default();
	Depth(S_MODE_DEPTH);
	ToolsUtil();
}

FEATURES
{
	Feature( F_TEXTURED, 0..1, "" );
	Feature( F_ALPHA_TEST, 0..2 (0="None", 1="Separate Alpha (RGB+A)", 2="Embedded Alpha (RGBA)"), "" );
	Feature( F_TRANSLUCENT, 0..1, "" );
	Feature( F_PER_POINT_SIZE, 0..1, "" );
	Feature( F_WORLD_SPACE_SIZE, 0..1 (0="Size In Pixels", 1="Size In World Space"), "" );
	Feature( F_CULL_LARGER_THAN_BOX, 0..1, "Cull if Larger Than Box" );
	FeatureRule( Requires( F_ALPHA_TEST, F_TEXTURED ), "Alpha testing requires texturing" );
	FeatureRule( Allow1( F_CULL_LARGER_THAN_BOX, F_WORLD_SPACE_SIZE ), "Box-Culling only supported for screen-space sprites" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor          : COLOR0     < Semantic( Color ); >;                                   
	float3 vPositionWs     : POSITION0  < Semantic( PosXyz ); >;                                  
	float4 vUv_flPointSize : TEXCOORD0  < Semantic( NONE ); >;                                     // S_PER_POINT_SIZE=1
};

VS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_PER_POINT_SIZE, F_PER_POINT_SIZE );
	StaticCombo( S_CULL_LARGER_THAN_BOX, F_CULL_LARGER_THAN_BOX );
	StaticCombo( S_WORLD_SPACE_SIZE, F_WORLD_SPACE_SIZE );
	StaticComboRule( Allow1( S_CULL_LARGER_THAN_BOX, S_WORLD_SPACE_SIZE ) );
	
	float g_flUniformPointSize < Default(3); Range(0, 64); UiType(Slider); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float _Globals_1_g_flUniformPointSize : packoffset(c0);
	};
	
	
	static float3 vPositionWs;
	static float4 vColor;
	static float4 output_0;
	static float4 output_1;
	static float output_2;
	
	struct VS_INPUT
	{
	    float3 vPositionWs : POSITION0;
	    float4 vColor : COLOR0;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float output_2 : TEXCOORD2;
	};
	
	void MainVs_inner()
	{
	    float3 _24030 = vColor.xyz * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((vColor.xyz * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (vColor.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _24030.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (vColor.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _24030.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (vColor.z <= 0.040449999272823333740234375f)
	    {
	        _19302 = _24030.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    output_0 = float4(vPositionWs, 1.0f);
	    output_1 = float4(_21354, _21355, _19302, vColor.w);
	    output_2 = _Globals_1_g_flUniformPointSize;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionWs = stage_input.vPositionWs;
	    vColor = stage_input.vColor;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	FloatAttribute(UniformPointSize, g_flUniformPointSize);
	
}

GS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_WORLD_SPACE_SIZE, F_WORLD_SPACE_SIZE );
	StaticCombo( S_CULL_LARGER_THAN_BOX, F_CULL_LARGER_THAN_BOX );
	StaticComboRule( Allow1( S_CULL_LARGER_THAN_BOX, S_WORLD_SPACE_SIZE ) );
	
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _2;
	
	cbuffer PerViewConstantBuffer_t : register(b0, space2)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c21);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float4 input_0[1];
	static float4 input_1[1];
	static float input_2[1];
	static float4 output_0;
	static float2 output_1;
	static float4 output_2;
	
	struct SPIRV_Cross_Input
	{
	    float4 input_0 : TEXCOORD0;
	    float4 input_1 : TEXCOORD1;
	    float input_2 : TEXCOORD2;
	};
	
	struct SPIRV_Cross_Output
	{
	    float4 output_0 : TEXCOORD0;
	    float2 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    float4 gl_Position : SV_Position;
	};
	
	void MainGs_inner(point SPIRV_Cross_Input stage_input[1], inout TriangleStream<SPIRV_Cross_Output> geometry_stream)
	{
	    float4 _20663 = mul(PerViewConstantBuffer_t_1_m0, (float4(input_0[0].xyz, 1.0f) + (PerViewConstantBuffer_t_1_m2 * 1.0f)).xyzw);
	    float2 _13731 = _20663.xy;
	    float2 _14654 = PerViewConstantBuffer_t_1_m1.xy * input_2[0];
	    float _12129 = _20663.w;
	    float2 _6635 = _13731 + ((_14654 * (-1.0f).xx) * _12129);
	    float _9979 = _6635.x;
	    float4 _20488;
	    _20488.x = _9979;
	    float _21775 = _6635.y;
	    _20488.y = _21775;
	    float2 _7534 = _12129.xx;
	    float2 _9003 = ((_20488.xy / _7534) * 0.5f) + 0.5f.xx;
	    float2 _22603 = float2(_9003.x, 1.0f - _9003.y) / PerViewConstantBuffer_t_1_m1.xy;
	    float2 _9022 = _13731 + (_14654 * _12129);
	    float _9980 = _9022.x;
	    float4 _20489;
	    _20489.x = _9980;
	    float _21776 = _9022.y;
	    _20489.y = _21776;
	    float2 _9004 = ((_20489.xy / _7534) * 0.5f) + 0.5f.xx;
	    float4 _5752 = float4(_22603.x, (float2(_9004.x, 1.0f - _9004.y) / PerViewConstantBuffer_t_1_m1.xy).yx, _22603.y);
	    float2 _9831 = _13731 + ((_14654 * float2(-1.0f, 1.0f)) * _12129);
	    float4 _20108 = _20663;
	    _20108.x = _9831.x;
	    output_0 = input_1[0];
	    output_1 = 0.0f.xx;
	    output_2 = _5752;
	    _20108.y = -_9831.y;
	    gl_Position = _20108;
	    {
	        SPIRV_Cross_Output stage_output;
	        stage_output.gl_Position = gl_Position;
	        stage_output.output_0 = output_0;
	        stage_output.output_1 = output_1;
	        stage_output.output_2 = output_2;
	        geometry_stream.Append(stage_output);
	    }
	    float4 _18816 = _20663;
	    _18816.x = _9979;
	    output_0 = input_1[0];
	    output_1 = float2(0.0f, 1.0f);
	    output_2 = _5752;
	    _18816.y = -_21775;
	    gl_Position = _18816;
	    {
	        SPIRV_Cross_Output stage_output;
	        stage_output.gl_Position = gl_Position;
	        stage_output.output_0 = output_0;
	        stage_output.output_1 = output_1;
	        stage_output.output_2 = output_2;
	        geometry_stream.Append(stage_output);
	    }
	    float4 _18817 = _20663;
	    _18817.x = _9980;
	    output_0 = input_1[0];
	    output_1 = float2(1.0f, 0.0f);
	    output_2 = _5752;
	    _18817.y = -_21776;
	    gl_Position = _18817;
	    {
	        SPIRV_Cross_Output stage_output;
	        stage_output.gl_Position = gl_Position;
	        stage_output.output_0 = output_0;
	        stage_output.output_1 = output_1;
	        stage_output.output_2 = output_2;
	        geometry_stream.Append(stage_output);
	    }
	    float2 _9832 = _13731 + ((_14654 * float2(1.0f, -1.0f)) * _12129);
	    float4 _20109 = _20663;
	    _20109.x = _9832.x;
	    output_0 = input_1[0];
	    output_1 = 1.0f.xx;
	    output_2 = _5752;
	    _20109.y = -_9832.y;
	    gl_Position = _20109;
	    {
	        SPIRV_Cross_Output stage_output;
	        stage_output.gl_Position = gl_Position;
	        stage_output.output_0 = output_0;
	        stage_output.output_1 = output_1;
	        stage_output.output_2 = output_2;
	        geometry_stream.Append(stage_output);
	    }
	    geometry_stream.RestartStrip();
	}
	
	[maxvertexcount(4)]
	void MainGs(point SPIRV_Cross_Input stage_input[1], inout TriangleStream<SPIRV_Cross_Output> geometry_stream)
	{
	    for (int i = 0; i < 1; i++)
	    {
	        input_0[i] = stage_input[i].input_0;
	    }
	    for (int i = 0; i < 1; i++)
	    {
	        input_1[i] = stage_input[i].input_1;
	    }
	    for (int i = 0; i < 1; i++)
	    {
	        input_2[i] = stage_input[i].input_2;
	    }
	    MainGs_inner(stage_input, geometry_stream);
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_TEXTURED, F_TEXTURED );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticComboRule( Requires( S_ALPHA_TEST, S_TEXTURED ) );
	DynamicCombo( D_NO_ZTEST, 0..1 );
	DynamicCombo( D_BORDER, 0..1 );
	
	RenderState(StencilRef, 1);
	float g_flAlphaTestReference < Default(0.3); Range(0.01, 0.99); UiType(Slider); >;
	float g_flBorderWidthPx < Default(1); Attribute("BorderWidthPx"); UiType(Slider); >;
	Texture2D g_tColorA < Channel(RGB, Box(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColorB < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	Texture2D g_tColorC < Channel(RGBA, Box(TextureColor), Srgb); OutputFormat(DXT5); SrgbRead(true); >;
	float4 g_vBorderColor < Default4(0, 0, 0, 1); Attribute("BorderColor"); UiType(VectorText); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color", Default4(1, 1, 1, 0));
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD0;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _20756 = input_0.xyzw;
	    _20756.w = 1.0f;
	    output_0 = _20756;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
