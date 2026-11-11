//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Environment shader with blended layers";
	DevShader = false;
	Version = 5;
	
	// Platform: VULKAN_SM_60
	// Programs: ps, vs, rtx, psrs
}

MODES
{
	CsgoForward();
	RayTrace();
	Depth(S_MODE_DEPTH);
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_DETAIL_NORMAL, 0..1, "Detail" );
	Feature( F_WETNESS, 0..1, "Wetness" );
	Feature( F_MATERIAL_REFERENCE, 0..1, "Create Variation" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_OCCLUSION_CULLING_BOUNDS_SCALE, 0..1, "Z-Buffering" );
	Feature( F_PIXEL_DEPTH_OFFSET, 0..1, "Pixel Depth Offset" );
	Feature( F_PARALLAX_OCCLUSION, 0..1, "Parallax Occlusion" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_PIXEL_DEPTH_OFFSET, F_ALPHA_TEST ), "Pixel Depth Offset is not compatible with alpha test" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_MODE_DEPTH=0, D_CS_VERTEX_ANIMATION=1, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST_LAYER=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;        
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;               
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;            // S_MODE_DEPTH=0, D_CS_VERTEX_ANIMATION=1, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST_LAYER=1
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_MODE_DEPTH=0, D_CS_VERTEX_ANIMATION=1, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST_LAYER=1
	float4 vColorBlendValues          : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;    // S_MODE_DEPTH=0, D_CS_VERTEX_ANIMATION=1, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST_LAYER=1
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_MATERIAL_REFERENCE, F_MATERIAL_REFERENCE );
	StaticCombo( S_PIXEL_DEPTH_OFFSET, F_PIXEL_DEPTH_OFFSET );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST_LAYER, F_ALPHA_TEST );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
	StaticComboRule( Allow1( S_PIXEL_DEPTH_OFFSET, S_ALPHA_TEST_LAYER ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression(g_nScaleTexCoordUByModelScaleAxis!=0 || g_nScaleTexCoordVByModelScaleAxis!=0); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vDetailTexCoordXform0_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale1.x,-v2*g_vDetailTexCoordScale1.y,0,g_vDetailTexCoordCenter1.x+g_vDetailTexCoordOffset1.x+v2*g_vDetailTexCoordCenter1.y-v1*g_vDetailTexCoordCenter1.x)); >;
	float4 g_vDetailTexCoordXform1_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale1.x,v1*g_vDetailTexCoordScale1.y,0,g_vDetailTexCoordCenter1.y+g_vDetailTexCoordOffset1.y-(v2*g_vDetailTexCoordCenter1.x+v1*g_vDetailTexCoordCenter1.y))); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordXform0_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale1.x,-v2*g_vTexCoordScale1.y,0,g_vTexCoordCenter1.x+g_vTexCoordOffset1.x+v2*g_vTexCoordCenter1.y-v1*g_vTexCoordCenter1.x)); >;
	float4 g_vTexCoordXform1_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale1.x,v1*g_vTexCoordScale1.y,0,g_vTexCoordCenter1.y+g_vTexCoordOffset1.y-(v2*g_vTexCoordCenter1.x+v1*g_vTexCoordCenter1.y))); >;
	
	// Material1
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vDetailTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/9"); UiVisibility(1); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
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
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float3 _Globals_1_g_vColorTint : packoffset(c15);
	    float _Globals_1_g_flModelTintAmount : packoffset(c15.w);
	    int _Globals_1_g_nUVSet1 : packoffset(c18);
	    float4 _Globals_1_g_vTexCoordXform0_1 : packoffset(c20);
	    float4 _Globals_1_g_vTexCoordXform1_1 : packoffset(c21);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space0)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c35);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float2 vTexCoord2;
	static float3 vNormalOs;
	static float4 vTangentUOs_flTangentVSign;
	static uint4 vBlendIndices;
	static uint nInstanceIdx;
	static float4 vBlendColorTint;
	static float4 vColorBlendValues;
	static float4 output_0;
	static float4 output_1;
	static float3 output_2;
	static float3 output_3;
	static float4 output_4;
	static float4 output_5;
	static float3 output_6;
	static float4 output_7;
	static uint output_8;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : POSITION0;
	    float2 vTexCoord : TEXCOORD0;
	    float2 vTexCoord2 : TEXCOORD1;
	    float3 vNormalOs : NORMAL0;
	    float4 vTangentUOs_flTangentVSign : TANGENT0;
	    uint4 vBlendIndices : BLENDINDICES0;
	    uint nInstanceIdx : TEXCOORD13;
	    float4 vBlendColorTint : COLOR0;
	    float4 vColorBlendValues : TEXCOORD4;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float3 output_3 : TEXCOORD3;
	    float4 output_4 : TEXCOORD4;
	    centroid float4 output_5 : TEXCOORD5;
	    centroid float3 output_6 : TEXCOORD6;
	    float4 output_7 : TEXCOORD7;
	    nointerpolation uint output_8 : TEXCOORD8;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _13771 = (g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4);
	    }
	    float3x4 _12618 = float3x4(g_transformBuffer.Load<float4>(_21785 * 48 + 0), g_transformBuffer.Load<float4>(_21785 * 48 + 16), g_transformBuffer.Load<float4>(_21785 * 48 + 32));
	    float3 _21709;
	    if (_13771 > 0u)
	    {
	        float3x4 _25207 = float3x4(g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 0), g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 16), g_transformBuffer.Load<float4>(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 4) * 48 + 32));
	        _21709 = _25207[0].z.xxx;
	    }
	    else
	    {
	        _21709 = 1.0f.xxx;
	    }
	    float4 _23812 = float4(uint4(g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 0) & 255u, (g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
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
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    float3 _11179 = normalize(mul(_12618, float4(vNormalOs.xyz, 0.0f)));
	    float3 _12151 = mul(_12618, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _18237 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float4 _9337 = vTexCoord.xyxy;
	    _9337.z = vTexCoord2.x;
	    _9337.w = vTexCoord2.y;
	    float4 _18606;
	    if (_Globals_1_g_nUVSet1 > 0)
	    {
	        bool2 _6474 = (_Globals_1_g_nUVSet1 == 2).xx;
	        float4 _11399 = float4(float2(_6474.x ? _9337.zw.x : _9337.xy.x, _6474.y ? _9337.zw.y : _9337.xy.y), vTexCoord2);
	        float2 _9573 = _11399.xy;
	        float4 _16823 = _11399;
	        _16823.x = dot(_9573, _Globals_1_g_vTexCoordXform0_1.xy) + _Globals_1_g_vTexCoordXform0_1.w;
	        _16823.y = dot(_9573, _Globals_1_g_vTexCoordXform1_1.xy) + _Globals_1_g_vTexCoordXform1_1.w;
	        _18606 = _16823;
	    }
	    else
	    {
	        _18606 = _9337;
	    }
	    float4 _11323 = float4(_Globals_1_g_vColorTint, _23812.w * g_instanceBuffer.Load<float>(nInstanceIdx * 32 + 28));
	    float3 _14119 = _11323.xyz * lerp(1.0f.xxx, vBlendColorTint.xyz, vBlendColorTint.w.xxx);
	    float4 _23714 = _11323;
	    _23714.x = _14119.x;
	    _23714.y = _14119.y;
	    _23714.z = _14119.z;
	    output_0 = float4(_21354, _21355, _17978, _Globals_1_g_flModelTintAmount * (1.0f - min(_21354, min(_21355, _17978))));
	    output_1 = float4(vColorBlendValues.xyz, max(min(vColorBlendValues.w, 1.0f), 0.001000000047497451305389404296875f));
	    output_2 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_3 = _11179;
	    output_4 = _18606;
	    output_5 = _23714;
	    output_6 = _11179;
	    output_7 = float4(normalize(mul(_12618, float4(vTangentUOs_flTangentVSign.xyz, 0.0f))), vTangentUOs_flTangentVSign.w);
	    output_8 = g_instanceBuffer.Load<uint>(nInstanceIdx * 32 + 20) & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vTexCoord2 = stage_input.vTexCoord2;
	    vNormalOs = stage_input.vNormalOs;
	    vTangentUOs_flTangentVSign = stage_input.vTangentUOs_flTangentVSign;
	    vBlendIndices = stage_input.vBlendIndices;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    vBlendColorTint = stage_input.vBlendColorTint;
	    vColorBlendValues = stage_input.vColorBlendValues;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    stage_output.output_5 = output_5;
	    stage_output.output_6 = output_6;
	    stage_output.output_7 = output_7;
	    stage_output.output_8 = output_8;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0)) ? 1 : 0);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(VertexPaintUIPuddles, (F_WETNESS==1) ? 1 : 0);
	BoolAttribute(SupportsAggregateInstancing, true);
	
	#if (S_MATERIAL_REFERENCE == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerType, csgo_environment);
	#endif
}

