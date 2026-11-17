//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "uber shader with lots of configurability";
	DevShader = false;
	Version = 5;
	
	// Platform: VULKAN_SM_60
	// Programs: ps, vs, rtx, psrs
}

MODES
{
	CsgoForward();
	RayTrace();
	Depth("csgo_depth_only.vfx");
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
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	Feature( F_ANISOTROPIC_GLOSS, 0..1, "PBR" );
	Feature( F_SELF_ILLUM, 0..1, "PBR" );
	Feature( F_DETAIL_TEXTURE, 0..4 (0="None", 1="Mod2X", 2="Overlay", 3="Normals", 4="Overlay and Normals"), "Detail Texture" );
	Feature( F_METALNESS_TEXTURE, 0..1, "PBR" );
	Feature( F_SECONDARY_UV, 0..1, "Secondary UV" );
	Feature( F_TEXTURE_ANIMATION, 0..1, "Animation" );
	Feature( F_TEXTURE_ANIMATION_MODE, 0..2 (0="Sequential", 1="Random", 2="Scripted"), "Animation" );
	Feature( F_PRE_BAKED_VERTEX_ANIMATION, 0..1, "Animation" );
	Feature( F_TRANSMISSIVE_BACKFACE_NDOTL, 0..1, "PBR" );
	Feature( F_USE_ALBEDO_FOR_TRANSMISSIVE, 0..1, "PBR" );
	Feature( F_DISABLE_TRANSMISSIVE_SHADOWS, 0..1, "PBR" );
	Feature( F_CLOTH_SHADING, 0..1, "PBR" );
	Feature( F_DECAL_TEXTURE, 0..1, "Decal Texture" );
	Feature( F_DECAL_BLEND_MODE, 0..1, "Decal Blend Mode" );
	Feature( F_PAINT_VERTEX_COLORS, 0..1, "Vertex Color" );
	Feature( F_DEPTH_BIAS, 0..1, "Z-Buffering" );
	Feature( F_OCCLUSION_CULLING_BOUNDS_SCALE, 0..1, "Z-Buffering" );
	Feature( F_IGNORE_FACE_NORMALS_FOR_LIGHTING, 0..1, "Lightmapping" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
	FeatureRule( Allow1( F_ANISOTROPIC_GLOSS, F_ADDITIVE_BLEND ), "Anisotropic Gloss and Additive Blend are incompatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_SELF_ILLUM ), "Detail Texture and Self Illum are not compatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_ANISOTROPIC_GLOSS ), "Detail Texture and Anisotropic Gloss are not compatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_ADDITIVE_BLEND ), "Detail Texture and Additive Blend are not compatible" );
	FeatureRule( Allow1( F_METALNESS_TEXTURE, F_ADDITIVE_BLEND ), "Metalness Texture and Additive Blend are not compatible" );
	FeatureRule( Requires( F_TEXTURE_ANIMATION_MODE, F_TEXTURE_ANIMATION==1 ), "Texture Animation Mode requires Texture Animation On" );
	FeatureRule( Allow1( F_PRE_BAKED_VERTEX_ANIMATION, F_TEXTURE_ANIMATION ), "Pre Baked Vertex Animation and Texture Animation are not compatible" );
	FeatureRule( Allow1( F_TRANSMISSIVE_BACKFACE_NDOTL, F_DETAIL_TEXTURE ), "Transmissive Backface Ndotl and Detail Texture are not compatible" );
	FeatureRule( Allow1( F_TRANSMISSIVE_BACKFACE_NDOTL, F_PRE_BAKED_VERTEX_ANIMATION ), "Transmissive Backface Ndotl and Pre Baked Vertex Animation are not compatible" );
	FeatureRule( Allow1( F_TRANSMISSIVE_BACKFACE_NDOTL, F_ADDITIVE_BLEND ), "Transmissive Backface Ndotl and Additive Blend are not compatible" );
	FeatureRule( ChildOf( F_USE_ALBEDO_FOR_TRANSMISSIVE, F_TRANSMISSIVE_BACKFACE_NDOTL ), "Use Albedo for Transmissive requires Transmissive Backface Ndotl" );
	FeatureRule( ChildOf( F_DISABLE_TRANSMISSIVE_SHADOWS, F_TRANSMISSIVE_BACKFACE_NDOTL ), "Disable Transmissive Shadows requires Transmissive Backface Ndotl" );
	FeatureRule( Allow1( F_CLOTH_SHADING, F_ANISOTROPIC_GLOSS ), "Cloth Shading and Anisotropic Gloss are not compatible" );
	FeatureRule( Allow1( F_CLOTH_SHADING, F_METALNESS_TEXTURE ), "Cloth Shading and Metalness Texture are not compatible" );
	FeatureRule( ChildOf( F_DECAL_BLEND_MODE, F_DECAL_TEXTURE ), "Decal Blend Mode requires Decal Texture" );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_ANISOTROPIC_GLOSS ), "Decal Texture not supported with Anisotropic Gloss to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_SELF_ILLUM ), "Decal Texture not supported with Self Ilum to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_TEXTURE_ANIMATION ), "Decal Texture not supported with Texture Animation to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_PRE_BAKED_VERTEX_ANIMATION ), "Decal Texture not supported with Pre Baked Vertex Animation to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_TRANSMISSIVE_BACKFACE_NDOTL ), "Decal Texture not supported with Transmissive Backface Ndotl to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_CLOTH_SHADING ), "Decal Texture not supported with Cloth Shading to reduce combos." );
	FeatureRule( Allow1( F_DISABLE_Z_BUFFERING, F_DEPTH_BIAS ), "Z Bias and Disable Z Buffering are not compatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_PAINT_VERTEX_COLORS=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_SECONDARY_UV=1
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_SECONDARY_UV, F_SECONDARY_UV );
	StaticCombo( S_TEXTURE_ANIMATION, F_TEXTURE_ANIMATION );
	StaticCombo( S_PRE_BAKED_VERTEX_ANIMATION, F_PRE_BAKED_VERTEX_ANIMATION );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticComboRule( Allow1( S_PRE_BAKED_VERTEX_ANIMATION, S_TEXTURE_ANIMATION ) );
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
	int g_nTextureAnimationMode < UiType(Slider); Expression(F_TEXTURE_ANIMATION_MODE); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float2 g_vAnimationInvGrid < UiType(VectorText); Expression(1/g_vAnimationGrid); >;
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,g_vTexCoordCenter.x+g_vTexCoordOffset.x+v2*g_vTexCoordCenter.y-v1*g_vTexCoordCenter.x)); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,g_vTexCoordCenter.y+g_vTexCoordOffset.y-(v2*g_vTexCoordCenter.x+v1*g_vTexCoordCenter.y))); >;
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailTexture < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 170"); >;
	float2 g_vDetailTexCoordScale < Default2(1, 1); UiType(VectorText); UiGroup("Detail Texture,80/30"); >;
	float g_flDetailTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Detail Texture,80/35"); >;
	float2 g_vDetailTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Detail Texture,80/40"); Expression(v0 = g_flDetailTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v4 = this;
		-.5*v3*float2(v1-v2,v2+v1)+v4+.5); >;
	
	// Texture Animation
	int2 g_vAnimationGrid < Default2(1, 1); Range2(1, 1, 64, 64); UiType(VectorText); UiGroup("Texture Animation,12/10"); >;
	int g_nNumAnimationCells < Default(1); Range(1, 4096); UiType(Slider); UiGroup("Texture Animation,12/20"); >;
	float g_flAnimationTimePerFrame < Default(0.1); Range(0, 10); UiType(Slider); UiGroup("Texture Animation,12/30"); >;
	float g_flAnimationTimeOffset < Range(0, 1000); UiType(Slider); UiGroup("Texture Animation,12/40"); >;
	float g_flAnimationFrame < Range(0, 4096); UiType(Slider); UiGroup("Texture Animation,12/50"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vTexCoordXform0) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
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
	    mat3x4 _m0;
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	struct _1260
	{
	    mat4 _m0;
	    float _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _1260 PerViewConstantBuffer_t;
	
	struct _1234
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	};
	
	layout(set = 0) uniform _1234 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec3 vNormalOs;
	layout(location = 3) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 4) in uvec4 vBlendIndices;
	layout(location = 5) in uint nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) centroid out vec4 output_3;
	layout(location = 4) centroid out vec3 output_4;
	layout(location = 5) out vec4 output_5;
	layout(location = 6) flat out uint output_6;
	
	void main()
	{
	    uint _13771 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5 >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1;
	    }
	    vec3 _21709;
	    if (_13771 > 0u)
	    {
	        _21709 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[0].z);
	    }
	    else
	    {
	        _21709 = vec3(1.0);
	    }
	    vec4 _23812 = vec4(uvec4(g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 255u, (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 65280u) >> uint(8), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 16711680u) >> uint(16), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec3 _6253 = _23812.xyz;
	    vec3 _17828 = _6253 * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((_6253 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    float _7654 = _23812.w;
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9360 = vTexCoord.xyxy;
	    _9360.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _9360.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _9360.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _9360;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _7654).xyz, vec3(_Globals_.g_flModelTintAmount)), _7654 * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _13062 = _11399.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _11399;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _11179;
	    output_2 = _20488;
	    output_3 = _23714;
	    output_4 = _11179;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_6 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColor, true);
		BoolAttribute(VertexPaintUIPickColorAlpha, F_ALPHA_TEST==1 || F_TRANSLUCENT==1);
	#endif
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_SECONDARY_UV, F_SECONDARY_UV );
	StaticCombo( S_ANISOTROPIC_GLOSS, F_ANISOTROPIC_GLOSS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_TRANSMISSIVE_BACKFACE_NDOTL, F_TRANSMISSIVE_BACKFACE_NDOTL );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_ANISOTROPIC_GLOSS, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_METALNESS_TEXTURE, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_DETAIL_TEXTURE ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_TRANSMISSIVE_BACKFACE_NDOTL ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY==1 ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT ) );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	bool g_bTransmissiveShadows < UiType(CheckBox); Expression(F_DISABLE_TRANSMISSIVE_SHADOWS ? 0 : 1); >;
	bool g_bUseAlbedoForTransmissive < UiType(CheckBox); Expression(F_USE_ALBEDO_FOR_TRANSMISSIVE ? 1 : 0); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE ? 1 : 0); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tAnisoGloss < Channel(RG, AnisoRoughness_RG(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDecal < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureDecal, TextureDecalTranslucency), Srgb); Channel(A, Box(TextureDecalTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailMask < Channel(R, Box(TextureDetailMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tTransmissiveColor < Channel(RGB, Box(TextureTransmissiveColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	float4 g_vDetailNormalStrengthOffsetScale < UiType(VectorText); Expression(float4(0,0,1-g_flDetailNormalStrength,g_flDetailNormalStrength)); >;
	float3 g_vFlatOverlayColor < Default3(1, 0, 1); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression(pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	bool g_bUseSecondaryUvForAmbientOcclusion < Default(1); UiType(CheckBox); UiGroup("Ambient Occlusion, 100"); >;
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	bool g_bUseSecondaryUvForTintMask < UiType(CheckBox); UiGroup("Color,101"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Decal Texture
	bool g_bUseSecondaryUvForDecal < Default(1); UiType(CheckBox); UiGroup("Decal Texture, 180"); >;
	CreateInputTexture2D(TextureDecal, Srgb, 8, "", "_decal", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureDecalTranslucency, Linear, 8, "", "_trans", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailMask < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 180"); >;
	CreateInputTexture2D(TextureDetail, Linear, 8, "Mod2XCenter", "_detail", "Detail Texture,80/10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureNormalDetail, Linear, 8, "NormalizeNormals", "_normal", "Detail Texture,80/10", Default4(0.5, 0.5, 1, 0));
	float g_flDetailNormalStrength < Default(1); UiType(Slider); UiGroup("Detail Texture,80/15"); >;
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture,80/20"); >;
	CreateInputTexture2D(TextureDetailMask, Linear, 8, "", "_detailmask", "Detail Texture,80/40", Default4(1, 1, 1, 1));
	float g_flDetailBlendToFull < UiType(Slider); UiGroup("Detail Texture,80/50"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Self Illum
	bool g_bUseSecondaryUvForSelfIllum < UiType(CheckBox); UiGroup("Self Illum,100"); >;
	float g_flSelfIllumBrightness < Range(-10, 10); UiType(Slider); UiGroup("Self Illum"); >;
	CreateInputTexture2D(TextureSelfIllumMask, Srgb, 8, "", "_selfillum", "Self Illum/10", Default4(0, 0, 0, 0));
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum/20"); >;
	float g_flSelfIllumScale < Default(1); UiType(Slider); UiGroup("Self Illum/30"); >;
	float2 g_vSelfIllumScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Self Illum/40"); >;
	float g_flSelfIllumAlbedoFactor < Default(1); UiType(Slider); UiGroup("Self Illum/50"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Transmission
	CreateInputTexture2D(TextureTransmissiveColor, Srgb, 8, "", "_color", "Transmission", Default4(1, 1, 1, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Occlusion Culling
	float g_flOcclusionCullingBoundsScale < Default(1); Range(1, 100); UiType(Slider); UiGroup("Occlusion Culling"); UiVisibility(F_OCCLUSION_CULLING_BOUNDS_SCALE); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ANISOTROPIC_GLOSS == 1)
		Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
		Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	#if (S_DECAL_TEXTURE == 1)
		Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _113
	{
	    float4 _m0[3];
	};
	
	struct _323
	{
	    float4 _m0[4];
	};
	
	struct _244
	{
	    column_major float4x4 _m0[4];
	};
	
	struct _200
	{
	    column_major float4x4 _m0;
	    column_major float4x4 _m1;
	    float4 _m2;
	    float4 _m3;
	    float4 _m4;
	    float4 _m5;
	    float3 _m6;
	    uint _m7;
	    float4 _m8;
	    float4 _m9;
	    float4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    column_major float4x3 _m15;
	    float4 _m16;
	    float4 _m17;
	    float4 _m18;
	    float4 _m19;
	    float4 _m20;
	    float3 _m21;
	    float _m22;
	    column_major float4x4 _m23;
	};
	
	static float3 _4;
	static float4 _5;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    uint _Globals_1_g_tColor : packoffset(c0);
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c4);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c4.y);
	    uint _Globals_1_g_sPointClamp : packoffset(c4.z);
	    uint _Globals_1_g_sUserConfig : packoffset(c5.y);
	    uint _Globals_1_g_sUserConfigAllowGlobalMipBias : packoffset(c5.z);
	    uint _Globals_1_g_sCookieSampler : packoffset(c6);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c6.y);
	    int _Globals_1_g_bFogEnabled : packoffset(c6.w);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c7);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c7.y);
	    float _Globals_1_g_flReflectance : packoffset(c7.z);
	    uint _Globals_1_g_tNormal : packoffset(c11.y);
	    uint _Globals_1_g_tAmbientOcclusion : packoffset(c12);
	    float _Globals_1_g_flMetalness : packoffset(c12.y);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c2);
	    int4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c3);
	    uint PerViewConstantBufferCsgo_t_1_m3 : packoffset(c4.z);
	    uint PerViewConstantBufferCsgo_t_1_m4 : packoffset(c4.w);
	    uint PerViewConstantBufferCsgo_t_1_m5 : packoffset(c5);
	    uint PerViewConstantBufferCsgo_t_1_m6 : packoffset(c5.z);
	    uint PerViewConstantBufferCsgo_t_1_m7 : packoffset(c6.z);
	    uint PerViewConstantBufferCsgo_t_1_m8 : packoffset(c8.y);
	    uint PerViewConstantBufferCsgo_t_1_m9 : packoffset(c8.z);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m12 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m20 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m21 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m22 : packoffset(c35);
	};
	
	cbuffer FireConstantBufferCsgo_t : register(b5, space1)
	{
	    uint FireConstantBufferCsgo_t_1_m0 : packoffset(c360);
	    uint FireConstantBufferCsgo_t_1_m1 : packoffset(c360.y);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c20.z);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c22);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c26);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _113 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _323 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
	    float4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c16);
	    float4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c17);
	    float4 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c24);
	    float4 PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1946);
	    int PerViewLightingConstantBufferGpu_t_1_m11 : packoffset(c1953);
	    float PerViewLightingConstantBufferGpu_t_1_m12 : packoffset(c1953.z);
	    float4 PerViewLightingConstantBufferGpu_t_1_m13 : packoffset(c1954);
	    float PerViewLightingConstantBufferGpu_t_1_m14 : packoffset(c1955);
	    float PerViewLightingConstantBufferGpu_t_1_m15 : packoffset(c1955.y);
	    float PerViewLightingConstantBufferGpu_t_1_m16 : packoffset(c1955.z);
	    float PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1955.w);
	    _244 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1956);
	    _323 PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1988);
	    uint PerViewLightingConstantBufferGpu_t_1_m20 : packoffset(c1996);
	    uint PerViewLightingConstantBufferGpu_t_1_m21 : packoffset(c1996.y);
	};
	
	ByteAddressBuffer g_CullBits : register(t30, space3);
	ByteAddressBuffer g_BarnLights : register(t31, space3);
	Texture2D<float4> g_bindless_Texture2D_float4[65536] : register(t46, space4);
	SamplerState g_bindless_Sampler[2048] : register(s29, space4);
	SamplerComparisonState g_bindless_Sampler_1[2048] : register(s29, space4);
	Texture3D<float4> g_bindless_Texture3D_float4[65536] : register(t46, space4);
	TextureCubeArray<float4> g_bindless_TextureCubeArray_float4[65536] : register(t46, space4);
	TextureCube<float4> g_bindless_TextureCube_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static bool gl_FrontFacing;
	static float3 input_0;
	static float3 input_1;
	static float4 input_2;
	static float4 input_3;
	static float3 input_4;
	static float4 input_5;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	    centroid float4 input_3 : TEXCOORD3;
	    centroid float3 input_4 : TEXCOORD4;
	    float4 input_5 : TEXCOORD5;
	    float4 gl_FragCoord : SV_Position;
	    bool gl_FrontFacing : SV_IsFrontFace;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _11408 = gl_FragCoord;
	    _11408.w = 1.0f / _11408.w;
	    float3 _21709;
	    if (dot(input_1.xyz, input_1.xyz) >= 1.0099999904632568359375f)
	    {
	        _21709 = input_4.xyz;
	    }
	    else
	    {
	        _21709 = input_1.xyz;
	    }
	    bool _14874 = _Globals_1_g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _10251;
	    [branch]
	    if (_12885)
	    {
	        _10251 = _21709 * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    float3 _24347 = normalize(_10251);
	    float3 _10061 = input_0 + PerViewConstantBufferCsgo_t_1_m22.xyz;
	    float4 _19680 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfigAllowGlobalMipBias], input_2.xy);
	    float3 _21103 = _19680.xyz * input_3.xyz;
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tAmbientOcclusion].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], float2(input_2.xy).xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_2.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125f;
	    float _11176 = _16000 - _19720;
	    float3 _18354 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
	    float2 _12835 = _19372.zz;
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _24327;
	    if (_12886)
	    {
	        _24327 = !gl_FrontFacing;
	    }
	    else
	    {
	        _24327 = false;
	    }
	    float3 _12631 = input_1.xyz * (_24327 ? (-1.0f) : 1.0f);
	    float3 _14435 = cross(_12631.xyz, input_5.xyz) * ((input_5.w > 0.0f) ? 1.0f : (-1.0f));
	    float3 _7424;
	    if (bool4(PerViewConstantBufferCsgo_t_1_m2.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m2.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m2.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m2.w != int4(0, 0, 0, 0).w).w)
	    {
	        _7424 = -_14435;
	    }
	    else
	    {
	        _7424 = _14435;
	    }
	    float3 _20480;
	    if (!_24327)
	    {
	        float3 _7482 = _18354;
	        _7482.y = -_18354.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _18354;
	    }
	    float3 _16230 = normalize((((input_5.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    float3 _21379 = _10061.xyz;
	    float3 _19870 = ddx(_21379);
	    float3 _9944 = ddy(_21379);
	    bool _12428 = (FireConstantBufferCsgo_t_1_m1 & 2u) != 0u;
	    float3 _13138;
	    float2 _13153;
	    float _24595;
	    [branch]
	    if (_12428)
	    {
	        bool _12887;
	        if (FireConstantBufferCsgo_t_1_m0 > 0u)
	        {
	            _12887 = true;
	        }
	        else
	        {
	            _12887 = (FireConstantBufferCsgo_t_1_m1 & 1u) != 0u;
	        }
	        float _6569;
	        float _13136;
	        float _13151;
	        [branch]
	        if (_12887)
	        {
	            float4 _11179 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m9].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f);
	            _13136 = _11179.x;
	            _13151 = _11179.y;
	            _6569 = _11179.w;
	        }
	        else
	        {
	            _13136 = 0.0f;
	            _13151 = 0.0f;
	            _6569 = 0.0f;
	        }
	        bool _17653 = _13136 > 0.0f;
	        bool _12888;
	        if (_17653)
	        {
	            _12888 = true;
	        }
	        else
	        {
	            _12888 = _13151 > 0.0f;
	        }
	        bool _12889;
	        if (_12888)
	        {
	            _12889 = true;
	        }
	        else
	        {
	            _12889 = _6569 > 0.0f;
	        }
	        float4 _20309;
	        [branch]
	        if (_12889)
	        {
	            float3 _14004 = pow(abs(_24347.xyz), 8.0f.xxx);
	            float3 _11969 = _14004 / dot(_14004, 1.0f.xxx).xxx;
	            float3 _18011 = _11969 * step(0.1500000059604644775390625f.xxx, _11969);
	            float3 _7622 = _18011 / max(dot(_18011, 1.0f.xxx), 9.9999997473787516355514526367188e-05f).xxx;
	            float _13822 = _7622.z;
	            float4 _21316;
	            [branch]
	            if (_13822 > 0.0f)
	            {
	                float _10504 = radians(37.0f);
	                float _17093 = cos(_10504);
	                float _6434 = sin(_10504);
	                float2x2 _15707 = float2x2(float2(_17093, -_6434) * 0.0078125f.xx, float2(_6434, _17093) * 0.0078125f.xx);
	                _21316 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m8].SampleGrad(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], mul(_15707, _10061.xy), mul(_15707, _19870.xy), mul(_15707, _9944.xy)) * _13822;
	            }
	            else
	            {
	                _21316 = 0.0f.xxxx;
	            }
	            float _10004 = _7622.x;
	            float4 _21317;
	            [branch]
	            if (_10004 > 0.0f)
	            {
	                float _10505 = radians(37.0f);
	                float _17094 = cos(_10505);
	                float _6435 = sin(_10505);
	                float2x2 _15708 = float2x2(float2(_17094, -_6435) * 0.0078125f.xx, float2(_6435, _17094) * 0.0078125f.xx);
	                _21317 = _21316 + (g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m8].SampleGrad(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], mul(_15708, _10061.yz), mul(_15708, _19870.yz), mul(_15708, _9944.yz)) * _10004);
	            }
	            else
	            {
	                _21317 = _21316;
	            }
	            float _10005 = _7622.y;
	            float4 _12501;
	            [branch]
	            if (_10005 > 0.0f)
	            {
	                float _10506 = radians(37.0f);
	                float _17095 = cos(_10506);
	                float _6437 = sin(_10506);
	                float2x2 _15709 = float2x2(float2(_17095, -_6437) * 0.0078125f.xx, float2(_6437, _17095) * 0.0078125f.xx);
	                _12501 = _21317 + (g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m8].SampleGrad(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], mul(_15709, _10061.xz), mul(_15709, _19870.xz), mul(_15709, _9944.xz)) * _10005);
	            }
	            else
	            {
	                _12501 = _21317;
	            }
	            _20309 = _12501;
	        }
	        else
	        {
	            _20309 = 0.5f.xxxx;
	        }
	        float _16380 = saturate(_6569 * lerp(1.0f, _20309.x * 2.0f, 0.17499999701976776123046875f));
	        float _16385 = 1.0f - _Globals_1_g_flMetalness;
	        float3 _21101 = (_21103.xyz * lerp(1.0f, 0.64999997615814208984375f, _16380 * lerp(0.300000011920928955078125f, 1.0f, saturate(_19372.z * 2.0f) * _16385))).xyz * lerp(1.0f.xxx, float3(0.75f, 0.62000000476837158203125f, 0.2800000011920928955078125f), (_16380 * 0.5f).xxx);
	        float3 _13137;
	        float _13152;
	        float2 _22371;
	        [branch]
	        if (_17653 ? _12428 : false)
	        {
	            float _16981 = _13136 * 2.0f;
	            float _13023 = saturate(_16981);
	            float _10371 = (_20309.x - 0.5f) * 0.699999988079071044921875f;
	            float _20671 = saturate(_13023 + (_10371 * saturate(_13023 * 4.0f)));
	            float _24490 = lerp(0.60000002384185791015625f, 1.0f, smoothstep(0.4000000059604644775390625f, 0.800000011920928955078125f, _24347.z));
	            float _20739 = (saturate((_20671 * 1.60000002384185791015625f) - 0.4000000059604644775390625f) * _24490) * lerp(1.0f, 0.800000011920928955078125f, _Globals_1_g_flMetalness);
	            float3 _14201 = _21101.xyz;
	            float3 _15381 = (_14201 * lerp(1.0f.xxx, float3(0.800000011920928955078125f, 0.699999988079071044921875f, 0.5f), ((((smoothstep(0.0f, 0.25f, _20671) * saturate(dot(_14201, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * 2.0f)) * _16385) * 0.4000000059604644775390625f) * _24490).xxx)).xyz;
	            float _7286 = saturate(saturate(_13023 + (_10371 * _13023)) * 1.2000000476837158203125f) * 7.0f;
	            float2 _24755 = _19372.zz;
	            _13137 = (lerp(_15381, _15381 * lerp(lerp(lerp(lerp(lerp(lerp(lerp(1.0f.xxx, float3(1.0f, 0.85000002384185791015625f, 0.550000011920928955078125f), saturate(_7286).xxx), float3(0.89999997615814208984375f, 0.60000002384185791015625f, 0.25f), saturate(_7286 - 1.0f).xxx), float3(0.64999997615814208984375f, 0.3499999940395355224609375f, 0.20000000298023223876953125f), saturate(_7286 - 2.0f).xxx), float3(0.5f, 0.20000000298023223876953125f, 0.5f), saturate(_7286 - 3.0f).xxx), float3(0.20000000298023223876953125f, 0.300000011920928955078125f, 0.75f), saturate(_7286 - 4.0f).xxx), float3(0.449999988079071044921875f, 0.60000002384185791015625f, 0.800000011920928955078125f), saturate(_7286 - 5.0f).xxx), float3(0.60000002384185791015625f, 0.62000000476837158203125f, 0.64999997615814208984375f), saturate(_7286 - 6.0f).xxx), (_Globals_1_g_flMetalness * 0.4000000059604644775390625f).xxx).xyz * lerp(1.0f, 0.60000002384185791015625f * lerp(1.0f, _20309.z * 2.0f, 0.5f), _20739)).xyz * lerp(1.0f, 0.20000000298023223876953125f, saturate(_16981 - 1.0f) * _20739);
	            _13152 = _Globals_1_g_flMetalness * lerp(1.0f, 0.89999997615814208984375f, _20739);
	            _22371 = lerp(_24755, max(_24755, 0.85000002384185791015625f.xx), (_20739 * 0.25f).xx);
	        }
	        else
	        {
	            _13137 = _21101;
	            _13152 = _Globals_1_g_flMetalness;
	            _22371 = _12835;
	        }
	        _13138 = _13137;
	        _13153 = lerp(_22371.xy, min(_22371.xy, 0.0500000007450580596923828125f.xx), saturate(_6569 * 0.89999997615814208984375f).xx);
	        _24595 = _13152;
	    }
	    else
	    {
	        _13138 = _21103;
	        _13153 = _12835;
	        _24595 = _Globals_1_g_flMetalness;
	    }
	    float3 _12351 = lerp(_Globals_1_g_flReflectance.xxx.xyz, _13138.xyz, _24595.xxx);
	    bool3 _24249 = all(bool3(true, true, true)).xxx;
	    float3 _17892 = float3(_24249.x ? _16230.x : 1.0f.xxx.x, _24249.y ? _16230.y : 1.0f.xxx.y, _24249.z ? _16230.z : 1.0f.xxx.z);
	    float3 _10560 = _24347.xyz;
	    float3 _11099 = ddx(_10560);
	    float3 _9175 = ddy(_10560);
	    float3 _10347 = _11099.xyz;
	    float3 _12420 = _9175.xyz;
	    float2 _21813 = max(_13153.xy, pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125f).xx);
	    float3 _15598 = -_24347;
	    float3 _24735 = _16230.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21710;
	    if (_24465.x)
	    {
	        float3 _11394 = _24347.xyz;
	        float2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m12) * PerViewConstantBufferCsgo_t_1_m11.xy) + (PerViewConstantBufferCsgo_t_1_m11.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        float2 _23168;
	        if (_12285)
	        {
	            _23168 = float2(PerViewConstantBufferCsgo_t_1_m11.x, 0.0f);
	        }
	        else
	        {
	            _23168 = 0.0f.xx;
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        float2 _23169;
	        if (_12286)
	        {
	            _23169 = float2(0.0f, PerViewConstantBufferCsgo_t_1_m11.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        bool2 _13083 = (abs(_18418.y) < (_12286 ? _15372 : _20965)).xx;
	        float4 _10010 = normalize(float4(PerViewLightingConstantBufferGpu_t_1_m2.x * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.y * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.z * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.w * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xy, 0.25f))), 0.5f, 0.5f)));
	        float4 _13232 = max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx) * normalize(clamp(((_10010 - max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)).xxxx) + 0.20000000298023223876953125f.xxxx) * 5.0f.xxxx, 0.0f.xxxx, 1.0f.xxxx));
	        _21710 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11087 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m11.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m11.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float _8634 = dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _24735);
	    float _12320;
	    [branch]
	    if (_8634 > 0.0f)
	    {
	        float _12504;
	        [branch]
	        if (PerViewLightingConstantBufferGpu_t_1_m11 != 0)
	        {
	            int _23989;
	            int _10191;
	            float _13139;
	            float3 _14975;
	            int _13039 = 0;
	            for (;;)
	            {
	                if (!(_13039 < PerViewLightingConstantBufferGpu_t_1_m11))
	                {
	                    _13139 = 1.0f;
	                    _14975 = 0.0f.xxx;
	                    _10191 = -1;
	                    break;
	                }
	                float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039], float4(input_0.xyz, 1.0f));
	                float _12779 = _18322.x;
	                if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t_1_m13[_13039])
	                {
	                    float3 _19470 = float3(_12779, _18322.yz);
	                    float2 _24804 = _19470.xy;
	                    float2 _22193 = 1.0f.xx - clamp((abs(_24804) * PerViewLightingConstantBufferGpu_t_1_m15.xx) + PerViewLightingConstantBufferGpu_t_1_m14.xx, 0.0f.xx, 1.0f.xx);
	                    float2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t_1_m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t_1_m19._m0[_13039].xy;
	                    float3 _20488 = _19470;
	                    _20488.x = _20561.x;
	                    _20488.y = _20561.y;
	                    _13139 = saturate(_22193.x * _22193.y);
	                    _14975 = _20488;
	                    _10191 = _13039;
	                    break;
	                }
	                _23989 = _13039 + 1;
	                _13039 = _23989;
	                continue;
	            }
	            float _21711;
	            if (_10191 >= 0)
	            {
	                float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t_1_m12));
	                float _12502;
	                [branch]
	                if (_13139 < 1.0f)
	                {
	                    float _7934;
	                    if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m11 - 1))
	                    {
	                        int _15335 = _10191 + 1;
	                        float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335], float4(input_0.xyz, 1.0f));
	                        float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m19._m0[_15335].xy;
	                        float3 _20489;
	                        _20489.x = _20562.x;
	                        _20489.y = _20562.y;
	                        _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t_1_m12));
	                    }
	                    else
	                    {
	                        _7934 = 1.0f;
	                    }
	                    _12502 = lerp(_7934, _18270, _13139);
	                }
	                else
	                {
	                    _12502 = _18270;
	                }
	                _21711 = _12502;
	            }
	            else
	            {
	                _21711 = 1.0f;
	            }
	            float _13279 = lerp(_21711, 1.0f, saturate((distance(_21379, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m17) + PerViewLightingConstantBufferGpu_t_1_m16));
	            float _12503;
	            if (_24465.y)
	            {
	                _12503 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	            }
	            else
	            {
	                _12503 = _13279;
	            }
	            _12504 = _12503;
	        }
	        else
	        {
	            _12504 = 1.0f;
	        }
	        _12320 = _12504;
	    }
	    else
	    {
	        _12320 = 1.0f;
	    }
	    float3 _9716;
	    float3 _24878;
	    [branch]
	    if ((_8634 * _12320) > 0.0f)
	    {
	        bool3 _19899 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	        float _11797 = max(0.0f, dot(_16230.xyz, PerViewLightingConstantBufferGpu_t_1_m9.xyz));
	        float2 _9840 = max(_21813, PerViewLightingConstantBufferGpu_t_1_m9.w.xx);
	        float3 _12281 = normalize(PerViewLightingConstantBufferGpu_t_1_m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, float3(_19899.x ? _24735.x : _17892.x, _19899.y ? _24735.y : _17892.y, _19899.z ? _24735.z : _17892.z).xyz);
	        float _19210 = max(0.0f, dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0f)) + 1.0f;
	        float3 _16808 = (PerViewLightingConstantBufferGpu_t_1_m10.xyz * _12320).xyz;
	        _9716 = ((_12351.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0f) + 2.0f)))).xyz * _11797).xyz * _16808;
	        _24878 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (_11797.xxx.xyz * _16808);
	    }
	    else
	    {
	        _9716 = 0.0f.xxx;
	        _24878 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19363;
	    if (_20060)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m10, float4(_21379, 1.0f).xyzw);
	        float _20176 = _18621.w;
	        float2 _11414 = _18621.xy / _20176.xx;
	        float4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0f) * PerViewConstantBuffer_t_1_m1.x) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.x - 1.0f);
	        _6651.y = clamp(((1.0f - _11414.y) * PerViewConstantBuffer_t_1_m1.y) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.y - 1.0f);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uint2 _12083 = uint2(_19363.xy - PerViewConstantBuffer_t_1_m0.xy) >> PerViewLightingConstantBufferGpu_t_1_m6.x.xx;
	    uint _10838 = PerViewLightingConstantBufferGpu_t_1_m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t_1_m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t_1_m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t_1_m7.x, 0.0f, PerViewLightingConstantBufferGpu_t_1_m7.y)) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    float3 _13140;
	    float3 _16324;
	    _13140 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    float3 _13141;
	    float3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t_1_m5.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load<uint>((_10838 + _17017) * 4 + 0) & g_CullBits.Load<uint>((_23393 + _17017) * 4 + 0));
	        _13141 = _13140;
	        _16325 = _16324;
	        uint _20344;
	        float3 _13212;
	        float3 _15670;
	        uint _17018 = _14475;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(firstbitlow(_17018) + (_17017 * 32u));
	            _20344 = _17018 & (_17018 - 1u);
	            do
	            {
	                float4x4 _14097 = float4x4(g_BarnLights.Load<float>(_12608 * 480 + 0), g_BarnLights.Load<float>(_12608 * 480 + 16), g_BarnLights.Load<float>(_12608 * 480 + 32), g_BarnLights.Load<float>(_12608 * 480 + 48), g_BarnLights.Load<float>(_12608 * 480 + 4), g_BarnLights.Load<float>(_12608 * 480 + 20), g_BarnLights.Load<float>(_12608 * 480 + 36), g_BarnLights.Load<float>(_12608 * 480 + 52), g_BarnLights.Load<float>(_12608 * 480 + 8), g_BarnLights.Load<float>(_12608 * 480 + 24), g_BarnLights.Load<float>(_12608 * 480 + 40), g_BarnLights.Load<float>(_12608 * 480 + 56), g_BarnLights.Load<float>(_12608 * 480 + 12), g_BarnLights.Load<float>(_12608 * 480 + 28), g_BarnLights.Load<float>(_12608 * 480 + 44), g_BarnLights.Load<float>(_12608 * 480 + 60));
	                float4 _24893 = mul(float4(input_0.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21776 = _10521.z;
	                _22905.z = _21776;
	                float3 _21642 = _22905.xyz;
	                bool _7425;
	                if (all(bool3(_22905.xyz.x > float3(-1.0f, -1.0f, 0.0f).x, _22905.xyz.y > float3(-1.0f, -1.0f, 0.0f).y, _22905.xyz.z > float3(-1.0f, -1.0f, 0.0f).z)))
	                {
	                    _7425 = all(bool3(_22905.xyz.x < 1.0f.xxx.x, _22905.xyz.y < 1.0f.xxx.y, _22905.xyz.z < 1.0f.xxx.z));
	                }
	                else
	                {
	                    _7425 = false;
	                }
	                bool _12891;
	                if (!_7425)
	                {
	                    _12891 = true;
	                }
	                else
	                {
	                    float4x3 _16509 = float4x3(g_BarnLights.Load<float>(_12608 * 480 + 272), g_BarnLights.Load<float>(_12608 * 480 + 288), g_BarnLights.Load<float>(_12608 * 480 + 304), g_BarnLights.Load<float>(_12608 * 480 + 276), g_BarnLights.Load<float>(_12608 * 480 + 292), g_BarnLights.Load<float>(_12608 * 480 + 308), g_BarnLights.Load<float>(_12608 * 480 + 280), g_BarnLights.Load<float>(_12608 * 480 + 296), g_BarnLights.Load<float>(_12608 * 480 + 312), g_BarnLights.Load<float>(_12608 * 480 + 284), g_BarnLights.Load<float>(_12608 * 480 + 300), g_BarnLights.Load<float>(_12608 * 480 + 316));
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), _16509).xyz);
	                    _12891 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12891)
	                {
	                    _13212 = _13141;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0f * g_BarnLights.Load<float4>(_12608 * 480 + 176).y;
	                float _18492 = (2.0f * g_BarnLights.Load<float4>(_12608 * 480 + 176).z) * g_BarnLights.Load<float4>(_12608 * 480 + 176).z;
	                float _14805 = 2.0f * g_BarnLights.Load<float4>(_12608 * 480 + 176).x;
	                float _9058 = _14805 * g_BarnLights.Load<float4>(_12608 * 480 + 176).y;
	                float _17330 = 2.0f * g_BarnLights.Load<float4>(_12608 * 480 + 176).w;
	                float _19825 = _17330 * g_BarnLights.Load<float4>(_12608 * 480 + 176).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * g_BarnLights.Load<float4>(_12608 * 480 + 176).x)) - _18492, (_23572 * g_BarnLights.Load<float4>(_12608 * 480 + 176).z) + (_17330 * g_BarnLights.Load<float4>(_12608 * 480 + 176).x)) * g_BarnLights.Load<float3>(_12608 * 480 + 192).z;
	                float _21318;
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 144).z > 0.0f)
	                {
	                    _21318 = min(1.0f, _21776 * g_BarnLights.Load<float4>(_12608 * 480 + 144).z);
	                }
	                else
	                {
	                    _21318 = 1.0f;
	                }
	                float _19667;
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 144).w > 0.0f)
	                {
	                    _19667 = _21318 * min(1.0f, (1.0f - _21776) * g_BarnLights.Load<float4>(_12608 * 480 + 144).w);
	                }
	                else
	                {
	                    _19667 = _21318;
	                }
	                float3 _11180;
	                float _11633;
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 128).w != 0.0f)
	                {
	                    float3 _10017 = g_BarnLights.Load<float4>(_12608 * 480 + 128).xyz - input_0.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    float3 _12302 = _10017 - _16268;
	                    float3 _10210;
	                    do
	                    {
	                        float3 _20229 = (_10017 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0f)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0f, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11180 = _10017 / _17647.xxx;
	                    _11633 = ((_19667 * (g_BarnLights.Load<float4>(_12608 * 480 + 128).w / max(_18345, g_BarnLights.Load<float4>(_12608 * 480 + 128).w))) * saturate(g_BarnLights.Load<float4>(_12608 * 480 + 144).x + (g_BarnLights.Load<float4>(_12608 * 480 + 144).y * _17647))) * saturate(g_BarnLights.Load<float3>(_12608 * 480 + 192).x + (g_BarnLights.Load<float3>(_12608 * 480 + 192).y * dot(float3((1.0f - (_23572 * g_BarnLights.Load<float4>(_12608 * 480 + 176).y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights.Load<float4>(_12608 * 480 + 176).z) - (_17330 * g_BarnLights.Load<float4>(_12608 * 480 + 176).y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11180 = g_BarnLights.Load<float4>(_12608 * 480 + 128).xyz;
	                    _11633 = _19667;
	                }
	                float3 _17828 = (g_BarnLights.Load<float4>(_12608 * 480 + 160).xyz * 1.0f).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 208).z > 0.0f)
	                {
	                    _24419 = !_20060;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                float3 _21548;
	                [branch]
	                if (g_BarnLights.Load<float4>(_12608 * 480 + 160).w == 0.0f)
	                {
	                    float _10342;
	                    do
	                    {
	                        float2 _22154 = abs(_22905.xy);
	                        if (g_BarnLights.Load<float4>(_12608 * 480 + 224).z == 0.0f)
	                        {
	                            _10342 = smoothstep(1.0f, g_BarnLights.Load<float4>(_12608 * 480 + 224).x, _22154.x) * smoothstep(1.0f, g_BarnLights.Load<float4>(_12608 * 480 + 224).y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0f / g_BarnLights.Load<float4>(_12608 * 480 + 224).z;
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5f) * g_BarnLights.Load<float4>(_12608 * 480 + 224).z;
	                            float _11981 = (g_BarnLights.Load<float4>(_12608 * 480 + 224).x * g_BarnLights.Load<float4>(_12608 * 480 + 224).y) * pow(max(pow(g_BarnLights.Load<float4>(_12608 * 480 + 224).y * _11473, _15266) + pow(g_BarnLights.Load<float4>(_12608 * 480 + 224).x * _15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0f);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0f);
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
	                    float3 _12505;
	                    if (g_BarnLights.Load<float4>(_12608 * 480 + 160).w < 0.0f)
	                    {
	                        float4 _17795 = float4(-g_BarnLights.Load<float4>(_12608 * 480 + 176).xyz, g_BarnLights.Load<float4>(_12608 * 480 + 176).w);
	                        float4 _19008 = _17795.xyzw * float4(-1.0f, -1.0f, -1.0f, 1.0f);
	                        float3 _24989 = _19008.xyz;
	                        float3 _23629 = float4((-_11180).xyz, 0.0f).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        float3 _20479 = float4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        float3 _23592 = _17795.xyz;
	                        float3 _12170 = ((_20479 * g_BarnLights.Load<float4>(_12608 * 480 + 176).w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        float3 _14081 = float3(float2(atan2(_12170.y, -_12170.x) * 0.15915493667125701904296875f, acos(_12170.z) * 0.3183098733425140380859375f), -g_BarnLights.Load<float4>(_12608 * 480 + 160).w);
	                        float2 _20564 = (_14081.xy * g_BarnLights.Load<float4>(_12608 * 480 + 224).zw) + g_BarnLights.Load<float4>(_12608 * 480 + 224).xy;
	                        float3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12505 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], _20492.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), g_BarnLights.Load<float4>(_12608 * 480 + 160).w);
	                        float2 _20563 = (_13791.xy * g_BarnLights.Load<float4>(_12608 * 480 + 224).zw) + g_BarnLights.Load<float4>(_12608 * 480 + 224).xy;
	                        float3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12505 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _20491.xyz, 0.0f).xyz;
	                    }
	                    _21548 = _12505;
	                }
	                if (all(bool3(_21548.xyz.x == 0.0f.xxx.x, _21548.xyz.y == 0.0f.xxx.y, _21548.xyz.z == 0.0f.xxx.z)))
	                {
	                    _13212 = _13141;
	                    _15670 = _16325;
	                    break;
	                }
	                float3 _22671;
	                if (_24419)
	                {
	                    float3 _19629;
	                    if ((g_BarnLights.Load<uint>(_12608 * 480 + 264) & 4u) != 0u)
	                    {
	                        float2 _6281 = _22905.yx * float2(1.0f, -1.0f);
	                        float3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, g_BarnLights.Load<float4>(_12608 * 480 + 208).zw, g_BarnLights.Load<float4>(_12608 * 480 + 208).xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t_1_m12)), g_BarnLights.Load<float>(_12608 * 480 + 260));
	                    float3 _16449 = _20482.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
	                    {
	                        _13212 = _13141;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _22671 = _20482;
	                }
	                else
	                {
	                    _22671 = _21548;
	                }
	                bool3 _19900 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	                float _11799 = max(0.0f, dot(_16230.xyz, _11180.xyz));
	                float2 _9841 = max(_21813, g_BarnLights.Load<float>(_12608 * 480 + 256).xx);
	                float3 _12282 = normalize(_11180.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, float3(_19900.x ? _24735.x : _17892.x, _19900.y ? _24735.y : _17892.y, _19900.z ? _24735.z : _17892.z).xyz);
	                float _19211 = max(0.0f, dot(_11180.xyz, _12282));
	                float _9851 = _9841.x;
	                float _25213 = _9851 * _9851;
	                float _19096 = _25213 * _25213;
	                float _15348 = ((_12387 * _12387) * (_19096 - 1.0f)) + 1.0f;
	                _13212 = _13141.xyz + (((_12351.xyz * (_19096 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0f) + 2.0f)))).xyz * _11799).xyz * _22671.xyz);
	                _15670 = _16325.xyz + (_11799.xxx.xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13141 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13140 = _13141;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21813.xy, 0.5f.xx);
	    float3 _6253 = _17892.xyz;
	    float3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0f - _17225);
	    float4 _15343 = (float4(-1.0f, -0.0274999998509883880615234375f, -0.572000026702880859375f, 0.02199999988079071044921875f) * _17172) + float4(1.0f, 0.0425000004470348358154296875f, 1.03999996185302734375f, -0.039999999105930328369140625f);
	    float _21215 = _15343.x;
	    float2 _24572 = (float2(-1.03999996185302734375f, 1.03999996185302734375f) * ((min(_21215 * _21215, exp2((-9.27999973297119140625f) * max(0.0f, dot((-_17138).xyz, _6253)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    float2 _11427 = float2(_20339, _24572.x + _20339);
	    float3 _8745 = float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz;
	    float3 _16991 = _16324.xyz + _8745;
	    float3 _20418 = (_21710 * _19068.x).xxx.xyz;
	    float3 _22686 = (_16324.xyz + (_8745 * _20418).xyz) * (_13138.xyz * (1.0f - _24595)).xyz;
	    float _12931 = _22686.x;
	    float4 _11204 = float4(_12931, _22686.yz, input_3.w);
	    _11204.x = _12931;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    float3 _15752 = _11204.xyz + (_13140.xyz * _20418).xyz;
	    float4 _20490 = _11204;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    float3 _15734 = _20490.xyz + ((((lerp(_11427.xxx, _11427.yyy, _12351) * g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t_1_m7].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], float4(normalize(lerp(_6253, reflect(_17138.xyz, _17892.xyz).xyz, (_20711 * (sqrt(_20711) + _17225)).xxx)), 0.0f), PerViewLightingConstantBufferGpu_t_1_m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + 0.001000000047497451305389404296875f.xxx) * clamp(length(_16991), 0.0f, 1.75f))).xyz * (1.0f.xxx + (normalize(_8745 + 0.001000000047497451305389404296875f.xxx) * 0.5f))).xyz * _20418).xyz;
	    float4 _13888 = _20490;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _6538 = _21379 - PerViewConstantBuffer_t_1_m3.xyz;
	        float3 _9057 = _6538.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _6538.xyz;
	            bool _12892;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m16.x)
	            {
	                _12892 = (_10061.z * PerViewConstantBufferCsgo_t_1_m16.z) < PerViewConstantBufferCsgo_t_1_m16.y;
	            }
	            else
	            {
	                _12892 = false;
	            }
	            [branch]
	            if (_12892)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m13.xy + (PerViewConstantBufferCsgo_t_1_m13.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m14.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m14.y)) * PerViewConstantBufferCsgo_t_1_m15.w;
	                _19340 = lerp(_13888.xyz, float4(PerViewConstantBufferCsgo_t_1_m15.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12893;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m20.x)
	            {
	                _12893 = (PerViewConstantBufferCsgo_t_1_m20.z * _10061.z) < PerViewConstantBufferCsgo_t_1_m20.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
	            {
	                float _14602 = saturate(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m17.y) + PerViewConstantBufferCsgo_t_1_m17.x), PerViewConstantBufferCsgo_t_1_m17.w)) * saturate(pow(max(0.0f, (_10061.z * PerViewConstantBufferCsgo_t_1_m18.y) + PerViewConstantBufferCsgo_t_1_m18.x), PerViewConstantBufferCsgo_t_1_m18.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t_1_m20.w;
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m19).xyz).xyz, PerViewConstantBufferCsgo_t_1_m18.w * saturate(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m17.z))) * PerViewConstantBufferCsgo_t_1_m21.x).xyz, _8892).xyz, _8892.xxx);
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
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    gl_FrontFacing = stage_input.gl_FrontFacing;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    input_4 = stage_input.input_4;
	    input_5 = stage_input.input_5;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	BoolAttribute(DoubleSided, F_RENDER_BACKFACES);
	BoolAttribute(IgnoreFaceNormalsForLighting, F_IGNORE_FACE_NORMALS_FOR_LIGHTING);
	FloatAttribute(OcclusionCullingBoundsScale, F_OCCLUSION_CULLING_BOUNDS_SCALE ? g_flOcclusionCullingBoundsScale : F_DEPTH_BIAS ? 1.3 : 1);
	
	#if (S_SELF_ILLUM == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(BlendEnable, true);
	RenderState(BlendEnable0, true);
	RenderState(BlendEnable1, true);
	RenderState(BlendEnable2, true);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, F_DEPTH_BIAS ? -64 : 0);
	RenderState(DepthBiasClamp, F_DEPTH_BIAS ? -.0005 : 0);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthFunc, Equal);
	RenderState(DepthWriteEnable, false);
	RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING || F_DEPTH_BIAS) ? false : true);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(DstBlend0, One);
	RenderState(DstBlend1, One);
	RenderState(DstBlend2, One);
	RenderState(DstBlendAlpha0, One);
	RenderState(DstBlendAlpha1, One);
	RenderState(DstBlendAlpha2, One);
	RenderState(SlopeScaleDepthBias, F_DEPTH_BIAS ? -2 : 0);
	RenderState(SrcBlend0, One);
	RenderState(SrcBlend1, One);
	RenderState(SrcBlend2, One);
	RenderState(SrcBlendAlpha0, One);
	RenderState(SrcBlendAlpha1, One);
	RenderState(SrcBlendAlpha2, One);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	#if (S_ALPHA_TEST == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_TRANSLUCENT == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, false);
	#endif
	#if (S_TRANSLUCENT == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING || F_DEPTH_BIAS) ? false : true);
	#endif
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(overlay, (F_DEPTH_BIAS && F_TRANSLUCENT) ? 1 : 0);
	
}

