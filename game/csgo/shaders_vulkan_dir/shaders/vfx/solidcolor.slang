//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "A shader for untextured and unlit meshes";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
	CsgoForward();
	Depth("csgo_depth_only.vfx");
	ProjectionDepth("csgo_depth_only.vfx");
	Forward();
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
}

FEATURES
{
	Feature( F_IGNOREZ, 0..1, "Destalpha and depth" );
	Feature( F_WRITE_TO_DESTALPHA, 0..1, "Destalpha and depth" );
	Feature( F_PREMULTIPLY_BY_ALPHA_AND_ACCUMULATE_ONE_MINUS_ALPHA, 0..1, "Destalpha and depth" );
	Feature( F_DISABLE_Z_WRITE, 0..1, "Destalpha and depth" );
	Feature( F_DISABLE_STENCIL_WRITE, 0..1, "Disable writing to the stencil buffer if bound" );
	Feature( F_BLEND_MODE, 0..1 (0="Opaque", 1="Translucent"), "Blend Mode" );
	Feature( F_PLAYER_VISIBILITY_DATA_COLOR, 0..1, "Player Visibility Data Color" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                           // D_CS_VERTEX_ANIMATION=0
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                 // D_CS_VERTEX_ANIMATION=0
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_PLAYER_VISIBILITY_DATA_COLOR, F_PLAYER_VISIBILITY_DATA_COLOR );
	StaticComboRule( Allow1( S_PLAYER_VISIBILITY_DATA_COLOR, S_MODE_TOOLS_WIREFRAME ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1125
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    float _m7;
	};
	
	struct _1119
	{
	    row_major float3x4 _m0;
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c17);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float gl_ClipDistance[1];
	static uint nInstanceIdx;
	static uint4 vBlendIndices;
	static float3 vPositionOs;
	static float3 output_0;
	static float4 output_1;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint4 vBlendIndices : TEXCOORD4;
	    uint nInstanceIdx : TEXCOORD5;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	    float gl_ClipDistance0 : SV_ClipDistance0;
	};
	
	void MainVs_inner()
	{
	    float4 _23812 = float4(uint4(g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 255u, (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
	    float3 _6253 = _23812.xyz;
	    float3 _17828 = _6253 * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((_6253 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _19302 = _17828.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    uint _13771 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    }
	    float3x4 _12618 = asfloat(uint3x4(g_transformBuffer.Load4(_21785 * 48 + 0), g_transformBuffer.Load4(_21785 * 48 + 16), g_transformBuffer.Load4(_21785 * 48 + 32)));
	    float3 _22743;
	    if (_13771 > 0u)
	    {
	        float3x4 _25207 = asfloat(uint3x4(g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load4(g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 32)));
	        _22743 = _25207[0].z.xxx;
	    }
	    else
	    {
	        _22743 = 1.0f.xxx;
	    }
	    float3 _12132 = mul(_12618, float4(vPositionOs.xyz * _22743.xyz, 1.0f));
	    float4 _18256 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12132.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m2 * 1.0f)).xyzw);
	    output_0 = _12132;
	    output_1 = float4(_21354, _21355, _19302, _23812.w);
	    _18256.y = -_18256.y;
	    gl_Position = _18256;
	    gl_ClipDistance[0] = dot(float4(_12132.xyz, 1.0f), PerViewConstantBuffer_t_1_m1.xyzw);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    nInstanceIdx = stage_input.nInstanceIdx;
	    vBlendIndices = stage_input.vBlendIndices;
	    vPositionOs = stage_input.vPositionOs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.gl_ClipDistance0.x = gl_ClipDistance[0];
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_PREMULTIPLY_BY_ALPHA_AND_ACCUMULATE_ONE_MINUS_ALPHA, F_PREMULTIPLY_BY_ALPHA_AND_ACCUMULATE_ONE_MINUS_ALPHA );
	StaticCombo( S_BLEND_MODE, F_BLEND_MODE );
	StaticCombo( S_PLAYER_VISIBILITY_DATA_COLOR, F_PLAYER_VISIBILITY_DATA_COLOR );
	StaticComboRule( Allow1( S_BLEND_MODE, S_PREMULTIPLY_BY_ALPHA_AND_ACCUMULATE_ONE_MINUS_ALPHA ) );
	StaticComboRule( Allow1( S_PLAYER_VISIBILITY_DATA_COLOR, S_MODE_TOOLS_WIREFRAME ) );
	StaticComboRule( Allow1( S_PLAYER_VISIBILITY_DATA_COLOR, S_PREMULTIPLY_BY_ALPHA_AND_ACCUMULATE_ONE_MINUS_ALPHA ) );
	StaticComboRule( Allow1( S_PLAYER_VISIBILITY_DATA_COLOR, S_BLEND_MODE ) );
	
	RenderState(BlendEnable, true);
	RenderState(ColorWriteEnable0, (F_WRITE_TO_DESTALPHA || F_PLAYER_VISIBILITY_DATA_COLOR) ? All : R|G|B);
	RenderState(DepthFunc, F_IGNOREZ ? Always : LessEqual);
	RenderState(DepthWriteEnable, F_DISABLE_Z_WRITE ? false : true);
	RenderState(DstBlend, One);
	RenderState(SrcBlend, One);
	RenderState(SrcBlendAlpha, Zero);
	RenderState(StencilEnable, F_DISABLE_STENCIL_WRITE ? false : true);
	RenderState(StencilPassOp, Replace);
	RenderState(StencilRef, 1);
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4 g_vPlayerDataVisibility < Attribute("g_vPlayerDataVisibility"); UiType(VectorText); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _1;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float3 _Globals_1_g_vColorTint : packoffset(c0);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float PerViewConstantBuffer_t_1_m0 : packoffset(c18);
	};
	
	
	static float4 input_1;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_1 : TEXCOORD1;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _13043 = _Globals_1_g_vColorTint.xyz * input_1.xyz;
	    float4 _13888;
	    _13888.x = _13043.x;
	    _13888.y = _13043.y;
	    _13888.z = _13043.z;
	    output_0 = float4(_13888.xyz * PerViewConstantBuffer_t_1_m0, input_1.w);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(SupportsMappingDimensions, true);
	
}