PS
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_MATERIAL_REFERENCE, F_MATERIAL_REFERENCE );
	StaticCombo( S_PIXEL_DEPTH_OFFSET, F_PIXEL_DEPTH_OFFSET );
	StaticCombo( S_ALPHA_TEST_LAYER, F_ALPHA_TEST );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_PARALLAX_OCCLUSION, F_PARALLAX_OCCLUSION );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_PIXEL_DEPTH_OFFSET, S_ALPHA_TEST_LAYER ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_ALPHA_TEST_PREPASS, 0..1 );
	DynamicCombo( D_PARALLAX_OCCLUSION, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY==1 ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST_LAYER, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_SPECULAR_CUBE_MAP_STATIC ) );
	DynamicComboRule( Requires( D_ALPHA_TEST_PREPASS, S_ALPHA_TEST_LAYER ) );
	DynamicComboRule( Requires( D_PARALLAX_OCCLUSION, S_PARALLAX_OCCLUSION ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_PARALLAX_OCCLUSION ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bAdjustBaseColor1 < UiType(CheckBox); Expression(g_nColorCorrectionMode1==1); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	bool g_bWetness < UiType(CheckBox); Expression((F_WETNESS==1) ? 1 : 0); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(1,1,1),TextureAverageColor(g_tColor1)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal1 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal1, TextureRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	float3 g_vBiplanarTexCoordScale < UiType(VectorText); Expression(1/64*float3(-1,1,-1)); >;
	float4 g_vDetailNormalXform_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float3 g_vFlatOverlayColor < Default3(1, 0, 1); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vNormalXform_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Material1
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Material1,0/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask1, Linear, 8, "", "_mask", "Material1/Tint Mask,15/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureTranslucency1, Linear, 8, "", "_trans", "Material1/Translucent,15/0", Default4(1, 1, 1, 0));
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float g_fTintMaskBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Tint Mask/5"); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight1, Linear, 8, "", "_height", "Material1/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast1 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material1/Tint Mask/10"); >;
	float g_flParallaxStrength1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Parallax Occlusion,32/10"); >;
	float3 g_vTextureColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/11"); >;
	float g_fTextureRoughnessBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/12"); >;
	float g_fTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Lighting/13"); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	bool g_bMetalness1 < Default(1); UiType(CheckBox); UiGroup("Material1/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Lighting,20/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flSnowGlintStrength1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Snow,100/20"); UiVisibility(g_bSnowLayer1); >;
	float3 g_vAmbientOcclusionLevels1 < Default3(0, 0.5, 1); Range(-1, 1); Attribute("0=Option 1,1=Option 2,2=Option 3"); UiType(VectorText); UiGroup("Material1/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	float g_flHeightMapZeroPoint1 < Default(0.5); UiType(Slider); UiGroup("Material1/Height/30"); >;
	CreateInputTexture2D(TextureNormalDetail1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	float g_fDetailTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Detail/45"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength1 < Default(1); UiType(Slider); UiGroup("Material1/Lighting/61"); >;
	float g_flPDOScale1 < Default(1); Range(-3, 3); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/80"); >;
	float g_flPDOOffset1 < Range(-1, 1); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/90"); >;
	float g_flPDOContactAoDistance1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/91"); >;
	float g_flPDOContactAoStrength1 < Default(0.3); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/92"); >;
	float g_flPDOSoftIntersectionWidth1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/93"); >;
	bool g_bSnowLayer1 < UiType(CheckBox); UiGroup("Material1/Snow,100"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Wetness
	bool g_bWetnessUseHeightmapAdjustments < UiType(CheckBox); UiGroup("Wetness/2"); UiVisibility(F_WETNESS ? 1 : 0); >;
	bool g_bPuddlesOnVerticalSurfaces < UiType(CheckBox); UiGroup("Wetness,9/3"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleStrength < Default(1); UiType(Slider); UiGroup("Wetness/5"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float3 g_vPuddleSedimentColor < Default3(0.62, 0.56, 0.5); UiType(Color); UiGroup("Wetness/10"); Expression(SrgbGammaToLinear(this)); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleSedimentHeight < Default(0.9); Range(0, 2); UiType(Slider); UiGroup("Wetness/15"); Expression(this*2-1); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleSedimentOpacity < Default(0.25); UiType(Slider); UiGroup("Wetness/16"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleRoughness < Default(0.02); UiType(Slider); UiGroup("Wetness/17"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleBlendSoftness < Default(0.08); UiType(Slider); UiGroup("Wetness/18"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetEdgeStrength < Default(0.5); UiType(Slider); UiGroup("Wetness/20"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetEdgeSpread < Default(0.2); UiType(Slider); UiGroup("Wetness/25"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetnessStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/30"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fRainStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/35"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fRippleStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/40"); UiVisibility(F_WETNESS ? 1 : 0); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Color
	float g_flBlendSoftnessDistanceModifierStrength < Default(1); UiType(Slider); UiGroup("Color/120"); >;
	
	// Occlusion Culling
	float g_flOcclusionCullingBoundsScale < Default(1); Range(1, 100); UiType(Slider); UiGroup("Occlusion Culling"); UiVisibility(F_OCCLUSION_CULLING_BOUNDS_SCALE); >;
	
	// Snow
	float g_flSnowGlintIntensity < Default(1); Range(0, 4); UiType(Slider); UiGroup("Snow,10/Glints,10/1"); >;
	float g_flSnowGlintSparkle < Default(1); Range(0, 8); UiType(Slider); UiGroup("Snow,10/Glints,10/2"); >;
	float g_flSnowGlintTwinkleAmount < Default(0.02); Range(0, 0.5); UiType(Slider); UiGroup("Snow,10/Glints,10/3"); >;
	float g_flSnowGlintTwinkleSpeed < Default(5); Range(0, 10); UiType(Slider); UiGroup("Snow,10/Glints,10/4"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_PIXEL_DEPTH_OFFSET == 0)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_MODE_DEPTH == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_SHADER_QUALITY == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_PARALLAX_OCCLUSION == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST_LAYER == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_MODE_TOOLS_VIS == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(1,1,1),TextureAverageColor(g_tColor1)))); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 5 (name: g_vBiplanarTexCoordScale) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#if defined(GL_EXT_control_flow_attributes)
	#extension GL_EXT_control_flow_attributes : require
	#define SPIRV_CROSS_FLATTEN [[flatten]]
	#define SPIRV_CROSS_BRANCH [[dont_flatten]]
	#define SPIRV_CROSS_UNROLL [[unroll]]
	#define SPIRV_CROSS_LOOP [[dont_unroll]]
	#else
	#define SPIRV_CROSS_FLATTEN
	#define SPIRV_CROSS_BRANCH
	#define SPIRV_CROSS_UNROLL
	#define SPIRV_CROSS_LOOP
	#endif
	#extension GL_KHR_shader_subgroup_arithmetic : require
	
	const vec3 _2509[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _1322[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
	struct _911
	{
	    vec4 _m0[3];
	};
	
	struct _1121
	{
	    vec4 _m0[4];
	};
	
	struct _767
	{
	    mat4 _m0[4];
	};
	
	struct _200
	{
	    mat4 _m0;
	    mat4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec3 _m6;
	    uint _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    mat4x3 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	    mat4 _m23;
	};
	
	float _4;
	vec3 _5;
	vec4 _6;
	float _7;
	
	struct _571
	{
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    uint g_sUserConfig;
	    uint g_tColor1;
	    vec3 g_vBiplanarTexCoordScale;
	    int g_bSnowLayer1;
	    float g_flSnowGlintStrength1;
	    int g_nUVSet1;
	    vec2 g_vTexCoordScale1;
	    vec4 g_vNormalXform_1;
	    float g_flWetnessDarkeningStrength1;
	    uint g_tNormal1;
	    uint g_tHeight1;
	    mat4 g_mTextureColorAdjust1;
	    int g_bPuddlesOnVerticalSurfaces;
	    int g_bWetnessUseHeightmapAdjustments;
	    float g_fPuddleStrength;
	    vec3 g_vPuddleSedimentColor;
	    float g_fPuddleSedimentHeight;
	    float g_fPuddleSedimentOpacity;
	    float g_fPuddleRoughness;
	    float g_fPuddleBlendSoftness;
	    float g_fWetEdgeStrength;
	    float g_fWetEdgeSpread;
	    float g_fWetnessStrength;
	    float g_fRainStrength;
	    float g_fRippleStrength;
	    float g_flSnowGlintIntensity;
	    float g_flSnowGlintSparkle;
	    float g_flSnowGlintTwinkleAmount;
	    float g_flSnowGlintTwinkleSpeed;
	    uint g_sCookieSampler;
	    uint g_tShadowDepthBufferCmpSampler;
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    int g_bWetness;
	};
	
	layout(set = 1) uniform _571 _Globals_;
	
	struct _558
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    float _m8;
	    float _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    mat4 _m13;
	    vec2 _m14;
	    float _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    mat4 _m22;
	    vec4 _m23;
	    vec4 _m24;
	    vec4 _m25;
	};
	
	layout(set = 1) uniform _558 PerViewConstantBufferCsgo_t;
	
	struct _1263
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    vec3 _m4;
	};
	
	layout(set = 1) uniform _1263 PerViewConstantBuffer_t;
	
	struct _1852
	{
	    _911 _m0;
	    _1121 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    uvec4 _m5;
	    uvec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    int _m11;
	    float _m12;
	    vec4 _m13;
	    float _m14;
	    float _m15;
	    float _m16;
	    float _m17;
	    _767 _m18;
	    _1121 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _1852 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(set = 4, binding = 29) uniform samplerShadow g_bindless_Sampler_1[2048];
	layout(set = 4, binding = 46) uniform texture3D g_bindless_Texture3D_float4[65536];
	layout(set = 4, binding = 46) uniform textureCubeArray g_bindless_TextureCubeArray_float4[65536];
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube_float4[65536];
	
	layout(location = 0) in vec4 input_0;
	layout(location = 1) in vec4 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 3) in vec3 input_3;
	layout(location = 4) in vec4 input_4;
	layout(location = 5) centroid in vec4 input_5;
	layout(location = 6) centroid in vec3 input_6;
	layout(location = 7) in vec4 input_7;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    _11408.w = 1.0 / _11408.w;
	    vec3 _21709;
	    if (dot(input_3.xyz, input_3.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_6.xyz;
	    }
	    else
	    {
	        _21709 = input_3.xyz;
	    }
	    bool _14874 = _Globals_.g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _10251;
	    SPIRV_CROSS_BRANCH
	    if (_12885)
	    {
	        _10251 = _21709 * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    vec3 _24347 = normalize(_10251);
	    vec3 _10061 = input_2 + PerViewConstantBufferCsgo_t._m25.xyz;
	    bool _7312 = _Globals_.g_nUVSet1 > 1;
	    vec3 _22993 = _10061 - PerViewConstantBuffer_t._m4.xyz;
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _18545;
	    if (_12886)
	    {
	        _18545 = !gl_FrontFacing;
	    }
	    else
	    {
	        _18545 = false;
	    }
	    vec3 _7147 = dFdxFine(_22993);
	    vec3 _20949 = dFdyFine(_22993);
	    float _12157 = 1.0 / length(input_3);
	    vec3 _11587 = input_3 * _12157;
	    vec3 _8889;
	    if (_18545)
	    {
	        _8889 = _11587 * (-1.0);
	    }
	    else
	    {
	        _8889 = _11587;
	    }
	    vec3 _10247;
	    vec3 _11711;
	    if (_7312)
	    {
	        vec2 _13939 = dFdxFine(input_4.zw);
	        vec2 _13915 = dFdyFine(input_4.zw);
	        float _17522 = _13915.y;
	        float _15279 = dot(_13939, vec2(_17522, -_13915.x));
	        float _17298 = (_15279 < 0.0) ? (-1.0) : 1.0;
	        vec2 _24530 = vec2(_17522, -_13939.y) * _17298;
	        vec3 _7463 = ((_7147 - (_8889 * dot(_7147, _8889))) * _24530.x) + ((_20949 - (_8889 * dot(_20949, _8889))) * _24530.y);
	        vec3 _9082;
	        if (abs(_15279) > 0.0)
	        {
	            _9082 = normalize(_7463);
	        }
	        else
	        {
	            _9082 = _7463;
	        }
	        _11711 = _9082;
	        _10247 = cross(_8889, _9082) * (_17298 * float((dot(_20949, cross(_8889, _7147)) < 0.0) ? (-1) : 1));
	    }
	    else
	    {
	        _11711 = vec3(0.0);
	        _10247 = vec3(0.0);
	    }
	    bool _8452 = _Globals_.g_nUVSet1 == 0;
	    vec2 _6616;
	    ivec2 _13136;
	    vec2 _13694;
	    ivec2 _16305;
	    vec2 _17114;
	    vec2 _17115;
	    vec2 _17116;
	    vec2 _17117;
	    vec2 _17118;
	    if (_8452)
	    {
	        vec3 _10577 = abs(_24347);
	        vec3 _16100 = _10577;
	        float _17349 = _10577.x;
	        float _8043 = _10577.y;
	        bool _12887;
	        if (_17349 > _8043)
	        {
	            _12887 = _17349 > _10577.z;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        ivec3 _23727;
	        if (_12887)
	        {
	            _23727 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            _23727 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_8043 > _10577.z));
	        }
	        bool _12888;
	        if (_17349 < _8043)
	        {
	            _12888 = _17349 < _10577.z;
	        }
	        else
	        {
	            _12888 = false;
	        }
	        ivec3 _11775;
	        if (_12888)
	        {
	            _11775 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            _11775 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_8043 < _10577.z));
	        }
	        ivec3 _19442 = (ivec3(3) - _11775) - _23727;
	        ivec2 _19321;
	        if (_23727.x == 1)
	        {
	            _19321 = _23727.zy;
	        }
	        else
	        {
	            _19321 = _23727.yz;
	        }
	        int _9992 = _19442.x;
	        ivec2 _19322;
	        if (_9992 == 1)
	        {
	            _19322 = _19442.zy;
	        }
	        else
	        {
	            _19322 = _19442.yz;
	        }
	        vec2 _19651 = saturate((vec2(_16100[_23727.x], _16100[_9992]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625));
	        vec3 _18781 = _10061 * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        vec3 _16414 = _18781;
	        vec3 _16415 = dFdxFine(_18781);
	        vec3 _16446 = dFdyFine(_18781);
	        _13136 = _19321;
	        _16305 = _19322;
	        _17114 = vec2(_16414[_19321.x], _16414[_19321.y]);
	        _17115 = vec2(_16414[_19322.x], _16414[_19322.y]);
	        _17116 = vec2(_16415[_19321.x], _16415[_19321.y]);
	        _17117 = vec2(_16446[_19321.x], _16446[_19321.y]);
	        _17118 = vec2(_16415[_19322.x], _16415[_19322.y]);
	        _13694 = vec2(_16446[_19322.x], _16446[_19322.y]);
	        _6616 = _19651 / vec2(_19651.x + _19651.y);
	    }
	    else
	    {
	        _13136 = ivec2(0);
	        _16305 = ivec2(0);
	        _17114 = vec2(0.0);
	        _17115 = vec2(0.0);
	        _17116 = vec2(0.0);
	        _17117 = vec2(0.0);
	        _17118 = vec2(0.0);
	        _13694 = vec2(0.0);
	        _6616 = vec2(0.0);
	    }
	    vec3 _18905;
	    _18905.x = input_4.x;
	    _18905.y = input_4.y;
	    vec4 _9716;
	    vec3 _24878;
	    if (_8452)
	    {
	        _9716 = vec4(0.0);
	        _24878 = _18905;
	    }
	    else
	    {
	        vec4 _8625 = vec4(dFdx(_18905.xy), dFdy(_18905.xy));
	        vec2 _20312 = _18905.xy + vec2(length(_8625) * 1.0000000133514319600180897396058e-10);
	        vec3 _20488;
	        _20488.x = _20312.x;
	        _20488.y = _20312.y;
	        _9716 = _8625;
	        _24878 = _20488;
	    }
	    vec4 _19323;
	    if (_8452)
	    {
	        _19323 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17114 * _Globals_.g_vTexCoordScale1.xy).xy, (_17116 * _Globals_.g_vTexCoordScale1.xy).xy, (_17117 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17115 * _Globals_.g_vTexCoordScale1.xy).xy, (_17118 * _Globals_.g_vTexCoordScale1.xy).xy, (_13694 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.y);
	    }
	    else
	    {
	        _19323 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy).xyzw;
	    }
	    float _21710;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.g_bWetnessUseHeightmapAdjustments != 0)
	    {
	        _21710 = max(0.0, _19323.x);
	    }
	    else
	    {
	        _21710 = _19323.x;
	    }
	    float _13138;
	    vec3 _13189;
	    vec4 _22057;
	    if (_8452)
	    {
	        vec2 _8315 = (_17114 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _7412 = (_17116 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _8903 = (_17117 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec4 _23806 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _8315, _7412, _8903) * _6616.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _8315, _7412, _8903);
	        float _18178 = _12167.z * _6616.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _21631 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _6616.x;
	        vec3 _24466 = (_2509[_13136.x] * _21631.x) + (_1322[_13136.y] * _21631.y);
	        float _13137;
	        vec3 _13753;
	        vec4 _14101;
	        if (_6616.y > 0.0)
	        {
	            vec2 _17047 = (_17115 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10017 = (_17118 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8904 = (_13694 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _17047, _10017, _8904);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _21632 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _6616.y;
	            _13137 = _18178 + (_12168.z * _6616.y);
	            _14101 = _23806 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _17047, _10017, _8904) * _6616.y);
	            _13753 = _24466 + ((_2509[_16305.x] * _21632.x) + (_1322[_16305.y] * _21632.y));
	        }
	        else
	        {
	            _13137 = _18178;
	            _14101 = _23806;
	            _13753 = _24466;
	        }
	        _13138 = _13137;
	        _13189 = normalize(_13753 + _24347);
	        _22057 = _14101;
	    }
	    else
	    {
	        vec4 _11179 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw);
	        float _6493 = _11179.x;
	        float _14881 = _11179.y;
	        float _16783 = (_6493 + _14881) - 1.00392162799835205078125;
	        float _11176 = _6493 - _14881;
	        vec3 _15162 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	        vec2 _20890 = _15162.xy;
	        float _7796 = dot(_20890, _Globals_.g_vNormalXform_1.xy);
	        float _19701 = dot(_20890, _Globals_.g_vNormalXform_1.zw);
	        vec3 _19582 = _15162;
	        _19582.x = _7796;
	        _19582.y = _19701;
	        bvec3 _20662 = bvec3(_7312);
	        vec3 _10844 = abs(_19582.xyz);
	        vec2 _16475 = (-vec2(_7796, (-1.0) * _19701)) / vec2(max(_10844.z, 0.0078125 * max(_10844.x, _10844.y)));
	        _13138 = _11179.z;
	        _13189 = normalize(_8889 - ((mix(input_7.xyz * _12157, _11711, _20662) * _16475.x) + (mix((cross(input_3, input_7.xyz) * ((input_7.w > 0.0) ? 1.0 : (-1.0))) * _12157, _10247, _20662) * _16475.y)));
	        _22057 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw).xyzw;
	    }
	    vec3 _19225 = normalize(_13189);
	    float _6375 = saturate(_13138);
	    float _14713 = saturate(mix(0.0, 1.0, pow(_22057.w, 1.0)));
	    float _7029 = saturate(_19323.y);
	    vec3 _25191 = mix(_22057.xyz, vec4((vec4(_22057.xyz, 1.0) * _Globals_.g_mTextureColorAdjust1).xyz, _4).xyz, vec3(_7029));
	    vec4 _17842;
	    _17842.x = _25191.x;
	    _17842.y = _25191.y;
	    _17842.z = _25191.z;
	    float _24323 = dot(_17842.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(input_0.xyz, vec3(0.001000000047497451305389404296875)));
	    bool _21618 = _Globals_.g_bSnowLayer1 != 0;
	    vec3 _6756 = _19225.xyz;
	    float _24969 = float(_21618);
	    vec2 _16795 = vec2(_6375);
	    vec3 _16488 = vec4(saturate(mix(_17842.xyz, (_9577 * min(_24323 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24323) * max(input_0.x, max(input_0.y, input_0.z)))).xyz, vec3(input_0.w * _7029))).xyz, _7).xyz * mix(vec3(1.0), input_5.xyz, vec3(saturate(_7029)));
	    bool _12889;
	    if (_Globals_.g_bWetness != 0)
	    {
	        _12889 = (_Globals_.g_fPuddleStrength + _Globals_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _12889 = false;
	    }
	    bool _12890;
	    if (_12889)
	    {
	        _12890 = input_1.z > 0.0;
	    }
	    else
	    {
	        _12890 = false;
	    }
	    vec3 _6618;
	    vec3 _13141;
	    vec3 _13695;
	    float _16306;
	    float _17119;
	    float _17120;
	    vec2 _17121;
	    SPIRV_CROSS_BRANCH
	    if (_12890)
	    {
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_1.z, saturate(PerViewConstantBufferCsgo_t._m11)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m12 - 0.5) * 2.0));
	        float _20426 = saturate(_23204 - 0.75);
	        float _8284 = _23204 + (4.0 * (_20426 * _20426));
	        float _16777 = _8284 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8284 * 20.0);
	        vec4 _9717;
	        float _24879;
	        SPIRV_CROSS_BRANCH
	        if (_Globals_.g_bPuddlesOnVerticalSurfaces != 0)
	        {
	            vec4 _9186 = vec4(0.0, 0.0, 1.0, 0.0);
	            _9186.x = _24347.x;
	            _9186.y = _24347.y;
	            _9186.z = _21302;
	            _9717 = _9186;
	            _24879 = max(0.0, _16777);
	        }
	        else
	        {
	            _9717 = vec4(0.0, 0.0, 1.0, 0.0);
	            _24879 = max(0.0, (_8284 * _14498) - _Globals_.g_fWetEdgeSpread);
	        }
	        float _15811 = max(0.001000000047497451305389404296875, _Globals_.g_fPuddleBlendSoftness);
	        float _14611 = smoothstep(_24879 + _15811, _24879 - (input_1.w + (_15811 * 2.0)), _21710) * _11964;
	        float _19808 = max((smoothstep(_23204, _16777 - (0.20000000298023223876953125 * _8284), _21710) * _Globals_.g_fWetEdgeStrength) * _11964, _14611) * _Globals_.g_fPuddleStrength;
	        float _17924 = (_23204 - 1.0) - _21710;
	        float _10334 = (saturate(_17924 + _Globals_.g_fPuddleSedimentHeight) * _Globals_.g_fPuddleSedimentOpacity) * _14611;
	        float _13706 = saturate(((saturate((((_8284 * 2.0) - (mix(0.5, _19372.w, saturate(_14498 * 20.0)) * 0.5)) - (_21710 * 0.5)) + 0.25) * _Globals_.g_fWetnessStrength) * _11964) + _14611);
	        float _13140;
	        float _13151;
	        vec4 _23607;
	        SPIRV_CROSS_BRANCH
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m9;
	            vec3 _6617;
	            vec4 _12891;
	            float _13139;
	            SPIRV_CROSS_BRANCH
	            if (_12497 > 0.0)
	            {
	                vec3 _18756 = normalize(vec3(-1.0, 0.20000000298023223876953125, 0.0));
	                float _9925 = PerViewConstantBufferCsgo_t._m10 * 6.283185482025146484375;
	                float _22373 = sin(_9925);
	                float _20617 = cos(_9925);
	                vec2 _23932 = _18756.xy * mat2(vec2(_20617, -_22373), vec2(_22373, _20617));
	                vec3 _22900 = _18756;
	                _22900.x = _23932.x;
	                _22900.y = _23932.y;
	                vec3 _21326 = -cross(_22900, _24347);
	                vec3 _13887 = _10061.xyz;
	                float _9965 = dot(_13887, _21326);
	                float _12056 = 1.0 - input_1.z;
	                vec2 _20274 = ((vec2(dot(_13887, _22900)) + (vec2(0.100000001490116119384765625, -0.100000001490116119384765625) * _9965)) + (vec2(8.0, 5.0) * _10061.z)) + vec2((_12056 * _12056) * (-80.0));
	                vec2 _15991 = vec2(_20274.x, _9965) * vec2(0.0199999995529651641845703125, 0.010999999940395355224609375);
	                vec4 _20877 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                vec2 _18922 = (_20877.xy * 2.0) - vec2(1.0);
	                float _22216 = saturate(length(fwidth(_15991)) * 10.0);
	                vec2 _15297 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_1.z) * mix(1.0, 0.300000011920928955078125, _22216);
	                vec2 _13711 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _15297);
	                _19601.y = dot(_13711, _15297);
	                vec2 _16046 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _20878 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_16046 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                vec2 _17104 = (((_20878.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_1.z;
	                _17104.y = _17104.y * 0.5;
	                float _9250 = saturate(length(fwidth(_16046)) * 10.0);
	                vec2 _13560 = _17104 * mix(1.0, 0.300000011920928955078125, _9250);
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _13560), dot(_13711, _13560));
	                vec4 _20489 = _19601;
	                _20489.x = _13330.x;
	                _20489.y = _13330.y;
	                _20489.w = input_1.z * (_20877.z + _20878.z);
	                vec3 _20490;
	                _20490.x = _10061.x;
	                _20490.y = _10061.y;
	                _13139 = _12497 * (0.039999999105930328369140625 * (_22216 + _9250));
	                _12891 = _9717 + ((_20489 * _14498) * _12497);
	                _6617 = _20490;
	            }
	            else
	            {
	                _13139 = 0.0;
	                _12891 = _9717;
	                _6617 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m8;
	            float _9982;
	            vec4 _21594;
	            SPIRV_CROSS_BRANCH
	            if (_8914 > 0.0)
	            {
	                vec2 _10473 = _6617.xy * 0.119999997317790985107421875;
	                vec3 _20506 = vec3(PerViewConstantBuffer_t._m0 * 6.5) + vec3(0.0, 0.3167000114917755126953125, 0.633400022983551025390625);
	                vec3 _13155;
	                _13155 = vec3(0.0);
	                int _18440;
	                vec3 _25251;
	                int _16208 = 0;
	                SPIRV_CROSS_UNROLL
	                for (;;)
	                {
	                    if (!(_16208 < 3))
	                    {
	                        break;
	                    }
	                    vec3 _23854 = vec3(0.97130000591278076171875, 0.751800000667572021484375, 0.362399995326995849609375);
	                    vec3 _16408 = vec3(0.23770000040531158447265625, 0.65939998626708984375, 0.931999981403350830078125);
	                    mat2 _21666 = mat2(vec2(_23854[_16208], -_16408[_16208]), vec2(_16408[_16208], _23854[_16208]));
	                    vec3 _16409 = vec3(0.60000002384185791015625, 0.666100025177001953125, 0.73220002651214599609375);
	                    float _23410 = _20506[_16208];
	                    vec2 _10212 = ((_21666 * _10473) * _16409[_16208]) + vec2(_23410 * 0.0199999995529651641845703125);
	                    vec2 _7848 = _21666 * ((fract(_10212) * 2.0) - vec2(1.0));
	                    float _8329 = length(_7848);
	                    float _20173 = saturate(1.0 - (_8329 * mix(3.0, 1.0, _14611)));
	                    float _20213 = saturate(1.0 - (_8329 * 6.0));
	                    float _7135 = floor(fract(_10212.x * 0.100000001490116119384765625) * 10.0);
	                    float _23598 = _20506[_16208];
	                    float _18429 = _23598 + ((_7135 + (floor(fract(_10212.y * 0.100000001490116119384765625) * 10.0) * (0.20000000298023223876953125 + _7135))) * 8.0);
	                    _20506[_16208] = _18429;
	                    float _18120 = _8914 * _8914;
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m0 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, saturate(fwidth(_20173) * 20.0)))) * ((saturate((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((saturate((sin((((_20213 + _18429) + 4.0) + (sin(_21710 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0) * _20213) / _18120) * 28.0));
	                    _18440 = _16208 + 1;
	                    _13155 = _25251;
	                    _16208 = _18440;
	                    continue;
	                }
	                vec3 _9348 = _13155 * _14498;
	                vec2 _15752 = _12891.xy + _9348.xy;
	                vec4 _20491 = _12891;
	                _20491.x = _15752.x;
	                _20491.y = _15752.y;
	                _9982 = _9348.z;
	                _21594 = _20491;
	            }
	            else
	            {
	                _9982 = 0.0;
	                _21594 = _12891;
	            }
	            vec3 _10508 = normalize(_21594.xyz);
	            vec4 _16886 = _21594;
	            _16886.x = _10508.x;
	            _16886.y = _10508.y;
	            _16886.z = _10508.z;
	            _13140 = _9982;
	            _13151 = _13139;
	            _23607 = _16886;
	        }
	        else
	        {
	            _13140 = 0.0;
	            _13151 = 0.0;
	            _23607 = _9717;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _23311 = vec3(_19808 * _10334);
	        vec3 _13712 = normalize(mix(_19225.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_16488, pow(_16488, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, saturate((pow(_16488, vec3(0.25)) * (_9038 * _6375)) * 8.0) * _Globals_.g_flWetnessDarkeningStrength1);
	        _13141 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _14713, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, _23311), vec3(1.0 + _13140), vec3(_13140 * 0.100000001490116119384765625));
	        _16306 = mix(_14713, 1.0, _19808);
	        _17119 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _17120 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17121 = saturate(mix(_16795.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13712.xyz)) * 0.5)));
	        _13695 = _13712;
	        _6618 = mix(_6756, _23607.xyz, _23311);
	    }
	    else
	    {
	        _13141 = _16488;
	        _16306 = _14713;
	        _17119 = 0.0;
	        _17120 = _Globals_.g_flReflectance;
	        _17121 = _16795;
	        _13695 = vec3(1.0);
	        _6618 = _6756;
	    }
	    float _12246 = _24969 * _Globals_.g_flSnowGlintStrength1;
	    vec3 _13787 = _10061.xyz;
	    vec3 _14997 = fwidth(_13787);
	    float _24419 = length(_14997);
	    bool _11564 = _12246 > 0.0;
	    float _13142;
	    float _13960;
	    float _16307;
	    vec3 _17124;
	    vec2 _17125;
	    vec3 _24595;
	    SPIRV_CROSS_BRANCH
	    if (_11564)
	    {
	        float _22968 = _12246 * (_Globals_.g_flSnowGlintIntensity * 0.75);
	        uvec3 _16765 = (uvec3(ivec3(floor(_10061))) * uvec3(1664525u)) + uvec3(1013904223u);
	        uint _9762 = _16765.y;
	        uint _22261 = _16765.z;
	        uint _16272 = _16765.x + (_9762 * _22261);
	        uint _24675 = _9762 + (_22261 * _16272);
	        uvec3 _18731 = uvec3(_16272, _24675, _22261 + (_16272 * _24675));
	        uvec3 _14317 = _18731 ^ (_18731 >> uvec3(16u));
	        uint _21164 = _14317.y;
	        uint _14446 = _14317.z;
	        uint _16273 = _14317.x + (_21164 * _14446);
	        uint _24676 = _21164 + (_14446 * _16273);
	        uvec3 _9056 = uvec3(_16273, _24676, _14446 + (_16273 * _24676));
	        uvec3 _7107 = (_9056 * uvec3(1664525u)) + uvec3(1013904223u);
	        uint _9763 = _7107.y;
	        uint _22262 = _7107.z;
	        uint _16274 = _7107.x + (_9763 * _22262);
	        uint _24677 = _9763 + (_22262 * _16274);
	        uvec3 _18732 = uvec3(_16274, _24677, _22262 + (_16274 * _24677));
	        uvec3 _14318 = _18732 ^ (_18732 >> uvec3(16u));
	        uint _21165 = _14318.y;
	        uint _14447 = _14318.z;
	        uint _16275 = _14318.x + (_21165 * _14447);
	        uint _24678 = _21165 + (_14447 * _16275);
	        vec3 _18779 = vec3(uvec3(_16275, _24678, _14447 + (_16275 * _24678)) & uvec3(65535u)) * vec3(1.525902189314365386962890625e-05);
	        vec3 _17975 = vec3(_9056 >> uvec3(ivec3(16))) * vec3(1.525902189314365386962890625e-05);
	        float _23280 = 0.100000001490116119384765625 + (0.1500000059604644775390625 * _17975.y);
	        float _6811 = min(_23280, _24419);
	        float _16301 = (1.0 - smoothstep(_6811 - _24419, _6811 + _24419, length(fract(_10061) - (vec3(0.25) + (_18779 * 0.5))))) * min(4.0, (_23280 * _23280) / (_6811 * _6811));
	        float _15112 = _17975.z;
	        float _9117 = (PerViewConstantBuffer_t._m0 * _Globals_.g_flSnowGlintTwinkleSpeed) * (0.75 + (0.5 * _18779.x));
	        vec3 _22725 = normalize(_6618.xyz + (((((vec3(_9056 & uvec3(65535u)) * vec3(1.525902189314365386962890625e-05)) * 2.0) - vec3(1.0)) + vec3(vec2(sin(_9117 + (_15112 * 6.283185482025146484375)), sin((_9117 * 1.37000000476837158203125) + (_15112 * 13.1946887969970703125))) * _Globals_.g_flSnowGlintTwinkleAmount, 0.0)) * 0.89999997615814208984375));
	        vec3 _8392 = normalize(_22725 + (_6618.xyz * max(0.0, 0.100000001490116119384765625 - dot(_22725, _6618.xyz))));
	        float _12383 = ((saturate(_16301) * pow(saturate(1.0 / max(_24419, 9.9999999747524270787835121154785e-07)), 1.0)) * saturate(_22968)) * saturate(dot(reflect(normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz), _8392), _6618.xyz) * 4.0);
	        vec3 _18229;
	        if (all(equal(_13695, vec3(1.0))))
	        {
	            _18229 = _6618.xyz;
	        }
	        else
	        {
	            _18229 = _13695.xyz;
	        }
	        _13142 = _16301;
	        _16307 = _24419;
	        _17124 = _8392;
	        _17125 = mix(_17121.xy, vec2(mix(0.300000011920928955078125, 0.5, float(_16275 >> uint(16)) * 1.525902189314365386962890625e-05)), vec2(_12383));
	        _13960 = mix(_17120, min(0.300000011920928955078125 * (max(_16301, 1.0) * _22968), 0.89999997615814208984375), _12383);
	        _24595 = normalize(mix(_18229, _8392, vec3(_12383)));
	    }
	    else
	    {
	        _13142 = 0.0;
	        _16307 = 1.0;
	        _17124 = vec3(0.0, 0.0, 1.0);
	        _17125 = _17121;
	        _13960 = _17120;
	        _24595 = _13695;
	    }
	    vec3 _9451 = mix(vec3(_13960).xyz, _13141.xyz, vec3(_19323.w));
	    vec3 _17892 = mix(_24595, _6618, bvec3(all(equal(_24595, vec3(1.0)))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21818 = max(_17125.xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec4 _23875 = vec4(_6618.xyz, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21711;
	    if (_24464.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m15) * PerViewConstantBufferCsgo_t._m14.xy) + (PerViewConstantBufferCsgo_t._m14.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _11086).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m14.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12287 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12287)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m14.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m2.x * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.y * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.z * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.w * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(saturate(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21711 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m3], g_bindless_Sampler[_Globals_.g_sPointClamp]), (_11086 + mix(_23169, PerViewConstantBufferCsgo_t._m14.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21711 = 1.0;
	    }
	    float _8634 = dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _6618.xyz);
	    float _12320;
	    SPIRV_CROSS_BRANCH
	    if (_8634 > (_21618 ? (-0.25) : 0.0))
	    {
	        float _12503;
	        SPIRV_CROSS_BRANCH
	        if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	        {
	            int _23989;
	            int _10191;
	            float _13143;
	            vec3 _14975;
	            int _13039 = 0;
	            for (;;)
	            {
	                if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	                {
	                    _13143 = 1.0;
	                    _14975 = vec3(0.0);
	                    _10191 = -1;
	                    break;
	                }
	                vec4 _18322 = vec4(input_2.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_13039];
	                float _12779 = _18322.x;
	                if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	                {
	                    vec3 _19470 = vec3(_12779, _18322.yz);
	                    vec2 _24804 = _19470.xy;
	                    vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14));
	                    vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                    vec3 _20492 = _19470;
	                    _20492.x = _20561.x;
	                    _20492.y = _20561.y;
	                    _13143 = saturate(_22193.x * _22193.y);
	                    _14975 = _20492;
	                    _10191 = _13039;
	                    break;
	                }
	                _23989 = _13039 + 1;
	                _13039 = _23989;
	                continue;
	            }
	            float _7258;
	            if (_10191 >= 0)
	            {
	                float _18270 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                float _12501;
	                SPIRV_CROSS_BRANCH
	                if (_13143 < 1.0)
	                {
	                    float _7934;
	                    if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                    {
	                        int _15335 = _10191 + 1;
	                        vec4 _19671 = vec4(input_2.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_15335];
	                        vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                        vec3 _20493;
	                        _20493.x = _20562.x;
	                        _20493.y = _20562.y;
	                        _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20493.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                    }
	                    else
	                    {
	                        _7934 = 1.0;
	                    }
	                    _12501 = mix(_7934, _18270, _13143);
	                }
	                else
	                {
	                    _12501 = _18270;
	                }
	                _7258 = _12501;
	            }
	            else
	            {
	                _7258 = 1.0;
	            }
	            float _13279 = mix(_7258, 1.0, saturate((distance(_13787, PerViewConstantBuffer_t._m4) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16));
	            float _12502;
	            if (_24464.y)
	            {
	                _12502 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	            }
	            else
	            {
	                _12502 = _13279;
	            }
	            _12503 = _12502;
	        }
	        else
	        {
	            _12503 = 1.0;
	        }
	        _12320 = _12503;
	    }
	    else
	    {
	        _12320 = 1.0;
	    }
	    vec3 _9718;
	    vec3 _24880;
	    SPIRV_CROSS_BRANCH
	    if ((_8634 * _12320) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _6618.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_6618.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_17119 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m9.xyz);
	            float _8124 = saturate(_17119);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * saturate((_8780 + 0.20000000298023223876953125) * 4.0)) * saturate(mix(dot(mix(_6618.xyz, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m9.xyz), 1.0, _8124))), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_21818, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _12320).xyz;
	        _9718 = ((_9451.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24880 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18223.xyz * _16808);
	    }
	    else
	    {
	        _9718 = vec3(0.0);
	        _24880 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    vec4 _19363;
	    if (_20059)
	    {
	        vec4 _18621 = vec4(_13787, 1.0).xyzw * PerViewConstantBufferCsgo_t._m13;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m1.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13144;
	    vec3 _16324;
	    _13144 = _9718;
	    _16324 = _24880;
	    uint _21567;
	    vec3 _13145;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13145 = _13144;
	        _16325 = _16324;
	        uint _20344;
	        vec3 _13212;
	        vec3 _15670;
	        uint _17018 = _14475;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(uint(findLSB(_17018)) + (_17017 * 32u));
	            _20344 = _17018 & (_17018 - 1u);
	            do
	            {
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_2.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7424;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7424 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7424 = false;
	                }
	                bool _12893;
	                if (!_7424)
	                {
	                    _12893 = true;
	                }
	                else
	                {
	                    _12893 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12893)
	                {
	                    _13212 = _13145;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23572 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = min(1.0, _21775 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21775) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11180;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10018 = g_BarnLights_1._m0[_12608]._m2.xyz - input_2.xyz;
	                    float _18345 = dot(_10018, _10018);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10018 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10018 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11180 = _10018 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * saturate(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11180 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24420;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24420 = !_20059;
	                }
	                else
	                {
	                    _24420 = false;
	                }
	                vec3 _21548;
	                SPIRV_CROSS_BRANCH
	                if (g_BarnLights_1._m0[_12608]._m4.w == 0.0)
	                {
	                    float _10342;
	                    do
	                    {
	                        vec2 _22154 = abs(_22905.xy);
	                        if (g_BarnLights_1._m0[_12608]._m9.z == 0.0)
	                        {
	                            _10342 = smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.x, _22154.x) * smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11475 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15018 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11475, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11475, _15266) + pow(_15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0);
	                                break;
	                            }
	                            break; // unreachable workaround
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _21548 = _17828.xyz * _10342;
	                }
	                else
	                {
	                    vec3 _12504;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11180).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20496 = _14081;
	                        _20496.x = _20564.x;
	                        _20496.y = _20564.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _20496.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20494 = _13791;
	                        _20494.x = _20563.x;
	                        _20494.y = _20563.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _20494.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13145;
	                    _15670 = _16325;
	                    break;
	                }
	                vec3 _21549;
	                if (_24420)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13145;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _21549 = _20482;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15461 = mix(_17892, _6618.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_6618.xyz, _11180.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18226;
	                if (_17119 > 0.0)
	                {
	                    float _8781 = dot(_15461, _11180.xyz);
	                    float _8125 = saturate(_17119);
	                    _18226 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * saturate((_8781 + 0.20000000298023223876953125) * 4.0)) * saturate(mix(dot(mix(_6618.xyz, _15461, vec3(10.0)), _11180.xyz), 1.0, _8125))), vec3(_8125));
	                }
	                else
	                {
	                    _18226 = _17875;
	                }
	                vec2 _17302 = max(_21818, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11180.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, _15461.xyz);
	                float _19211 = max(0.0, dot(_11180.xyz, _12282));
	                float _9851 = _17302.x;
	                float _25212 = _9851 * _9851;
	                float _19096 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19096 - 1.0)) + 1.0;
	                _13212 = _13145.xyz + (((_9451.xyz * (_19096 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15670 = _16325.xyz + (_18226.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13145 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13144 = _13145;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21818.xy, vec2(0.5));
	    vec3 _7507 = _17892.xyz;
	    vec3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec3 _12240 = -_17138;
	    vec4 _15344 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15344.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot(_12240.xyz, _7507)))) * _21215) + _15344.y)) + _15344.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _20418 = vec3(_21711 * _16306).xyz;
	    vec3 _20015 = _8745 * _20418;
	    vec3 _19476 = _13144.xyz * _20418;
	    vec3 _12894;
	    SPIRV_CROSS_BRANCH
	    if (_11564)
	    {
	        float _19823 = 1.0 - saturate(dot(_6618.xyz, _12240));
	        float _10374 = _19823 * _19823;
	        float _12410 = radians(5.0 * mix(1.0, 3.0, _10374 * _10374));
	        float _13467 = _12410 * _12410;
	        float _15075 = (1.0 - (_13467 * 0.5)) + ((_13467 * _13467) * 0.0416666679084300994873046875);
	        float _15046 = max(1.0 - _15075, 9.9999999747524270787835121154785e-07);
	        float _20967 = 1.0 / max(_16307, 9.9999999747524270787835121154785e-07);
	        float _9867 = _13142 * pow(saturate(_20967), 1.0);
	        _12894 = _19476.xyz + (((pow(PerViewLightingConstantBufferGpu_t._m10.xyz, vec3(2.0)) * ((((((smoothstep(0.89999997615814208984375, 1.0, saturate((dot(_17124, normalize(PerViewLightingConstantBufferGpu_t._m9.xyz - _17138)) - _15075) / _15046)) * _9867) * smoothstep(1.0, 2.0, _20967)) * 20000.0) * _Globals_.g_flSnowGlintSparkle) * _12320) * saturate(_8634))) + (_20015.xyz * (1.5 * ((smoothstep(0.0, 0.300000011920928955078125, saturate((dot(_17124, normalize(vec3(0.0, 0.0, 1.0) - _17138)) - _15075) / _15046)) * _9867) * _Globals_.g_flSnowGlintIntensity)))) * _12246);
	    }
	    else
	    {
	        _12894 = _19476;
	    }
	    vec3 _9983;
	    vec3 _22798;
	    SPIRV_CROSS_BRANCH
	    if (_21618)
	    {
	        float _17864 = saturate(_8634);
	        float _10543 = saturate((_8634 + 0.25) * 0.800000011920928955078125) * 0.800000011920928955078125;
	        _9983 = mix(_20015, mix(pow(_20015, vec3(1.39999997615814208984375, 0.60000002384185791015625, 0.449999988079071044921875)), _20015, vec3(saturate(_16306 * 0.75))), vec3(_24969));
	        _22798 = _16324 + ((PerViewLightingConstantBufferGpu_t._m10.xyz * (_12320 * _24969)) * (((vec3(min(_10543, _17864)) + (vec3(0.60000002384185791015625, 1.0, 4.0) * max(_10543 - _17864, 0.0))) * mix(1.0, (0.63999998569488525390625 * pow(1.36000001430511474609375 + (1.2000000476837158203125 * dot(_12240, PerViewLightingConstantBufferGpu_t._m9.xyz)), -1.5)) * (1.32679998874664306640625 + (_17864 * (2.138000011444091796875 + (_17864 * (1.677700042724609375 + (_17864 * (-0.361699998378753662109375))))))), 0.300000011920928955078125)) - vec3(_17864)));
	    }
	    else
	    {
	        _9983 = _20015;
	        _22798 = _16324;
	    }
	    vec3 _22686 = (_22798.xyz + _9983.xyz) * (_13141.xyz * (1.0 - _19323.w)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11204 = vec4(_12931, _22686.yz, input_5.w);
	    _11204.x = _12931;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    vec3 _15753 = _11204.xyz + _12894.xyz;
	    vec4 _20497 = _11204;
	    _20497.x = _15753.x;
	    _20497.y = _15753.y;
	    _20497.z = _15753.z;
	    vec3 _15734 = _20497.xyz + ((((mix(_11427.xxx, _11427.yyy, _9451) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m6], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _20418).xyz;
	    vec4 _13888 = _20497;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _23187 = _13787 - PerViewConstantBuffer_t._m4.xyz;
	        vec3 _9057 = _23187.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _23187.xyz;
	            bool _12895;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m19.x)
	            {
	                _12895 = (_10061.z * PerViewConstantBufferCsgo_t._m19.z) < PerViewConstantBufferCsgo_t._m19.y;
	            }
	            else
	            {
	                _12895 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12895)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m16.xy + (PerViewConstantBufferCsgo_t._m16.zw * vec2(length(_21493), _10061.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m17.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m17.y)) * PerViewConstantBufferCsgo_t._m18.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m18.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12896;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m23.x)
	            {
	                _12896 = (PerViewConstantBufferCsgo_t._m23.z * _10061.z) < PerViewConstantBufferCsgo_t._m23.y;
	            }
	            else
	            {
	                _12896 = false;
	            }
	            if (_12896)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m20.y) + PerViewConstantBufferCsgo_t._m20.x), PerViewConstantBufferCsgo_t._m20.w)) * saturate(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m21.y) + PerViewConstantBufferCsgo_t._m21.x), PerViewConstantBufferCsgo_t._m21.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m23.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m2], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), normalize((PerViewConstantBufferCsgo_t._m22 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m21.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m20.z))) * PerViewConstantBufferCsgo_t._m24.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _6805 = _23944;
	    }
	    else
	    {
	        _6805 = _13888;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0)) ? 1 : 0);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor1);
	TextureAttribute(RepresentativeTexture, g_tColor1);
	FloatAttribute(OcclusionCullingBoundsScale, F_OCCLUSION_CULLING_BOUNDS_SCALE ? g_flOcclusionCullingBoundsScale : 1);
	
	#if (S_ALPHA_TEST_LAYER == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_ALPHA_TEST_LAYER == 0)
		IntAttribute(DepthPassBatchID, F_RENDER_BACKFACES ? 0 : 1);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_MATERIAL_REFERENCE == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerType, csgo_environment);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		IntAttribute(DepthPassBatchID, F_RENDER_BACKFACES ? 0 : 1);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_MATERIAL_REFERENCE == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthClipEnable, false);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthFunc, Equal);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	// Variant parameters
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	
	BoolAttribute(BindlessResources, true);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	
	#if (S_MATERIAL_REFERENCE == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerType, csgo_environment);
	#endif
}