RTX
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_SECONDARY_UV, F_SECONDARY_UV );
	StaticCombo( S_TEXTURE_ANIMATION, F_TEXTURE_ANIMATION );
	StaticCombo( S_PRE_BAKED_VERTEX_ANIMATION, F_PRE_BAKED_VERTEX_ANIMATION );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticCombo( S_ANISOTROPIC_GLOSS, F_ANISOTROPIC_GLOSS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_TRANSMISSIVE_BACKFACE_NDOTL, F_TRANSMISSIVE_BACKFACE_NDOTL );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_PRE_BAKED_VERTEX_ANIMATION ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_ANISOTROPIC_GLOSS, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_METALNESS_TEXTURE, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_PRE_BAKED_VERTEX_ANIMATION, S_TEXTURE_ANIMATION ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_DETAIL_TEXTURE ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_PRE_BAKED_VERTEX_ANIMATION ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_TEXTURE_ANIMATION ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_PRE_BAKED_VERTEX_ANIMATION ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_TRANSMISSIVE_BACKFACE_NDOTL ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bUseAlbedoForTransmissive < UiType(CheckBox); Expression(F_USE_ALBEDO_FOR_TRANSMISSIVE ? 1 : 0); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE ? 1 : 0); >;
	int g_nTextureAnimationMode < UiType(Slider); Expression(F_TEXTURE_ANIMATION_MODE); >;
	Texture2D g_tAnisoGloss < Channel(RG, AnisoRoughness_RG(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDecal < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureDecal, TextureDecalTranslucency), Srgb); Channel(A, Box(TextureDecalTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailMask < Channel(R, Box(TextureDetailMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tTransmissiveColor < Channel(RGB, Box(TextureTransmissiveColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	float2 g_vAnimationInvGrid < UiType(VectorText); Expression(1/g_vAnimationGrid); >;
	float4 g_vDetailNormalStrengthOffsetScale < UiType(VectorText); Expression(float4(0,0,1-g_flDetailNormalStrength,g_flDetailNormalStrength)); >;
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression(pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,g_vTexCoordCenter.x+g_vTexCoordOffset.x+v2*g_vTexCoordCenter.y-v1*g_vTexCoordCenter.x)); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,g_vTexCoordCenter.y+g_vTexCoordOffset.y-(v2*g_vTexCoordCenter.x+v1*g_vTexCoordCenter.y))); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	bool g_bUseSecondaryUvForTintMask < UiType(CheckBox); UiGroup("Color,101"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// Decal Texture
	bool g_bUseSecondaryUvForDecal < Default(1); UiType(CheckBox); UiGroup("Decal Texture, 180"); >;
	CreateInputTexture2D(TextureDecal, Srgb, 8, "", "_decal", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureDecalTranslucency, Linear, 8, "", "_trans", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailMask < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 180"); >;
	bool g_bUseSecondaryUvForDetailTexture < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 170"); >;
	CreateInputTexture2D(TextureDetail, Linear, 8, "Mod2XCenter", "_detail", "Detail Texture,80/10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureNormalDetail, Linear, 8, "NormalizeNormals", "_normal", "Detail Texture,80/10", Default4(0.5, 0.5, 1, 0));
	float g_flDetailNormalStrength < Default(1); UiType(Slider); UiGroup("Detail Texture,80/15"); >;
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture,80/20"); >;
	float2 g_vDetailTexCoordScale < Default2(1, 1); UiType(VectorText); UiGroup("Detail Texture,80/30"); >;
	float g_flDetailTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Detail Texture,80/35"); >;
	CreateInputTexture2D(TextureDetailMask, Linear, 8, "", "_detailmask", "Detail Texture,80/40", Default4(1, 1, 1, 1));
	float2 g_vDetailTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Detail Texture,80/40"); Expression(v0 = g_flDetailTexCoordRotation*3.14159/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v4 = this;
		-.5*v3*float2(v1-v2,v2+v1)+v4+.5); >;
	float g_flDetailBlendToFull < UiType(Slider); UiGroup("Detail Texture,80/50"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Self Illum
	bool g_bUseSecondaryUvForSelfIllum < UiType(CheckBox); UiGroup("Self Illum,100"); >;
	float g_flSelfIllumBrightness < Range(-10, 10); UiType(Slider); UiGroup("Self Illum"); >;
	CreateInputTexture2D(TextureSelfIllumMask, Srgb, 8, "", "_selfillum", "Self Illum/10", Default4(0, 0, 0, 0));
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum/20"); >;
	float g_flSelfIllumScale < Default(1); UiType(Slider); UiGroup("Self Illum/30"); >;
	float2 g_vSelfIllumScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Self Illum/40"); >;
	float g_flSelfIllumAlbedoFactor < Default(1); UiType(Slider); UiGroup("Self Illum/50"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Transmission
	CreateInputTexture2D(TextureTransmissiveColor, Srgb, 8, "", "_color", "Transmission", Default4(1, 1, 1, 0));
	
	// Texture Animation
	int2 g_vAnimationGrid < Default2(1, 1); Range2(1, 1, 64, 64); UiType(VectorText); UiGroup("Texture Animation,12/10"); >;
	int g_nNumAnimationCells < Default(1); Range(1, 4096); UiType(Slider); UiGroup("Texture Animation,12/20"); >;
	float g_flAnimationTimePerFrame < Default(0.1); Range(0, 10); UiType(Slider); UiGroup("Texture Animation,12/30"); >;
	float g_flAnimationTimeOffset < Range(0, 1000); UiType(Slider); UiGroup("Texture Animation,12/40"); >;
	float g_flAnimationFrame < Range(0, 4096); UiType(Slider); UiGroup("Texture Animation,12/50"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ANISOTROPIC_GLOSS == 1)
		Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
		Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	#if (S_DECAL_TEXTURE == 1)
		Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	
	// Variant parameters
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	
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
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
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
	    uint _member0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    float _member0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _member0[];
	} g_MaterialData_5;
	
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
	
	struct SLANG_ParameterGroup_PerViewConstantBuffer_t_natural
	{
	    mat4 g_matWorldToProjection;
	    mat4 g_matProjectionToWorld;
	    mat4 g_matWorldToView;
	    mat4 g_matViewToProjection;
	    vec4 g_vInvProjLowerRight2x2;
	    vec4 g_vClipPlane0;
	    float g_flToneMapScalarLinear;
	    float g_flInvToneMapScalarLinear;
	    float g_flRealTime;
	    float g_flGameTime;
	    vec2 g_vViewportToGBufferRatio;
	    float g_fInvViewportZRange;
	    float g_fMinViewportZScaled;
	    vec2 g_vViewportOffset;
	    vec2 g_vViewportSize;
	    vec2 g_vInvViewportSize;
	    vec2 g_vRenderTargetSize;
	    vec4 g_vInvGBufferSize;
	    float g_flViewportMinZ;
	    float g_flViewportMaxZ;
	    float g_flNearPlane;
	    float g_flFarPlane;
	    vec4 g_vWorldToCameraOffset;
	    vec4 g_vCameraAngles;
	    vec3 g_vCameraPositionWs;
	    float _PerViewPad0;
	    vec3 g_vCameraUpDirWs;
	    float _PerViewPad1;
	    vec3 g_vCameraDirWs;
	    float g_flInvMSAASampleCount;
	    vec3 g_vDepthPsToVsConversion;
	    int g_nMSAASampleCount;
	    vec2 g_vMorphTextureAtlasSize;
	    uint g_tCompositeMorphAtlasTextureIndex;
	    float _PerViewPad4;
	    vec3 g_vFogColor;
	    float g_flNegFogStartOverFogRange;
	    float g_flInvFogRange;
	    float g_flFogMaxDensity;
	    float g_flFogExponent;
	    float g_flFogBlendToBackground;
	    vec4 g_vFrameBufferCopyInvSizeAndUvScale;
	    vec4 g_vPrevWorldToCameraOffset;
	    mat4 g_matPrevWorldToProjection;
	    vec4 g_vWireframeColor;
	};
	
	layout(set = 5) uniform SLANG_ParameterGroup_PerViewConstantBuffer_t_natural PerViewConstantBuffer_t;
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes attrs;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t payload;
	
	void main()
	{
	    uint _452 = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    uint _497 = g_MaterialData_1._member0[(_452 + 32u) / 4u];
	    uint _496 = g_MaterialData_1._member0[(_452 + 36u) / 4u];
	    vec4 _495 = vec4(g_MaterialData_3._member0[(_452 + 144u) / 4u], g_MaterialData_3._member0[(_452 + 148u) / 4u], g_MaterialData_3._member0[(_452 + 152u) / 4u], g_MaterialData_3._member0[(_452 + 156u) / 4u]);
	    vec4 _494 = vec4(g_MaterialData_3._member0[(_452 + 160u) / 4u], g_MaterialData_3._member0[(_452 + 164u) / 4u], g_MaterialData_3._member0[(_452 + 168u) / 4u], g_MaterialData_3._member0[(_452 + 172u) / 4u]);
	    vec2 _493 = vec2(g_MaterialData_3._member0[(_452 + 176u) / 4u], g_MaterialData_3._member0[(_452 + 180u) / 4u]);
	    vec3 _492 = vec3(g_MaterialData_3._member0[(_452 + 240u) / 4u], g_MaterialData_3._member0[(_452 + 244u) / 4u], g_MaterialData_3._member0[(_452 + 248u) / 4u]);
	    float _491 = g_MaterialData_3._member0[(_452 + 252u) / 4u];
	    uint _490 = g_MaterialData_1._member0[(_452 + 260u) / 4u];
	    bool _489 = g_MaterialData_5._member0[(_452 + 316u) / 4u] != 0;
	    bool _488 = g_MaterialData_5._member0[(_452 + 320u) / 4u] != 0;
	    float _487 = g_MaterialData_3._member0[(_452 + 324u) / 4u];
	    uint _486 = g_MaterialData_1._member0[(_452 + 328u) / 4u];
	    float _485 = g_MaterialData_3._member0[(_452 + 344u) / 4u];
	    uvec3 _583;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _727 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _583 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_727 / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_727 + 4u) / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_727 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _706 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _707 = _706 & 4294967292u;
	            uint _56 = _707 / 4u;
	            uint _59 = (_707 + 4u) / 4u;
	            uint _711 = (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_56] & 4294901760u) >> uint(16);
	            uint _712 = g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_59] & 65535u;
	            uvec3 _584;
	            if (_706 == _707)
	            {
	                _584 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_56] & 65535u, _711, _712);
	            }
	            else
	            {
	                _584 = uvec3(_711, _712, (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_59] & 4294901760u) >> uint(16));
	            }
	            _583 = _584;
	            break;
	        }
	        break;
	    } while(false);
	    uint _72 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _749 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _583) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _578[3];
	    uint _751 = _749.x;
	    _578[0] = vec3(g_Vertices_1[nonuniformEXT(_72)]._member0[_751 / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_751 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_751 + 8u) / 4u]);
	    uint _756 = _749.y;
	    _578[1] = vec3(g_Vertices_1[nonuniformEXT(_72)]._member0[_756 / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_756 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_756 + 8u) / 4u]);
	    uint _761 = _749.z;
	    _578[2] = vec3(g_Vertices_1[nonuniformEXT(_72)]._member0[_761 / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_761 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_72)]._member0[(_761 + 8u) / 4u]);
	    int _579 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_579 < 3))
	        {
	            break;
	        }
	        vsInput[_579].vPositionOs = _578[_579];
	        _579++;
	        continue;
	    }
	    vec2 _580[3];
	    _580[0] = vec2(0.0);
	    _580[1] = vec2(0.0);
	    _580[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _577 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _101 = uint(_577[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _803 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _575 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _576 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _819 = (uvec3(uint(_575[_803])) * _583) + uvec3(uint(_576[_803]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _933 = _819.x;
	            _580[0] = vec2(g_Vertices_1[nonuniformEXT(_101)]._member0[_933 / 4u], g_Vertices_1[nonuniformEXT(_101)]._member0[(_933 + 4u) / 4u]);
	            uint _936 = _819.y;
	            _580[1] = vec2(g_Vertices_1[nonuniformEXT(_101)]._member0[_936 / 4u], g_Vertices_1[nonuniformEXT(_101)]._member0[(_936 + 4u) / 4u]);
	            uint _939 = _819.z;
	            _580[2] = vec2(g_Vertices_1[nonuniformEXT(_101)]._member0[_939 / 4u], g_Vertices_1[nonuniformEXT(_101)]._member0[(_939 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _113 = _819.x / 4u;
	                _580[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_101)]._member0[_113], g_Vertices_3[nonuniformEXT(_101)]._member0[_113] >> uint(16)) & uvec2(65535u))));
	                uint _116 = _819.y / 4u;
	                _580[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_101)]._member0[_116], g_Vertices_3[nonuniformEXT(_101)]._member0[_116] >> uint(16)) & uvec2(65535u))));
	                uint _119 = _819.z / 4u;
	                _580[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_101)]._member0[_119], g_Vertices_3[nonuniformEXT(_101)]._member0[_119] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _103 = _819.x / 4u;
	                    uint _832 = g_Vertices_3[nonuniformEXT(_101)]._member0[_103] & 65535u;
	                    int _574;
	                    if (_832 > 32767u)
	                    {
	                        _574 = int(4294901760u | _832);
	                    }
	                    else
	                    {
	                        _574 = int(_832);
	                    }
	                    uint _845 = (g_Vertices_3[nonuniformEXT(_101)]._member0[_103] & 4294901760u) >> uint(16);
	                    int _573;
	                    if (_845 > 32767u)
	                    {
	                        _573 = int(4294901760u | _845);
	                    }
	                    else
	                    {
	                        _573 = int(_845);
	                    }
	                    _580[0] = vec2(max(float(_574) * 3.0518509447574615478515625e-05, -1.0), max(float(_573) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _106 = _819.y / 4u;
	                    uint _859 = g_Vertices_3[nonuniformEXT(_101)]._member0[_106] & 65535u;
	                    int _572;
	                    if (_859 > 32767u)
	                    {
	                        _572 = int(4294901760u | _859);
	                    }
	                    else
	                    {
	                        _572 = int(_859);
	                    }
	                    uint _872 = (g_Vertices_3[nonuniformEXT(_101)]._member0[_106] & 4294901760u) >> uint(16);
	                    int _571;
	                    if (_872 > 32767u)
	                    {
	                        _571 = int(4294901760u | _872);
	                    }
	                    else
	                    {
	                        _571 = int(_872);
	                    }
	                    _580[1] = vec2(max(float(_572) * 3.0518509447574615478515625e-05, -1.0), max(float(_571) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _109 = _819.z / 4u;
	                    uint _886 = g_Vertices_3[nonuniformEXT(_101)]._member0[_109] & 65535u;
	                    int _570;
	                    if (_886 > 32767u)
	                    {
	                        _570 = int(4294901760u | _886);
	                    }
	                    else
	                    {
	                        _570 = int(_886);
	                    }
	                    uint _899 = (g_Vertices_3[nonuniformEXT(_101)]._member0[_109] & 4294901760u) >> uint(16);
	                    int _569;
	                    if (_899 > 32767u)
	                    {
	                        _569 = int(4294901760u | _899);
	                    }
	                    else
	                    {
	                        _569 = int(_899);
	                    }
	                    _580[2] = vec2(max(float(_570) * 3.0518509447574615478515625e-05, -1.0), max(float(_569) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _579 = 0;
	    for (;;)
	    {
	        if (!(_579 < 3))
	        {
	            break;
	        }
	        vsInput[_579].vTexCoord = _580[_579];
	        _579++;
	        continue;
	    }
	    vec3 _581[3];
	    vec4 _582[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _555 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _141 = uint(_555[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _983 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _553 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _554 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _999 = (uvec3(uint(_553[_983])) * _583) + uvec3(uint(_554[_983]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1500 = _999.x;
	                _581[0] = vec3(g_Vertices_1[nonuniformEXT(_141)]._member0[_1500 / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1500 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1500 + 8u) / 4u]);
	                uint _1505 = _999.y;
	                _581[1] = vec3(g_Vertices_1[nonuniformEXT(_141)]._member0[_1505 / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1505 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1505 + 8u) / 4u]);
	                uint _1510 = _999.z;
	                _581[2] = vec3(g_Vertices_1[nonuniformEXT(_141)]._member0[_1510 / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1510 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_141)]._member0[(_1510 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1254 = _999.x;
	                    uvec2 _1256 = uvec2(g_Vertices_3[nonuniformEXT(_141)]._member0[_1254 / 4u], g_Vertices_3[nonuniformEXT(_141)]._member0[(_1254 + 4u) / 4u]);
	                    uint _1257 = _999.y;
	                    uvec2 _448 = uvec2(g_Vertices_3[nonuniformEXT(_141)]._member0[_1257 / 4u], g_Vertices_3[nonuniformEXT(_141)]._member0[(_1257 + 4u) / 4u]);
	                    uint _1260 = _999.z;
	                    uvec2 _447 = uvec2(g_Vertices_3[nonuniformEXT(_141)]._member0[_1260 / 4u], g_Vertices_3[nonuniformEXT(_141)]._member0[(_1260 + 4u) / 4u]);
	                    uint _1266 = _1256.x;
	                    uint _1274 = _1256.y;
	                    vec2 _1284 = ((vec2(float(_1266 & 65535u), float((_1266 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1285 = _1284.x;
	                    float _1290 = (1.0 - abs(_1285)) - abs(_1284.y);
	                    vec3 _1291 = vec3(_1285, _1284.y, _1290);
	                    float _1293 = saturate(-_1290);
	                    vec2 _1299 = _1284 + mix(vec2(_1293), vec2(-_1293), greaterThanEqual(_1284, vec2(0.0)));
	                    _1291.x = _1299.x;
	                    _1291.y = _1299.y;
	                    vec3 _557 = normalize(_1291);
	                    vec2 _1306 = ((vec2(float((_1274 >> uint(1)) & 32767u), float((_1274 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1307 = _1306.x;
	                    float _1312 = (1.0 - abs(_1307)) - abs(_1306.y);
	                    vec3 _1313 = vec3(_1307, _1306.y, _1312);
	                    float _1315 = saturate(-_1312);
	                    vec2 _1321 = _1306 + mix(vec2(_1315), vec2(-_1315), greaterThanEqual(_1306, vec2(0.0)));
	                    _1313.x = _1321.x;
	                    _1313.y = _1321.y;
	                    vec3 _556 = normalize(_1313);
	                    float _543;
	                    if ((_1274 & 1u) != 0u)
	                    {
	                        _543 = 1.0;
	                    }
	                    else
	                    {
	                        _543 = -1.0;
	                    }
	                    _581[0] = _557;
	                    _582[0].w = _543;
	                    _582[0].x = _556.x;
	                    _582[0].y = _556.y;
	                    _582[0].z = _556.z;
	                    vec2 _1363 = ((vec2(float(_448.x & 65535u), float((_448.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1364 = _1363.x;
	                    float _1369 = (1.0 - abs(_1364)) - abs(_1363.y);
	                    vec3 _1370 = vec3(_1364, _1363.y, _1369);
	                    float _1372 = saturate(-_1369);
	                    vec2 _1378 = _1363 + mix(vec2(_1372), vec2(-_1372), greaterThanEqual(_1363, vec2(0.0)));
	                    _1370.x = _1378.x;
	                    _1370.y = _1378.y;
	                    vec3 _559 = normalize(_1370);
	                    vec2 _1385 = ((vec2(float((_448.y >> uint(1)) & 32767u), float((_448.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1386 = _1385.x;
	                    float _1391 = (1.0 - abs(_1386)) - abs(_1385.y);
	                    vec3 _1392 = vec3(_1386, _1385.y, _1391);
	                    float _1394 = saturate(-_1391);
	                    vec2 _1400 = _1385 + mix(vec2(_1394), vec2(-_1394), greaterThanEqual(_1385, vec2(0.0)));
	                    _1392.x = _1400.x;
	                    _1392.y = _1400.y;
	                    vec3 _558 = normalize(_1392);
	                    float _542;
	                    if ((_448.y & 1u) != 0u)
	                    {
	                        _542 = 1.0;
	                    }
	                    else
	                    {
	                        _542 = -1.0;
	                    }
	                    _581[1] = _559;
	                    _582[1].w = _542;
	                    _582[1].x = _558.x;
	                    _582[1].y = _558.y;
	                    _582[1].z = _558.z;
	                    vec2 _1442 = ((vec2(float(_447.x & 65535u), float((_447.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1443 = _1442.x;
	                    float _1448 = (1.0 - abs(_1443)) - abs(_1442.y);
	                    vec3 _1449 = vec3(_1443, _1442.y, _1448);
	                    float _1451 = saturate(-_1448);
	                    vec2 _1457 = _1442 + mix(vec2(_1451), vec2(-_1451), greaterThanEqual(_1442, vec2(0.0)));
	                    _1449.x = _1457.x;
	                    _1449.y = _1457.y;
	                    vec3 _561 = normalize(_1449);
	                    vec2 _1464 = ((vec2(float((_447.y >> uint(1)) & 32767u), float((_447.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1465 = _1464.x;
	                    float _1470 = (1.0 - abs(_1465)) - abs(_1464.y);
	                    vec3 _1471 = vec3(_1465, _1464.y, _1470);
	                    float _1473 = saturate(-_1470);
	                    vec2 _1479 = _1464 + mix(vec2(_1473), vec2(-_1473), greaterThanEqual(_1464, vec2(0.0)));
	                    _1471.x = _1479.x;
	                    _1471.y = _1479.y;
	                    vec3 _560 = normalize(_1471);
	                    float _541;
	                    if ((_447.y & 1u) != 0u)
	                    {
	                        _541 = 1.0;
	                    }
	                    else
	                    {
	                        _541 = -1.0;
	                    }
	                    _581[2] = _561;
	                    _582[2].w = _541;
	                    _582[2].x = _560.x;
	                    _582[2].y = _560.y;
	                    _582[2].z = _560.z;
	                    break;
	                }
	                else
	                {
	                    uint _143 = _999.x / 4u;
	                    vec4 _563 = _582[0];
	                    float _1021 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_143] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1024 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_143] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1028 = (1.0 - abs(_1021)) - abs(_1024);
	                    vec3 _1029 = vec3(_1021, _1024, _1028);
	                    float _1031 = saturate(-_1028);
	                    vec2 _1032 = vec2(_1021, _1024);
	                    vec2 _1038 = _1032 + mix(vec2(_1031), vec2(-_1031), greaterThanEqual(_1032, vec2(0.0)));
	                    _1029.x = _1038.x;
	                    _1029.y = _1038.y;
	                    vec3 _1043 = normalize(_1029);
	                    vec3 _562 = _1043;
	                    float _1044 = _1043.z;
	                    float _550;
	                    if (_1044 >= 0.0)
	                    {
	                        _550 = 1.0;
	                    }
	                    else
	                    {
	                        _550 = -1.0;
	                    }
	                    float _1051 = (-1.0) / (_550 + _1044);
	                    float _1052 = _1043.x;
	                    vec3 _551;
	                    vec3 _1060 = _551;
	                    _1060.x = 1.0 + (((_550 * _1052) * _1052) * _1051);
	                    _1060.y = _550 * ((_1052 * _1043.y) * _1051);
	                    _1060.z = (-_550) * _1052;
	                    _551 = _1060;
	                    float _1068 = float((g_Vertices_3[nonuniformEXT(_141)]._member0[_143] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1074 = (_1060 * cos(_1068)) + (cross(_1043, _1060) * sin(_1068));
	                    vec4 _1076 = _563;
	                    _1076.x = _1074.x;
	                    _1076.y = _1074.y;
	                    _1076.z = _1074.z;
	                    _563 = _1076;
	                    float _552;
	                    if ((g_Vertices_3[nonuniformEXT(_141)]._member0[_143] & 1u) == 0u)
	                    {
	                        _552 = -1.0;
	                    }
	                    else
	                    {
	                        _552 = 1.0;
	                    }
	                    vec4 _1087 = _563;
	                    _1087.w = _552;
	                    _563 = _1087;
	                    _581[0] = _562;
	                    _582[0] = _1087;
	                    uint _146 = _999.y / 4u;
	                    vec4 _565 = _582[1];
	                    float _1103 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_146] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1106 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_146] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1110 = (1.0 - abs(_1103)) - abs(_1106);
	                    vec3 _1111 = vec3(_1103, _1106, _1110);
	                    float _1113 = saturate(-_1110);
	                    vec2 _1114 = vec2(_1103, _1106);
	                    vec2 _1120 = _1114 + mix(vec2(_1113), vec2(-_1113), greaterThanEqual(_1114, vec2(0.0)));
	                    _1111.x = _1120.x;
	                    _1111.y = _1120.y;
	                    vec3 _1125 = normalize(_1111);
	                    vec3 _564 = _1125;
	                    float _1126 = _1125.z;
	                    float _547;
	                    if (_1126 >= 0.0)
	                    {
	                        _547 = 1.0;
	                    }
	                    else
	                    {
	                        _547 = -1.0;
	                    }
	                    float _1133 = (-1.0) / (_547 + _1126);
	                    float _1134 = _1125.x;
	                    vec3 _548;
	                    vec3 _1142 = _548;
	                    _1142.x = 1.0 + (((_547 * _1134) * _1134) * _1133);
	                    _1142.y = _547 * ((_1134 * _1125.y) * _1133);
	                    _1142.z = (-_547) * _1134;
	                    _548 = _1142;
	                    float _1150 = float((g_Vertices_3[nonuniformEXT(_141)]._member0[_146] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1156 = (_1142 * cos(_1150)) + (cross(_1125, _1142) * sin(_1150));
	                    vec4 _1158 = _565;
	                    _1158.x = _1156.x;
	                    _1158.y = _1156.y;
	                    _1158.z = _1156.z;
	                    _565 = _1158;
	                    float _549;
	                    if ((g_Vertices_3[nonuniformEXT(_141)]._member0[_146] & 1u) == 0u)
	                    {
	                        _549 = -1.0;
	                    }
	                    else
	                    {
	                        _549 = 1.0;
	                    }
	                    vec4 _1169 = _565;
	                    _1169.w = _549;
	                    _565 = _1169;
	                    _581[1] = _564;
	                    _582[1] = _1169;
	                    uint _149 = _999.z / 4u;
	                    vec4 _567 = _582[2];
	                    float _1185 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_149] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1188 = (float((g_Vertices_3[nonuniformEXT(_141)]._member0[_149] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1192 = (1.0 - abs(_1185)) - abs(_1188);
	                    vec3 _1193 = vec3(_1185, _1188, _1192);
	                    float _1195 = saturate(-_1192);
	                    vec2 _1196 = vec2(_1185, _1188);
	                    vec2 _1202 = _1196 + mix(vec2(_1195), vec2(-_1195), greaterThanEqual(_1196, vec2(0.0)));
	                    _1193.x = _1202.x;
	                    _1193.y = _1202.y;
	                    vec3 _1207 = normalize(_1193);
	                    vec3 _566 = _1207;
	                    float _1208 = _1207.z;
	                    float _544;
	                    if (_1208 >= 0.0)
	                    {
	                        _544 = 1.0;
	                    }
	                    else
	                    {
	                        _544 = -1.0;
	                    }
	                    float _1215 = (-1.0) / (_544 + _1208);
	                    float _1216 = _1207.x;
	                    vec3 _545;
	                    vec3 _1224 = _545;
	                    _1224.x = 1.0 + (((_544 * _1216) * _1216) * _1215);
	                    _1224.y = _544 * ((_1216 * _1207.y) * _1215);
	                    _1224.z = (-_544) * _1216;
	                    _545 = _1224;
	                    float _1232 = float((g_Vertices_3[nonuniformEXT(_141)]._member0[_149] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1238 = (_1224 * cos(_1232)) + (cross(_1207, _1224) * sin(_1232));
	                    vec4 _1240 = _567;
	                    _1240.x = _1238.x;
	                    _1240.y = _1238.y;
	                    _1240.z = _1238.z;
	                    _567 = _1240;
	                    float _546;
	                    if ((g_Vertices_3[nonuniformEXT(_141)]._member0[_149] & 1u) == 0u)
	                    {
	                        _546 = -1.0;
	                    }
	                    else
	                    {
	                        _546 = 1.0;
	                    }
	                    vec4 _1251 = _567;
	                    _1251.w = _546;
	                    _567 = _1251;
	                    _581[2] = _566;
	                    _582[2] = _1251;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _581[0] = vec3(0.0);
	            _581[1] = vec3(0.0);
	            _581[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _568 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _199 = uint(_568[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1529 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _539 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _540 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1545 = (uvec3(uint(_539[_1529])) * _583) + uvec3(uint(_540[_1529]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1547 = _1545.x;
	            _582[0] = vec4(g_Vertices_1[nonuniformEXT(_199)]._member0[_1547 / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1547 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1547 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1547 + 12u) / 4u]);
	            uint _1553 = _1545.y;
	            _582[1] = vec4(g_Vertices_1[nonuniformEXT(_199)]._member0[_1553 / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1553 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1553 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1553 + 12u) / 4u]);
	            uint _1559 = _1545.z;
	            _582[2] = vec4(g_Vertices_1[nonuniformEXT(_199)]._member0[_1559 / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1559 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1559 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_199)]._member0[(_1559 + 12u) / 4u]);
	        }
	        else
	        {
	            _582[0] = vec4(0.0);
	            _582[1] = vec4(0.0);
	            _582[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _579 = 0;
	    for (;;)
	    {
	        if (!(_579 < 3))
	        {
	            break;
	        }
	        vsInput[_579].vNormalOs = _581[_579];
	        vsInput[_579].vTangentUOs_flTangentVSign = _582[_579];
	        _579++;
	        continue;
	    }
	    vec2 _451 = vsInput[0].vTexCoord;
	    vec3 _537 = vsInput[0].vNormalOs;
	    vec4 _538;
	    vec4 _1593 = _538;
	    _1593.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _1593.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _1593.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _1593.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _538 = _1593;
	    vec4 _1616 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _536 = _1616;
	    vec3 _1617 = _1616.xyz;
	    vec3 _1618 = _1617 * vec3(0.077399380505084991455078125);
	    vec3 _1621 = pow((_1617 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _533;
	    if (_1616.x <= 0.040449999272823333740234375)
	    {
	        _533 = _1618.x;
	    }
	    else
	    {
	        _533 = _1621.x;
	    }
	    float _534;
	    if (_1616.y <= 0.040449999272823333740234375)
	    {
	        _534 = _1618.y;
	    }
	    else
	    {
	        _534 = _1621.y;
	    }
	    float _535;
	    if (_1616.z <= 0.040449999272823333740234375)
	    {
	        _535 = _1618.z;
	    }
	    else
	    {
	        _535 = _1621.z;
	    }
	    vec3 _1646 = vec3(_533, _534, _535);
	    vec4 _1648 = _536;
	    _1648.x = _1646.x;
	    _1648.y = _1646.y;
	    _1648.z = _1646.z;
	    _536 = _1648;
	    vec4 _454;
	    vec4 _1655 = _454;
	    _1655.x = _1648.x;
	    _1655.y = _1648.y;
	    _1655.z = _1648.z;
	    _1655.w = _1648.w;
	    _454 = _1655;
	    mat3x4 _1666 = transpose(gl_WorldToObjectEXT);
	    mat3 _532;
	    mat3 _1669 = _532;
	    _1669[0] = _1666[0].xyz;
	    _1669[1] = _1666[1].xyz;
	    _1669[2] = _1666[2].xyz;
	    _532 = _1669;
	    vec3 _1678 = normalize(_1669 * _537.xyz);
	    vec3 _455;
	    vec3 _1680 = _455;
	    _1680.x = _1678.x;
	    _1680.y = _1678.y;
	    _1680.z = _1678.z;
	    _455 = _1680;
	    mat3x4 _1692 = transpose(gl_WorldToObjectEXT);
	    mat3 _531;
	    mat3 _1695 = _531;
	    _1695[0] = _1692[0].xyz;
	    _1695[1] = _1692[1].xyz;
	    _1695[2] = _1692[2].xyz;
	    _531 = _1695;
	    vec3 _1704 = normalize(_1695 * _538.xyz);
	    vec4 _453;
	    vec4 _1706 = _453;
	    _1706.x = _1704.x;
	    _1706.y = _1704.y;
	    _1706.z = _1704.z;
	    _1706.w = _538.w;
	    _453 = _1706;
	    vec4 _1715 = _451.xyxy;
	    vec4 _1728 = _1715;
	    _1728.x = dot(_1715.xy, _495.xy) + _495.w;
	    _1728.y = dot(_1715.xy, _494.xy) + _494.w;
	    vec2 _1736 = _1728.xy + (_493.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1738 = _1728;
	    _1738.x = _1736.x;
	    _1738.y = _1736.y;
	    vec3 _1744 = mix(vec3(1.0), _1655.xyz, vec3(_491));
	    vec4 _1746 = _1655;
	    _1746.x = _1744.x;
	    _1746.y = _1744.y;
	    _1746.z = _1744.z;
	    vec3 _1754 = _1746.xyz * _492.xyz;
	    vec4 _1756 = _1746;
	    _1756.x = _1754.x;
	    _1756.y = _1754.y;
	    _1756.z = _1754.z;
	    vec3 _446 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _445 = _1680;
	    vec4 _444 = _1738;
	    vec4 _443 = _1756;
	    vec4 _442 = _1706;
	    vec2 _450 = vsInput[1].vTexCoord;
	    vec3 _529 = vsInput[1].vNormalOs;
	    vec4 _530;
	    vec4 _1768 = _530;
	    _1768.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _1768.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _1768.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _1768.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _530 = _1768;
	    vec4 _1791 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _528 = _1791;
	    vec3 _1792 = _1791.xyz;
	    vec3 _1793 = _1792 * vec3(0.077399380505084991455078125);
	    vec3 _1796 = pow((_1792 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _525;
	    if (_1791.x <= 0.040449999272823333740234375)
	    {
	        _525 = _1793.x;
	    }
	    else
	    {
	        _525 = _1796.x;
	    }
	    float _526;
	    if (_1791.y <= 0.040449999272823333740234375)
	    {
	        _526 = _1793.y;
	    }
	    else
	    {
	        _526 = _1796.y;
	    }
	    float _527;
	    if (_1791.z <= 0.040449999272823333740234375)
	    {
	        _527 = _1793.z;
	    }
	    else
	    {
	        _527 = _1796.z;
	    }
	    vec3 _1821 = vec3(_525, _526, _527);
	    vec4 _1823 = _528;
	    _1823.x = _1821.x;
	    _1823.y = _1821.y;
	    _1823.z = _1821.z;
	    _528 = _1823;
	    vec4 _457;
	    vec4 _1830 = _457;
	    _1830.x = _1823.x;
	    _1830.y = _1823.y;
	    _1830.z = _1823.z;
	    _1830.w = _1823.w;
	    _457 = _1830;
	    mat3x4 _1841 = transpose(gl_WorldToObjectEXT);
	    mat3 _524;
	    mat3 _1844 = _524;
	    _1844[0] = _1841[0].xyz;
	    _1844[1] = _1841[1].xyz;
	    _1844[2] = _1841[2].xyz;
	    _524 = _1844;
	    vec3 _1853 = normalize(_1844 * _529.xyz);
	    vec3 _458;
	    vec3 _1855 = _458;
	    _1855.x = _1853.x;
	    _1855.y = _1853.y;
	    _1855.z = _1853.z;
	    _458 = _1855;
	    mat3x4 _1867 = transpose(gl_WorldToObjectEXT);
	    mat3 _523;
	    mat3 _1870 = _523;
	    _1870[0] = _1867[0].xyz;
	    _1870[1] = _1867[1].xyz;
	    _1870[2] = _1867[2].xyz;
	    _523 = _1870;
	    vec3 _1879 = normalize(_1870 * _530.xyz);
	    vec4 _456;
	    vec4 _1881 = _456;
	    _1881.x = _1879.x;
	    _1881.y = _1879.y;
	    _1881.z = _1879.z;
	    _1881.w = _530.w;
	    _456 = _1881;
	    vec4 _1890 = _450.xyxy;
	    vec4 _1903 = _1890;
	    _1903.x = dot(_1890.xy, _495.xy) + _495.w;
	    _1903.y = dot(_1890.xy, _494.xy) + _494.w;
	    vec2 _1911 = _1903.xy + (_493.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1913 = _1903;
	    _1913.x = _1911.x;
	    _1913.y = _1911.y;
	    vec3 _1919 = mix(vec3(1.0), _1830.xyz, vec3(_491));
	    vec4 _1921 = _1830;
	    _1921.x = _1919.x;
	    _1921.y = _1919.y;
	    _1921.z = _1919.z;
	    vec3 _1929 = _1921.xyz * _492.xyz;
	    vec4 _1931 = _1921;
	    _1931.x = _1929.x;
	    _1931.y = _1929.y;
	    _1931.z = _1929.z;
	    vec3 _441 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _440 = _1855;
	    vec4 _439 = _1913;
	    vec4 _438 = _1931;
	    vec4 _437 = _1881;
	    vec2 _449 = vsInput[2].vTexCoord;
	    vec3 _521 = vsInput[2].vNormalOs;
	    vec4 _522;
	    vec4 _1943 = _522;
	    _1943.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _1943.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _1943.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _1943.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _522 = _1943;
	    vec4 _1966 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _520 = _1966;
	    vec3 _1967 = _1966.xyz;
	    vec3 _1968 = _1967 * vec3(0.077399380505084991455078125);
	    vec3 _1971 = pow((_1967 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _517;
	    if (_1966.x <= 0.040449999272823333740234375)
	    {
	        _517 = _1968.x;
	    }
	    else
	    {
	        _517 = _1971.x;
	    }
	    float _518;
	    if (_1966.y <= 0.040449999272823333740234375)
	    {
	        _518 = _1968.y;
	    }
	    else
	    {
	        _518 = _1971.y;
	    }
	    float _519;
	    if (_1966.z <= 0.040449999272823333740234375)
	    {
	        _519 = _1968.z;
	    }
	    else
	    {
	        _519 = _1971.z;
	    }
	    vec3 _1996 = vec3(_517, _518, _519);
	    vec4 _1998 = _520;
	    _1998.x = _1996.x;
	    _1998.y = _1996.y;
	    _1998.z = _1996.z;
	    _520 = _1998;
	    vec4 _460;
	    vec4 _2005 = _460;
	    _2005.x = _1998.x;
	    _2005.y = _1998.y;
	    _2005.z = _1998.z;
	    _2005.w = _1998.w;
	    _460 = _2005;
	    mat3x4 _2016 = transpose(gl_WorldToObjectEXT);
	    mat3 _516;
	    mat3 _2019 = _516;
	    _2019[0] = _2016[0].xyz;
	    _2019[1] = _2016[1].xyz;
	    _2019[2] = _2016[2].xyz;
	    _516 = _2019;
	    vec3 _2028 = normalize(_2019 * _521.xyz);
	    vec3 _461;
	    vec3 _2030 = _461;
	    _2030.x = _2028.x;
	    _2030.y = _2028.y;
	    _2030.z = _2028.z;
	    _461 = _2030;
	    vec3 _2038 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2042 = transpose(gl_WorldToObjectEXT);
	    mat3 _515;
	    mat3 _2045 = _515;
	    _2045[0] = _2042[0].xyz;
	    _2045[1] = _2042[1].xyz;
	    _2045[2] = _2042[2].xyz;
	    _515 = _2045;
	    vec3 _2054 = normalize(_2045 * _522.xyz);
	    vec4 _459;
	    vec4 _2056 = _459;
	    _2056.x = _2054.x;
	    _2056.y = _2054.y;
	    _2056.z = _2054.z;
	    _2056.w = _522.w;
	    _459 = _2056;
	    vec4 _2065 = _449.xyxy;
	    vec4 _2078 = _2065;
	    _2078.x = dot(_2065.xy, _495.xy) + _495.w;
	    _2078.y = dot(_2065.xy, _494.xy) + _494.w;
	    vec2 _2086 = _2078.xy + (_493.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2088 = _2078;
	    _2088.x = _2086.x;
	    _2088.y = _2086.y;
	    vec3 _2094 = mix(vec3(1.0), _2005.xyz, vec3(_491));
	    vec4 _2096 = _2005;
	    _2096.x = _2094.x;
	    _2096.y = _2094.y;
	    _2096.z = _2094.z;
	    vec3 _2104 = _2096.xyz * _492.xyz;
	    vec4 _2106 = _2096;
	    _2106.x = _2104.x;
	    _2106.y = _2104.y;
	    _2106.z = _2104.z;
	    vec3 _436 = _2038;
	    vec3 _435 = _2030;
	    vec3 _2131 = ((_445 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_440 * attrs.barycentrics.x)) + (_2030 * attrs.barycentrics.y);
	    vec3 _462;
	    vec3 _469 = _2131;
	    vec4 _468 = ((_444 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_439 * attrs.barycentrics.x)) + (_2088 * attrs.barycentrics.y);
	    vec4 _467 = ((_443 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_438 * attrs.barycentrics.x)) + (_2106 * attrs.barycentrics.y);
	    vec3 _466 = _462;
	    vec4 _465 = ((_442 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_437 * attrs.barycentrics.x)) + (_2056 * attrs.barycentrics.y);
	    vec3 _464 = normalize(cross(_441 - _446, _2038 - _446));
	    bool _463 = gl_HitKindEXT == 254u;
	    vec3 _484 = vec3(0.0);
	    float _483 = 0.039999999105930328369140625;
	    vec3 _482 = vec3(0.0);
	    vec3 _480 = vec3(1.0);
	    bool _479 = false;
	    vec3 _2166 = _2131.xyz;
	    vec3 _481 = _2166;
	    if (dot(_2166, _2166) >= 1.0099999904632568359375)
	    {
	        _481 = _466.xyz;
	    }
	    _483 = _487;
	    _480 = _464;
	    bool _513;
	    if (_488)
	    {
	        _513 = !_489;
	    }
	    else
	    {
	        _513 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_513)
	    {
	        float _514;
	        if (_463)
	        {
	            _514 = 1.0;
	        }
	        else
	        {
	            _514 = -1.0;
	        }
	        _481 *= _514;
	        if (_463)
	        {
	            _514 = 1.0;
	        }
	        else
	        {
	            _514 = -1.0;
	        }
	        _480 *= _514;
	        _479 = !_463;
	    }
	    vec3 _2198 = _481;
	    vec3 _2199 = normalize(_2198);
	    _481 = _2199;
	    vec3 _475 = _484;
	    float _474 = _483;
	    vec3 _473 = _482;
	    vec3 _472 = _2199;
	    vec3 _471 = _480;
	    bool _470 = _479;
	    vec3 _478 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_490], g_bindless_Sampler[_496])), _468.xy, 0.0).xyz * _467.xyz;
	    float _476 = _485;
	    vec4 _2220 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_486], g_bindless_Sampler[_497])), _468.xy, 0.0);
	    float _2221 = _2220.x;
	    float _2222 = _2220.y;
	    float _2224 = (_2221 + _2222) - 1.00392162799835205078125;
	    float _2225 = _2221 - _2222;
	    vec2 _477 = _2220.zz;
	    vec3 _511 = normalize(vec3(vec2(_2224, _2225), (1.0 - abs(_2224)) - abs(_2225)));
	    bool _509;
	    if (_488)
	    {
	        _509 = !_489;
	    }
	    else
	    {
	        _509 = false;
	    }
	    if (_509)
	    {
	        float _510;
	        if (_463)
	        {
	            _510 = 1.0;
	        }
	        else
	        {
	            _510 = -1.0;
	        }
	        _509 = _510 < 0.0;
	    }
	    else
	    {
	        _509 = false;
	    }
	    float _512;
	    if (_509)
	    {
	        _512 = -1.0;
	    }
	    else
	    {
	        _512 = 1.0;
	    }
	    float _2256 = _512;
	    vec3 _2257 = _469.xyz * _2256;
	    if (_465.w > 0.0)
	    {
	        _512 = 1.0;
	    }
	    else
	    {
	        _512 = -1.0;
	    }
	    bool _507;
	    if (_488)
	    {
	        _507 = !_489;
	    }
	    else
	    {
	        _507 = false;
	    }
	    if (_507)
	    {
	        float _508;
	        if (_463)
	        {
	            _508 = 1.0;
	        }
	        else
	        {
	            _508 = -1.0;
	        }
	        _507 = _508 < 0.0;
	    }
	    else
	    {
	        _507 = false;
	    }
	    if (!_507)
	    {
	        vec3 _2289 = _511;
	        _2289.y = -_2289.y;
	        _511 = _2289;
	    }
	    vec3 _2296 = _465.xyz * _511.x;
	    vec3 _506;
	    vec3 _2298 = _506;
	    _2298.x = _2296.x;
	    _2298.y = _2296.y;
	    _2298.z = _2296.z;
	    vec3 _2308 = _2298.xyz + ((cross(_2257.xyz, _465.xyz) * _512).xyz * _511.y);
	    vec3 _2310 = _2298;
	    _2310.x = _2308.x;
	    _2310.y = _2308.y;
	    _2310.z = _2308.z;
	    vec3 _2319 = _2310.xyz + (_2257.xyz * _511.z);
	    vec3 _2321 = _2310;
	    _2321.x = _2319.x;
	    _2321.y = _2319.y;
	    _2321.z = _2319.z;
	    _506 = _2321;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _471;
	    payload.vInterpolatedNormalWs = _472;
	    vec3 _504[3] = vec3[](_446, _441, _436);
	    vec3 _505[3] = vec3[](_445, _440, _435);
	    vec3 _2368 = ((_504[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_504[1] * attrs.barycentrics.x)) + (_504[2] * attrs.barycentrics.y);
	    vec3 _498[3];
	    _498[0] = _2368 - (_505[0] * dot(_2368 - _504[0], _505[0]));
	    _498[1] = _2368 - (_505[1] * dot(_2368 - _504[1], _505[1]));
	    _498[2] = _2368 - (_505[2] * dot(_2368 - _504[2], _505[2]));
	    vec3 _2408 = ((_498[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_498[1] * attrs.barycentrics.x)) + (_498[2] * attrs.barycentrics.y);
	    vec3 _499[3];
	    _499[0] = cross(_504[0] - _504[1], _471);
	    _499[1] = cross(_504[1] - _504[2], _471);
	    _499[2] = cross(_504[2] - _504[0], _471);
	    float _500 = dot(_2408 - _2368, _471);
	    vec3 _501 = _2408;
	    int _502 = 0;
	    for (;;)
	    {
	        bool _2424_ladder_break = false;
	        do
	        {
	            if (!(_502 < 3))
	            {
	                _2424_ladder_break = true;
	                break;
	            }
	            if (_500 > 0.00999999977648258209228515625)
	            {
	                _2424_ladder_break = true;
	                break;
	            }
	            if (dot(_499[_502], _499[_502]) == 0.0)
	            {
	                break;
	            }
	            _499[_502] = normalize(_499[_502]);
	            int _503 = 0;
	            for (;;)
	            {
	                if (!(_503 < 3))
	                {
	                    break;
	                }
	                vec3 _2462 = _505[_503] - (_499[_502] * dot(_499[_502], _505[_503]));
	                _498[_503] = _2368 - (_2462 * dot(_2368 - _504[_503], _2462));
	                _503++;
	                continue;
	            }
	            vec3 _2486 = ((_498[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_498[1] * attrs.barycentrics.x)) + (_498[2] * attrs.barycentrics.y);
	            _500 = dot(_2486 - _2368, _471);
	            _501 = _2486;
	            break;
	        } while(false);
	        if (_2424_ladder_break)
	        {
	            break;
	        }
	        _502++;
	        continue;
	    }
	    if (!(_500 > 0.00999999977648258209228515625))
	    {
	        _501 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _501;
	    payload.bFlippedNormal = _470;
	    f16vec3 _2499 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_2499, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2499, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(normalize(_2321.xyz));
	    payload.material.vAlbedo = f16vec3(_478);
	    payload.material.vEmissive = f16vec3(_475);
	    payload.material.flReflectance = float16_t(_474);
	    payload.material.flMetalness = float16_t(_476);
	    payload.material.flRoughness = float16_t(dot(_477, vec2(0.5)));
	    if (any(greaterThan(_473, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _2525 = f16vec3(_473);
	        payload.material.vMaterialBits.x = _2525.x;
	        payload.material.vMaterialBits.y = _2525.y;
	        payload.material.vMaterialBits.z = _2525.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SHADER_QUALITY == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_PAINT_VERTEX_COLORS == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SELF_ILLUM == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_PRE_BAKED_VERTEX_ANIMATION == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColor, true);
		BoolAttribute(VertexPaintUIPickColorAlpha, F_ALPHA_TEST==1 || F_TRANSLUCENT==1);
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
}