RTX
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_MATERIAL_REFERENCE, F_MATERIAL_REFERENCE );
	StaticCombo( S_PIXEL_DEPTH_OFFSET, F_PIXEL_DEPTH_OFFSET );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST_LAYER, F_ALPHA_TEST );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_MODE_DEPTH ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_PIXEL_DEPTH_OFFSET, S_ALPHA_TEST_LAYER ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool g_bAdjustBaseColor1 < UiType(CheckBox); Expression(g_nColorCorrectionMode1==1); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(1,1,1),TextureAverageColor(g_tColor1)))); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal1 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal1, TextureRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	float3 g_vBiplanarTexCoordScale < UiType(VectorText); Expression(1/64*float3(-1,1,-1)); >;
	float4 g_vDetailNormalXform_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vDetailTexCoordXform0_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale1.x,-v2*g_vDetailTexCoordScale1.y,0,g_vDetailTexCoordCenter1.x+g_vDetailTexCoordOffset1.x+v2*g_vDetailTexCoordCenter1.y-v1*g_vDetailTexCoordCenter1.x)); >;
	float4 g_vDetailTexCoordXform1_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale1.x,v1*g_vDetailTexCoordScale1.y,0,g_vDetailTexCoordCenter1.y+g_vDetailTexCoordOffset1.y-(v2*g_vDetailTexCoordCenter1.x+v1*g_vDetailTexCoordCenter1.y))); >;
	float4 g_vNormalXform_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vTexCoordXform0_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale1.x,-v2*g_vTexCoordScale1.y,0,g_vTexCoordCenter1.x+g_vTexCoordOffset1.x+v2*g_vTexCoordCenter1.y-v1*g_vTexCoordCenter1.x)); >;
	float4 g_vTexCoordXform1_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale1.x,v1*g_vTexCoordScale1.y,0,g_vTexCoordCenter1.y+g_vTexCoordOffset1.y-(v2*g_vTexCoordCenter1.x+v1*g_vTexCoordCenter1.y))); >;
	
	// Material1
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Material1,0/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask1, Linear, 8, "", "_mask", "Material1/Tint Mask,15/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureTranslucency1, Linear, 8, "", "_trans", "Material1/Translucent,15/0", Default4(1, 1, 1, 0));
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float g_fTintMaskBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Tint Mask/5"); >;
	float2 g_vDetailTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/9"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight1, Linear, 8, "", "_height", "Material1/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast1 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material1/Tint Mask/10"); >;
	float3 g_vTextureColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/11"); >;
	float g_fTextureRoughnessBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/12"); >;
	float g_fTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Lighting/13"); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	bool g_bMetalness1 < Default(1); UiType(CheckBox); UiGroup("Material1/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Lighting,20/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/20"); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	CreateInputTexture2D(TextureNormalDetail1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	float g_fDetailTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Detail/45"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_MATERIAL_REFERENCE == 1)
		float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
		Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST_LAYER == 1)
		Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(1,1,1),TextureAverageColor(g_tColor1)))); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
	#extension GL_EXT_shader_16bit_storage : require
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_nonuniform_qualifier : require
	#if defined(GL_EXT_control_flow_attributes)
	#extension GL_EXT_control_flow_attributes : require
	#define SPIRV_CROSS_FLATTEN [[flatten]]
	#define SPIRV_CROSS_BRANCH [[dont_flatten]]
	#define SPIRV_CROSS_UNROLL [[unroll]]
	#define SPIRV_CROSS_LOOP [[dont_unroll]]
	#else
	#define SPIRV_CROSS_FLATTEN
	#define SPIRV_CROSS_BRANCH
	#define SPIRV_CROSS_UNROLL
	#define SPIRV_CROSS_LOOP
	#endif
	
	struct VS_INPUT
	{
	    vec3 vPositionOs;
	    vec2 vTexCoord;
	    vec2 vTexCoord2;
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
	    vec4 vBlendColorTint;
	    vec4 vColorBlendValues;
	};
	
	struct PackedRtxInstanceData_t_natural
	{
	    uint nSrgbColor;
	    uint nTriangleGeometry;
	    uint nMaterialData;
	    uint nMaterialFlags_nInstanceFlags;
	    float fEmissiveBoost;
	    uint nInstanceFlags;
	    uint _pad1;
	    uint _pad2;
	};
	
	struct _RTX_MATERIAL_DATA_
	{
	    vec2 g_vDetailTexCoordScale;
	    float g_flDetailTexCoordRotation;
	    float _g_fl_AutoPad0_;
	    vec2 g_vDetailTexCoordOffset;
	    float _g_fl_AutoPad1_;
	    float _g_fl_AutoPad2_;
	    vec4 g_vDetailTexCoordXform;
	    float g_flDetailNormalStrength;
	    float _g_fl_AutoPad3_;
	    float _g_fl_AutoPad4_;
	    float _g_fl_AutoPad5_;
	    vec4 g_vDetailNormalStrengthOffsetScale;
	    vec2 g_vTexCoordCenter;
	    vec2 g_vTexCoordScale;
	    float g_flTexCoordRotation;
	    float _g_fl_AutoPad6_;
	    vec2 g_vTexCoordOffset;
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    int g_nScaleTexCoordUByModelScaleAxis;
	    int g_nScaleTexCoordVByModelScaleAxis;
	    bool g_bTexCoordScaleByModel;
	    float _g_fl_AutoPad7_;
	    float _g_fl_AutoPad8_;
	    float _g_fl_AutoPad9_;
	    vec4 g_vTexCoordScaleByModelU;
	    vec4 g_vTexCoordScaleByModelV;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    bool g_bUseSecondaryUvForDetailTexture;
	    float _g_fl_AutoPad10_;
	    float _g_fl_AutoPad11_;
	    float _g_fl_AutoPad12_;
	    vec3 g_vBiplanarTexCoordScale;
	    float g_flDetailPropMaskBias1;
	    float g_flDetailPropPuddleReduction1;
	    bool g_bSnowLayer1;
	    float g_flSnowGlintStrength1;
	    int g_nUVSet1;
	    vec2 g_vTexCoordScale1;
	    vec2 g_vTexCoordCenter1;
	    float g_flTexCoordRotation1;
	    float _g_fl_AutoPad13_;
	    vec2 g_vTexCoordOffset1;
	    vec4 g_vTexCoordXform0_1;
	    vec4 g_vTexCoordXform1_1;
	    vec4 g_vNormalXform_1;
	    float g_flPDOScale1;
	    float g_flPDOOffset1;
	    float g_flPDOContactAoDistance1;
	    float g_flPDOContactAoStrength1;
	    float g_flPDOSoftIntersectionWidth1;
	    float g_flParallaxStrength1;
	    float g_flWetnessDarkeningStrength1;
	    int g_nDetailUVSet1;
	    vec2 g_vDetailTexCoordScale1;
	    vec2 g_vDetailTexCoordCenter1;
	    float g_flDetailTexCoordRotation1;
	    float _g_fl_AutoPad14_;
	    vec2 g_vDetailTexCoordOffset1;
	    vec4 g_vDetailTexCoordXform0_1;
	    vec4 g_vDetailTexCoordXform1_1;
	    vec4 g_vDetailNormalXform_1;
	    uint g_tNormal1;
	    uint g_tHeight1;
	    uint g_tNormalDetail1;
	    float g_fDetailTextureNormalContrast1;
	    mat4 g_mTextureColorAdjust1;
	    mat4 g_mTextureAdjust1;
	    float g_flBlendSoftnessDistanceModifierStrength;
	    bool g_bPuddlesOnVerticalSurfaces;
	    bool g_bWetnessUseHeightmapAdjustments;
	    float g_flWetnessUnderlyingHeightMapInfluence;
	    float g_flHorizontalSurfaceTolerance;
	    float g_fPuddleStrength;
	    float g_fPuddleHeight;
	    float _g_fl_AutoPad15_;
	    vec3 g_vPuddleSedimentColor;
	    float g_fPuddleSedimentHeight;
	    float g_fPuddleSedimentOpacity;
	    float g_fPuddleRoughness;
	    float g_fPuddleBlendSoftness;
	    float g_fWetEdgeStrength;
	    float g_fWetEdgeSpread;
	    float g_fWetEdgeSoftness;
	    float g_fWetnessStrength;
	    float g_fRainStrength;
	    float g_fRippleStrength;
	    float g_flSnowGlintIntensity;
	    float g_flSnowGlintSparkle;
	    float g_flSnowGlintTwinkleAmount;
	    float g_flSnowGlintTwinkleSpeed;
	    uint g_sAniso;
	    uint g_sBilinearWrap;
	    uint g_sBilinearClamp;
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    int g_nTextureAddressModeU;
	    int g_nTextureAddressModeV;
	    uint g_sUserConfig;
	    uint g_sUserConfigAllowGlobalMipBias;
	    uint g_tColor1;
	    bool g_bFogEnabled;
	    bool g_bDontFlipBackfaceNormals;
	    bool g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    uint g_tAmbientOcclusion;
	    float g_flMetalness;
	    float g_flRetroReflectivity;
	    bool g_bWetness;
	};
	
	struct _Array_natural_vector_int_4_8
	{
	    ivec4 data[8];
	};
	
	struct GeometryInfo_t_natural
	{
	    ivec4 m_nVertexAndIndexBuffers;
	    ivec4 m_nBufferBindOffsetBytes;
	    ivec4 m_nBufferStrideInBytes;
	    ivec4 m_vNormalFieldInfo;
	    ivec4 m_vTangentFieldInfo;
	    _Array_natural_vector_int_4_8 m_vTexCoordFieldInfo;
	    _Array_natural_vector_int_4_8 m_vColorFieldInfo;
	};
	
	struct BuiltInTriangleIntersectionAttributes
	{
	    vec2 barycentrics;
	};
	
	const vec3 _735[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _739[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
	struct MaterialDataMinimal_t
	{
	    f16vec3 vNormalWs;
	    float16_t flMetalness;
	    f16vec3 vAlbedo;
	    float16_t flRoughness;
	    f16vec3 vEmissive;
	    float16_t flReflectance;
	    uint nMaterialTypeAndFlags;
	    f16vec4 vMaterialBits;
	};
	
	struct Payload_t
	{
	    vec3 vSmoothPositionWs;
	    vec3 vFaceNormalWs;
	    vec3 vInterpolatedNormalWs;
	    float flHitT;
	    float flOpacityRng;
	    int nInstance;
	    bool bFlippedNormal;
	    MaterialDataMinimal_t material;
	};
	
	vec4 _796;
	float _797;
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData
	{
	    float _member0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    int _member0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _member0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_6
	{
	    uint _member0[];
	} g_MaterialData_7;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_Geometries
	{
	    GeometryInfo_t_natural _member0[];
	} g_Geometries_1;
	
	layout(set = 3, binding = 33, std430) readonly buffer g_Indices
	{
	    uint _member0[];
	} g_Indices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices
	{
	    float _member0[];
	} g_Vertices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices_2
	{
	    uint _member0[];
	} g_Vertices_3[];
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes attrs;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t payload;
	
	void main()
	{
	    uint _836 = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _RTX_MATERIAL_DATA_ _1913 = _RTX_MATERIAL_DATA_(vec2(g_MaterialData_1._member0[_836 / 4u], g_MaterialData_1._member0[(_836 + 4u) / 4u]), g_MaterialData_1._member0[(_836 + 8u) / 4u], g_MaterialData_1._member0[(_836 + 12u) / 4u], vec2(g_MaterialData_1._member0[(_836 + 16u) / 4u], g_MaterialData_1._member0[(_836 + 20u) / 4u]), g_MaterialData_1._member0[(_836 + 24u) / 4u], g_MaterialData_1._member0[(_836 + 28u) / 4u], vec4(g_MaterialData_1._member0[(_836 + 32u) / 4u], g_MaterialData_1._member0[(_836 + 36u) / 4u], g_MaterialData_1._member0[(_836 + 40u) / 4u], g_MaterialData_1._member0[(_836 + 44u) / 4u]), g_MaterialData_1._member0[(_836 + 48u) / 4u], g_MaterialData_1._member0[(_836 + 52u) / 4u], g_MaterialData_1._member0[(_836 + 56u) / 4u], g_MaterialData_1._member0[(_836 + 60u) / 4u], vec4(g_MaterialData_1._member0[(_836 + 64u) / 4u], g_MaterialData_1._member0[(_836 + 68u) / 4u], g_MaterialData_1._member0[(_836 + 72u) / 4u], g_MaterialData_1._member0[(_836 + 76u) / 4u]), vec2(g_MaterialData_1._member0[(_836 + 80u) / 4u], g_MaterialData_1._member0[(_836 + 84u) / 4u]), vec2(g_MaterialData_1._member0[(_836 + 88u) / 4u], g_MaterialData_1._member0[(_836 + 92u) / 4u]), g_MaterialData_1._member0[(_836 + 96u) / 4u], g_MaterialData_1._member0[(_836 + 100u) / 4u], vec2(g_MaterialData_1._member0[(_836 + 104u) / 4u], g_MaterialData_1._member0[(_836 + 108u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 112u) / 4u], g_MaterialData_1._member0[(_836 + 116u) / 4u], g_MaterialData_1._member0[(_836 + 120u) / 4u], g_MaterialData_1._member0[(_836 + 124u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 128u) / 4u], g_MaterialData_1._member0[(_836 + 132u) / 4u], g_MaterialData_1._member0[(_836 + 136u) / 4u], g_MaterialData_1._member0[(_836 + 140u) / 4u]), vec2(g_MaterialData_1._member0[(_836 + 144u) / 4u], g_MaterialData_1._member0[(_836 + 148u) / 4u]), g_MaterialData_3._member0[(_836 + 152u) / 4u], g_MaterialData_3._member0[(_836 + 156u) / 4u], g_MaterialData_5._member0[(_836 + 160u) / 4u] != 0, g_MaterialData_1._member0[(_836 + 164u) / 4u], g_MaterialData_1._member0[(_836 + 168u) / 4u], g_MaterialData_1._member0[(_836 + 172u) / 4u], vec4(g_MaterialData_1._member0[(_836 + 176u) / 4u], g_MaterialData_1._member0[(_836 + 180u) / 4u], g_MaterialData_1._member0[(_836 + 184u) / 4u], g_MaterialData_1._member0[(_836 + 188u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 192u) / 4u], g_MaterialData_1._member0[(_836 + 196u) / 4u], g_MaterialData_1._member0[(_836 + 200u) / 4u], g_MaterialData_1._member0[(_836 + 204u) / 4u]), vec3(g_MaterialData_1._member0[(_836 + 208u) / 4u], g_MaterialData_1._member0[(_836 + 212u) / 4u], g_MaterialData_1._member0[(_836 + 216u) / 4u]), g_MaterialData_1._member0[(_836 + 220u) / 4u], g_MaterialData_5._member0[(_836 + 224u) / 4u] != 0, g_MaterialData_1._member0[(_836 + 228u) / 4u], g_MaterialData_1._member0[(_836 + 232u) / 4u], g_MaterialData_1._member0[(_836 + 236u) / 4u], vec3(g_MaterialData_1._member0[(_836 + 240u) / 4u], g_MaterialData_1._member0[(_836 + 244u) / 4u], g_MaterialData_1._member0[(_836 + 248u) / 4u]), g_MaterialData_1._member0[(_836 + 252u) / 4u], g_MaterialData_1._member0[(_836 + 256u) / 4u], g_MaterialData_5._member0[(_836 + 260u) / 4u] != 0, g_MaterialData_1._member0[(_836 + 264u) / 4u], g_MaterialData_3._member0[(_836 + 268u) / 4u], vec2(g_MaterialData_1._member0[(_836 + 272u) / 4u], g_MaterialData_1._member0[(_836 + 276u) / 4u]), vec2(g_MaterialData_1._member0[(_836 + 280u) / 4u], g_MaterialData_1._member0[(_836 + 284u) / 4u]), g_MaterialData_1._member0[(_836 + 288u) / 4u], g_MaterialData_1._member0[(_836 + 292u) / 4u], vec2(g_MaterialData_1._member0[(_836 + 296u) / 4u], g_MaterialData_1._member0[(_836 + 300u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 304u) / 4u], g_MaterialData_1._member0[(_836 + 308u) / 4u], g_MaterialData_1._member0[(_836 + 312u) / 4u], g_MaterialData_1._member0[(_836 + 316u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 320u) / 4u], g_MaterialData_1._member0[(_836 + 324u) / 4u], g_MaterialData_1._member0[(_836 + 328u) / 4u], g_MaterialData_1._member0[(_836 + 332u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 336u) / 4u], g_MaterialData_1._member0[(_836 + 340u) / 4u], g_MaterialData_1._member0[(_836 + 344u) / 4u], g_MaterialData_1._member0[(_836 + 348u) / 4u]), g_MaterialData_1._member0[(_836 + 352u) / 4u], g_MaterialData_1._member0[(_836 + 356u) / 4u], g_MaterialData_1._member0[(_836 + 360u) / 4u], g_MaterialData_1._member0[(_836 + 364u) / 4u], g_MaterialData_1._member0[(_836 + 368u) / 4u], g_MaterialData_1._member0[(_836 + 372u) / 4u], g_MaterialData_1._member0[(_836 + 376u) / 4u], g_MaterialData_3._member0[(_836 + 380u) / 4u], vec2(g_MaterialData_1._member0[(_836 + 384u) / 4u], g_MaterialData_1._member0[(_836 + 388u) / 4u]), vec2(g_MaterialData_1._member0[(_836 + 392u) / 4u], g_MaterialData_1._member0[(_836 + 396u) / 4u]), g_MaterialData_1._member0[(_836 + 400u) / 4u], g_MaterialData_1._member0[(_836 + 404u) / 4u], vec2(g_MaterialData_1._member0[(_836 + 408u) / 4u], g_MaterialData_1._member0[(_836 + 412u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 416u) / 4u], g_MaterialData_1._member0[(_836 + 420u) / 4u], g_MaterialData_1._member0[(_836 + 424u) / 4u], g_MaterialData_1._member0[(_836 + 428u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 432u) / 4u], g_MaterialData_1._member0[(_836 + 436u) / 4u], g_MaterialData_1._member0[(_836 + 440u) / 4u], g_MaterialData_1._member0[(_836 + 444u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 448u) / 4u], g_MaterialData_1._member0[(_836 + 452u) / 4u], g_MaterialData_1._member0[(_836 + 456u) / 4u], g_MaterialData_1._member0[(_836 + 460u) / 4u]), g_MaterialData_7._member0[(_836 + 464u) / 4u], g_MaterialData_7._member0[(_836 + 468u) / 4u], g_MaterialData_7._member0[(_836 + 472u) / 4u], g_MaterialData_1._member0[(_836 + 476u) / 4u], mat4(vec4(g_MaterialData_1._member0[(_836 + 480u) / 4u], g_MaterialData_1._member0[(_836 + 496u) / 4u], g_MaterialData_1._member0[(_836 + 512u) / 4u], g_MaterialData_1._member0[(_836 + 528u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 484u) / 4u], g_MaterialData_1._member0[(_836 + 500u) / 4u], g_MaterialData_1._member0[(_836 + 516u) / 4u], g_MaterialData_1._member0[(_836 + 532u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 488u) / 4u], g_MaterialData_1._member0[(_836 + 504u) / 4u], g_MaterialData_1._member0[(_836 + 520u) / 4u], g_MaterialData_1._member0[(_836 + 536u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 492u) / 4u], g_MaterialData_1._member0[(_836 + 508u) / 4u], g_MaterialData_1._member0[(_836 + 524u) / 4u], g_MaterialData_1._member0[(_836 + 540u) / 4u])), mat4(vec4(g_MaterialData_1._member0[(_836 + 544u) / 4u], g_MaterialData_1._member0[(_836 + 560u) / 4u], g_MaterialData_1._member0[(_836 + 576u) / 4u], g_MaterialData_1._member0[(_836 + 592u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 548u) / 4u], g_MaterialData_1._member0[(_836 + 564u) / 4u], g_MaterialData_1._member0[(_836 + 580u) / 4u], g_MaterialData_1._member0[(_836 + 596u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 552u) / 4u], g_MaterialData_1._member0[(_836 + 568u) / 4u], g_MaterialData_1._member0[(_836 + 584u) / 4u], g_MaterialData_1._member0[(_836 + 600u) / 4u]), vec4(g_MaterialData_1._member0[(_836 + 556u) / 4u], g_MaterialData_1._member0[(_836 + 572u) / 4u], g_MaterialData_1._member0[(_836 + 588u) / 4u], g_MaterialData_1._member0[(_836 + 604u) / 4u])), g_MaterialData_1._member0[(_836 + 608u) / 4u], g_MaterialData_5._member0[(_836 + 612u) / 4u] != 0, g_MaterialData_5._member0[(_836 + 616u) / 4u] != 0, g_MaterialData_1._member0[(_836 + 620u) / 4u], g_MaterialData_1._member0[(_836 + 624u) / 4u], g_MaterialData_1._member0[(_836 + 628u) / 4u], g_MaterialData_1._member0[(_836 + 632u) / 4u], g_MaterialData_1._member0[(_836 + 636u) / 4u], vec3(g_MaterialData_1._member0[(_836 + 640u) / 4u], g_MaterialData_1._member0[(_836 + 644u) / 4u], g_MaterialData_1._member0[(_836 + 648u) / 4u]), g_MaterialData_1._member0[(_836 + 652u) / 4u], g_MaterialData_1._member0[(_836 + 656u) / 4u], g_MaterialData_1._member0[(_836 + 660u) / 4u], g_MaterialData_1._member0[(_836 + 664u) / 4u], g_MaterialData_1._member0[(_836 + 668u) / 4u], g_MaterialData_1._member0[(_836 + 672u) / 4u], g_MaterialData_1._member0[(_836 + 676u) / 4u], g_MaterialData_1._member0[(_836 + 680u) / 4u], g_MaterialData_1._member0[(_836 + 684u) / 4u], g_MaterialData_1._member0[(_836 + 688u) / 4u], g_MaterialData_1._member0[(_836 + 692u) / 4u], g_MaterialData_1._member0[(_836 + 696u) / 4u], g_MaterialData_1._member0[(_836 + 700u) / 4u], g_MaterialData_1._member0[(_836 + 704u) / 4u], g_MaterialData_7._member0[(_836 + 708u) / 4u], g_MaterialData_7._member0[(_836 + 712u) / 4u], g_MaterialData_7._member0[(_836 + 716u) / 4u], g_MaterialData_7._member0[(_836 + 720u) / 4u], g_MaterialData_7._member0[(_836 + 724u) / 4u], g_MaterialData_7._member0[(_836 + 728u) / 4u], g_MaterialData_3._member0[(_836 + 732u) / 4u], g_MaterialData_3._member0[(_836 + 736u) / 4u], g_MaterialData_7._member0[(_836 + 740u) / 4u], g_MaterialData_7._member0[(_836 + 744u) / 4u], g_MaterialData_7._member0[(_836 + 748u) / 4u], g_MaterialData_5._member0[(_836 + 752u) / 4u] != 0, g_MaterialData_5._member0[(_836 + 756u) / 4u] != 0, g_MaterialData_5._member0[(_836 + 760u) / 4u] != 0, g_MaterialData_1._member0[(_836 + 764u) / 4u], g_MaterialData_7._member0[(_836 + 768u) / 4u], g_MaterialData_1._member0[(_836 + 772u) / 4u], g_MaterialData_1._member0[(_836 + 776u) / 4u], g_MaterialData_5._member0[(_836 + 780u) / 4u] != 0);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _1913;
	    uvec3 _1072;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _1955 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _1072 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_1955 / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_1955 + 4u) / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_1955 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _1934 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _1935 = _1934 & 4294967292u;
	            uint _57 = _1935 / 4u;
	            uint _60 = (_1935 + 4u) / 4u;
	            uint _1939 = (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_57] & 4294901760u) >> uint(16);
	            uint _1940 = g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_60] & 65535u;
	            uvec3 _1073;
	            if (_1934 == _1935)
	            {
	                _1073 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_57] & 65535u, _1939, _1940);
	            }
	            else
	            {
	                _1073 = uvec3(_1939, _1940, (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_60] & 4294901760u) >> uint(16));
	            }
	            _1072 = _1073;
	            break;
	        }
	        break;
	    } while(false);
	    uint _73 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _1977 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _1072) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _1066[3];
	    uint _1979 = _1977.x;
	    _1066[0] = vec3(g_Vertices_1[nonuniformEXT(_73)]._member0[_1979 / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_1979 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_1979 + 8u) / 4u]);
	    uint _1984 = _1977.y;
	    _1066[1] = vec3(g_Vertices_1[nonuniformEXT(_73)]._member0[_1984 / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_1984 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_1984 + 8u) / 4u]);
	    uint _1989 = _1977.z;
	    _1066[2] = vec3(g_Vertices_1[nonuniformEXT(_73)]._member0[_1989 / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_1989 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_1989 + 8u) / 4u]);
	    int _1067 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_1067 < 3))
	        {
	            break;
	        }
	        vsInput[_1067].vPositionOs = _1066[_1067];
	        _1067++;
	        continue;
	    }
	    vec2 _1068[3];
	    _1068[0] = vec2(0.0);
	    _1068[1] = vec2(0.0);
	    _1068[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _1065 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _102 = uint(_1065[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _2031 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _1063 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1064 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2047 = (uvec3(uint(_1063[_2031])) * _1072) + uvec3(uint(_1064[_2031]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _2161 = _2047.x;
	            _1068[0] = vec2(g_Vertices_1[nonuniformEXT(_102)]._member0[_2161 / 4u], g_Vertices_1[nonuniformEXT(_102)]._member0[(_2161 + 4u) / 4u]);
	            uint _2164 = _2047.y;
	            _1068[1] = vec2(g_Vertices_1[nonuniformEXT(_102)]._member0[_2164 / 4u], g_Vertices_1[nonuniformEXT(_102)]._member0[(_2164 + 4u) / 4u]);
	            uint _2167 = _2047.z;
	            _1068[2] = vec2(g_Vertices_1[nonuniformEXT(_102)]._member0[_2167 / 4u], g_Vertices_1[nonuniformEXT(_102)]._member0[(_2167 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _114 = _2047.x / 4u;
	                _1068[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_102)]._member0[_114], g_Vertices_3[nonuniformEXT(_102)]._member0[_114] >> uint(16)) & uvec2(65535u))));
	                uint _117 = _2047.y / 4u;
	                _1068[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_102)]._member0[_117], g_Vertices_3[nonuniformEXT(_102)]._member0[_117] >> uint(16)) & uvec2(65535u))));
	                uint _120 = _2047.z / 4u;
	                _1068[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_102)]._member0[_120], g_Vertices_3[nonuniformEXT(_102)]._member0[_120] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _104 = _2047.x / 4u;
	                    uint _2060 = g_Vertices_3[nonuniformEXT(_102)]._member0[_104] & 65535u;
	                    int _1062;
	                    if (_2060 > 32767u)
	                    {
	                        _1062 = int(4294901760u | _2060);
	                    }
	                    else
	                    {
	                        _1062 = int(_2060);
	                    }
	                    uint _2073 = (g_Vertices_3[nonuniformEXT(_102)]._member0[_104] & 4294901760u) >> uint(16);
	                    int _1061;
	                    if (_2073 > 32767u)
	                    {
	                        _1061 = int(4294901760u | _2073);
	                    }
	                    else
	                    {
	                        _1061 = int(_2073);
	                    }
	                    _1068[0] = vec2(max(float(_1062) * 3.0518509447574615478515625e-05, -1.0), max(float(_1061) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _107 = _2047.y / 4u;
	                    uint _2087 = g_Vertices_3[nonuniformEXT(_102)]._member0[_107] & 65535u;
	                    int _1060;
	                    if (_2087 > 32767u)
	                    {
	                        _1060 = int(4294901760u | _2087);
	                    }
	                    else
	                    {
	                        _1060 = int(_2087);
	                    }
	                    uint _2100 = (g_Vertices_3[nonuniformEXT(_102)]._member0[_107] & 4294901760u) >> uint(16);
	                    int _1059;
	                    if (_2100 > 32767u)
	                    {
	                        _1059 = int(4294901760u | _2100);
	                    }
	                    else
	                    {
	                        _1059 = int(_2100);
	                    }
	                    _1068[1] = vec2(max(float(_1060) * 3.0518509447574615478515625e-05, -1.0), max(float(_1059) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _110 = _2047.z / 4u;
	                    uint _2114 = g_Vertices_3[nonuniformEXT(_102)]._member0[_110] & 65535u;
	                    int _1058;
	                    if (_2114 > 32767u)
	                    {
	                        _1058 = int(4294901760u | _2114);
	                    }
	                    else
	                    {
	                        _1058 = int(_2114);
	                    }
	                    uint _2127 = (g_Vertices_3[nonuniformEXT(_102)]._member0[_110] & 4294901760u) >> uint(16);
	                    int _1057;
	                    if (_2127 > 32767u)
	                    {
	                        _1057 = int(4294901760u | _2127);
	                    }
	                    else
	                    {
	                        _1057 = int(_2127);
	                    }
	                    _1068[2] = vec2(max(float(_1058) * 3.0518509447574615478515625e-05, -1.0), max(float(_1057) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _1067 = 0;
	    for (;;)
	    {
	        if (!(_1067 < 3))
	        {
	            break;
	        }
	        vsInput[_1067].vTexCoord = _1068[_1067];
	        _1067++;
	        continue;
	    }
	    _1068[0] = vec2(0.0);
	    _1068[1] = vec2(0.0);
	    _1068[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _1056 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _142 = uint(_1056[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _2206 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _1054 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1055 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2222 = (uvec3(uint(_1054[_2206])) * _1072) + uvec3(uint(_1055[_2206]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _2336 = _2222.x;
	            _1068[0] = vec2(g_Vertices_1[nonuniformEXT(_142)]._member0[_2336 / 4u], g_Vertices_1[nonuniformEXT(_142)]._member0[(_2336 + 4u) / 4u]);
	            uint _2339 = _2222.y;
	            _1068[1] = vec2(g_Vertices_1[nonuniformEXT(_142)]._member0[_2339 / 4u], g_Vertices_1[nonuniformEXT(_142)]._member0[(_2339 + 4u) / 4u]);
	            uint _2342 = _2222.z;
	            _1068[2] = vec2(g_Vertices_1[nonuniformEXT(_142)]._member0[_2342 / 4u], g_Vertices_1[nonuniformEXT(_142)]._member0[(_2342 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _154 = _2222.x / 4u;
	                _1068[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_142)]._member0[_154], g_Vertices_3[nonuniformEXT(_142)]._member0[_154] >> uint(16)) & uvec2(65535u))));
	                uint _157 = _2222.y / 4u;
	                _1068[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_142)]._member0[_157], g_Vertices_3[nonuniformEXT(_142)]._member0[_157] >> uint(16)) & uvec2(65535u))));
	                uint _160 = _2222.z / 4u;
	                _1068[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_142)]._member0[_160], g_Vertices_3[nonuniformEXT(_142)]._member0[_160] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _144 = _2222.x / 4u;
	                    uint _2235 = g_Vertices_3[nonuniformEXT(_142)]._member0[_144] & 65535u;
	                    int _1053;
	                    if (_2235 > 32767u)
	                    {
	                        _1053 = int(4294901760u | _2235);
	                    }
	                    else
	                    {
	                        _1053 = int(_2235);
	                    }
	                    uint _2248 = (g_Vertices_3[nonuniformEXT(_142)]._member0[_144] & 4294901760u) >> uint(16);
	                    int _1052;
	                    if (_2248 > 32767u)
	                    {
	                        _1052 = int(4294901760u | _2248);
	                    }
	                    else
	                    {
	                        _1052 = int(_2248);
	                    }
	                    _1068[0] = vec2(max(float(_1053) * 3.0518509447574615478515625e-05, -1.0), max(float(_1052) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _147 = _2222.y / 4u;
	                    uint _2262 = g_Vertices_3[nonuniformEXT(_142)]._member0[_147] & 65535u;
	                    int _1051;
	                    if (_2262 > 32767u)
	                    {
	                        _1051 = int(4294901760u | _2262);
	                    }
	                    else
	                    {
	                        _1051 = int(_2262);
	                    }
	                    uint _2275 = (g_Vertices_3[nonuniformEXT(_142)]._member0[_147] & 4294901760u) >> uint(16);
	                    int _1050;
	                    if (_2275 > 32767u)
	                    {
	                        _1050 = int(4294901760u | _2275);
	                    }
	                    else
	                    {
	                        _1050 = int(_2275);
	                    }
	                    _1068[1] = vec2(max(float(_1051) * 3.0518509447574615478515625e-05, -1.0), max(float(_1050) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _150 = _2222.z / 4u;
	                    uint _2289 = g_Vertices_3[nonuniformEXT(_142)]._member0[_150] & 65535u;
	                    int _1049;
	                    if (_2289 > 32767u)
	                    {
	                        _1049 = int(4294901760u | _2289);
	                    }
	                    else
	                    {
	                        _1049 = int(_2289);
	                    }
	                    uint _2302 = (g_Vertices_3[nonuniformEXT(_142)]._member0[_150] & 4294901760u) >> uint(16);
	                    int _1048;
	                    if (_2302 > 32767u)
	                    {
	                        _1048 = int(4294901760u | _2302);
	                    }
	                    else
	                    {
	                        _1048 = int(_2302);
	                    }
	                    _1068[2] = vec2(max(float(_1049) * 3.0518509447574615478515625e-05, -1.0), max(float(_1048) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _1067 = 0;
	    for (;;)
	    {
	        if (!(_1067 < 3))
	        {
	            break;
	        }
	        vsInput[_1067].vTexCoord2 = _1068[_1067];
	        _1067++;
	        continue;
	    }
	    vec3 _1069[3];
	    vec4 _1070[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _1034 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _182 = uint(_1034[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _2386 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _1032 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _1033 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2402 = (uvec3(uint(_1032[_2386])) * _1072) + uvec3(uint(_1033[_2386]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _2903 = _2402.x;
	                _1069[0] = vec3(g_Vertices_1[nonuniformEXT(_182)]._member0[_2903 / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_2903 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_2903 + 8u) / 4u]);
	                uint _2908 = _2402.y;
	                _1069[1] = vec3(g_Vertices_1[nonuniformEXT(_182)]._member0[_2908 / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_2908 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_2908 + 8u) / 4u]);
	                uint _2913 = _2402.z;
	                _1069[2] = vec3(g_Vertices_1[nonuniformEXT(_182)]._member0[_2913 / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_2913 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_2913 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _2657 = _2402.x;
	                    uvec2 _2659 = uvec2(g_Vertices_3[nonuniformEXT(_182)]._member0[_2657 / 4u], g_Vertices_3[nonuniformEXT(_182)]._member0[(_2657 + 4u) / 4u]);
	                    uint _2660 = _2402.y;
	                    uvec2 _817 = uvec2(g_Vertices_3[nonuniformEXT(_182)]._member0[_2660 / 4u], g_Vertices_3[nonuniformEXT(_182)]._member0[(_2660 + 4u) / 4u]);
	                    uint _2663 = _2402.z;
	                    uvec2 _816 = uvec2(g_Vertices_3[nonuniformEXT(_182)]._member0[_2663 / 4u], g_Vertices_3[nonuniformEXT(_182)]._member0[(_2663 + 4u) / 4u]);
	                    uint _2669 = _2659.x;
	                    uint _2677 = _2659.y;
	                    vec2 _2687 = ((vec2(float(_2669 & 65535u), float((_2669 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2688 = _2687.x;
	                    float _2693 = (1.0 - abs(_2688)) - abs(_2687.y);
	                    vec3 _2694 = vec3(_2688, _2687.y, _2693);
	                    float _2696 = saturate(-_2693);
	                    vec2 _2702 = _2687 + mix(vec2(_2696), vec2(-_2696), greaterThanEqual(_2687, vec2(0.0)));
	                    _2694.x = _2702.x;
	                    _2694.y = _2702.y;
	                    vec3 _1036 = normalize(_2694);
	                    vec2 _2709 = ((vec2(float((_2677 >> uint(1)) & 32767u), float((_2677 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2710 = _2709.x;
	                    float _2715 = (1.0 - abs(_2710)) - abs(_2709.y);
	                    vec3 _2716 = vec3(_2710, _2709.y, _2715);
	                    float _2718 = saturate(-_2715);
	                    vec2 _2724 = _2709 + mix(vec2(_2718), vec2(-_2718), greaterThanEqual(_2709, vec2(0.0)));
	                    _2716.x = _2724.x;
	                    _2716.y = _2724.y;
	                    vec3 _1035 = normalize(_2716);
	                    float _1022;
	                    if ((_2677 & 1u) != 0u)
	                    {
	                        _1022 = 1.0;
	                    }
	                    else
	                    {
	                        _1022 = -1.0;
	                    }
	                    _1069[0] = _1036;
	                    _1070[0].w = _1022;
	                    _1070[0].x = _1035.x;
	                    _1070[0].y = _1035.y;
	                    _1070[0].z = _1035.z;
	                    vec2 _2766 = ((vec2(float(_817.x & 65535u), float((_817.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2767 = _2766.x;
	                    float _2772 = (1.0 - abs(_2767)) - abs(_2766.y);
	                    vec3 _2773 = vec3(_2767, _2766.y, _2772);
	                    float _2775 = saturate(-_2772);
	                    vec2 _2781 = _2766 + mix(vec2(_2775), vec2(-_2775), greaterThanEqual(_2766, vec2(0.0)));
	                    _2773.x = _2781.x;
	                    _2773.y = _2781.y;
	                    vec3 _1038 = normalize(_2773);
	                    vec2 _2788 = ((vec2(float((_817.y >> uint(1)) & 32767u), float((_817.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2789 = _2788.x;
	                    float _2794 = (1.0 - abs(_2789)) - abs(_2788.y);
	                    vec3 _2795 = vec3(_2789, _2788.y, _2794);
	                    float _2797 = saturate(-_2794);
	                    vec2 _2803 = _2788 + mix(vec2(_2797), vec2(-_2797), greaterThanEqual(_2788, vec2(0.0)));
	                    _2795.x = _2803.x;
	                    _2795.y = _2803.y;
	                    vec3 _1037 = normalize(_2795);
	                    float _1021;
	                    if ((_817.y & 1u) != 0u)
	                    {
	                        _1021 = 1.0;
	                    }
	                    else
	                    {
	                        _1021 = -1.0;
	                    }
	                    _1069[1] = _1038;
	                    _1070[1].w = _1021;
	                    _1070[1].x = _1037.x;
	                    _1070[1].y = _1037.y;
	                    _1070[1].z = _1037.z;
	                    vec2 _2845 = ((vec2(float(_816.x & 65535u), float((_816.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2846 = _2845.x;
	                    float _2851 = (1.0 - abs(_2846)) - abs(_2845.y);
	                    vec3 _2852 = vec3(_2846, _2845.y, _2851);
	                    float _2854 = saturate(-_2851);
	                    vec2 _2860 = _2845 + mix(vec2(_2854), vec2(-_2854), greaterThanEqual(_2845, vec2(0.0)));
	                    _2852.x = _2860.x;
	                    _2852.y = _2860.y;
	                    vec3 _1040 = normalize(_2852);
	                    vec2 _2867 = ((vec2(float((_816.y >> uint(1)) & 32767u), float((_816.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2868 = _2867.x;
	                    float _2873 = (1.0 - abs(_2868)) - abs(_2867.y);
	                    vec3 _2874 = vec3(_2868, _2867.y, _2873);
	                    float _2876 = saturate(-_2873);
	                    vec2 _2882 = _2867 + mix(vec2(_2876), vec2(-_2876), greaterThanEqual(_2867, vec2(0.0)));
	                    _2874.x = _2882.x;
	                    _2874.y = _2882.y;
	                    vec3 _1039 = normalize(_2874);
	                    float _1020;
	                    if ((_816.y & 1u) != 0u)
	                    {
	                        _1020 = 1.0;
	                    }
	                    else
	                    {
	                        _1020 = -1.0;
	                    }
	                    _1069[2] = _1040;
	                    _1070[2].w = _1020;
	                    _1070[2].x = _1039.x;
	                    _1070[2].y = _1039.y;
	                    _1070[2].z = _1039.z;
	                    break;
	                }
	                else
	                {
	                    uint _184 = _2402.x / 4u;
	                    vec4 _1042 = _1070[0];
	                    float _2424 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_184] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2427 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_184] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2431 = (1.0 - abs(_2424)) - abs(_2427);
	                    vec3 _2432 = vec3(_2424, _2427, _2431);
	                    float _2434 = saturate(-_2431);
	                    vec2 _2435 = vec2(_2424, _2427);
	                    vec2 _2441 = _2435 + mix(vec2(_2434), vec2(-_2434), greaterThanEqual(_2435, vec2(0.0)));
	                    _2432.x = _2441.x;
	                    _2432.y = _2441.y;
	                    vec3 _2446 = normalize(_2432);
	                    vec3 _1041 = _2446;
	                    float _2447 = _2446.z;
	                    float _1029;
	                    if (_2447 >= 0.0)
	                    {
	                        _1029 = 1.0;
	                    }
	                    else
	                    {
	                        _1029 = -1.0;
	                    }
	                    float _2454 = (-1.0) / (_1029 + _2447);
	                    float _2455 = _2446.x;
	                    vec3 _1030;
	                    vec3 _2463 = _1030;
	                    _2463.x = 1.0 + (((_1029 * _2455) * _2455) * _2454);
	                    _2463.y = _1029 * ((_2455 * _2446.y) * _2454);
	                    _2463.z = (-_1029) * _2455;
	                    _1030 = _2463;
	                    float _2471 = float((g_Vertices_3[nonuniformEXT(_182)]._member0[_184] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2477 = (_2463 * cos(_2471)) + (cross(_2446, _2463) * sin(_2471));
	                    vec4 _2479 = _1042;
	                    _2479.x = _2477.x;
	                    _2479.y = _2477.y;
	                    _2479.z = _2477.z;
	                    _1042 = _2479;
	                    float _1031;
	                    if ((g_Vertices_3[nonuniformEXT(_182)]._member0[_184] & 1u) == 0u)
	                    {
	                        _1031 = -1.0;
	                    }
	                    else
	                    {
	                        _1031 = 1.0;
	                    }
	                    vec4 _2490 = _1042;
	                    _2490.w = _1031;
	                    _1042 = _2490;
	                    _1069[0] = _1041;
	                    _1070[0] = _2490;
	                    uint _187 = _2402.y / 4u;
	                    vec4 _1044 = _1070[1];
	                    float _2506 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_187] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2509 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_187] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2513 = (1.0 - abs(_2506)) - abs(_2509);
	                    vec3 _2514 = vec3(_2506, _2509, _2513);
	                    float _2516 = saturate(-_2513);
	                    vec2 _2517 = vec2(_2506, _2509);
	                    vec2 _2523 = _2517 + mix(vec2(_2516), vec2(-_2516), greaterThanEqual(_2517, vec2(0.0)));
	                    _2514.x = _2523.x;
	                    _2514.y = _2523.y;
	                    vec3 _2528 = normalize(_2514);
	                    vec3 _1043 = _2528;
	                    float _2529 = _2528.z;
	                    float _1026;
	                    if (_2529 >= 0.0)
	                    {
	                        _1026 = 1.0;
	                    }
	                    else
	                    {
	                        _1026 = -1.0;
	                    }
	                    float _2536 = (-1.0) / (_1026 + _2529);
	                    float _2537 = _2528.x;
	                    vec3 _1027;
	                    vec3 _2545 = _1027;
	                    _2545.x = 1.0 + (((_1026 * _2537) * _2537) * _2536);
	                    _2545.y = _1026 * ((_2537 * _2528.y) * _2536);
	                    _2545.z = (-_1026) * _2537;
	                    _1027 = _2545;
	                    float _2553 = float((g_Vertices_3[nonuniformEXT(_182)]._member0[_187] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2559 = (_2545 * cos(_2553)) + (cross(_2528, _2545) * sin(_2553));
	                    vec4 _2561 = _1044;
	                    _2561.x = _2559.x;
	                    _2561.y = _2559.y;
	                    _2561.z = _2559.z;
	                    _1044 = _2561;
	                    float _1028;
	                    if ((g_Vertices_3[nonuniformEXT(_182)]._member0[_187] & 1u) == 0u)
	                    {
	                        _1028 = -1.0;
	                    }
	                    else
	                    {
	                        _1028 = 1.0;
	                    }
	                    vec4 _2572 = _1044;
	                    _2572.w = _1028;
	                    _1044 = _2572;
	                    _1069[1] = _1043;
	                    _1070[1] = _2572;
	                    uint _190 = _2402.z / 4u;
	                    vec4 _1046 = _1070[2];
	                    float _2588 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_190] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2591 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_190] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2595 = (1.0 - abs(_2588)) - abs(_2591);
	                    vec3 _2596 = vec3(_2588, _2591, _2595);
	                    float _2598 = saturate(-_2595);
	                    vec2 _2599 = vec2(_2588, _2591);
	                    vec2 _2605 = _2599 + mix(vec2(_2598), vec2(-_2598), greaterThanEqual(_2599, vec2(0.0)));
	                    _2596.x = _2605.x;
	                    _2596.y = _2605.y;
	                    vec3 _2610 = normalize(_2596);
	                    vec3 _1045 = _2610;
	                    float _2611 = _2610.z;
	                    float _1023;
	                    if (_2611 >= 0.0)
	                    {
	                        _1023 = 1.0;
	                    }
	                    else
	                    {
	                        _1023 = -1.0;
	                    }
	                    float _2618 = (-1.0) / (_1023 + _2611);
	                    float _2619 = _2610.x;
	                    vec3 _1024;
	                    vec3 _2627 = _1024;
	                    _2627.x = 1.0 + (((_1023 * _2619) * _2619) * _2618);
	                    _2627.y = _1023 * ((_2619 * _2610.y) * _2618);
	                    _2627.z = (-_1023) * _2619;
	                    _1024 = _2627;
	                    float _2635 = float((g_Vertices_3[nonuniformEXT(_182)]._member0[_190] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2641 = (_2627 * cos(_2635)) + (cross(_2610, _2627) * sin(_2635));
	                    vec4 _2643 = _1046;
	                    _2643.x = _2641.x;
	                    _2643.y = _2641.y;
	                    _2643.z = _2641.z;
	                    _1046 = _2643;
	                    float _1025;
	                    if ((g_Vertices_3[nonuniformEXT(_182)]._member0[_190] & 1u) == 0u)
	                    {
	                        _1025 = -1.0;
	                    }
	                    else
	                    {
	                        _1025 = 1.0;
	                    }
	                    vec4 _2654 = _1046;
	                    _2654.w = _1025;
	                    _1046 = _2654;
	                    _1069[2] = _1045;
	                    _1070[2] = _2654;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _1069[0] = vec3(0.0);
	            _1069[1] = vec3(0.0);
	            _1069[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _1047 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _240 = uint(_1047[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _2932 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _1018 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _1019 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2948 = (uvec3(uint(_1018[_2932])) * _1072) + uvec3(uint(_1019[_2932]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _2950 = _2948.x;
	            _1070[0] = vec4(g_Vertices_1[nonuniformEXT(_240)]._member0[_2950 / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2950 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2950 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2950 + 12u) / 4u]);
	            uint _2956 = _2948.y;
	            _1070[1] = vec4(g_Vertices_1[nonuniformEXT(_240)]._member0[_2956 / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2956 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2956 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2956 + 12u) / 4u]);
	            uint _2962 = _2948.z;
	            _1070[2] = vec4(g_Vertices_1[nonuniformEXT(_240)]._member0[_2962 / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2962 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2962 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_2962 + 12u) / 4u]);
	        }
	        else
	        {
	            _1070[0] = vec4(0.0);
	            _1070[1] = vec4(0.0);
	            _1070[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _1067 = 0;
	    for (;;)
	    {
	        if (!(_1067 < 3))
	        {
	            break;
	        }
	        vsInput[_1067].vNormalOs = _1069[_1067];
	        vsInput[_1067].vTangentUOs_flTangentVSign = _1070[_1067];
	        _1067++;
	        continue;
	    }
	    vec4 _1071[3];
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _1017 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _278 = uint(_1017[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _3009 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _1015 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1016 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3025 = (uvec3(uint(_1015[_3009])) * _1072) + uvec3(uint(_1016[_3009]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _3067 = _3025.x;
	            _1071[0] = vec4(g_Vertices_1[nonuniformEXT(_278)]._member0[_3067 / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3067 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3067 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3067 + 12u) / 4u]);
	            uint _3073 = _3025.y;
	            _1071[1] = vec4(g_Vertices_1[nonuniformEXT(_278)]._member0[_3073 / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3073 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3073 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3073 + 12u) / 4u]);
	            uint _3079 = _3025.z;
	            _1071[2] = vec4(g_Vertices_1[nonuniformEXT(_278)]._member0[_3079 / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3079 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3079 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_3079 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _280 = _3025.x / 4u;
	            _1071[0] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_278)]._member0[_280] & 255u, (g_Vertices_3[nonuniformEXT(_278)]._member0[_280] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_278)]._member0[_280] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_278)]._member0[_280] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _283 = _3025.y / 4u;
	            _1071[1] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_278)]._member0[_283] & 255u, (g_Vertices_3[nonuniformEXT(_278)]._member0[_283] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_278)]._member0[_283] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_278)]._member0[_283] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _286 = _3025.z / 4u;
	            _1071[2] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_278)]._member0[_286] & 255u, (g_Vertices_3[nonuniformEXT(_278)]._member0[_286] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_278)]._member0[_286] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_278)]._member0[_286] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _1071[0] = vec4(0.0);
	        _1071[1] = vec4(0.0);
	        _1071[2] = vec4(0.0);
	    }
	    _1067 = 0;
	    for (;;)
	    {
	        if (!(_1067 < 3))
	        {
	            break;
	        }
	        vsInput[_1067].vBlendColorTint = _1071[_1067];
	        _1067++;
	        continue;
	    }
	    vec4 _1074[3];
	    _1074[0] = vec4(0.0);
	    _1074[1] = vec4(0.0);
	    _1074[2] = vec4(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _1014 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _326 = uint(_1014[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _3122 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _1012 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1013 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3138 = (uvec3(uint(_1012[_3122])) * _1072) + uvec3(uint(_1013[_3122]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _3179 = _3138.x;
	            _1074[0] = vec4(g_Vertices_1[nonuniformEXT(_326)]._member0[_3179 / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3179 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3179 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3179 + 12u) / 4u]);
	            uint _3184 = _3138.y;
	            _1074[1] = vec4(g_Vertices_1[nonuniformEXT(_326)]._member0[_3184 / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3184 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3184 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3184 + 12u) / 4u]);
	            uint _3189 = _3138.z;
	            _1074[2] = vec4(g_Vertices_1[nonuniformEXT(_326)]._member0[_3189 / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3189 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3189 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_3189 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _328 = _3138.x / 4u;
	                _1074[0] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_326)]._member0[_328] & 255u, (g_Vertices_3[nonuniformEXT(_326)]._member0[_328] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_326)]._member0[_328] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_326)]._member0[_328] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _331 = _3138.y / 4u;
	                _1074[1] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_326)]._member0[_331] & 255u, (g_Vertices_3[nonuniformEXT(_326)]._member0[_331] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_326)]._member0[_331] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_326)]._member0[_331] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _334 = _3138.z / 4u;
	                _1074[2] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_326)]._member0[_334] & 255u, (g_Vertices_3[nonuniformEXT(_326)]._member0[_334] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_326)]._member0[_334] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_326)]._member0[_334] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _1075 = 0;
	    for (;;)
	    {
	        if (!(_1075 < 3))
	        {
	            break;
	        }
	        vsInput[_1075].vColorBlendValues = _1074[_1075];
	        _1075++;
	        continue;
	    }
	    vec2 _835 = vsInput[0].vTexCoord;
	    vec2 _834 = vsInput[0].vTexCoord2;
	    vec4 _833 = vsInput[0].vBlendColorTint;
	    vec3 _1009 = vsInput[0].vNormalOs;
	    vec4 _1010;
	    vec4 _3222 = _1010;
	    _3222.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _3222.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _3222.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _3222.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _1010 = _3222;
	    vec4 _3245 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _1008 = _3245;
	    vec3 _3246 = _3245.xyz;
	    vec3 _3247 = _3246 * vec3(0.077399380505084991455078125);
	    vec3 _3250 = pow((_3246 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _1005;
	    if (_3245.x <= 0.040449999272823333740234375)
	    {
	        _1005 = _3247.x;
	    }
	    else
	    {
	        _1005 = _3250.x;
	    }
	    float _1006;
	    if (_3245.y <= 0.040449999272823333740234375)
	    {
	        _1006 = _3247.y;
	    }
	    else
	    {
	        _1006 = _3250.y;
	    }
	    float _1007;
	    if (_3245.z <= 0.040449999272823333740234375)
	    {
	        _1007 = _3247.z;
	    }
	    else
	    {
	        _1007 = _3250.z;
	    }
	    vec3 _3275 = vec3(_1005, _1006, _1007);
	    vec4 _3277 = _1008;
	    _3277.x = _3275.x;
	    _3277.y = _3275.y;
	    _3277.z = _3275.z;
	    _1008 = _3277;
	    vec4 _844;
	    vec4 _3284 = _844;
	    _3284.x = _3277.x;
	    _3284.y = _3277.y;
	    _3284.z = _3277.z;
	    _3284.w = _3277.w;
	    _844 = _3284;
	    mat3x4 _3295 = transpose(gl_WorldToObjectEXT);
	    mat3 _1004;
	    mat3 _3298 = _1004;
	    _3298[0] = _3295[0].xyz;
	    _3298[1] = _3295[1].xyz;
	    _3298[2] = _3295[2].xyz;
	    _1004 = _3298;
	    vec3 _3307 = normalize(_3298 * _1009.xyz);
	    vec3 _845;
	    vec3 _3309 = _845;
	    _3309.x = _3307.x;
	    _3309.y = _3307.y;
	    _3309.z = _3307.z;
	    _845 = _3309;
	    mat3x4 _3321 = transpose(gl_WorldToObjectEXT);
	    mat3 _1003;
	    mat3 _3324 = _1003;
	    _3324[0] = _3321[0].xyz;
	    _3324[1] = _3321[1].xyz;
	    _3324[2] = _3321[2].xyz;
	    _1003 = _3324;
	    vec3 _3333 = normalize(_3324 * _1010.xyz);
	    vec4 _843;
	    vec4 _3335 = _843;
	    _3335.x = _3333.x;
	    _3335.y = _3333.y;
	    _3335.z = _3333.z;
	    _3335.w = _1010.w;
	    _843 = _3335;
	    vec4 _3344 = _835.xyxy;
	    _3344.z = _834.x;
	    _3344.w = _834.y;
	    vec4 _846;
	    vec4 _842 = _846;
	    vec3 _841 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _840 = _3309;
	    vec4 _839 = _3344;
	    vec4 _838 = _3284;
	    vec4 _837 = _3335;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        vec2 _1011;
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _1011 = _3344.zw;
	        }
	        else
	        {
	            _1011 = _3344.xy;
	        }
	        vec4 _3366 = _839;
	        _3366.x = _1011.x;
	        _3366.y = _1011.y;
	        vec4 _3385 = _3366;
	        _3385.x = dot(_3366.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _3385.y = dot(_3366.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _839 = _3385;
	    }
	    vec4 _3387 = _838;
	    vec4 _3389 = _842;
	    _3389.x = _3387.x;
	    _3389.y = _3387.y;
	    _3389.z = _3387.z;
	    _3389.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_3389.x, min(_3389.y, _3389.z)));
	    _842 = _3389;
	    _3387.x = _g_rtx_material_data_.g_vColorTint.x;
	    _3387.y = _g_rtx_material_data_.g_vColorTint.y;
	    _3387.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _3418 = _3387.xyz * mix(vec3(1.0), _833.xyz, vec3(_833.w));
	    vec4 _3420 = _3387;
	    _3420.x = _3418.x;
	    _3420.y = _3418.y;
	    _3420.z = _3418.z;
	    _838 = _3420;
	    vec4 _815 = _3389;
	    vec3 _814 = _841;
	    vec3 _813 = _840;
	    vec4 _812 = _839;
	    vec4 _811 = _3420;
	    vec4 _810 = _837;
	    vec2 _832 = vsInput[1].vTexCoord;
	    vec2 _831 = vsInput[1].vTexCoord2;
	    vec4 _830 = vsInput[1].vBlendColorTint;
	    vec3 _1000 = vsInput[1].vNormalOs;
	    vec4 _1001;
	    vec4 _3438 = _1001;
	    _3438.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _3438.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _3438.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _3438.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _1001 = _3438;
	    vec4 _3461 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _999 = _3461;
	    vec3 _3462 = _3461.xyz;
	    vec3 _3463 = _3462 * vec3(0.077399380505084991455078125);
	    vec3 _3466 = pow((_3462 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _996;
	    if (_3461.x <= 0.040449999272823333740234375)
	    {
	        _996 = _3463.x;
	    }
	    else
	    {
	        _996 = _3466.x;
	    }
	    float _997;
	    if (_3461.y <= 0.040449999272823333740234375)
	    {
	        _997 = _3463.y;
	    }
	    else
	    {
	        _997 = _3466.y;
	    }
	    float _998;
	    if (_3461.z <= 0.040449999272823333740234375)
	    {
	        _998 = _3463.z;
	    }
	    else
	    {
	        _998 = _3466.z;
	    }
	    vec3 _3491 = vec3(_996, _997, _998);
	    vec4 _3493 = _999;
	    _3493.x = _3491.x;
	    _3493.y = _3491.y;
	    _3493.z = _3491.z;
	    _999 = _3493;
	    vec4 _854;
	    vec4 _3500 = _854;
	    _3500.x = _3493.x;
	    _3500.y = _3493.y;
	    _3500.z = _3493.z;
	    _3500.w = _3493.w;
	    _854 = _3500;
	    mat3x4 _3511 = transpose(gl_WorldToObjectEXT);
	    mat3 _995;
	    mat3 _3514 = _995;
	    _3514[0] = _3511[0].xyz;
	    _3514[1] = _3511[1].xyz;
	    _3514[2] = _3511[2].xyz;
	    _995 = _3514;
	    vec3 _3523 = normalize(_3514 * _1000.xyz);
	    vec3 _855;
	    vec3 _3525 = _855;
	    _3525.x = _3523.x;
	    _3525.y = _3523.y;
	    _3525.z = _3523.z;
	    _855 = _3525;
	    mat3x4 _3537 = transpose(gl_WorldToObjectEXT);
	    mat3 _994;
	    mat3 _3540 = _994;
	    _3540[0] = _3537[0].xyz;
	    _3540[1] = _3537[1].xyz;
	    _3540[2] = _3537[2].xyz;
	    _994 = _3540;
	    vec3 _3549 = normalize(_3540 * _1001.xyz);
	    vec4 _853;
	    vec4 _3551 = _853;
	    _3551.x = _3549.x;
	    _3551.y = _3549.y;
	    _3551.z = _3549.z;
	    _3551.w = _1001.w;
	    _853 = _3551;
	    vec4 _3560 = _832.xyxy;
	    _3560.z = _831.x;
	    _3560.w = _831.y;
	    vec4 _856;
	    vec4 _852 = _856;
	    vec3 _851 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _850 = _3525;
	    vec4 _849 = _3560;
	    vec4 _848 = _3500;
	    vec4 _847 = _3551;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        vec2 _1002;
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _1002 = _3560.zw;
	        }
	        else
	        {
	            _1002 = _3560.xy;
	        }
	        vec4 _3582 = _849;
	        _3582.x = _1002.x;
	        _3582.y = _1002.y;
	        vec4 _3601 = _3582;
	        _3601.x = dot(_3582.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _3601.y = dot(_3582.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _849 = _3601;
	    }
	    vec4 _3603 = _848;
	    vec4 _3605 = _852;
	    _3605.x = _3603.x;
	    _3605.y = _3603.y;
	    _3605.z = _3603.z;
	    _3605.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_3605.x, min(_3605.y, _3605.z)));
	    _852 = _3605;
	    _3603.x = _g_rtx_material_data_.g_vColorTint.x;
	    _3603.y = _g_rtx_material_data_.g_vColorTint.y;
	    _3603.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _3634 = _3603.xyz * mix(vec3(1.0), _830.xyz, vec3(_830.w));
	    vec4 _3636 = _3603;
	    _3636.x = _3634.x;
	    _3636.y = _3634.y;
	    _3636.z = _3634.z;
	    _848 = _3636;
	    vec4 _809 = _3605;
	    vec3 _808 = _851;
	    vec3 _807 = _850;
	    vec4 _806 = _849;
	    vec4 _805 = _3636;
	    vec4 _804 = _847;
	    vec2 _829 = vsInput[2].vTexCoord;
	    vec2 _828 = vsInput[2].vTexCoord2;
	    vec4 _827 = vsInput[2].vBlendColorTint;
	    vec3 _991 = vsInput[2].vNormalOs;
	    vec4 _992;
	    vec4 _3654 = _992;
	    _3654.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _3654.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _3654.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _3654.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _992 = _3654;
	    vec4 _3677 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _990 = _3677;
	    vec3 _3678 = _3677.xyz;
	    vec3 _3679 = _3678 * vec3(0.077399380505084991455078125);
	    vec3 _3682 = pow((_3678 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _987;
	    if (_3677.x <= 0.040449999272823333740234375)
	    {
	        _987 = _3679.x;
	    }
	    else
	    {
	        _987 = _3682.x;
	    }
	    float _988;
	    if (_3677.y <= 0.040449999272823333740234375)
	    {
	        _988 = _3679.y;
	    }
	    else
	    {
	        _988 = _3682.y;
	    }
	    float _989;
	    if (_3677.z <= 0.040449999272823333740234375)
	    {
	        _989 = _3679.z;
	    }
	    else
	    {
	        _989 = _3682.z;
	    }
	    vec3 _3707 = vec3(_987, _988, _989);
	    vec4 _3709 = _990;
	    _3709.x = _3707.x;
	    _3709.y = _3707.y;
	    _3709.z = _3707.z;
	    _990 = _3709;
	    vec4 _864;
	    vec4 _3716 = _864;
	    _3716.x = _3709.x;
	    _3716.y = _3709.y;
	    _3716.z = _3709.z;
	    _3716.w = _3709.w;
	    _864 = _3716;
	    mat3x4 _3727 = transpose(gl_WorldToObjectEXT);
	    mat3 _986;
	    mat3 _3730 = _986;
	    _3730[0] = _3727[0].xyz;
	    _3730[1] = _3727[1].xyz;
	    _3730[2] = _3727[2].xyz;
	    _986 = _3730;
	    vec3 _3739 = normalize(_3730 * _991.xyz);
	    vec3 _865;
	    vec3 _3741 = _865;
	    _3741.x = _3739.x;
	    _3741.y = _3739.y;
	    _3741.z = _3739.z;
	    _865 = _3741;
	    mat3x4 _3753 = transpose(gl_WorldToObjectEXT);
	    mat3 _985;
	    mat3 _3756 = _985;
	    _3756[0] = _3753[0].xyz;
	    _3756[1] = _3753[1].xyz;
	    _3756[2] = _3753[2].xyz;
	    _985 = _3756;
	    vec3 _3765 = normalize(_3756 * _992.xyz);
	    vec4 _863;
	    vec4 _3767 = _863;
	    _3767.x = _3765.x;
	    _3767.y = _3765.y;
	    _3767.z = _3765.z;
	    _3767.w = _992.w;
	    _863 = _3767;
	    vec4 _3776 = _829.xyxy;
	    _3776.z = _828.x;
	    _3776.w = _828.y;
	    vec4 _866;
	    vec4 _862 = _866;
	    vec3 _861 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _860 = _3741;
	    vec4 _859 = _3776;
	    vec4 _858 = _3716;
	    vec4 _857 = _3767;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        vec2 _993;
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _993 = _3776.zw;
	        }
	        else
	        {
	            _993 = _3776.xy;
	        }
	        vec4 _3798 = _859;
	        _3798.x = _993.x;
	        _3798.y = _993.y;
	        vec4 _3817 = _3798;
	        _3817.x = dot(_3798.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _3817.y = dot(_3798.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _859 = _3817;
	    }
	    vec4 _3819 = _858;
	    vec4 _3821 = _862;
	    _3821.x = _3819.x;
	    _3821.y = _3819.y;
	    _3821.z = _3819.z;
	    _3821.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_3821.x, min(_3821.y, _3821.z)));
	    _862 = _3821;
	    _3819.x = _g_rtx_material_data_.g_vColorTint.x;
	    _3819.y = _g_rtx_material_data_.g_vColorTint.y;
	    _3819.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _3850 = _3819.xyz * mix(vec3(1.0), _827.xyz, vec3(_827.w));
	    vec4 _3852 = _3819;
	    _3852.x = _3850.x;
	    _3852.y = _3850.y;
	    _3852.z = _3850.z;
	    _858 = _3852;
	    vec3 _803 = _861;
	    vec3 _802 = _860;
	    vec3 _3883 = ((_813 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_807 * attrs.barycentrics.x)) + (_860 * attrs.barycentrics.y);
	    bool _3889 = gl_HitKindEXT == 254u;
	    vec3 _867;
	    vec3 _868;
	    vec4 _826 = ((_815 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_809 * attrs.barycentrics.x)) + (_3821 * attrs.barycentrics.y);
	    vec3 _825 = _868;
	    vec3 _824 = _3883;
	    vec4 _823 = ((_812 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_806 * attrs.barycentrics.x)) + (_859 * attrs.barycentrics.y);
	    vec4 _822 = ((_811 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_805 * attrs.barycentrics.x)) + (_3852 * attrs.barycentrics.y);
	    vec4 _821 = ((_810 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_804 * attrs.barycentrics.x)) + (_857 * attrs.barycentrics.y);
	    bool _820 = _3889;
	    vec3 _877 = _867;
	    vec3 _876 = normalize(cross(_808 - _814, _861 - _814));
	    bool _875 = _3889;
	    vec3 _886 = vec3(0.5);
	    vec2 _885 = vec2(0.5);
	    float _884 = 0.0;
	    vec3 _883 = vec3(0.0);
	    float _882 = 0.039999999105930328369140625;
	    vec3 _881 = vec3(0.0);
	    vec3 _879 = vec3(1.0);
	    bool _878 = false;
	    vec3 _3928 = _3883.xyz;
	    vec3 _880 = _3928;
	    if (dot(_3928, _3928) >= 1.0099999904632568359375)
	    {
	        _880 = _877.xyz;
	    }
	    _882 = _g_rtx_material_data_.g_flReflectance;
	    _879 = _876;
	    bool _983;
	    if (_g_rtx_material_data_.g_bRenderBackfaceNormals)
	    {
	        _983 = !_g_rtx_material_data_.g_bDontFlipBackfaceNormals;
	    }
	    else
	    {
	        _983 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_983)
	    {
	        float _984;
	        if (_875)
	        {
	            _984 = 1.0;
	        }
	        else
	        {
	            _984 = -1.0;
	        }
	        _880 *= _984;
	        if (_875)
	        {
	            _984 = 1.0;
	        }
	        else
	        {
	            _984 = -1.0;
	        }
	        _879 *= _984;
	        _878 = !_875;
	    }
	    vec3 _3962 = _880;
	    vec3 _3963 = normalize(_3962);
	    _880 = _3963;
	    vec4 _874 = _826;
	    vec3 _873 = _825;
	    vec3 _872 = _824;
	    vec4 _871 = _823;
	    vec4 _870 = _822;
	    bool _869 = _820;
	    vec3 _920 = _3963;
	    vec3 _919 = _886;
	    vec2 _918 = _885;
	    float _917 = _884;
	    vec3 _916 = _883;
	    float _915 = _882;
	    vec3 _914 = _881;
	    vec3 _913 = _3963;
	    vec3 _912 = _879;
	    bool _911 = _878;
	    bool _981;
	    if (_g_rtx_material_data_.g_bRenderBackfaceNormals)
	    {
	        _981 = !_g_rtx_material_data_.g_bDontFlipBackfaceNormals;
	    }
	    else
	    {
	        _981 = false;
	    }
	    if (_981)
	    {
	        float _982;
	        if (_869)
	        {
	            _982 = 1.0;
	        }
	        else
	        {
	            _982 = -1.0;
	        }
	        _981 = _982 < 0.0;
	    }
	    else
	    {
	        _981 = false;
	    }
	    vec3 _924 = vec3(0.0);
	    vec3 _923 = vec3(0.0);
	    float _979;
	    if (_821.w > 0.0)
	    {
	        _979 = 1.0;
	    }
	    else
	    {
	        _979 = -1.0;
	    }
	    float _4014 = 1.0 / length(_872);
	    vec3 _925 = _872 * _4014;
	    vec3 _819 = _821.xyz * _4014;
	    vec3 _818 = (cross(_872, _821.xyz) * _979) * _4014;
	    if (_981)
	    {
	        _925 *= (-1.0);
	    }
	    vec3 _922 = _924 - (_925 * dot(_924, _925));
	    vec3 _921 = _923 - (_925 * dot(_923, _925));
	    int _980;
	    if (dot(_923, cross(_925, _924)) < 0.0)
	    {
	        _980 = -1;
	    }
	    else
	    {
	        _980 = 1;
	    }
	    vec3 _948 = _925;
	    vec3 _947 = _922;
	    vec3 _946 = _921;
	    float _945 = float(_980);
	    vec3 _909;
	    vec3 _910;
	    if (_g_rtx_material_data_.g_nUVSet1 > 1)
	    {
	        float _978;
	        if (false)
	        {
	            _978 = -1.0;
	        }
	        else
	        {
	            _978 = 1.0;
	        }
	        vec2 _4051 = vec2(0.0, -0.0) * _978;
	        vec3 _926 = (_947 * _4051.x) + (_946 * _4051.y);
	        float _4059 = abs(0.0);
	        if (_4059 > 0.0)
	        {
	            _926 = normalize(_926);
	        }
	        _910 = _926;
	        _909 = cross(_948, _926) * (_978 * _945);
	    }
	    else
	    {
	        _910 = vec3(0.0);
	        _909 = vec3(0.0);
	    }
	    vec2 _908 = vec2(0.0);
	    vec2 _907 = vec2(0.0);
	    vec2 _906 = vec2(0.0);
	    vec2 _905 = vec2(0.0);
	    vec2 _904 = vec2(0.0);
	    vec2 _903 = vec2(0.0);
	    vec2 _902 = vec2(0.0);
	    ivec2 _901 = ivec2(0);
	    ivec2 _900 = ivec2(0);
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        vec3 _4079 = abs(_913);
	        vec3 _973 = _4079;
	        float _4080 = _4079.x;
	        float _4081 = _4079.y;
	        bool _974;
	        if (_4080 > _4081)
	        {
	            _974 = _4080 > _4079.z;
	        }
	        else
	        {
	            _974 = false;
	        }
	        ivec3 _975;
	        if (_974)
	        {
	            _975 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_4081 > _4079.z)
	            {
	                _975 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _975 = ivec3(2, 0, 1);
	            }
	        }
	        if (_4080 < _4081)
	        {
	            _974 = _4080 < _4079.z;
	        }
	        else
	        {
	            _974 = false;
	        }
	        ivec3 _976;
	        if (_974)
	        {
	            _976 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_4081 < _4079.z)
	            {
	                _976 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _976 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _4115 = (ivec3(3) - _976) - _975;
	        ivec2 _977;
	        if (_975.x == 1)
	        {
	            _977 = _975.zy;
	        }
	        else
	        {
	            _977 = _975.yz;
	        }
	        ivec2 _4127 = _901;
	        _4127.x = _977.x;
	        _4127.y = _977.y;
	        _901 = _4127;
	        int _4131 = _4115.x;
	        if (_4131 == 1)
	        {
	            _977 = _4115.zy;
	        }
	        else
	        {
	            _977 = _4115.yz;
	        }
	        ivec2 _4140 = _900;
	        _4140.x = _977.x;
	        _4140.y = _977.y;
	        _900 = _4140;
	        vec2 _4151 = saturate((vec2(_973[_975.x], _973[_4131]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625));
	        _902 = _4151 / vec2(_4151.x + _4151.y);
	        vec3 _964 = _873 * _g_rtx_material_data_.g_vBiplanarTexCoordScale.xyz;
	        _908 = vec2(_964[_901.x], _964[_901.y]);
	        vec3 _965 = vec3(0.0);
	        vec3 _966 = vec3(0.0);
	        _906 = vec2(_965[_901.x], _966[_901.y]);
	        vec3 _967 = vec3(0.0);
	        vec3 _968 = vec3(0.0);
	        _905 = vec2(_967[_901.x], _968[_901.y]);
	        _907 = vec2(_964[_4140.x], _964[_4140.y]);
	        vec3 _969 = vec3(0.0);
	        vec3 _970 = vec3(0.0);
	        _904 = vec2(_969[_4140.x], _970[_4140.y]);
	        vec3 _971 = vec3(0.0);
	        vec3 _972 = vec3(0.0);
	        _903 = vec2(_971[_4140.x], _972[_4140.y]);
	    }
	    vec4 _899 = vec4(0.0);
	    vec3 _898 = vec3(0.0);
	    vec4 _895 = vec4(0.0);
	    float _894 = 0.0;
	    float _893 = 0.0;
	    float _892 = 0.0;
	    vec3 _4209 = vec3(0.0);
	    _4209.x = _871.x;
	    _4209.y = _871.y;
	    vec3 _897 = _4209;
	    vec2 _896 = _g_rtx_material_data_.g_vTexCoordScale1.xy;
	    vec2 _933 = _908;
	    vec2 _932 = _907;
	    vec2 _931 = _906;
	    vec2 _930 = _905;
	    vec2 _929 = _904;
	    vec2 _928 = _903;
	    vec2 _927 = _902;
	    vec4 _963;
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        vec2 _4234 = _933;
	        vec2 _4235 = _4234 * _896;
	        _933 = _4235;
	        vec2 _4236 = _931;
	        vec2 _4237 = _4236 * _896;
	        _931 = _4237;
	        vec2 _4238 = _930;
	        vec2 _4239 = _4238 * _896;
	        _930 = _4239;
	        vec2 _4240 = _932;
	        vec2 _4241 = _4240 * _896;
	        _932 = _4241;
	        vec2 _4242 = _929;
	        vec2 _4243 = _4242 * _896;
	        _929 = _4243;
	        vec2 _4244 = _928;
	        vec2 _4245 = _4244 * _896;
	        _928 = _4245;
	        _963 = (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _4235.xy, _4237.xy, _4239.xy) * _927.x) + (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _4241.xy, _4243.xy, _4245.xy) * _927.y);
	    }
	    else
	    {
	        _963 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _897.xy, 0.0).xyzw;
	    }
	    _893 = _963.y;
	    _894 = _963.w;
	    vec3 _891 = _913;
	    vec3 _890 = _819;
	    vec3 _889 = _818;
	    vec3 _888 = _910;
	    vec3 _887 = _909;
	    vec2 _944 = _908;
	    vec2 _943 = _907;
	    vec2 _942 = _906;
	    vec2 _941 = _905;
	    vec2 _940 = _904;
	    vec2 _939 = _903;
	    vec2 _938 = _902;
	    ivec2 _937 = _901;
	    ivec2 _936 = _900;
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        _944 *= _896;
	        _942 *= _896;
	        _941 *= _896;
	        _943 *= _896;
	        _940 *= _896;
	        _939 *= _896;
	        _898 = _891;
	        if (true)
	        {
	            _899 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _944.xy, _942.xy, _941.xy) * _938.x;
	        }
	        if (true)
	        {
	            vec4 _4422 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _944.xy, _942.xy, _941.xy);
	            _892 = _4422.z * _938.x;
	            float _4427 = _4422.x;
	            float _4428 = _4422.y;
	            float _4430 = (_4427 + _4428) - 1.00392162799835205078125;
	            float _4431 = _4427 - _4428;
	            vec3 _4441 = normalize(vec3(vec2(_4430, _4431), (1.0 - abs(_4430)) - abs(_4431))).xyz * _938.x;
	            vec4 _4443;
	            _4443.x = _4441.x;
	            _4443.y = _4441.y;
	            vec4 _4447 = _4443;
	            _4447.z = _4441.z;
	            _898 = (_735[_937.x] * _4443.x) + (_739[_937.y] * _4443.y);
	        }
	        if (_938.y > 0.0)
	        {
	            if (true)
	            {
	                _899 += (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _943.xy, _940.xy, _939.xy) * _938.y);
	            }
	            if (true)
	            {
	                vec4 _4495 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _943.xy, _940.xy, _939.xy);
	                _892 += (_4495.z * _938.y);
	                float _4502 = _4495.x;
	                float _4503 = _4495.y;
	                float _4505 = (_4502 + _4503) - 1.00392162799835205078125;
	                float _4506 = _4502 - _4503;
	                vec3 _4516 = normalize(vec3(vec2(_4505, _4506), (1.0 - abs(_4505)) - abs(_4506))).xyz * _938.y;
	                vec4 _4518;
	                _4518.x = _4516.x;
	                _4518.y = _4516.y;
	                vec4 _4522 = _4518;
	                _4522.z = _4516.z;
	                _898 += ((_735[_936.x] * _4518.x) + (_739[_936.y] * _4518.y));
	            }
	        }
	        _898 = normalize(_898 + _891);
	    }
	    else
	    {
	        if (true)
	        {
	            _899 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _897.xy, _895.xy, _895.zw).xyzw;
	        }
	        if (true)
	        {
	            vec4 _4317 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _897.xy, _895.xy, _895.zw);
	            vec3 _4318 = _4317.xyz;
	            _892 = _4317.z;
	            float _4320 = _4317.x;
	            float _4321 = _4317.y;
	            float _4323 = (_4320 + _4321) - 1.00392162799835205078125;
	            float _4324 = _4320 - _4321;
	            vec3 _4331 = normalize(vec3(vec2(_4323, _4324), (1.0 - abs(_4323)) - abs(_4324)));
	            _4318.x = _4331.x;
	            _4318.y = _4331.y;
	            _4318.z = _4331.z;
	            vec3 _4344 = _4318;
	            _4344.x = dot(_4318.xy, _g_rtx_material_data_.g_vNormalXform_1.xy);
	            _4344.y = dot(_4318.xy, _g_rtx_material_data_.g_vNormalXform_1.zw);
	            vec3 _962 = _4344;
	            vec3 _934;
	            vec3 _935;
	            if (_g_rtx_material_data_.g_nUVSet1 > 1)
	            {
	                _935 = _888;
	                _934 = _887;
	            }
	            else
	            {
	                _935 = _890;
	                _934 = _889;
	            }
	            vec3 _4356 = abs(_962.xyz);
	            vec2 _4369 = (-vec2(_962.x, (-1.0) * _962.y)) / vec2(max(_4356.z, 0.0078125 * max(_4356.x, _4356.y)));
	            _898 = normalize(_948 - ((_935 * _4369.x) + (_934 * _4369.y)));
	        }
	    }
	    if (true)
	    {
	        _898 = normalize(_898);
	        _892 = saturate(_892);
	    }
	    vec4 _957;
	    if (false)
	    {
	        _957 = vec4((vec4(_899.xyz, 1.0) * _g_rtx_material_data_.g_mTextureAdjust1).xyz, _899.w);
	    }
	    else
	    {
	        _957 = _899;
	    }
	    vec4 _4565 = _957;
	    float _4567 = _893;
	    float _4568 = saturate(_4567);
	    _893 = _4568;
	    vec3 _4572 = mix(_4565.xyz, vec4((vec4(_899.xyz, 1.0) * _g_rtx_material_data_.g_mTextureColorAdjust1).xyz, _797).xyz, vec3(_4568));
	    vec4 _4574 = _4565;
	    _4574.x = _4572.x;
	    _4574.y = _4572.y;
	    _4574.z = _4572.z;
	    float _4584 = dot(_4574.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _4587 = normalize(max(_874.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _4606 = vec4(saturate(mix(_4574.xyz, (_4587 * min(_4584 / dot(_4587.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _4584) * max(_874.x, max(_874.y, _874.z)))).xyz, vec3(_874.w * _4568))).xyz, _4574.w);
	    _899 = _4606;
	    _920 = _898.xyz;
	    vec2 _4611 = _918;
	    _4611.x = _892;
	    _917 = _894;
	    vec2 _4614 = _4611;
	    _4614.x = _4611.x;
	    _4614.y = _4611.x;
	    _918 = _4614;
	    _919 = _4606.xyz * mix(vec3(1.0), _870.xyz, vec3(saturate(_4568)));
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _912;
	    payload.vInterpolatedNormalWs = _913;
	    vec3 _955[3] = vec3[](_814, _808, _803);
	    vec3 _956[3] = vec3[](_813, _807, _802);
	    vec3 _4665 = ((_955[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_955[1] * attrs.barycentrics.x)) + (_955[2] * attrs.barycentrics.y);
	    vec3 _949[3];
	    _949[0] = _4665 - (_956[0] * dot(_4665 - _955[0], _956[0]));
	    _949[1] = _4665 - (_956[1] * dot(_4665 - _955[1], _956[1]));
	    _949[2] = _4665 - (_956[2] * dot(_4665 - _955[2], _956[2]));
	    vec3 _4705 = ((_949[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_949[1] * attrs.barycentrics.x)) + (_949[2] * attrs.barycentrics.y);
	    vec3 _950[3];
	    _950[0] = cross(_955[0] - _955[1], _912);
	    _950[1] = cross(_955[1] - _955[2], _912);
	    _950[2] = cross(_955[2] - _955[0], _912);
	    float _951 = dot(_4705 - _4665, _912);
	    vec3 _952 = _4705;
	    int _953 = 0;
	    for (;;)
	    {
	        bool _4721_ladder_break = false;
	        do
	        {
	            if (!(_953 < 3))
	            {
	                _4721_ladder_break = true;
	                break;
	            }
	            if (_951 > 0.00999999977648258209228515625)
	            {
	                _4721_ladder_break = true;
	                break;
	            }
	            if (dot(_950[_953], _950[_953]) == 0.0)
	            {
	                break;
	            }
	            _950[_953] = normalize(_950[_953]);
	            int _954 = 0;
	            for (;;)
	            {
	                if (!(_954 < 3))
	                {
	                    break;
	                }
	                vec3 _4759 = _956[_954] - (_950[_953] * dot(_950[_953], _956[_954]));
	                _949[_954] = _4665 - (_4759 * dot(_4665 - _955[_954], _4759));
	                _954++;
	                continue;
	            }
	            vec3 _4783 = ((_949[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_949[1] * attrs.barycentrics.x)) + (_949[2] * attrs.barycentrics.y);
	            _951 = dot(_4783 - _4665, _912);
	            _952 = _4783;
	            break;
	        } while(false);
	        if (_4721_ladder_break)
	        {
	            break;
	        }
	        _953++;
	        continue;
	    }
	    if (!(_951 > 0.00999999977648258209228515625))
	    {
	        _952 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _952;
	    payload.bFlippedNormal = _911;
	    f16vec3 _4796 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_4796, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4796, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(_920);
	    payload.material.vAlbedo = f16vec3(_919);
	    payload.material.vEmissive = f16vec3(_916);
	    payload.material.flReflectance = float16_t(_915);
	    payload.material.flMetalness = float16_t(_917);
	    payload.material.flRoughness = float16_t(dot(_918, vec2(0.5)));
	    if (any(greaterThan(_914, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _4822 = f16vec3(_914);
	        payload.material.vMaterialBits.x = _4822.x;
	        payload.material.vMaterialBits.y = _4822.y;
	        payload.material.vMaterialBits.z = _4822.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0)) ? 1 : 0);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(VertexPaintUIPuddles, (F_WETNESS==1) ? 1 : 0);
	BoolAttribute(SupportsAggregateInstancing, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST_LAYER == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST_LAYER == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MATERIAL_REFERENCE == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MATERIAL_REFERENCE == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerType, csgo_environment);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
}
