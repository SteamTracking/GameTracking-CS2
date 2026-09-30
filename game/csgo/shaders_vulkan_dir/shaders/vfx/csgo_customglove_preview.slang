//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Preview and edit glove parameters to be used it csgo_customglove compositing shader.";
	DevShader = false;
	Version = 1;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	CsgoForward();
	Depth("csgo_depth_only.vfx");
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_PATTERN, 0..1, "Pattern" );
	Feature( F_PATTERN_PAINT, 0..1, "Pattern" );
	Feature( F_PUFFY_PAINT, 0..1, "Pattern" );
	Feature( F_TINT_ID, 0..1, "Tint" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Requires( F_PATTERN_PAINT, F_PATTERN ), "Pattern Paint requires Pattern" );
	FeatureRule( Requires( F_PUFFY_PAINT, F_PATTERN_PAINT ), "Puffy Paint requires Pattern Paint" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vDamageTexCoordXform0 < UiType(VectorText); Expression(v0 = g_fDamageTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,0,.5+g_vDamageTexCoordOffset.x+v2*.5-v1*.5)); >;
	float4 g_vDamageTexCoordXform1 < UiType(VectorText); Expression(v0 = g_fDamageTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2,v1,0,.5+g_vDamageTexCoordOffset.y-(v2*.5+v1*.5))); >;
	float4 g_vGrimeTexCoordXform0 < UiType(VectorText); Expression(v0 = g_fGrimeTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,0,.5+g_vGrimeTexCoordOffset.x+v2*.5-v1*.5)); >;
	float4 g_vGrimeTexCoordXform1 < UiType(VectorText); Expression(v0 = g_fGrimeTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2,v1,0,.5+g_vGrimeTexCoordOffset.y-(v2*.5+v1*.5))); >;
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = g_fPatternTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vPatternTexCoordScale.x,-v2*g_vPatternTexCoordScale.y,0,g_vPatternTexCoordCenter.x+g_vPatternTexCoordOffset.x+v2*g_vPatternTexCoordCenter.y-v1*g_vPatternTexCoordCenter.x)); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = g_fPatternTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vPatternTexCoordScale.x,v1*g_vPatternTexCoordScale.y,0,g_vPatternTexCoordCenter.y+g_vPatternTexCoordOffset.y-(v2*g_vPatternTexCoordCenter.x+v1*g_vPatternTexCoordCenter.y))); >;
	
	// Composite Inputs
	float g_fPatternNormalDistortion < UiType(Slider); UiGroup("Composite Inputs/Pattern/6"); Expression(this*.1); UiVisibility(F_PATTERN); >;
	float g_fDamageTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Wear/10"); >;
	float2 g_vDamageTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Wear/11"); >;
	float g_fGrimeTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Wear/20"); >;
	float2 g_vGrimeTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Wear/21"); >;
	float2 g_vPatternTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Composite Inputs/Pattern/55"); UiVisibility(F_PATTERN); >;
	float2 g_vPatternTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Composite Inputs/Pattern/56"); UiVisibility(F_PATTERN); >;
	float g_fPatternTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Composite Inputs/Pattern/57"); UiVisibility(F_PATTERN); >;
	bool g_bFlipFixup < UiType(CheckBox); UiGroup("Composite Inputs/Off-Hand/58"); >;
	float2 g_vPatternTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Composite Inputs/Pattern/58"); UiVisibility(F_PATTERN); >;
	
	// Material1
	float2 g_vUvScale1 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material1,1/Texcoord Transform,0/0"); >;
	float2 g_vUvOffset1 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material1/Texcoord Transform/1"); >;
	
	// Material2
	float2 g_vUvScale2 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material2,2/Texcoord Transform,0/0"); >;
	float2 g_vUvOffset2 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material2/Texcoord Transform/1"); >;
	
	// Material3
	float2 g_vUvScale3 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material3,3/Texcoord Transform,0/0"); >;
	float2 g_vUvOffset3 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material3/Texcoord Transform/1"); >;
	
	// Material4
	float2 g_vUvScale4 < Default2(4, 4); Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Material4,4/Texcoord Transform,0/0"); >;
	float2 g_vUvOffset4 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material4/Texcoord Transform/1"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 15 (name: g_vPatternTexCoordXform0) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	vec4 _3;
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	struct _1224
	{
	    mat4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _1224 PerViewConstantBuffer_t;
	
	struct _443
	{
	    vec2 g_vUvScale1;
	    vec2 g_vUvOffset1;
	    vec2 g_vUvScale2;
	    vec2 g_vUvOffset2;
	    vec2 g_vUvScale3;
	    vec2 g_vUvOffset3;
	    vec2 g_vUvScale4;
	    vec2 g_vUvOffset4;
	    vec4 g_vDamageTexCoordXform0;
	    vec4 g_vDamageTexCoordXform1;
	    vec4 g_vGrimeTexCoordXform0;
	    vec4 g_vGrimeTexCoordXform1;
	    vec2 g_vPatternTexCoordScale;
	    int g_bFlipFixup;
	    float g_fPatternNormalDistortion;
	    vec4 g_vPatternTexCoordXform0;
	    vec4 g_vPatternTexCoordXform1;
	};
	
	layout(set = 0) uniform _443 _Globals_;
	
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
	layout(location = 7) out vec4 output_7;
	layout(location = 8) out vec4 output_8;
	layout(location = 9) out vec4 output_9;
	layout(location = 10) out vec4 output_10;
	
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
	    vec4 _20063 = vec4(_21354, _21355, _17978, _7654);
	    _20063.w = _7654 * g_instanceBuffer_1._m0[nInstanceIdx]._m7;
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _18905;
	    _18905.x = vTexCoord.x;
	    _18905.y = vTexCoord.y;
	    vec2 _21689 = vTexCoord.xy;
	    bool _12885;
	    if (vTexCoord.x < 0.0)
	    {
	        _12885 = _Globals_.g_bFlipFixup != 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec2 _9982;
	    vec4 _22532;
	    if (_12885)
	    {
	        vec4 _19754 = _18905;
	        _19754.x = vTexCoord.x * (-1.0);
	        vec2 _23633 = _21689;
	        _23633.x = vTexCoord.x + 1.0;
	        _9982 = _23633;
	        _22532 = _19754;
	    }
	    else
	    {
	        _9982 = _21689;
	        _22532 = _18905;
	    }
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _11179;
	    output_2 = vTexCoord.xyxy;
	    output_3 = _20063;
	    output_4 = _11179;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_6 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	    output_7 = vec4(dot(_22532.xy, _Globals_.g_vPatternTexCoordXform0.xy) + _Globals_.g_vPatternTexCoordXform0.w, dot(_22532.xy, _Globals_.g_vPatternTexCoordXform1.xy) + _Globals_.g_vPatternTexCoordXform1.w, vec2(_Globals_.g_fPatternNormalDistortion) * _Globals_.g_vPatternTexCoordScale.xy);
	    output_8 = vec4((_9982.xy * _Globals_.g_vUvScale1.xy) + _Globals_.g_vUvOffset1.xy, (_9982.xy * _Globals_.g_vUvScale2.xy) + _Globals_.g_vUvOffset2.xy);
	    output_9 = vec4((_9982.xy * _Globals_.g_vUvScale3.xy) + _Globals_.g_vUvOffset3.xy, (_9982.xy * _Globals_.g_vUvScale4.xy) + _Globals_.g_vUvOffset4.xy);
	    output_10 = vec4(dot(_21689, _Globals_.g_vDamageTexCoordXform0.xy) + _Globals_.g_vDamageTexCoordXform0.w, dot(_21689, _Globals_.g_vDamageTexCoordXform1.xy) + _Globals_.g_vDamageTexCoordXform1.w, dot(_21689, _Globals_.g_vGrimeTexCoordXform0.xy) + _Globals_.g_vGrimeTexCoordXform0.w, dot(_21689, _Globals_.g_vGrimeTexCoordXform1.xy) + _Globals_.g_vGrimeTexCoordXform1.w);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	IntAttribute(MaterialLayerCount, 4);
	StringAttribute(MaterialLayerRefType, csgo_textile_layer);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	
}

PS
{
	StaticCombo( S_TINT_ID, F_TINT_ID );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bClothShading < UiType(CheckBox); Expression(1); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bPattern < UiType(CheckBox); Expression(F_PATTERN ? 1 : 0); >;
	bool g_bPatternPaintEmboss < UiType(CheckBox); Expression(F_PUFFY_PAINT); >;
	bool g_bPatternPaintLayer < UiType(CheckBox); Expression(F_PATTERN_PAINT); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_mDamageColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint1,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast1,g_fDamageBevelColorSaturation1,g_fDamageBevelColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	float4x4 g_mDamageColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint2,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast2,g_fDamageBevelColorSaturation2,g_fDamageBevelColorBrightness2),TextureAverageColor(g_tSurface2)))); >;
	float4x4 g_mDamageColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint3,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast3,g_fDamageBevelColorSaturation3,g_fDamageBevelColorBrightness3),TextureAverageColor(g_tSurface3)))); >;
	float4x4 g_mDamageColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vDamageBevelColorTint4,1),MatrixColorCorrect2(float3(g_fDamageBevelColorContrast4,g_fDamageBevelColorSaturation4,g_fDamageBevelColorBrightness4),TextureAverageColor(g_tSurface4)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint1,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast1,g_fBurnishingColorSaturation1,g_fBurnishingColorBrightness1),TextureAverageColor(g_tSubstrate1)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint2,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast2,g_fBurnishingColorSaturation2,g_fBurnishingColorBrightness2),TextureAverageColor(g_tSubstrate2)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint3,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast3,g_fBurnishingColorSaturation3,g_fBurnishingColorBrightness3),TextureAverageColor(g_tSubstrate3)))); >;
	float4x4 g_mSubstrateBurnishingColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint4,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast4,g_fBurnishingColorSaturation4,g_fBurnishingColorBrightness4),TextureAverageColor(g_tSubstrate4)))); >;
	float4x4 g_mSubstrateColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint1,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast1,g_fSubstrateColorSaturation1,g_fSubstrateColorBrightness1),TextureAverageColor(g_tSubstrate1)))); >;
	float4x4 g_mSubstrateColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint2,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast2,g_fSubstrateColorSaturation2,g_fSubstrateColorBrightness2),TextureAverageColor(g_tSubstrate2)))); >;
	float4x4 g_mSubstrateColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint3,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast3,g_fSubstrateColorSaturation3,g_fSubstrateColorBrightness3),TextureAverageColor(g_tSubstrate3)))); >;
	float4x4 g_mSubstrateColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vSubstrateColorTint4,1),MatrixColorCorrect2(float3(g_fSubstrateColorContrast4,g_fSubstrateColorSaturation4,g_fSubstrateColorBrightness4),TextureAverageColor(g_tSubstrate4)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint1,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast1,g_fBurnishingColorSaturation1,g_fBurnishingColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint2,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast2,g_fBurnishingColorSaturation2,g_fBurnishingColorBrightness2),TextureAverageColor(g_tSurface2)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint3,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast3,g_fBurnishingColorSaturation3,g_fBurnishingColorBrightness3),TextureAverageColor(g_tSurface3)))); >;
	float4x4 g_mSurfaceBurnishingColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vBurnishingColorTint4,1),MatrixColorCorrect2(float3(g_fBurnishingColorContrast4,g_fBurnishingColorSaturation4,g_fBurnishingColorBrightness4),TextureAverageColor(g_tSurface4)))); >;
	float4x4 g_mSurfaceColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint1,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast1,g_fSurfaceColorSaturation1,g_fSurfaceColorBrightness1),TextureAverageColor(g_tSurface1)))); >;
	float4x4 g_mSurfaceColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint2,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast2,g_fSurfaceColorSaturation2,g_fSurfaceColorBrightness2),TextureAverageColor(g_tSurface2)))); >;
	float4x4 g_mSurfaceColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint3,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast3,g_fSurfaceColorSaturation3,g_fSurfaceColorBrightness3),TextureAverageColor(g_tSurface3)))); >;
	float4x4 g_mSurfaceColorAdjust4 < Expression(MatrixMultiply(MatrixColorTint2(g_vSurfaceColorTint4,1),MatrixColorCorrect2(float3(g_fSurfaceColorContrast4,g_fSurfaceColorSaturation4,g_fSurfaceColorBrightness4),TextureAverageColor(g_tSurface4)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tDamage1 < Channel(R, Box(TextureDamageHeight1), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDamage2 < Channel(R, Box(TextureDamageHeight2), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDamage3 < Channel(R, Box(TextureDamageHeight3), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDamage4 < Channel(R, Box(TextureDamageHeight4), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tGrime1 < Channel(RGB, ArtistDefined(TextureGrime1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrime2 < Channel(RGB, ArtistDefined(TextureGrime2), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrime3 < Channel(RGB, ArtistDefined(TextureGrime3), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGrime4 < Channel(RGB, ArtistDefined(TextureGrime4), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tLayerId < Channel(RGB, Box(TextureObjectMaterialId), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureObjectNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tObjectProperties < Channel(R, Box(TextureObjectAmbientOcclusion), Linear); Channel(G, Box(TextureObjectCurvature), Linear); Channel(B, Box(TextureObjectHighTouchMask), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tPattern < Channel(RGB, Box(TexturePatternColor), Srgb); Channel(A, Box(TexturePatternTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tPatternProperties < Channel(R, Box(TexturePatternMetalness), Linear); Channel(G, Box(TexturePatternRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	Texture2D g_tSubstrate1 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo1), Srgb); Channel(A, Box(TextureSubstrateTintMask1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrate2 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo2), Srgb); Channel(A, Box(TextureSubstrateTintMask2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrate3 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo3), Srgb); Channel(A, Box(TextureSubstrateTintMask3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrate4 < Channel(RGB, ArtistDefined(TextureSubstrateAlbedo4), Srgb); Channel(A, Box(TextureSubstrateTintMask4), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSubstrateNormal1 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal1, TextureSubstrateRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateNormal2 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal2, TextureSubstrateRoughness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateNormal3 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal3, TextureSubstrateRoughness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateNormal4 < Channel(RGBA, HemiOctAnisoRoughness(TextureSubstrateNormal4, TextureSubstrateRoughness4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties1 < Channel(R, Box3(TextureSubstrateAmbientOcclusion1), Linear); Channel(G, Box(TextureSubstrateMetalness1), Linear); Channel(B, Box(TextureSubstrateClothMask1), Linear); Channel(A, Box(TextureSubstrateHeight1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties2 < Channel(R, Box3(TextureSubstrateAmbientOcclusion2), Linear); Channel(G, Box(TextureSubstrateMetalness2), Linear); Channel(B, Box(TextureSubstrateClothMask2), Linear); Channel(A, Box(TextureSubstrateHeight2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties3 < Channel(R, Box3(TextureSubstrateAmbientOcclusion3), Linear); Channel(G, Box(TextureSubstrateMetalness3), Linear); Channel(B, Box(TextureSubstrateClothMask3), Linear); Channel(A, Box(TextureSubstrateHeight3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSubstrateProperties4 < Channel(R, Box3(TextureSubstrateAmbientOcclusion4), Linear); Channel(G, Box(TextureSubstrateMetalness4), Linear); Channel(B, Box(TextureSubstrateClothMask4), Linear); Channel(A, Box(TextureSubstrateHeight4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurface1 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo1), Srgb); Channel(A, Box(TextureSurfaceTintMask1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurface2 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo2), Srgb); Channel(A, Box(TextureSurfaceTintMask2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurface3 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo3), Srgb); Channel(A, Box(TextureSurfaceTintMask3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurface4 < Channel(RGB, ArtistDefined(TextureSurfaceAlbedo4), Srgb); Channel(A, Box(TextureSurfaceTintMask4), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tSurfaceNormal1 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal1, TextureSurfaceRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceNormal2 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal2, TextureSurfaceRoughness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceNormal3 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal3, TextureSurfaceRoughness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceNormal4 < Channel(RGBA, HemiOctAnisoRoughness(TextureSurfaceNormal4, TextureSurfaceRoughness4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties1 < Channel(R, Box3(TextureSurfaceAmbientOcclusion1), Linear); Channel(G, Box(TextureSurfaceMetalness1), Linear); Channel(B, Box(TextureSurfaceClothMask1), Linear); Channel(A, Box(TextureSurfaceHeight1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties2 < Channel(R, Box3(TextureSurfaceAmbientOcclusion2), Linear); Channel(G, Box(TextureSurfaceMetalness2), Linear); Channel(B, Box(TextureSurfaceClothMask2), Linear); Channel(A, Box(TextureSurfaceHeight2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties3 < Channel(R, Box3(TextureSurfaceAmbientOcclusion3), Linear); Channel(G, Box(TextureSurfaceMetalness3), Linear); Channel(B, Box(TextureSurfaceClothMask3), Linear); Channel(A, Box(TextureSurfaceHeight3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSurfaceProperties4 < Channel(R, Box3(TextureSurfaceAmbientOcclusion4), Linear); Channel(G, Box(TextureSurfaceMetalness4), Linear); Channel(B, Box(TextureSurfaceClothMask4), Linear); Channel(A, Box(TextureSurfaceHeight4), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tTintId < Channel(RGB, None(TextureObjectTintId), Linear); OutputFormat(I8); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Material1
	CreateInputTexture2D(TextureDamageHeight1, Linear, 8, "Inverse", "_height", "Material1/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureGrime1, Srgb, 8, "", "_color", "Material1/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo1, Srgb, 8, "", "_color", "Material1/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo1, Srgb, 8, "", "_color", "Material1/Surface Layer,1/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSubstrateTintMask1, Linear, 8, "", "_tintmask", "Material1/Substrate Layer/2", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceTintMask1, Linear, 8, "", "_tintmask", "Material1/Surface Layer/2", Default4(1, 1, 1, 0));
	float g_fDamageUvScale1 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material1/Damage Height/2"); >;
	float g_fGrimeUvScale1 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material1/Grime/2"); >;
	float g_fGrimeTranslucency1 < Default(0.5); UiType(Slider); UiGroup("Material1/Grime/3"); >;
	float g_fGrimeRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Grime/5"); >;
	float3 g_vSubstrateColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Substrate Layer/5"); >;
	float3 g_vSurfaceColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Surface Layer/5"); >;
	float g_fSubstrateColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Substrate Layer/6"); >;
	float g_fSurfaceColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Surface Layer/6"); >;
	float g_fSubstrateColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Substrate Layer/7"); >;
	float g_fSurfaceColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Surface Layer/7"); >;
	float g_fSubstrateColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Substrate Layer/8"); >;
	float g_fSurfaceColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Surface Layer/8"); >;
	float2 g_vSurfaceGrimeMinMax1 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material1/Grime/10"); >;
	float g_fDamageHeightBlendSoftness1 < Default(0.01); UiType(Slider); UiGroup("Material1/Damage Height/11"); Expression(max(this,.001)); >;
	float2 g_vSubstrateGrimeMinMax1 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material1/Grime/11"); >;
	float2 g_vDamageMinMax1 < Default(0); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material1/Damage Height/12"); >;
	float g_fBurnishingGrime1 < Default(0.5); UiType(Slider); UiGroup("Material1/Grime/20"); >;
	float3 g_vBurnishingColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Burnishing,5/20"); >;
	float3 g_vDamageBevelColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Damage Bevel,4/20"); >;
	float g_fBurnishingColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Burnishing/21"); >;
	float g_fDamageBevelColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Damage Bevel/21"); >;
	float g_fSubstrateCompositeColorTranslucency1 < Default(0.5); UiType(Slider); UiGroup("Material1/Substrate Layer/21"); UiVisibility(F_PATTERN || F_TINT_ID); >;
	float g_fBurnishingColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Burnishing/22"); >;
	float g_fDamageBevelColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Damage Bevel/22"); >;
	float g_fBurnishingColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Burnishing/23"); >;
	float g_fDamageBevelColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Damage Bevel/23"); >;
	bool g_bDamageBevelUseTintMask1 < UiType(CheckBox); UiGroup("Material1/Damage Bevel/24"); >;
	float g_fBurnishingCloth1 < UiType(Slider); UiGroup("Material1/Burnishing/25"); >;
	float g_fBurnishingMetalness1 < UiType(Slider); UiGroup("Material1/Burnishing/25"); >;
	CreateInputTexture2D(TextureSubstrateNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Substrate Layer/30", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureSurfaceNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Surface Layer/30", Default4(0.5, 0.5, 1, 0));
	float g_fBurnishingNormalScale1 < Default(1); UiType(Slider); UiGroup("Material1/Burnishing/30"); >;
	float g_fDamageBevelBlendSoftness1 < Default(0.5); UiType(Slider); UiGroup("Material1/Damage Bevel/30"); Expression(max(this+g_fDamageHeightBlendSoftness1,.001)); >;
	CreateInputTexture2D(TextureSubstrateRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Substrate Layer/31", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Surface Layer/31", Default4(0.5, 0.5, 0.5, 0));
	float g_fDamageBevelEmboss1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Damage Bevel/31"); >;
	CreateInputTexture2D(TextureSubstrateAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Substrate Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Surface Layer/32", Default4(1, 1, 1, 0));
	float g_fSurfaceBurnishingRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/32"); >;
	float g_fSurfaceBurnishingRoughnessBrightness2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/32"); >;
	float g_fSurfaceBurnishingRoughnessBrightness3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/32"); >;
	float g_fSurfaceBurnishingRoughnessBrightness4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/32"); >;
	CreateInputTexture2D(TextureSubstrateHeight1, Linear, 8, "", "_height", "Material1/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight1, Linear, 8, "", "_height", "Material1/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	float g_fSubstrateBurnishingRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	float g_fSubstrateBurnishingRoughnessBrightness2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	float g_fSubstrateBurnishingRoughnessBrightness3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	float g_fSubstrateBurnishingRoughnessBrightness4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Burnishing/33"); >;
	CreateInputTexture2D(TextureSubstrateMetalness1, Srgb, 8, "", "_metal", "Material1/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness1, Linear, 8, "", "_metal", "Material1/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax1 < Default(0); UiType(VectorText); UiGroup("Material1/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask1, Srgb, 8, "", "_mask", "Material1/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask1, Linear, 8, "", "_mask", "Material1/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy1 < UiType(Slider); UiGroup("Material1/Damage Bevel/41"); >;
	float2 g_vSubstrateBurnishingMinMax1 < Default(0); UiType(VectorText); UiGroup("Material1/Burnishing/41"); >;
	float g_fDamageBevelMetalness1 < UiType(Slider); UiGroup("Material1/Damage Bevel/50"); >;
	float g_fDamageBevelCloth1 < UiType(Slider); UiGroup("Material1/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate1 < UiType(CheckBox); UiGroup("Material1/Damage Bevel/80"); >;
	
	// Material2
	CreateInputTexture2D(TextureDamageHeight2, Linear, 8, "Inverse", "_height", "Material2/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureGrime2, Srgb, 8, "", "_color", "Material2/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo2, Srgb, 8, "", "_color", "Material2/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo2, Srgb, 8, "", "_color", "Material2/Surface Layer,1/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSubstrateTintMask2, Linear, 8, "", "_tintmask", "Material2/Substrate Layer/2", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceTintMask2, Linear, 8, "", "_tintmask", "Material2/Surface Layer/2", Default4(1, 1, 1, 0));
	float g_fDamageUvScale2 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material2/Damage Height/2"); >;
	float g_fGrimeUvScale2 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material2/Grime/2"); >;
	float g_fGrimeRoughnessBrightness2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material2/Grime/3"); >;
	float g_fGrimeTranslucency2 < Default(0.5); UiType(Slider); UiGroup("Material2/Grime/3"); >;
	float3 g_vSubstrateColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Substrate Layer/5"); >;
	float3 g_vSurfaceColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Surface Layer/5"); >;
	float g_fSubstrateColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Substrate Layer/6"); >;
	float g_fSurfaceColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Surface Layer/6"); >;
	float g_fSubstrateColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Substrate Layer/7"); >;
	float g_fSurfaceColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Surface Layer/7"); >;
	float g_fSubstrateColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Substrate Layer/8"); >;
	float g_fSurfaceColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Surface Layer/8"); >;
	float2 g_vSurfaceGrimeMinMax2 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material2/Grime/10"); >;
	float g_fDamageHeightBlendSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Damage Height/11"); Expression(max(this,.001)); >;
	float2 g_vSubstrateGrimeMinMax2 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material2/Grime/11"); >;
	float2 g_vDamageMinMax2 < Default(0); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material2/Damage Height/12"); >;
	float g_fBurnishingGrime2 < Default(0.5); UiType(Slider); UiGroup("Material2/Grime/20"); >;
	float3 g_vBurnishingColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Burnishing,5/20"); >;
	float3 g_vDamageBevelColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Damage Bevel,4/20"); >;
	float g_fBurnishingColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Burnishing/21"); >;
	float g_fDamageBevelColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Damage Bevel/21"); >;
	float g_fSubstrateCompositeColorTranslucency2 < Default(0.5); UiType(Slider); UiGroup("Material2/Substrate Layer/21"); UiVisibility(F_PATTERN || F_TINT_ID); >;
	float g_fBurnishingColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Burnishing/22"); >;
	float g_fDamageBevelColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Damage Bevel/22"); >;
	float g_fBurnishingColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Burnishing/23"); >;
	float g_fDamageBevelColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Damage Bevel/23"); >;
	bool g_bDamageBevelUseTintMask2 < UiType(CheckBox); UiGroup("Material2/Damage Bevel/24"); >;
	float g_fBurnishingCloth2 < UiType(Slider); UiGroup("Material2/Burnishing/25"); >;
	float g_fBurnishingMetalness2 < UiType(Slider); UiGroup("Material2/Burnishing/25"); >;
	CreateInputTexture2D(TextureSubstrateNormal2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Substrate Layer/30", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureSurfaceNormal2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Surface Layer/30", Default4(0.5, 0.5, 1, 0));
	float g_fBurnishingNormalScale2 < Default(1); UiType(Slider); UiGroup("Material2/Burnishing/30"); >;
	float g_fDamageBevelBlendSoftness2 < Default(0.5); UiType(Slider); UiGroup("Material2/Damage Bevel/30"); Expression(max(this+g_fDamageHeightBlendSoftness2,.001)); >;
	CreateInputTexture2D(TextureSubstrateRoughness2, Linear, 8, "Inverse", "_rough", "Material2/Substrate Layer/31", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceRoughness2, Linear, 8, "Inverse", "_rough", "Material2/Surface Layer/31", Default4(0.5, 0.5, 0.5, 0));
	float g_fDamageBevelEmboss2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Damage Bevel/31"); >;
	CreateInputTexture2D(TextureSubstrateAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Substrate Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Surface Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSubstrateHeight2, Linear, 8, "", "_height", "Material2/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight2, Linear, 8, "", "_height", "Material2/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateMetalness2, Srgb, 8, "", "_metal", "Material2/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness2, Linear, 8, "", "_metal", "Material2/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material2/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax2 < Default(0); UiType(VectorText); UiGroup("Material2/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask2, Srgb, 8, "", "_mask", "Material2/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask2, Linear, 8, "", "_mask", "Material2/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy2 < UiType(Slider); UiGroup("Material2/Damage Bevel/41"); >;
	float2 g_vSubstrateBurnishingMinMax2 < Default(0); UiType(VectorText); UiGroup("Material2/Burnishing/41"); >;
	float g_fDamageBevelMetalness2 < UiType(Slider); UiGroup("Material2/Damage Bevel/50"); >;
	float g_fDamageBevelCloth2 < UiType(Slider); UiGroup("Material2/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate2 < UiType(CheckBox); UiGroup("Material2/Damage Bevel/80"); >;
	
	// Material3
	CreateInputTexture2D(TextureDamageHeight3, Linear, 8, "Inverse", "_height", "Material3/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureGrime3, Srgb, 8, "", "_color", "Material3/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo3, Srgb, 8, "", "_color", "Material3/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo3, Srgb, 8, "", "_color", "Material3/Surface Layer,1/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSubstrateTintMask3, Linear, 8, "", "_tintmask", "Material3/Substrate Layer/2", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceTintMask3, Linear, 8, "", "_tintmask", "Material3/Surface Layer/2", Default4(1, 1, 1, 0));
	float g_fDamageUvScale3 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material3/Damage Height/2"); >;
	float g_fGrimeUvScale3 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material3/Grime/2"); >;
	float g_fGrimeRoughnessBrightness3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material3/Grime/3"); >;
	float g_fGrimeTranslucency3 < Default(0.5); UiType(Slider); UiGroup("Material3/Grime/3"); >;
	float3 g_vSubstrateColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Substrate Layer/5"); >;
	float3 g_vSurfaceColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Surface Layer/5"); >;
	float g_fSubstrateColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Substrate Layer/6"); >;
	float g_fSurfaceColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Surface Layer/6"); >;
	float g_fSubstrateColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Substrate Layer/7"); >;
	float g_fSurfaceColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Surface Layer/7"); >;
	float g_fSubstrateColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Substrate Layer/8"); >;
	float g_fSurfaceColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Surface Layer/8"); >;
	float2 g_vSurfaceGrimeMinMax3 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material3/Grime/10"); >;
	float g_fDamageHeightBlendSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Damage Height/11"); Expression(max(this,.001)); >;
	float2 g_vSubstrateGrimeMinMax3 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material3/Grime/11"); >;
	float2 g_vDamageMinMax3 < Default(0); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material3/Damage Height/12"); >;
	float g_fBurnishingGrime3 < Default(0.5); UiType(Slider); UiGroup("Material3/Grime/20"); >;
	float3 g_vBurnishingColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Burnishing,5/20"); >;
	float3 g_vDamageBevelColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Damage Bevel,4/20"); >;
	float g_fBurnishingColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Burnishing/21"); >;
	float g_fDamageBevelColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Damage Bevel/21"); >;
	float g_fSubstrateCompositeColorTranslucency3 < Default(0.5); UiType(Slider); UiGroup("Material3/Substrate Layer/21"); UiVisibility(F_PATTERN || F_TINT_ID); >;
	float g_fBurnishingColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Burnishing/22"); >;
	float g_fDamageBevelColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Damage Bevel/22"); >;
	float g_fBurnishingColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Burnishing/23"); >;
	float g_fDamageBevelColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Damage Bevel/23"); >;
	bool g_bDamageBevelUseTintMask3 < UiType(CheckBox); UiGroup("Material3/Damage Bevel/24"); >;
	float g_fBurnishingCloth3 < UiType(Slider); UiGroup("Material3/Burnishing/25"); >;
	float g_fBurnishingMetalness3 < UiType(Slider); UiGroup("Material3/Burnishing/25"); >;
	CreateInputTexture2D(TextureSubstrateNormal3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Substrate Layer/30", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureSurfaceNormal3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Surface Layer/30", Default4(0.5, 0.5, 1, 0));
	float g_fBurnishingNormalScale3 < Default(1); UiType(Slider); UiGroup("Material3/Burnishing/30"); >;
	float g_fDamageBevelBlendSoftness3 < Default(0.5); UiType(Slider); UiGroup("Material3/Damage Bevel/30"); Expression(max(this+g_fDamageHeightBlendSoftness3,.001)); >;
	CreateInputTexture2D(TextureSubstrateRoughness3, Linear, 8, "Inverse", "_rough", "Material3/Substrate Layer/31", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceRoughness3, Linear, 8, "Inverse", "_rough", "Material3/Surface Layer/31", Default4(0.5, 0.5, 0.5, 0));
	float g_fDamageBevelEmboss3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Damage Bevel/31"); >;
	CreateInputTexture2D(TextureSubstrateAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Substrate Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Surface Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSubstrateHeight3, Linear, 8, "", "_height", "Material3/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight3, Linear, 8, "", "_height", "Material3/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateMetalness3, Srgb, 8, "", "_metal", "Material3/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness3, Linear, 8, "", "_metal", "Material3/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material3/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax3 < Default(0); UiType(VectorText); UiGroup("Material3/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask3, Srgb, 8, "", "_mask", "Material3/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask3, Linear, 8, "", "_mask", "Material3/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy3 < UiType(Slider); UiGroup("Material3/Damage Bevel/41"); >;
	float2 g_vSubstrateBurnishingMinMax3 < Default(0); UiType(VectorText); UiGroup("Material3/Burnishing/41"); >;
	float g_fDamageBevelMetalness3 < UiType(Slider); UiGroup("Material3/Damage Bevel/50"); >;
	float g_fDamageBevelCloth3 < UiType(Slider); UiGroup("Material3/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate3 < UiType(CheckBox); UiGroup("Material3/Damage Bevel/80"); >;
	
	// Material4
	CreateInputTexture2D(TextureDamageHeight4, Linear, 8, "Inverse", "_height", "Material4/Damage Height,3/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureGrime4, Srgb, 8, "", "_color", "Material4/Grime,6/1", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateAlbedo4, Srgb, 8, "", "_color", "Material4/Substrate Layer,2/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAlbedo4, Srgb, 8, "", "_color", "Material4/Surface Layer/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSubstrateTintMask4, Linear, 8, "", "_tintmask", "Material4/Substrate Layer/2", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceTintMask4, Linear, 8, "", "_tintmask", "Material4/Surface Layer/2", Default4(1, 1, 1, 0));
	float g_fDamageUvScale4 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material4/Damage Height/2"); >;
	float g_fGrimeUvScale4 < Default(4); Range(-10, 10); UiType(Slider); UiGroup("Material4/Grime/2"); >;
	float g_fGrimeRoughnessBrightness4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material4/Grime/3"); >;
	float g_fGrimeTranslucency4 < Default(0.5); UiType(Slider); UiGroup("Material4/Grime/3"); >;
	float3 g_vSubstrateColorTint4 < Default3(1, 1, 1); UiType(Color); UiGroup("Material4/Substrate Layer/5"); >;
	float3 g_vSurfaceColorTint4 < Default3(1, 1, 1); UiType(Color); UiGroup("Material4/Surface Layer/5"); >;
	float g_fSubstrateColorContrast4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Substrate Layer/6"); >;
	float g_fSurfaceColorContrast4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Surface Layer/6"); >;
	float g_fSubstrateColorSaturation4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Substrate Layer/7"); >;
	float g_fSurfaceColorSaturation4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Surface Layer/7"); >;
	float g_fSubstrateColorBrightness4 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material4/Substrate Layer/8"); >;
	float g_fSurfaceColorBrightness4 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material4/Surface Layer/8"); >;
	float2 g_vSurfaceGrimeMinMax4 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material4/Grime/10"); >;
	float g_fDamageHeightBlendSoftness4 < Default(0.01); UiType(Slider); UiGroup("Material4/Damage Height/11"); Expression(max(this,.001)); >;
	float2 g_vSubstrateGrimeMinMax4 < Default(0); Range2(-1, -1, 2, 2); UiType(VectorText); UiGroup("Material4/Grime/11"); >;
	float2 g_vDamageMinMax4 < Default(0); Range2(0, 0, 2, 2); UiType(VectorText); UiGroup("Material4/Damage Height/12"); >;
	float g_fBurnishingGrime4 < Default(0.5); UiType(Slider); UiGroup("Material4/Grime/20"); >;
	float3 g_vBurnishingColorTint4 < Default3(1, 1, 1); UiType(Color); UiGroup("Material4/Burnishing,5/20"); >;
	float3 g_vDamageBevelColorTint4 < Default3(1, 1, 1); UiType(Color); UiGroup("Material4/Damage Bevel,4/20"); >;
	float g_fBurnishingColorContrast4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Burnishing/21"); >;
	float g_fDamageBevelColorContrast4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Damage Bevel/21"); >;
	float g_fSubstrateCompositeColorTranslucency4 < Default(0.5); UiType(Slider); UiGroup("Material4/Substrate Layer/21"); UiVisibility(F_PATTERN || F_TINT_ID); >;
	float g_fBurnishingColorSaturation4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Burnishing/22"); >;
	float g_fDamageBevelColorSaturation4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Damage Bevel/22"); >;
	float g_fBurnishingColorBrightness4 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material4/Burnishing/23"); >;
	float g_fDamageBevelColorBrightness4 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material4/Damage Bevel/23"); >;
	bool g_bDamageBevelUseTintMask4 < UiType(CheckBox); UiGroup("Material4/Damage Bevel/24"); >;
	float g_fBurnishingCloth4 < UiType(Slider); UiGroup("Material4/Burnishing/25"); >;
	float g_fBurnishingMetalness4 < UiType(Slider); UiGroup("Material4/Burnishing/25"); >;
	CreateInputTexture2D(TextureSubstrateNormal4, Linear, 8, "NormalizeNormals", "_normal", "Material4/Substrate Layer/30", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureSurfaceNormal4, Linear, 8, "NormalizeNormals", "_normal", "Material4/Surface Layer/30", Default4(0.5, 0.5, 1, 0));
	float g_fBurnishingNormalScale4 < Default(1); UiType(Slider); UiGroup("Material4/Burnishing/30"); >;
	float g_fDamageBevelBlendSoftness4 < Default(0.5); UiType(Slider); UiGroup("Material4/Damage Bevel/30"); Expression(max(this+g_fDamageHeightBlendSoftness4,.001)); >;
	CreateInputTexture2D(TextureSubstrateRoughness4, Linear, 8, "Inverse", "_rough", "Material4/Substrate Layer/31", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceRoughness4, Linear, 8, "Inverse", "_rough", "Material4/Surface Layer/31", Default4(0.5, 0.5, 0.5, 0));
	float g_fDamageBevelEmboss4 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material4/Damage Bevel/31"); >;
	CreateInputTexture2D(TextureSubstrateAmbientOcclusion4, Linear, 8, "", "_ao", "Material4/Substrate Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSurfaceAmbientOcclusion4, Linear, 8, "", "_ao", "Material4/Surface Layer/32", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureSubstrateHeight4, Linear, 8, "", "_height", "Material4/Substrate Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSurfaceHeight4, Linear, 8, "", "_height", "Material4/Surface Layer/33", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureSubstrateMetalness4, Srgb, 8, "", "_metal", "Material4/Substrate Layer/40", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureSurfaceMetalness4, Linear, 8, "", "_metal", "Material4/Surface Layer/40", Default4(0, 0, 0, 0));
	float g_fDamageBevelRoughnessBrightness4 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material4/Damage Bevel/40"); >;
	float2 g_vSurfaceBurnishingMinMax4 < Default(0); UiType(VectorText); UiGroup("Material4/Burnishing/40"); >;
	CreateInputTexture2D(TextureSubstrateClothMask4, Srgb, 8, "", "_mask", "Material4/Substrate Layer/41", "materials/default/default_black_mask.tga");
	CreateInputTexture2D(TextureSurfaceClothMask4, Linear, 8, "", "_mask", "Material4/Surface Layer/41", "materials/default/default_black_mask.tga");
	float g_fDamageBevelAnisotropy4 < UiType(Slider); UiGroup("Material4/Damage Bevel/41"); >;
	float2 g_vSubstrateBurnishingMinMax4 < Default(0); UiType(VectorText); UiGroup("Material4/Burnishing/41"); >;
	float g_fDamageBevelMetalness4 < UiType(Slider); UiGroup("Material4/Damage Bevel/50"); >;
	float g_fDamageBevelCloth4 < UiType(Slider); UiGroup("Material4/Damage Bevel/60"); >;
	bool g_bDamageBevelBlendToSubstrate4 < UiType(CheckBox); UiGroup("Material4/Damage Bevel/80"); >;
	
	// Composite Inputs
	CreateInputTexture2D(TextureObjectNormal, Linear, 8, "", "_normal", "Composite Inputs,0/Object Textures,1/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TexturePatternColor, Srgb, 8, "", "_color", "Composite Inputs/Pattern,200/0", Default4(0, 0, 0, 1));
	float g_fWearProgress < UiType(Slider); UiGroup("Composite Inputs/Wear/0"); Expression(SrgbLinearToGamma(this)); >;
	CreateInputTexture2D(TextureObjectAmbientOcclusion, Linear, 8, "", "_ao", "Composite Inputs/Object Textures/1", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureObjectTintId, Linear, 8, "", "_tintid", "Composite Inputs/Tint by ID,100/1", Default4(0, 0, 0, 1));
	CreateInputTexture2D(TextureObjectCurvature, Linear, 8, "", "_curvature", "Composite Inputs/Object Textures/2", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureObjectHighTouchMask, Linear, 8, "", "_mask", "Composite Inputs/Object Textures/3", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureObjectMaterialId, Linear, 8, "", "_materialid", "Composite Inputs/Object Textures/5", Default4(0, 0, 0, 1));
	CreateInputTexture2D(TexturePatternTranslucency, Linear, 8, "", "_trans", "Composite Inputs/Pattern,200/10", Default4(1, 1, 1, 1));
	float g_fPatternTranslucencyThreshold < Default(0.01); UiType(Slider); UiGroup("Composite Inputs/Pattern/11"); UiVisibility(F_PUFFY_PAINT); >;
	float4 g_vId1Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/11"); Expression(SrgbGammaToLinear(this)); >;
	bool g_fPatternPaintRespectsTintMask < UiType(CheckBox); UiGroup("Composite Inputs/Pattern/12"); UiVisibility(F_PATTERN && !F_PUFFY_PAINT); >;
	float g_flSheenScale < Default(0.667); Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/Lighting,1000/12"); UiVisibility(1); >;
	float4 g_vId2Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/12"); Expression(SrgbGammaToLinear(this)); >;
	float4 g_vId3Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/13"); Expression(SrgbGammaToLinear(this)); >;
	float4 g_vId4Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/14"); Expression(SrgbGammaToLinear(this)); >;
	float4 g_vId5Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/15"); Expression(SrgbGammaToLinear(this)); >;
	float4 g_vId6Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/16"); Expression(SrgbGammaToLinear(this)); >;
	float4 g_vId7Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/17"); Expression(SrgbGammaToLinear(this)); >;
	float4 g_vId8Color < Default4(1, 1, 1, 1); UiType(Color); UiGroup("Composite Inputs/Tint by ID/18"); Expression(SrgbGammaToLinear(this)); >;
	CreateInputTexture2D(TexturePatternMetalness, Linear, 8, "", "_metal", "Composite Inputs/Pattern/20", Default4(0, 0, 0, 1));
	float g_fPatternEmboss < Default(0.5); Range(-4, 4); UiType(Slider); UiGroup("Composite Inputs/Pattern/30"); UiVisibility(F_PUFFY_PAINT); >;
	float g_fPuffyPaintNormalSoftness < Range(0, 10); UiType(Slider); UiGroup("Composite Inputs/Pattern/31"); UiVisibility(F_PUFFY_PAINT); >;
	float2 g_vPatternRoughnessContrastBrightness < Default(1); Range2(0, -0.5, 2, 0.5); UiType(VectorText); UiGroup("Composite Inputs/Pattern/84"); UiVisibility(F_PATTERN && F_PATTERN_PAINT==0); >;
	CreateInputTexture2D(TexturePatternRoughness, Linear, 8, "", "_rough", "Composite Inputs/Pattern/85", Default4(0.5, 0.5, 0.5, 1));
	float g_fPatternCloth < UiType(Slider); UiGroup("Composite Inputs/Pattern/88"); UiVisibility(F_PATTERN && F_PATTERN_PAINT==1); >;
	float g_fSubstratePatternMipBias < Range(0, 8); UiType(Slider); UiGroup("Composite Inputs/Pattern/88"); UiVisibility(F_PATTERN && !F_PATTERN_PAINT); >;
	bool g_bId1Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/101"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId2Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/102"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId3Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/103"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId4Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/104"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId5Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/105"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId6Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/106"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId7Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/107"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	bool g_bId8Pattern < Default(1); UiType(CheckBox); UiGroup("Composite Inputs/Pattern/108"); UiVisibility(F_PATTERN && F_TINT_ID); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// Variant parameters
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 5 (name: g_mSurfaceColorAdjust1) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _2872
	{
	    vec4 _m0[3];
	};
	
	struct _71
	{
	    vec4 _m0[4];
	};
	
	struct _1677
	{
	    mat4x3 _m0;
	    vec3 _m1;
	    uint _m2;
	    vec3 _m3;
	    vec4 _m4;
	    vec3 _m5;
	    vec4 _m6;
	};
	
	struct _193
	{
	    _1677 _m0[128];
	};
	
	struct _2139
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
	
	float _3;
	float _4;
	vec3 _5;
	vec4 _6;
	
	struct _285
	{
	    int g_bClothShading;
	    int g_bPattern;
	    float g_flSheenScale;
	    int g_bFogEnabled;
	    float g_flReflectance;
	    mat4 g_mSurfaceColorAdjust1;
	    mat4 g_mSubstrateColorAdjust1;
	    float g_fSubstrateCompositeColorTranslucency1;
	    float g_fDamageUvScale1;
	    float g_fDamageHeightBlendSoftness1;
	    vec2 g_vDamageMinMax1;
	    int g_bDamageBevelUseTintMask1;
	    mat4 g_mDamageColorAdjust1;
	    float g_fDamageBevelBlendSoftness1;
	    float g_fDamageBevelEmboss1;
	    float g_fDamageBevelRoughnessBrightness1;
	    float g_fDamageBevelAnisotropy1;
	    float g_fDamageBevelMetalness1;
	    float g_fDamageBevelCloth1;
	    int g_bDamageBevelBlendToSubstrate1;
	    float g_fBurnishingMetalness1;
	    float g_fBurnishingCloth1;
	    mat4 g_mSurfaceBurnishingColorAdjust1;
	    mat4 g_mSubstrateBurnishingColorAdjust1;
	    float g_fBurnishingNormalScale1;
	    float g_fSurfaceBurnishingRoughnessBrightness1;
	    float g_fSubstrateBurnishingRoughnessBrightness1;
	    vec2 g_vSurfaceBurnishingMinMax1;
	    vec2 g_vSubstrateBurnishingMinMax1;
	    float g_fGrimeUvScale1;
	    float g_fGrimeTranslucency1;
	    float g_fGrimeRoughnessBrightness1;
	    vec2 g_vSurfaceGrimeMinMax1;
	    vec2 g_vSubstrateGrimeMinMax1;
	    float g_fBurnishingGrime1;
	    mat4 g_mSurfaceColorAdjust2;
	    mat4 g_mSubstrateColorAdjust2;
	    float g_fSubstrateCompositeColorTranslucency2;
	    float g_fDamageUvScale2;
	    float g_fDamageHeightBlendSoftness2;
	    vec2 g_vDamageMinMax2;
	    int g_bDamageBevelUseTintMask2;
	    mat4 g_mDamageColorAdjust2;
	    float g_fDamageBevelBlendSoftness2;
	    float g_fDamageBevelEmboss2;
	    float g_fDamageBevelRoughnessBrightness2;
	    float g_fDamageBevelAnisotropy2;
	    float g_fDamageBevelMetalness2;
	    float g_fDamageBevelCloth2;
	    int g_bDamageBevelBlendToSubstrate2;
	    float g_fBurnishingMetalness2;
	    float g_fBurnishingCloth2;
	    mat4 g_mSurfaceBurnishingColorAdjust2;
	    mat4 g_mSubstrateBurnishingColorAdjust2;
	    float g_fBurnishingNormalScale2;
	    float g_fSurfaceBurnishingRoughnessBrightness2;
	    float g_fSubstrateBurnishingRoughnessBrightness2;
	    vec2 g_vSurfaceBurnishingMinMax2;
	    vec2 g_vSubstrateBurnishingMinMax2;
	    float g_fGrimeUvScale2;
	    float g_fGrimeTranslucency2;
	    float g_fGrimeRoughnessBrightness2;
	    vec2 g_vSurfaceGrimeMinMax2;
	    vec2 g_vSubstrateGrimeMinMax2;
	    float g_fBurnishingGrime2;
	    mat4 g_mSurfaceColorAdjust3;
	    mat4 g_mSubstrateColorAdjust3;
	    float g_fSubstrateCompositeColorTranslucency3;
	    float g_fDamageUvScale3;
	    float g_fDamageHeightBlendSoftness3;
	    vec2 g_vDamageMinMax3;
	    int g_bDamageBevelUseTintMask3;
	    mat4 g_mDamageColorAdjust3;
	    float g_fDamageBevelBlendSoftness3;
	    float g_fDamageBevelEmboss3;
	    float g_fDamageBevelRoughnessBrightness3;
	    float g_fDamageBevelAnisotropy3;
	    float g_fDamageBevelMetalness3;
	    float g_fDamageBevelCloth3;
	    int g_bDamageBevelBlendToSubstrate3;
	    float g_fBurnishingMetalness3;
	    float g_fBurnishingCloth3;
	    mat4 g_mSurfaceBurnishingColorAdjust3;
	    mat4 g_mSubstrateBurnishingColorAdjust3;
	    float g_fBurnishingNormalScale3;
	    float g_fSurfaceBurnishingRoughnessBrightness3;
	    float g_fSubstrateBurnishingRoughnessBrightness3;
	    vec2 g_vSurfaceBurnishingMinMax3;
	    vec2 g_vSubstrateBurnishingMinMax3;
	    float g_fGrimeUvScale3;
	    float g_fGrimeTranslucency3;
	    float g_fGrimeRoughnessBrightness3;
	    vec2 g_vSurfaceGrimeMinMax3;
	    vec2 g_vSubstrateGrimeMinMax3;
	    float g_fBurnishingGrime3;
	    mat4 g_mSurfaceColorAdjust4;
	    mat4 g_mSubstrateColorAdjust4;
	    float g_fSubstrateCompositeColorTranslucency4;
	    float g_fDamageUvScale4;
	    float g_fDamageHeightBlendSoftness4;
	    vec2 g_vDamageMinMax4;
	    int g_bDamageBevelUseTintMask4;
	    mat4 g_mDamageColorAdjust4;
	    float g_fDamageBevelBlendSoftness4;
	    float g_fDamageBevelEmboss4;
	    float g_fDamageBevelRoughnessBrightness4;
	    float g_fDamageBevelAnisotropy4;
	    float g_fDamageBevelMetalness4;
	    float g_fDamageBevelCloth4;
	    int g_bDamageBevelBlendToSubstrate4;
	    float g_fBurnishingMetalness4;
	    float g_fBurnishingCloth4;
	    mat4 g_mSurfaceBurnishingColorAdjust4;
	    mat4 g_mSubstrateBurnishingColorAdjust4;
	    float g_fBurnishingNormalScale4;
	    float g_fSurfaceBurnishingRoughnessBrightness4;
	    float g_fSubstrateBurnishingRoughnessBrightness4;
	    vec2 g_vSurfaceBurnishingMinMax4;
	    vec2 g_vSubstrateBurnishingMinMax4;
	    float g_fGrimeUvScale4;
	    float g_fGrimeTranslucency4;
	    float g_fGrimeRoughnessBrightness4;
	    vec2 g_vSurfaceGrimeMinMax4;
	    vec2 g_vSubstrateGrimeMinMax4;
	    float g_fBurnishingGrime4;
	    int g_bPatternPaintLayer;
	    int g_bPatternPaintEmboss;
	    float g_fPatternTranslucencyThreshold;
	    int g_fPatternPaintRespectsTintMask;
	    float g_fPatternCloth;
	    float g_fPatternEmboss;
	    float g_fPuffyPaintNormalSoftness;
	    vec2 g_vPatternRoughnessContrastBrightness;
	    float g_fSubstratePatternMipBias;
	    float g_fWearProgress;
	};
	
	layout(set = 1) uniform _285 _Globals_;
	
	struct _2806
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    ivec4 _m3;
	    mat4 _m4;
	    vec2 _m5;
	    float _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    vec4 _m11;
	    vec4 _m12;
	    mat4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	    vec4 _m16;
	};
	
	layout(set = 1) uniform _2806 PerViewConstantBufferCsgo_t;
	
	struct _854
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    _2872 _m5;
	    _71 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    uvec4 _m10;
	    uvec4 _m11;
	    uvec4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	    _193 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    int _m18;
	    float _m19;
	    vec4 _m20;
	    float _m21;
	    float _m22;
	    float _m23;
	    float _m24;
	    _2139 _m25;
	    _71 _m26;
	};
	
	layout(set = 3) uniform _854 PerViewLightingConstantBufferGpu_t;
	
	struct _1194
	{
	    vec2 _m0;
	    vec2 _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 1) uniform _1194 PerViewConstantBuffer_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 85) uniform texture2D g_tLayerId;
	layout(set = 1, binding = 16) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 52) uniform texture2D g_tSurfaceNormal1;
	layout(set = 1, binding = 55) uniform texture2D g_tSubstrateNormal1;
	layout(set = 1, binding = 60) uniform texture2D g_tSurfaceNormal2;
	layout(set = 1, binding = 63) uniform texture2D g_tSubstrateNormal2;
	layout(set = 1, binding = 68) uniform texture2D g_tSurfaceNormal3;
	layout(set = 1, binding = 71) uniform texture2D g_tSubstrateNormal3;
	layout(set = 1, binding = 76) uniform texture2D g_tSurfaceNormal4;
	layout(set = 1, binding = 79) uniform texture2D g_tSubstrateNormal4;
	layout(set = 1, binding = 86) uniform texture2D g_tPattern;
	layout(set = 1, binding = 87) uniform texture2D g_tPatternProperties;
	layout(set = 1, binding = 51) uniform texture2D g_tSurface1;
	layout(set = 1, binding = 53) uniform texture2D g_tSurfaceProperties1;
	layout(set = 1, binding = 54) uniform texture2D g_tSubstrate1;
	layout(set = 1, binding = 56) uniform texture2D g_tSubstrateProperties1;
	layout(set = 1, binding = 57) uniform texture2D g_tDamage1;
	layout(set = 1, binding = 58) uniform texture2D g_tGrime1;
	layout(set = 1, binding = 59) uniform texture2D g_tSurface2;
	layout(set = 1, binding = 61) uniform texture2D g_tSurfaceProperties2;
	layout(set = 1, binding = 62) uniform texture2D g_tSubstrate2;
	layout(set = 1, binding = 64) uniform texture2D g_tSubstrateProperties2;
	layout(set = 1, binding = 65) uniform texture2D g_tDamage2;
	layout(set = 1, binding = 66) uniform texture2D g_tGrime2;
	layout(set = 1, binding = 67) uniform texture2D g_tSurface3;
	layout(set = 1, binding = 69) uniform texture2D g_tSurfaceProperties3;
	layout(set = 1, binding = 70) uniform texture2D g_tSubstrate3;
	layout(set = 1, binding = 72) uniform texture2D g_tSubstrateProperties3;
	layout(set = 1, binding = 73) uniform texture2D g_tDamage3;
	layout(set = 1, binding = 74) uniform texture2D g_tGrime3;
	layout(set = 1, binding = 75) uniform texture2D g_tSurface4;
	layout(set = 1, binding = 77) uniform texture2D g_tSurfaceProperties4;
	layout(set = 1, binding = 78) uniform texture2D g_tSubstrate4;
	layout(set = 1, binding = 80) uniform texture2D g_tSubstrateProperties4;
	layout(set = 1, binding = 81) uniform texture2D g_tDamage4;
	layout(set = 1, binding = 82) uniform texture2D g_tGrime4;
	layout(set = 1, binding = 84) uniform texture2D g_tObjectProperties;
	layout(set = 1, binding = 14) uniform sampler g_sAniso;
	layout(set = 1, binding = 83) uniform texture2D g_tNormal;
	layout(set = 1, binding = 38) uniform texture2D g_tDynamicAmbientOcclusionDepth;
	layout(set = 1, binding = 22) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 37) uniform texture2D g_tDynamicAmbientOcclusion;
	layout(set = 1, binding = 18) uniform sampler g_sPointClamp;
	layout(set = 1, binding = 39) uniform texture2D g_tSsao;
	layout(set = 1, binding = 19) uniform sampler g_sUserConfig;
	layout(set = 1, binding = 23) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 49) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 40) uniform textureCubeArray g_tEnvironmentMap;
	layout(set = 1, binding = 15) uniform sampler g_sBilinearClamp;
	layout(set = 1, binding = 35) uniform texture2DArray g_tBRDFLookup;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in vec4 input_2;
	layout(location = 3) centroid in vec4 input_3;
	layout(location = 4) centroid in vec3 input_4;
	layout(location = 5) in vec4 input_5;
	layout(location = 7) in vec4 input_7;
	layout(location = 8) in vec4 input_8;
	layout(location = 9) in vec4 input_9;
	layout(location = 10) in vec4 input_10;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    float _6864 = 1.0 / _11408.w;
	    vec4 _18180 = _11408;
	    _18180.w = _6864;
	    vec3 _21709;
	    if (dot(input_1.xyz, input_1.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_4.xyz;
	    }
	    else
	    {
	        _21709 = input_1.xyz;
	    }
	    vec3 _20700 = normalize(_21709);
	    vec3 _12292 = input_0 + PerViewConstantBufferCsgo_t._m16.xyz;
	    vec3 _19396 = input_1.xyz * 1.0;
	    vec3 _14435 = cross(_19396.xyz, input_5.xyz) * ((input_5.w > 0.0) ? 1.0 : (-1.0));
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m3, ivec4(0));
	    bool _20058 = _24464.w;
	    vec3 _20826;
	    if (_20058)
	    {
	        _20826 = -_14435;
	    }
	    else
	    {
	        _20826 = _14435;
	    }
	    vec3 _24090 = _19396.xyz;
	    vec4 _19372 = texture(sampler2D(g_tLayerId, g_sTrilinearWrap), input_2.xy);
	    float _15088 = _19372.x;
	    float _12846 = (_19372.z + _19372.y) + _15088;
	    float _12687 = max(0.0, 1.0 - _12846);
	    vec4 _20009 = vec4(_15088, _19372.yz, _12687) / vec4(_12846 + _12687);
	    float _7021 = dFdxFine(input_8.x);
	    float _14684 = dFdxFine(input_8.y);
	    vec2 _7272 = vec2(_7021, _14684);
	    float _19730 = dFdyFine(input_8.x);
	    float _11417 = dFdyFine(input_8.y);
	    vec2 _24870 = vec2(_19730, _11417);
	    float _12659 = dFdxFine(input_8.z);
	    float _14685 = dFdxFine(input_8.w);
	    vec2 _7273 = vec2(_12659, _14685);
	    float _19731 = dFdyFine(input_8.z);
	    float _11418 = dFdyFine(input_8.w);
	    vec2 _24871 = vec2(_19731, _11418);
	    float _12660 = dFdxFine(input_9.x);
	    float _14686 = dFdxFine(input_9.y);
	    vec2 _7274 = vec2(_12660, _14686);
	    float _19732 = dFdyFine(input_9.x);
	    float _11419 = dFdyFine(input_9.y);
	    vec2 _24872 = vec2(_19732, _11419);
	    float _12661 = dFdxFine(input_9.z);
	    float _14687 = dFdxFine(input_9.w);
	    vec2 _7275 = vec2(_12661, _14687);
	    float _19733 = dFdyFine(input_9.z);
	    float _11420 = dFdyFine(input_9.w);
	    vec2 _24414 = vec2(_19733, _11420);
	    float _9306 = _20009.x;
	    bool _9694 = _9306 > 0.0;
	    vec4 _6223;
	    vec2 _13136;
	    vec4 _13189;
	    if (_9694)
	    {
	        _13136 = textureGrad(sampler2D(g_tSurfaceNormal1, g_sTrilinearWrap), input_8.xy, (_7272 * _Globals_.g_fPuffyPaintNormalSoftness).xy, (_24870 * _Globals_.g_fPuffyPaintNormalSoftness).xy).wy * _9306;
	        _13189 = textureGrad(sampler2D(g_tSubstrateNormal1, g_sTrilinearWrap), input_8.xy, _7272, _24870).xyzw * _9306;
	        _6223 = textureGrad(sampler2D(g_tSurfaceNormal1, g_sTrilinearWrap), input_8.xy, _7272, _24870).xyzw * _9306;
	    }
	    else
	    {
	        _13136 = vec2(0.0);
	        _13189 = vec4(0.0);
	        _6223 = vec4(0.0);
	    }
	    float _23427 = _20009.y;
	    bool _17155 = _23427 > 0.0;
	    vec4 _6224;
	    vec2 _13137;
	    vec4 _13190;
	    if (_17155)
	    {
	        _13137 = _13136.xy + (textureGrad(sampler2D(g_tSurfaceNormal2, g_sTrilinearWrap), input_8.zw, (_7273 * _Globals_.g_fPuffyPaintNormalSoftness).xy, (_24871 * _Globals_.g_fPuffyPaintNormalSoftness).xy).wy * _23427);
	        _13190 = _13189.xyzw + (textureGrad(sampler2D(g_tSubstrateNormal2, g_sTrilinearWrap), input_8.zw, _7273, _24871).xyzw * _23427);
	        _6224 = _6223.xyzw + (textureGrad(sampler2D(g_tSurfaceNormal2, g_sTrilinearWrap), input_8.zw, _7273, _24871).xyzw * _23427);
	    }
	    else
	    {
	        _13137 = _13136;
	        _13190 = _13189;
	        _6224 = _6223;
	    }
	    float _23428 = _20009.z;
	    bool _17156 = _23428 > 0.0;
	    vec4 _6225;
	    vec2 _13138;
	    vec4 _13191;
	    if (_17156)
	    {
	        _13138 = _13137.xy + (textureGrad(sampler2D(g_tSurfaceNormal3, g_sTrilinearWrap), input_9.xy, (_7274 * _Globals_.g_fPuffyPaintNormalSoftness).xy, (_24872 * _Globals_.g_fPuffyPaintNormalSoftness).xy).wy * _23428);
	        _13191 = _13190.xyzw + (textureGrad(sampler2D(g_tSubstrateNormal3, g_sTrilinearWrap), input_9.xy, _7274, _24872).xyzw * _23428);
	        _6225 = _6224.xyzw + (textureGrad(sampler2D(g_tSurfaceNormal3, g_sTrilinearWrap), input_9.xy, _7274, _24872).xyzw * _23428);
	    }
	    else
	    {
	        _13138 = _13137;
	        _13191 = _13190;
	        _6225 = _6224;
	    }
	    float _23429 = _20009.w;
	    bool _17157 = _23429 > 0.0;
	    vec2 _13139;
	    vec4 _13192;
	    vec4 _23299;
	    if (_17157)
	    {
	        _13139 = _13138.xy + (textureGrad(sampler2D(g_tSurfaceNormal4, g_sTrilinearWrap), input_9.zw, (_7275 * _Globals_.g_fPuffyPaintNormalSoftness).xy, (_24414 * _Globals_.g_fPuffyPaintNormalSoftness).xy).wy * _23429);
	        _13192 = _13191.xyzw + (textureGrad(sampler2D(g_tSubstrateNormal4, g_sTrilinearWrap), input_9.zw, _7275, _24414).xyzw * _23429);
	        _23299 = _6225.xyzw + (textureGrad(sampler2D(g_tSurfaceNormal4, g_sTrilinearWrap), input_9.zw, _7275, _24414).xyzw * _23429);
	    }
	    else
	    {
	        _13139 = _13138;
	        _13192 = _13191;
	        _23299 = _6225;
	    }
	    vec2 _23430;
	    float _16783 = (_23299.w + _23299.y) - 1.00392162799835205078125;
	    float _11176 = _23299.w - _23299.y;
	    vec3 _14854 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	    float _16784 = (_13192.w + _13192.y) - 1.00392162799835205078125;
	    float _11177 = _13192.w - _13192.y;
	    float _16785 = (_13139.x + _13139.y) - 1.00392162799835205078125;
	    float _11178 = _13139.x - _13139.y;
	    vec3 _13150;
	    float _13998;
	    vec3 _16317;
	    float _17335;
	    float _17336;
	    float _17337;
	    float _17338;
	    vec3 _17339;
	    vec2 _17340;
	    vec2 _17342;
	    vec2 _17343;
	    vec3 _17344;
	    vec3 _17345;
	    float _17346;
	    float _17347;
	    float _17354;
	    float _17355;
	    vec2 _17356;
	    vec2 _17357;
	    vec3 _17358;
	    vec3 _17359;
	    float _17360;
	    float _17361;
	    vec2 _17362;
	    vec4 _17363;
	    vec2 _17364;
	    float _17365;
	    float _17366;
	    float _17367;
	    float _17368;
	    float _17369;
	    float _17370;
	    float _17371;
	    float _17372;
	    float _17373;
	    float _17374;
	    float _23300;
	    do
	    {
	        vec2 _25090 = (input_7.xy - (input_7.zw * _14854.xy)).xy;
	        vec4 _22452 = texture(sampler2D(g_tPattern, g_sTrilinearWrap), _25090);
	        vec4 _20706 = texture(sampler2D(g_tPatternProperties, g_sTrilinearWrap), _25090);
	        _23430 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xy;
	        vec4 _19373 = texture(sampler2D(g_tPattern, g_sTrilinearWrap), (input_7.xy - (input_7.zw * _23430)).xy, _Globals_.g_fSubstratePatternMipBias);
	        float _24623 = _22452.w;
	        bool _14874 = _Globals_.g_bPatternPaintEmboss != 0;
	        float _9716;
	        vec4 _24878;
	        if (_14874)
	        {
	            vec4 _9250 = _22452;
	            _9250.w = smoothstep(_Globals_.g_fPatternTranslucencyThreshold, _Globals_.g_fPatternTranslucencyThreshold + 0.039999999105930328369140625, _24623);
	            _9716 = saturate((_24623 * (1.0 + _Globals_.g_fPatternTranslucencyThreshold)) - _Globals_.g_fPatternTranslucencyThreshold);
	            _24878 = _9250;
	        }
	        else
	        {
	            _9716 = _24623;
	            _24878 = _22452;
	        }
	        bool _14875 = _Globals_.g_bPattern != 0;
	        bool _12887;
	        if (_14875)
	        {
	            _12887 = _Globals_.g_bPatternPaintLayer == 0;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        float _6536;
	        vec3 _7078;
	        float _8530;
	        float _8531;
	        vec2 _9596;
	        vec3 _10658;
	        vec3 _12900;
	        float _13559;
	        vec3 _14273;
	        bool _14876;
	        float _16297;
	        float _16973;
	        vec3 _18503;
	        float _22892;
	        float _22893;
	        vec3 _23992;
	        vec2 _13143;
	        vec2 _16308;
	        vec2 _17190;
	        vec2 _17191;
	        float _17192;
	        vec4 _17193;
	        vec2 _17194;
	        float _17195;
	        float _17196;
	        float _17197;
	        float _17198;
	        float _17199;
	        float _17200;
	        float _17201;
	        float _17202;
	        float _17203;
	        float _17204;
	        float _17205;
	        float _17206;
	        float _17209;
	        float _21710;
	        SPIRV_CROSS_BRANCH
	        if (_12887)
	        {
	            float _10902 = _19373.w;
	            vec3 _19714 = mix(vec3(1.0), _19373.xyz, vec3(max(1.0, _10902) * _24878.w));
	            float _14750 = max(0.0, _10902 * _24878.w);
	            vec4 _11729 = vec4(_19714, _14750);
	            vec3 _14905 = mix(vec3(1.0), _24878.xyz, vec3(_24878.w));
	            float _14615 = max(0.0, _24878.w * _24878.w);
	            float _22280 = _14905.x;
	            float _17341 = _14905.y;
	            float _24875 = _14905.z;
	            vec4 _10562 = vec4(_22280, _17341, _24875, _14615);
	            float _7259 = dFdxFine(input_8.x);
	            float _18737 = dFdxFine(input_8.y);
	            float _12361 = dFdyFine(input_8.x);
	            float _12285 = dFdyFine(input_8.y);
	            float _18075 = dFdxFine(input_8.z);
	            float _24608 = dFdxFine(input_8.w);
	            float _12371 = dFdyFine(input_8.z);
	            float _12286 = dFdyFine(input_8.w);
	            float _18076 = dFdxFine(input_9.x);
	            float _24609 = dFdxFine(input_9.y);
	            float _12372 = dFdyFine(input_9.x);
	            float _12287 = dFdyFine(input_9.y);
	            float _18077 = dFdxFine(input_9.z);
	            float _24610 = dFdxFine(input_9.w);
	            float _9870 = dFdyFine(input_9.z);
	            float _13125 = dFdyFine(input_9.w);
	            vec2 _13400 = input_10.xy * _Globals_.g_fDamageUvScale1;
	            vec2 _13401 = input_10.xy * _Globals_.g_fDamageUvScale2;
	            vec2 _13402 = input_10.xy * _Globals_.g_fDamageUvScale3;
	            vec2 _13437 = input_10.xy * _Globals_.g_fDamageUvScale4;
	            float _12000 = _13400.x;
	            float _23922 = dFdxFine(_12000);
	            float _18331 = _13400.y;
	            float _11100 = dFdxFine(_18331);
	            float _12115 = dFdyFine(_12000);
	            float _15534 = dFdyFine(_18331);
	            float _10986 = _13401.x;
	            float _12077 = dFdxFine(_10986);
	            float _18332 = _13401.y;
	            float _11101 = dFdxFine(_18332);
	            float _12116 = dFdyFine(_10986);
	            float _15535 = dFdyFine(_18332);
	            float _10987 = _13402.x;
	            float _12078 = dFdxFine(_10987);
	            float _18333 = _13402.y;
	            float _11102 = dFdxFine(_18333);
	            float _12117 = dFdyFine(_10987);
	            float _15536 = dFdyFine(_18333);
	            float _10988 = _13437.x;
	            float _12079 = dFdxFine(_10988);
	            float _18334 = _13437.y;
	            float _11103 = dFdxFine(_18334);
	            float _12080 = dFdyFine(_10988);
	            float _13126 = dFdyFine(_18334);
	            vec2 _13403 = input_10.zw * _Globals_.g_fGrimeUvScale1;
	            vec2 _13404 = input_10.zw * _Globals_.g_fGrimeUvScale2;
	            vec2 _13405 = input_10.zw * _Globals_.g_fGrimeUvScale3;
	            vec2 _13438 = input_10.zw * _Globals_.g_fGrimeUvScale4;
	            float _12001 = _13403.x;
	            float _23923 = dFdxFine(_12001);
	            float _18335 = _13403.y;
	            float _11104 = dFdxFine(_18335);
	            float _12118 = dFdyFine(_12001);
	            float _15537 = dFdyFine(_18335);
	            float _10989 = _13404.x;
	            float _12081 = dFdxFine(_10989);
	            float _18336 = _13404.y;
	            float _11105 = dFdxFine(_18336);
	            float _12119 = dFdyFine(_10989);
	            float _15538 = dFdyFine(_18336);
	            float _10990 = _13405.x;
	            float _12082 = dFdxFine(_10990);
	            float _18337 = _13405.y;
	            float _11106 = dFdxFine(_18337);
	            float _12120 = dFdyFine(_10990);
	            float _15539 = dFdyFine(_18337);
	            float _10991 = _13438.x;
	            float _12083 = dFdxFine(_10991);
	            float _18338 = _13438.y;
	            float _11107 = dFdxFine(_18338);
	            float _15264 = dFdyFine(_10991);
	            float _6642 = dFdyFine(_18338);
	            float _13144;
	            float _16309;
	            vec2 _16866;
	            float _17213;
	            bool _17214;
	            float _17215;
	            float _17216;
	            float _17217;
	            float _17218;
	            float _17219;
	            float _17220;
	            float _17221;
	            float _17222;
	            float _17225;
	            float _17226;
	            float _17227;
	            float _17228;
	            vec2 _17229;
	            vec2 _17230;
	            vec2 _17231;
	            vec2 _17232;
	            float _17233;
	            vec4 _17234;
	            float _17235;
	            vec4 _17236;
	            vec4 _17237;
	            vec4 _17238;
	            vec4 _17239;
	            if (_9694)
	            {
	                vec2 _6262 = vec2(_7259, _18737);
	                vec2 _19542 = vec2(_12361, _12285);
	                _13144 = _Globals_.g_fBurnishingNormalScale1 * _9306;
	                _16309 = _Globals_.g_fSurfaceBurnishingRoughnessBrightness1 * _9306;
	                _17213 = _Globals_.g_fSubstrateBurnishingRoughnessBrightness1 * _9306;
	                _17214 = _Globals_.g_bDamageBevelUseTintMask1 != 0;
	                _17215 = _Globals_.g_fDamageBevelEmboss1 * _9306;
	                _17216 = _Globals_.g_fDamageHeightBlendSoftness1 * _9306;
	                _17217 = _Globals_.g_fDamageBevelBlendSoftness1 * _9306;
	                _17218 = _Globals_.g_fBurnishingGrime1 * _9306;
	                _17219 = _Globals_.g_fGrimeRoughnessBrightness1 * _9306;
	                _17220 = _Globals_.g_fBurnishingCloth1 * _9306;
	                _17221 = _Globals_.g_fBurnishingMetalness1 * _9306;
	                _17222 = float(_Globals_.g_bDamageBevelBlendToSubstrate1 != 0) * _9306;
	                _17225 = _Globals_.g_fDamageBevelCloth1 * _9306;
	                _17226 = _Globals_.g_fDamageBevelMetalness1 * _9306;
	                _17227 = _Globals_.g_fDamageBevelAnisotropy1 * _9306;
	                _17228 = _Globals_.g_fDamageBevelRoughnessBrightness1 * _9306;
	                _17229 = _Globals_.g_vSubstrateGrimeMinMax1 * _9306;
	                _17230 = _Globals_.g_vSurfaceGrimeMinMax1 * _9306;
	                _17231 = _Globals_.g_vSubstrateBurnishingMinMax1 * _9306;
	                _17232 = _Globals_.g_vSurfaceBurnishingMinMax1 * _9306;
	                _17233 = _Globals_.g_fSubstrateCompositeColorTranslucency1 * _9306;
	                _17234 = vec4(textureGrad(sampler2D(g_tGrime1, g_sTrilinearWrap), _13403.xy, vec2(_23923, _11104), vec2(_12118, _15537)).xyz * _9306, _Globals_.g_fGrimeTranslucency1 * _9306);
	                _17235 = textureGrad(sampler2D(g_tDamage1, g_sTrilinearWrap), _13400.xy, vec2(_23922, _11100), vec2(_12115, _15534)).x * _9306;
	                _17236 = textureGrad(sampler2D(g_tSubstrateProperties1, g_sTrilinearWrap), input_8.xy, _6262, _19542).xyzw * _9306;
	                _17237 = textureGrad(sampler2D(g_tSubstrate1, g_sTrilinearWrap), input_8.xy, _6262, _19542).xyzw * _9306;
	                _17238 = textureGrad(sampler2D(g_tSurfaceProperties1, g_sTrilinearWrap), input_8.xy, _6262, _19542).xyzw * _9306;
	                _17239 = textureGrad(sampler2D(g_tSurface1, g_sTrilinearWrap), input_8.xy, _6262, _19542).xyzw * _9306;
	                _16866 = _Globals_.g_vDamageMinMax1 * _9306;
	            }
	            else
	            {
	                _13144 = 0.0;
	                _16309 = 0.0;
	                _17213 = 0.0;
	                _17214 = false;
	                _17215 = 0.0;
	                _17216 = 0.0;
	                _17217 = 0.0;
	                _17218 = 0.0;
	                _17219 = 0.0;
	                _17220 = 0.0;
	                _17221 = 0.0;
	                _17222 = 0.0;
	                _17225 = 0.0;
	                _17226 = 0.0;
	                _17227 = 0.0;
	                _17228 = 0.0;
	                _17229 = vec2(0.0);
	                _17230 = vec2(0.0);
	                _17231 = vec2(0.0);
	                _17232 = vec2(0.0);
	                _17233 = 0.0;
	                _17234 = vec4(0.0);
	                _17235 = 0.0;
	                _17236 = vec4(0.0);
	                _17237 = vec4(0.0);
	                _17238 = vec4(0.0);
	                _17239 = vec4(0.0);
	                _16866 = vec2(0.0);
	            }
	            float _13145;
	            float _16310;
	            vec2 _16867;
	            float _17240;
	            bool _17241;
	            float _17246;
	            float _17247;
	            float _17248;
	            float _17249;
	            float _17250;
	            float _17251;
	            float _17252;
	            float _17253;
	            float _17257;
	            float _17258;
	            float _17259;
	            float _17260;
	            vec2 _17261;
	            vec2 _17262;
	            vec2 _17263;
	            vec2 _17264;
	            float _17265;
	            vec4 _17266;
	            float _17267;
	            vec4 _17268;
	            vec4 _17269;
	            vec4 _17270;
	            vec4 _17271;
	            if (_17155)
	            {
	                vec2 _16498 = vec2(_18075, _24608);
	                vec2 _19545 = vec2(_12371, _12286);
	                _13145 = _Globals_.g_fBurnishingNormalScale2 * _23427;
	                _16310 = _Globals_.g_fSurfaceBurnishingRoughnessBrightness2 * _23427;
	                _17240 = _Globals_.g_fSubstrateBurnishingRoughnessBrightness2 * _23427;
	                _17241 = _Globals_.g_bDamageBevelUseTintMask2 != 0;
	                _17246 = _17215 + (_Globals_.g_fDamageBevelEmboss2 * _23427);
	                _17247 = _17216 + (_Globals_.g_fDamageHeightBlendSoftness2 * _23427);
	                _17248 = _17217 + (_Globals_.g_fDamageBevelBlendSoftness2 * _23427);
	                _17249 = _17218 + (_Globals_.g_fBurnishingGrime2 * _23427);
	                _17250 = _17219 + (_Globals_.g_fGrimeRoughnessBrightness2 * _23427);
	                _17251 = _17220 + (_Globals_.g_fBurnishingCloth2 * _23427);
	                _17252 = _17221 + (_Globals_.g_fBurnishingMetalness2 * _23427);
	                _17253 = _17222 + (float(_Globals_.g_bDamageBevelBlendToSubstrate2 != 0) * _23427);
	                _17257 = _17225 + (_Globals_.g_fDamageBevelCloth2 * _23427);
	                _17258 = _17226 + (_Globals_.g_fDamageBevelMetalness2 * _23427);
	                _17259 = _17227 + (_Globals_.g_fDamageBevelAnisotropy2 * _23427);
	                _17260 = _17228 + (_Globals_.g_fDamageBevelRoughnessBrightness2 * _23427);
	                _17261 = _17229 + (_Globals_.g_vSubstrateGrimeMinMax2 * _23427);
	                _17262 = _17230 + (_Globals_.g_vSurfaceGrimeMinMax2 * _23427);
	                _17263 = _17231 + (_Globals_.g_vSubstrateBurnishingMinMax2 * _23427);
	                _17264 = _17232 + (_Globals_.g_vSurfaceBurnishingMinMax2 * _23427);
	                _17265 = _17233 + (_Globals_.g_fSubstrateCompositeColorTranslucency2 * _23427);
	                _17266 = vec4(_17234.xyz + (textureGrad(sampler2D(g_tGrime2, g_sTrilinearWrap), _13404.xy, vec2(_12081, _11105), vec2(_12119, _15538)).xyz * _23427), _17234.w + (_Globals_.g_fGrimeTranslucency2 * _23427));
	                _17267 = _17235 + (textureGrad(sampler2D(g_tDamage2, g_sTrilinearWrap), _13401.xy, vec2(_12077, _11101), vec2(_12116, _15535)).x * _23427);
	                _17268 = _17236.xyzw + (textureGrad(sampler2D(g_tSubstrateProperties2, g_sTrilinearWrap), input_8.zw, _16498, _19545).xyzw * _23427);
	                _17269 = _17237.xyzw + (textureGrad(sampler2D(g_tSubstrate2, g_sTrilinearWrap), input_8.zw, _16498, _19545).xyzw * _23427);
	                _17270 = _17238.xyzw + (textureGrad(sampler2D(g_tSurfaceProperties2, g_sTrilinearWrap), input_8.zw, _16498, _19545).xyzw * _23427);
	                _17271 = _17239.xyzw + (textureGrad(sampler2D(g_tSurface2, g_sTrilinearWrap), input_8.zw, _16498, _19545).xyzw * _23427);
	                _16867 = _16866 + (_Globals_.g_vDamageMinMax2 * _23427);
	            }
	            else
	            {
	                _13145 = _13144;
	                _16310 = _16309;
	                _17240 = _17213;
	                _17241 = _17214;
	                _17246 = _17215;
	                _17247 = _17216;
	                _17248 = _17217;
	                _17249 = _17218;
	                _17250 = _17219;
	                _17251 = _17220;
	                _17252 = _17221;
	                _17253 = _17222;
	                _17257 = _17225;
	                _17258 = _17226;
	                _17259 = _17227;
	                _17260 = _17228;
	                _17261 = _17229;
	                _17262 = _17230;
	                _17263 = _17231;
	                _17264 = _17232;
	                _17265 = _17233;
	                _17266 = _17234;
	                _17267 = _17235;
	                _17268 = _17236;
	                _17269 = _17237;
	                _17270 = _17238;
	                _17271 = _17239;
	                _16867 = _16866;
	            }
	            float _13146;
	            float _16311;
	            vec2 _16868;
	            float _17272;
	            bool _17273;
	            float _17274;
	            float _17275;
	            float _17276;
	            float _17277;
	            float _17278;
	            float _17279;
	            float _17280;
	            float _17281;
	            float _17282;
	            float _17285;
	            float _17286;
	            float _17287;
	            vec2 _17288;
	            vec2 _17289;
	            vec2 _17290;
	            vec2 _17291;
	            float _17292;
	            vec4 _17293;
	            float _17294;
	            vec4 _17295;
	            vec4 _17296;
	            vec4 _17297;
	            vec4 _17298;
	            if (_17156)
	            {
	                vec2 _16500 = vec2(_18076, _24609);
	                vec2 _19549 = vec2(_12372, _12287);
	                _13146 = _Globals_.g_fBurnishingNormalScale3 * _23428;
	                _16311 = _Globals_.g_fSurfaceBurnishingRoughnessBrightness3 * _23428;
	                _17272 = _Globals_.g_fSubstrateBurnishingRoughnessBrightness3 * _23428;
	                _17273 = _Globals_.g_bDamageBevelUseTintMask3 != 0;
	                _17274 = _17246 + (_Globals_.g_fDamageBevelEmboss3 * _23428);
	                _17275 = _17247 + (_Globals_.g_fDamageHeightBlendSoftness3 * _23428);
	                _17276 = _17248 + (_Globals_.g_fDamageBevelBlendSoftness3 * _23428);
	                _17277 = _17249 + (_Globals_.g_fBurnishingGrime3 * _23428);
	                _17278 = _17250 + (_Globals_.g_fGrimeRoughnessBrightness3 * _23428);
	                _17279 = _17251 + (_Globals_.g_fBurnishingCloth3 * _23428);
	                _17280 = _17252 + (_Globals_.g_fBurnishingMetalness3 * _23428);
	                _17281 = _17253 + (float(_Globals_.g_bDamageBevelBlendToSubstrate3 != 0) * _23428);
	                _17282 = _17257 + (_Globals_.g_fDamageBevelCloth3 * _23428);
	                _17285 = _17258 + (_Globals_.g_fDamageBevelMetalness3 * _23428);
	                _17286 = _17259 + (_Globals_.g_fDamageBevelAnisotropy3 * _23428);
	                _17287 = _17260 + (_Globals_.g_fDamageBevelRoughnessBrightness3 * _23428);
	                _17288 = _17261 + (_Globals_.g_vSubstrateGrimeMinMax3 * _23428);
	                _17289 = _17262 + (_Globals_.g_vSurfaceGrimeMinMax3 * _23428);
	                _17290 = _17263 + (_Globals_.g_vSubstrateBurnishingMinMax3 * _23428);
	                _17291 = _17264 + (_Globals_.g_vSurfaceBurnishingMinMax3 * _23428);
	                _17292 = _17265 + (_Globals_.g_fSubstrateCompositeColorTranslucency3 * _23428);
	                _17293 = vec4(_17266.xyz + (textureGrad(sampler2D(g_tGrime3, g_sTrilinearWrap), _13405.xy, vec2(_12082, _11106), vec2(_12120, _15539)).xyz * _23428), _17266.w + (_Globals_.g_fGrimeTranslucency3 * _23428));
	                _17294 = _17267 + (textureGrad(sampler2D(g_tDamage3, g_sTrilinearWrap), _13402.xy, vec2(_12078, _11102), vec2(_12117, _15536)).x * _23428);
	                _17295 = _17268.xyzw + (textureGrad(sampler2D(g_tSubstrateProperties3, g_sTrilinearWrap), input_9.xy, _16500, _19549).xyzw * _23428);
	                _17296 = _17269.xyzw + (textureGrad(sampler2D(g_tSubstrate3, g_sTrilinearWrap), input_9.xy, _16500, _19549).xyzw * _23428);
	                _17297 = _17270.xyzw + (textureGrad(sampler2D(g_tSurfaceProperties3, g_sTrilinearWrap), input_9.xy, _16500, _19549).xyzw * _23428);
	                _17298 = _17271.xyzw + (textureGrad(sampler2D(g_tSurface3, g_sTrilinearWrap), input_9.xy, _16500, _19549).xyzw * _23428);
	                _16868 = _16867 + (_Globals_.g_vDamageMinMax3 * _23428);
	            }
	            else
	            {
	                _13146 = _13145;
	                _16311 = _16310;
	                _17272 = _17240;
	                _17273 = _17241;
	                _17274 = _17246;
	                _17275 = _17247;
	                _17276 = _17248;
	                _17277 = _17249;
	                _17278 = _17250;
	                _17279 = _17251;
	                _17280 = _17252;
	                _17281 = _17253;
	                _17282 = _17257;
	                _17285 = _17258;
	                _17286 = _17259;
	                _17287 = _17260;
	                _17288 = _17261;
	                _17289 = _17262;
	                _17290 = _17263;
	                _17291 = _17264;
	                _17292 = _17265;
	                _17293 = _17266;
	                _17294 = _17267;
	                _17295 = _17268;
	                _17296 = _17269;
	                _17297 = _17270;
	                _17298 = _17271;
	                _16868 = _16867;
	            }
	            vec4 _6617;
	            vec2 _13147;
	            bool _13695;
	            vec2 _16312;
	            vec2 _17299;
	            vec2 _17300;
	            float _17301;
	            float _17302;
	            vec4 _17303;
	            vec2 _17304;
	            float _17305;
	            float _17306;
	            float _17307;
	            float _17308;
	            float _17309;
	            float _17310;
	            float _17311;
	            float _17312;
	            float _17313;
	            float _17314;
	            float _17315;
	            float _17316;
	            float _17317;
	            float _17318;
	            float _17319;
	            vec4 _17320;
	            vec4 _17321;
	            vec4 _17322;
	            if (_17157)
	            {
	                vec2 _16502 = vec2(_18077, _24610);
	                vec2 _19554 = vec2(_9870, _13125);
	                _13147 = _17291 + (_Globals_.g_vSurfaceBurnishingMinMax4 * _23429);
	                _16312 = _17289 + (_Globals_.g_vSurfaceGrimeMinMax4 * _23429);
	                _17299 = _17290 + (_Globals_.g_vSubstrateBurnishingMinMax4 * _23429);
	                _17300 = _17288 + (_Globals_.g_vSubstrateGrimeMinMax4 * _23429);
	                _17301 = _17294 + (textureGrad(sampler2D(g_tDamage4, g_sTrilinearWrap), _13437.xy, vec2(_12079, _11103), vec2(_12080, _13126)).x * _23429);
	                _17302 = _17275 + (_Globals_.g_fDamageHeightBlendSoftness4 * _23429);
	                _17303 = vec4(_17293.xyz + (textureGrad(sampler2D(g_tGrime4, g_sTrilinearWrap), _13438.xy, vec2(_12083, _11107), vec2(_15264, _6642)).xyz * _23429), _17293.w + (_Globals_.g_fGrimeTranslucency4 * _23429));
	                _17304 = _16868 + (_Globals_.g_vDamageMinMax4 * _23429);
	                _17305 = _17278 + (_Globals_.g_fGrimeRoughnessBrightness4 * _23429);
	                _17306 = _17276 + (_Globals_.g_fDamageBevelBlendSoftness4 * _23429);
	                _17307 = _17282 + (_Globals_.g_fDamageBevelCloth4 * _23429);
	                _17308 = _17281 + (float(_Globals_.g_bDamageBevelBlendToSubstrate4 != 0) * _23429);
	                _17309 = _17280 + (_Globals_.g_fBurnishingMetalness4 * _23429);
	                _17310 = _17274 + (_Globals_.g_fDamageBevelEmboss4 * _23429);
	                _17311 = _17279 + (_Globals_.g_fBurnishingCloth4 * _23429);
	                _17312 = _17277 + (_Globals_.g_fBurnishingGrime4 * _23429);
	                _17313 = _Globals_.g_fBurnishingNormalScale4 * _23429;
	                _17314 = _Globals_.g_fSurfaceBurnishingRoughnessBrightness4 * _23429;
	                _17315 = _Globals_.g_fSubstrateBurnishingRoughnessBrightness4 * _23429;
	                _17316 = _17286 + (_Globals_.g_fDamageBevelAnisotropy4 * _23429);
	                _17317 = _17287 + (_Globals_.g_fDamageBevelRoughnessBrightness4 * _23429);
	                _17318 = _17285 + (_Globals_.g_fDamageBevelMetalness4 * _23429);
	                _17319 = _17292 + (_Globals_.g_fSubstrateCompositeColorTranslucency4 * _23429);
	                _17320 = _17295.xyzw + (textureGrad(sampler2D(g_tSubstrateProperties4, g_sTrilinearWrap), input_9.zw, _16502, _19554).xyzw * _23429);
	                _17321 = _17296.xyzw + (textureGrad(sampler2D(g_tSubstrate4, g_sTrilinearWrap), input_9.zw, _16502, _19554).xyzw * _23429);
	                _17322 = _17297.xyzw + (textureGrad(sampler2D(g_tSurfaceProperties4, g_sTrilinearWrap), input_9.zw, _16502, _19554).xyzw * _23429);
	                _13695 = _Globals_.g_bDamageBevelUseTintMask4 != 0;
	                _6617 = _17298.xyzw + (textureGrad(sampler2D(g_tSurface4, g_sTrilinearWrap), input_9.zw, _16502, _19554).xyzw * _23429);
	            }
	            else
	            {
	                _13147 = _17291;
	                _16312 = _17289;
	                _17299 = _17290;
	                _17300 = _17288;
	                _17301 = _17294;
	                _17302 = _17275;
	                _17303 = _17293;
	                _17304 = _16868;
	                _17305 = _17278;
	                _17306 = _17276;
	                _17307 = _17282;
	                _17308 = _17281;
	                _17309 = _17280;
	                _17310 = _17274;
	                _17311 = _17279;
	                _17312 = _17277;
	                _17313 = _13146;
	                _17314 = _16311;
	                _17315 = _17272;
	                _17316 = _17286;
	                _17317 = _17287;
	                _17318 = _17285;
	                _17319 = _17292;
	                _17320 = _17295;
	                _17321 = _17296;
	                _17322 = _17297;
	                _13695 = _17273;
	                _6617 = _17298;
	            }
	            bool _14877 = _Globals_.g_fPatternPaintRespectsTintMask != 0;
	            float _21712;
	            if (_14877)
	            {
	                _21712 = _6617.w;
	            }
	            else
	            {
	                _21712 = max(_6617.w, _24878.w);
	            }
	            mat4 _19938 = mat4((((_Globals_.g_mSurfaceBurnishingColorAdjust1[0] * _9306) + (_Globals_.g_mSurfaceBurnishingColorAdjust2[0] * _23427)) + (_Globals_.g_mSurfaceBurnishingColorAdjust3[0] * _23428)) + (_Globals_.g_mSurfaceBurnishingColorAdjust4[0] * _23429), (((_Globals_.g_mSurfaceBurnishingColorAdjust1[1] * _9306) + (_Globals_.g_mSurfaceBurnishingColorAdjust2[1] * _23427)) + (_Globals_.g_mSurfaceBurnishingColorAdjust3[1] * _23428)) + (_Globals_.g_mSurfaceBurnishingColorAdjust4[1] * _23429), (((_Globals_.g_mSurfaceBurnishingColorAdjust1[2] * _9306) + (_Globals_.g_mSurfaceBurnishingColorAdjust2[2] * _23427)) + (_Globals_.g_mSurfaceBurnishingColorAdjust3[2] * _23428)) + (_Globals_.g_mSurfaceBurnishingColorAdjust4[2] * _23429), (((_Globals_.g_mSurfaceBurnishingColorAdjust1[3] * _9306) + (_Globals_.g_mSurfaceBurnishingColorAdjust2[3] * _23427)) + (_Globals_.g_mSurfaceBurnishingColorAdjust3[3] * _23428)) + (_Globals_.g_mSurfaceBurnishingColorAdjust4[3] * _23429));
	            vec4 _24835 = vec4(_6617.xyz, 1.0);
	            vec4 _11582 = vec4((_24835 * mat4((((_Globals_.g_mSurfaceColorAdjust1[0] * _9306) + (_Globals_.g_mSurfaceColorAdjust2[0] * _23427)) + (_Globals_.g_mSurfaceColorAdjust3[0] * _23428)) + (_Globals_.g_mSurfaceColorAdjust4[0] * _23429), (((_Globals_.g_mSurfaceColorAdjust1[1] * _9306) + (_Globals_.g_mSurfaceColorAdjust2[1] * _23427)) + (_Globals_.g_mSurfaceColorAdjust3[1] * _23428)) + (_Globals_.g_mSurfaceColorAdjust4[1] * _23429), (((_Globals_.g_mSurfaceColorAdjust1[2] * _9306) + (_Globals_.g_mSurfaceColorAdjust2[2] * _23427)) + (_Globals_.g_mSurfaceColorAdjust3[2] * _23428)) + (_Globals_.g_mSurfaceColorAdjust4[2] * _23429), (((_Globals_.g_mSurfaceColorAdjust1[3] * _9306) + (_Globals_.g_mSurfaceColorAdjust2[3] * _23427)) + (_Globals_.g_mSurfaceColorAdjust3[3] * _23428)) + (_Globals_.g_mSurfaceColorAdjust4[3] * _23429))).xyz, _3);
	            vec3 _18228 = _11582.xyz;
	            vec3 _16611;
	            do
	            {
	                float _20940;
	                do
	                {
	                    float _18473 = max(_22280, max(_17341, _24875));
	                    if (_18473 == 0.0)
	                    {
	                        _20940 = 0.0;
	                        break;
	                    }
	                    _20940 = (_18473 - min(_22280, min(_17341, _24875))) / _18473;
	                    break;
	                } while(false);
	                float _12835 = dot(_10562.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                float _23052 = max(dot(_11582.xyz, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), 0.001000000047497451305389404296875);
	                if (_12835 > 0.0)
	                {
	                    vec3 _22572 = normalize(_10562.xyz).xyz - vec3(0.57700002193450927734375);
	                    vec3 _7057 = saturate((normalize(_22572) * 2.0) + vec3(1.0)).xyz;
	                    vec3 _15712 = _7057 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	                    _16611 = mix((_18228 * mix(1.0, min(max(1.0 + (4.0 * (_12835 - 0.5)), mix(0.02999999932944774627685546875, 0.134000003337860107421875, _17322.y) / _23052), mix(0.89999997615814208984375, 0.980000019073486328125, _17322.y) / _23052), _14615)).xyz, _7057 * (_12835 / ((_15712.x + _15712.y) + _15712.z)), vec3(saturate(_20940 * pow(abs(dot(_22572, vec3(0.57700002193450927734375))), 0.20000000298023223876953125)) * _14615));
	                    break;
	                }
	                else
	                {
	                    _16611 = _18228;
	                    break;
	                }
	                break; // unreachable workaround
	            } while(false);
	            vec3 _19312 = mix(_6617.xyz, _16611, vec3(_21712));
	            float _21719;
	            if (_14877)
	            {
	                _21719 = _17321.w;
	            }
	            else
	            {
	                _21719 = max(_17321.w, _24878.w);
	            }
	            bool _6221;
	            vec3 _7901;
	            float _9231;
	            float _12836;
	            bool _15230;
	            float _16314;
	            float _18474;
	            float _6651 = _14750 * _17319;
	            vec4 _24836 = vec4(_17321.xyz, 1.0);
	            vec4 _11583 = vec4((_24836 * mat4((((_Globals_.g_mSubstrateColorAdjust1[0] * _9306) + (_Globals_.g_mSubstrateColorAdjust2[0] * _23427)) + (_Globals_.g_mSubstrateColorAdjust3[0] * _23428)) + (_Globals_.g_mSubstrateColorAdjust4[0] * _23429), (((_Globals_.g_mSubstrateColorAdjust1[1] * _9306) + (_Globals_.g_mSubstrateColorAdjust2[1] * _23427)) + (_Globals_.g_mSubstrateColorAdjust3[1] * _23428)) + (_Globals_.g_mSubstrateColorAdjust4[1] * _23429), (((_Globals_.g_mSubstrateColorAdjust1[2] * _9306) + (_Globals_.g_mSubstrateColorAdjust2[2] * _23427)) + (_Globals_.g_mSubstrateColorAdjust3[2] * _23428)) + (_Globals_.g_mSubstrateColorAdjust4[2] * _23429), (((_Globals_.g_mSubstrateColorAdjust1[3] * _9306) + (_Globals_.g_mSubstrateColorAdjust2[3] * _23427)) + (_Globals_.g_mSubstrateColorAdjust3[3] * _23428)) + (_Globals_.g_mSubstrateColorAdjust4[3] * _23429))).xyz, _3);
	            vec3 _18229 = _11583.xyz;
	            vec3 _16612;
	            do
	            {
	                _7901 = _11729.xyz;
	                float _20941;
	                do
	                {
	                    float _17002 = _19714.x;
	                    float _10964 = _19714.y;
	                    float _21520 = _19714.z;
	                    _18474 = max(_17002, max(_10964, _21520));
	                    _16314 = _18474 - min(_17002, min(_10964, _21520));
	                    _6221 = _18474 == 0.0;
	                    if (_6221)
	                    {
	                        _20941 = 0.0;
	                        break;
	                    }
	                    _20941 = _16314 / _18474;
	                    break;
	                } while(false);
	                _12836 = dot(_11729.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	                float _23053 = max(dot(_11583.xyz, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), 0.001000000047497451305389404296875);
	                _9231 = 4.0 * (_12836 - 0.5);
	                _15230 = _12836 > 0.0;
	                if (_15230)
	                {
	                    vec3 _22573 = normalize(_7901).xyz - vec3(0.57700002193450927734375);
	                    vec3 _7058 = saturate((normalize(_22573) * 2.0) + vec3(1.0)).xyz;
	                    vec3 _15713 = _7058 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	                    _16612 = mix((_18229 * mix(1.0, min(max(1.0 + _9231, mix(0.02999999932944774627685546875, 0.134000003337860107421875, _17320.y) / _23053), mix(0.89999997615814208984375, 0.980000019073486328125, _17320.y) / _23053), _6651)).xyz, _7058 * (_12836 / ((_15713.x + _15713.y) + _15713.z)), vec3(saturate(_20941 * pow(abs(dot(_22573, vec3(0.57700002193450927734375))), 0.20000000298023223876953125)) * _6651));
	                    break;
	                }
	                else
	                {
	                    _16612 = _18229;
	                    break;
	                }
	                break; // unreachable workaround
	            } while(false);
	            vec4 _11584 = vec4((_24835 * mat4((((_Globals_.g_mDamageColorAdjust1[0] * _9306) + (_Globals_.g_mDamageColorAdjust2[0] * _23427)) + (_Globals_.g_mDamageColorAdjust3[0] * _23428)) + (_Globals_.g_mDamageColorAdjust4[0] * _23429), (((_Globals_.g_mDamageColorAdjust1[1] * _9306) + (_Globals_.g_mDamageColorAdjust2[1] * _23427)) + (_Globals_.g_mDamageColorAdjust3[1] * _23428)) + (_Globals_.g_mDamageColorAdjust4[1] * _23429), (((_Globals_.g_mDamageColorAdjust1[2] * _9306) + (_Globals_.g_mDamageColorAdjust2[2] * _23427)) + (_Globals_.g_mDamageColorAdjust3[2] * _23428)) + (_Globals_.g_mDamageColorAdjust4[2] * _23429), (((_Globals_.g_mDamageColorAdjust1[3] * _9306) + (_Globals_.g_mDamageColorAdjust2[3] * _23427)) + (_Globals_.g_mDamageColorAdjust3[3] * _23428)) + (_Globals_.g_mDamageColorAdjust4[3] * _23429))).xyz, _3);
	            vec3 _18230 = _11584.xyz;
	            vec3 _16615;
	            do
	            {
	                float _20942;
	                do
	                {
	                    if (_6221)
	                    {
	                        _20942 = 0.0;
	                        break;
	                    }
	                    _20942 = _16314 / _18474;
	                    break;
	                } while(false);
	                float _17323 = max(dot(_11584.xyz, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), 0.001000000047497451305389404296875);
	                if (_15230)
	                {
	                    vec3 _22574 = normalize(_7901).xyz - vec3(0.57700002193450927734375);
	                    vec3 _7059 = saturate((normalize(_22574) * 2.0) + vec3(1.0)).xyz;
	                    vec3 _15714 = _7059 * vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125);
	                    _16615 = mix((_18230 * mix(1.0, min(max(1.0 + _9231, mix(0.02999999932944774627685546875, 0.134000003337860107421875, _17318) / _17323), mix(0.89999997615814208984375, 0.980000019073486328125, _17318) / _17323), _6651)).xyz, _7059 * (_12836 / ((_15714.x + _15714.y) + _15714.z)), vec3(saturate(_20942 * pow(abs(dot(_22574, vec3(0.57700002193450927734375))), 0.20000000298023223876953125)) * _6651));
	                    break;
	                }
	                else
	                {
	                    _16615 = _18230;
	                    break;
	                }
	                break; // unreachable workaround
	            } while(false);
	            vec3 _11467 = mix(_19312.xyz, _16615, vec3(_13695 ? _21712 : 1.0));
	            vec2 _23651 = _23299.xz * _17317;
	            _23651.y = mix(_23651.x, _23651.y, _17316);
	            _13150 = _19312;
	            _16317 = vec3((_24835 * _19938).xyz);
	            _17335 = _17322.x;
	            _17336 = _17322.w;
	            _17337 = _17322.y;
	            _17338 = _17322.z * (1.0 - _17322.y);
	            _17339 = _14854;
	            _17340 = mix(_23299.xz, saturate((((_23299.xz - vec2(0.5)) + vec2(_Globals_.g_vPatternRoughnessContrastBrightness.y)) * _Globals_.g_vPatternRoughnessContrastBrightness.x) + vec2(0.5)), vec2(_24878.w * _21712));
	            _17342 = _13147;
	            _17343 = _16312;
	            _17344 = mix(_17321.xyz, _16612, vec3(_21719));
	            _17345 = vec3((_24836 * mat4((((_Globals_.g_mSubstrateBurnishingColorAdjust1[0] * _9306) + (_Globals_.g_mSubstrateBurnishingColorAdjust2[0] * _23427)) + (_Globals_.g_mSubstrateBurnishingColorAdjust3[0] * _23428)) + (_Globals_.g_mSubstrateBurnishingColorAdjust4[0] * _23429), (((_Globals_.g_mSubstrateBurnishingColorAdjust1[1] * _9306) + (_Globals_.g_mSubstrateBurnishingColorAdjust2[1] * _23427)) + (_Globals_.g_mSubstrateBurnishingColorAdjust3[1] * _23428)) + (_Globals_.g_mSubstrateBurnishingColorAdjust4[1] * _23429), (((_Globals_.g_mSubstrateBurnishingColorAdjust1[2] * _9306) + (_Globals_.g_mSubstrateBurnishingColorAdjust2[2] * _23427)) + (_Globals_.g_mSubstrateBurnishingColorAdjust3[2] * _23428)) + (_Globals_.g_mSubstrateBurnishingColorAdjust4[2] * _23429), (((_Globals_.g_mSubstrateBurnishingColorAdjust1[3] * _9306) + (_Globals_.g_mSubstrateBurnishingColorAdjust2[3] * _23427)) + (_Globals_.g_mSubstrateBurnishingColorAdjust3[3] * _23428)) + (_Globals_.g_mSubstrateBurnishingColorAdjust4[3] * _23429))).xyz);
	            _17346 = _17320.x;
	            _17347 = _17320.w;
	            _17354 = _17320.z * (1.0 - _17320.y);
	            _17355 = _17320.y;
	            _17356 = _17299;
	            _17357 = _17300;
	            _17358 = _11467;
	            _17359 = vec4((vec4(vec4(_11467.xyz, 1.0).xyz, 1.0) * _19938).xyz, 1.0).xyz;
	            _17360 = _17301;
	            _17361 = _17302;
	            _17362 = _23651;
	            _17363 = _17303;
	            _17364 = _17304;
	            _17365 = _17305;
	            _17366 = _17306;
	            _17367 = _17318;
	            _17368 = _17307;
	            _17369 = _17308;
	            _17370 = _17309;
	            _17371 = _17310;
	            _17372 = _17311;
	            _17373 = _17312;
	            _17374 = _17313;
	            _13998 = _17314;
	            _23300 = _17315;
	            break;
	        }
	        else
	        {
	            float _23270 = dFdxFine(input_8.x);
	            float _6318 = dFdxFine(input_8.y);
	            float _12358 = dFdyFine(input_8.x);
	            float _12282 = dFdyFine(input_8.y);
	            float _18072 = dFdxFine(input_8.z);
	            float _24605 = dFdxFine(input_8.w);
	            float _12359 = dFdyFine(input_8.z);
	            float _12283 = dFdyFine(input_8.w);
	            float _18073 = dFdxFine(input_9.x);
	            float _24606 = dFdxFine(input_9.y);
	            float _12360 = dFdyFine(input_9.x);
	            float _12284 = dFdyFine(input_9.y);
	            float _18074 = dFdxFine(input_9.z);
	            float _24607 = dFdxFine(input_9.w);
	            float _9869 = dFdyFine(input_9.z);
	            float _13119 = dFdyFine(input_9.w);
	            vec2 _13372 = input_10.xy * _Globals_.g_fDamageUvScale1;
	            vec2 _13373 = input_10.xy * _Globals_.g_fDamageUvScale2;
	            vec2 _13374 = input_10.xy * _Globals_.g_fDamageUvScale3;
	            vec2 _13435 = input_10.xy * _Globals_.g_fDamageUvScale4;
	            float _11998 = _13372.x;
	            float _23920 = dFdxFine(_11998);
	            float _18323 = _13372.y;
	            float _11092 = dFdxFine(_18323);
	            float _12109 = dFdyFine(_11998);
	            float _15528 = dFdyFine(_18323);
	            float _10980 = _13373.x;
	            float _12070 = dFdxFine(_10980);
	            float _18324 = _13373.y;
	            float _11093 = dFdxFine(_18324);
	            float _12110 = dFdyFine(_10980);
	            float _15529 = dFdyFine(_18324);
	            float _10981 = _13374.x;
	            float _12071 = dFdxFine(_10981);
	            float _18325 = _13374.y;
	            float _11094 = dFdxFine(_18325);
	            float _12111 = dFdyFine(_10981);
	            float _15530 = dFdyFine(_18325);
	            float _10982 = _13435.x;
	            float _12072 = dFdxFine(_10982);
	            float _18326 = _13435.y;
	            float _11095 = dFdxFine(_18326);
	            float _12073 = dFdyFine(_10982);
	            float _13120 = dFdyFine(_18326);
	            vec2 _13375 = input_10.zw * _Globals_.g_fGrimeUvScale1;
	            vec2 _13376 = input_10.zw * _Globals_.g_fGrimeUvScale2;
	            vec2 _13377 = input_10.zw * _Globals_.g_fGrimeUvScale3;
	            vec2 _13436 = input_10.zw * _Globals_.g_fGrimeUvScale4;
	            float _11999 = _13375.x;
	            float _23921 = dFdxFine(_11999);
	            float _18327 = _13375.y;
	            float _11096 = dFdxFine(_18327);
	            float _12112 = dFdyFine(_11999);
	            float _15531 = dFdyFine(_18327);
	            float _10983 = _13376.x;
	            float _12074 = dFdxFine(_10983);
	            float _18328 = _13376.y;
	            float _11097 = dFdxFine(_18328);
	            float _12113 = dFdyFine(_10983);
	            float _15532 = dFdyFine(_18328);
	            float _10984 = _13377.x;
	            float _12075 = dFdxFine(_10984);
	            float _18329 = _13377.y;
	            float _11098 = dFdxFine(_18329);
	            float _12114 = dFdyFine(_10984);
	            float _15533 = dFdyFine(_18329);
	            float _10985 = _13436.x;
	            float _12076 = dFdxFine(_10985);
	            float _18330 = _13436.y;
	            float _11099 = dFdxFine(_18330);
	            float _15263 = dFdyFine(_10985);
	            float _6641 = dFdyFine(_18330);
	            float _13140;
	            float _16305;
	            vec2 _16863;
	            float _17114;
	            bool _17115;
	            float _17116;
	            float _17117;
	            float _17118;
	            float _17119;
	            float _17120;
	            float _17121;
	            float _17122;
	            float _17123;
	            float _17124;
	            float _17125;
	            float _17126;
	            float _17127;
	            vec2 _17128;
	            vec2 _17129;
	            vec2 _17130;
	            vec2 _17131;
	            vec4 _17132;
	            float _17133;
	            vec4 _17134;
	            vec4 _17135;
	            vec4 _17136;
	            vec4 _17152;
	            if (_9694)
	            {
	                vec2 _6260 = vec2(_23270, _6318);
	                vec2 _19530 = vec2(_12358, _12282);
	                _13140 = _Globals_.g_fBurnishingNormalScale1 * _9306;
	                _16305 = _Globals_.g_fSurfaceBurnishingRoughnessBrightness1 * _9306;
	                _17114 = _Globals_.g_fSubstrateBurnishingRoughnessBrightness1 * _9306;
	                _17115 = _Globals_.g_bDamageBevelUseTintMask1 != 0;
	                _17116 = _Globals_.g_fDamageBevelEmboss1 * _9306;
	                _17117 = _Globals_.g_fDamageHeightBlendSoftness1 * _9306;
	                _17118 = _Globals_.g_fDamageBevelBlendSoftness1 * _9306;
	                _17119 = _Globals_.g_fBurnishingGrime1 * _9306;
	                _17120 = _Globals_.g_fGrimeRoughnessBrightness1 * _9306;
	                _17121 = _Globals_.g_fBurnishingCloth1 * _9306;
	                _17122 = _Globals_.g_fBurnishingMetalness1 * _9306;
	                _17123 = float(_Globals_.g_bDamageBevelBlendToSubstrate1 != 0) * _9306;
	                _17124 = _Globals_.g_fDamageBevelCloth1 * _9306;
	                _17125 = _Globals_.g_fDamageBevelMetalness1 * _9306;
	                _17126 = _Globals_.g_fDamageBevelAnisotropy1 * _9306;
	                _17127 = _Globals_.g_fDamageBevelRoughnessBrightness1 * _9306;
	                _17128 = _Globals_.g_vSubstrateGrimeMinMax1 * _9306;
	                _17129 = _Globals_.g_vSurfaceGrimeMinMax1 * _9306;
	                _17130 = _Globals_.g_vSubstrateBurnishingMinMax1 * _9306;
	                _17131 = _Globals_.g_vSurfaceBurnishingMinMax1 * _9306;
	                _17132 = vec4(textureGrad(sampler2D(g_tGrime1, g_sTrilinearWrap), _13375.xy, vec2(_23921, _11096), vec2(_12112, _15531)).xyz * _9306, _Globals_.g_fGrimeTranslucency1 * _9306);
	                _17133 = textureGrad(sampler2D(g_tDamage1, g_sTrilinearWrap), _13372.xy, vec2(_23920, _11092), vec2(_12109, _15528)).x * _9306;
	                _17134 = textureGrad(sampler2D(g_tSubstrateProperties1, g_sTrilinearWrap), input_8.xy, _6260, _19530).xyzw * _9306;
	                _17135 = textureGrad(sampler2D(g_tSubstrate1, g_sTrilinearWrap), input_8.xy, _6260, _19530).xyzw * _9306;
	                _17136 = textureGrad(sampler2D(g_tSurfaceProperties1, g_sTrilinearWrap), input_8.xy, _6260, _19530).xyzw * _9306;
	                _17152 = textureGrad(sampler2D(g_tSurface1, g_sTrilinearWrap), input_8.xy, _6260, _19530).xyzw * _9306;
	                _16863 = _Globals_.g_vDamageMinMax1 * _9306;
	            }
	            else
	            {
	                _13140 = 0.0;
	                _16305 = 0.0;
	                _17114 = 0.0;
	                _17115 = false;
	                _17116 = 0.0;
	                _17117 = 0.0;
	                _17118 = 0.0;
	                _17119 = 0.0;
	                _17120 = 0.0;
	                _17121 = 0.0;
	                _17122 = 0.0;
	                _17123 = 0.0;
	                _17124 = 0.0;
	                _17125 = 0.0;
	                _17126 = 0.0;
	                _17127 = 0.0;
	                _17128 = vec2(0.0);
	                _17129 = vec2(0.0);
	                _17130 = vec2(0.0);
	                _17131 = vec2(0.0);
	                _17132 = vec4(0.0);
	                _17133 = 0.0;
	                _17134 = vec4(0.0);
	                _17135 = vec4(0.0);
	                _17136 = vec4(0.0);
	                _17152 = vec4(0.0);
	                _16863 = vec2(0.0);
	            }
	            float _13141;
	            float _16306;
	            vec2 _16864;
	            float _17137;
	            bool _17138;
	            float _17139;
	            float _17140;
	            float _17141;
	            float _17142;
	            float _17143;
	            float _17145;
	            float _17146;
	            float _17147;
	            float _17148;
	            float _17149;
	            float _17150;
	            float _17151;
	            vec2 _17153;
	            vec2 _17154;
	            vec2 _17158;
	            vec2 _17159;
	            vec4 _17160;
	            float _17161;
	            vec4 _17162;
	            vec4 _17163;
	            vec4 _17164;
	            vec4 _17165;
	            if (_17155)
	            {
	                vec2 _16492 = vec2(_18072, _24605);
	                vec2 _19533 = vec2(_12359, _12283);
	                _13141 = _Globals_.g_fBurnishingNormalScale2 * _23427;
	                _16306 = _Globals_.g_fSurfaceBurnishingRoughnessBrightness2 * _23427;
	                _17137 = _Globals_.g_fSubstrateBurnishingRoughnessBrightness2 * _23427;
	                _17138 = _Globals_.g_bDamageBevelUseTintMask2 != 0;
	                _17139 = _17116 + (_Globals_.g_fDamageBevelEmboss2 * _23427);
	                _17140 = _17117 + (_Globals_.g_fDamageHeightBlendSoftness2 * _23427);
	                _17141 = _17118 + (_Globals_.g_fDamageBevelBlendSoftness2 * _23427);
	                _17142 = _17119 + (_Globals_.g_fBurnishingGrime2 * _23427);
	                _17143 = _17120 + (_Globals_.g_fGrimeRoughnessBrightness2 * _23427);
	                _17145 = _17121 + (_Globals_.g_fBurnishingCloth2 * _23427);
	                _17146 = _17122 + (_Globals_.g_fBurnishingMetalness2 * _23427);
	                _17147 = _17123 + (float(_Globals_.g_bDamageBevelBlendToSubstrate2 != 0) * _23427);
	                _17148 = _17124 + (_Globals_.g_fDamageBevelCloth2 * _23427);
	                _17149 = _17125 + (_Globals_.g_fDamageBevelMetalness2 * _23427);
	                _17150 = _17126 + (_Globals_.g_fDamageBevelAnisotropy2 * _23427);
	                _17151 = _17127 + (_Globals_.g_fDamageBevelRoughnessBrightness2 * _23427);
	                _17153 = _17128 + (_Globals_.g_vSubstrateGrimeMinMax2 * _23427);
	                _17154 = _17129 + (_Globals_.g_vSurfaceGrimeMinMax2 * _23427);
	                _17158 = _17130 + (_Globals_.g_vSubstrateBurnishingMinMax2 * _23427);
	                _17159 = _17131 + (_Globals_.g_vSurfaceBurnishingMinMax2 * _23427);
	                _17160 = vec4(_17132.xyz + (textureGrad(sampler2D(g_tGrime2, g_sTrilinearWrap), _13376.xy, vec2(_12074, _11097), vec2(_12113, _15532)).xyz * _23427), _17132.w + (_Globals_.g_fGrimeTranslucency2 * _23427));
	                _17161 = _17133 + (textureGrad(sampler2D(g_tDamage2, g_sTrilinearWrap), _13373.xy, vec2(_12070, _11093), vec2(_12110, _15529)).x * _23427);
	                _17162 = _17134.xyzw + (textureGrad(sampler2D(g_tSubstrateProperties2, g_sTrilinearWrap), input_8.zw, _16492, _19533).xyzw * _23427);
	                _17163 = _17135.xyzw + (textureGrad(sampler2D(g_tSubstrate2, g_sTrilinearWrap), input_8.zw, _16492, _19533).xyzw * _23427);
	                _17164 = _17136.xyzw + (textureGrad(sampler2D(g_tSurfaceProperties2, g_sTrilinearWrap), input_8.zw, _16492, _19533).xyzw * _23427);
	                _17165 = _17152.xyzw + (textureGrad(sampler2D(g_tSurface2, g_sTrilinearWrap), input_8.zw, _16492, _19533).xyzw * _23427);
	                _16864 = _16863 + (_Globals_.g_vDamageMinMax2 * _23427);
	            }
	            else
	            {
	                _13141 = _13140;
	                _16306 = _16305;
	                _17137 = _17114;
	                _17138 = _17115;
	                _17139 = _17116;
	                _17140 = _17117;
	                _17141 = _17118;
	                _17142 = _17119;
	                _17143 = _17120;
	                _17145 = _17121;
	                _17146 = _17122;
	                _17147 = _17123;
	                _17148 = _17124;
	                _17149 = _17125;
	                _17150 = _17126;
	                _17151 = _17127;
	                _17153 = _17128;
	                _17154 = _17129;
	                _17158 = _17130;
	                _17159 = _17131;
	                _17160 = _17132;
	                _17161 = _17133;
	                _17162 = _17134;
	                _17163 = _17135;
	                _17164 = _17136;
	                _17165 = _17152;
	                _16864 = _16863;
	            }
	            float _13142;
	            float _16307;
	            vec2 _16865;
	            float _17166;
	            bool _17167;
	            float _17168;
	            float _17169;
	            float _17170;
	            float _17171;
	            float _17172;
	            float _17173;
	            float _17174;
	            float _17175;
	            float _17176;
	            float _17177;
	            float _17178;
	            float _17179;
	            vec2 _17180;
	            vec2 _17181;
	            vec2 _17182;
	            vec2 _17183;
	            vec4 _17184;
	            float _17185;
	            vec4 _17186;
	            vec4 _17187;
	            vec4 _17188;
	            vec4 _17189;
	            if (_17156)
	            {
	                vec2 _16494 = vec2(_18073, _24606);
	                vec2 _19536 = vec2(_12360, _12284);
	                _13142 = _Globals_.g_fBurnishingNormalScale3 * _23428;
	                _16307 = _Globals_.g_fSurfaceBurnishingRoughnessBrightness3 * _23428;
	                _17166 = _Globals_.g_fSubstrateBurnishingRoughnessBrightness3 * _23428;
	                _17167 = _Globals_.g_bDamageBevelUseTintMask3 != 0;
	                _17168 = _17139 + (_Globals_.g_fDamageBevelEmboss3 * _23428);
	                _17169 = _17140 + (_Globals_.g_fDamageHeightBlendSoftness3 * _23428);
	                _17170 = _17141 + (_Globals_.g_fDamageBevelBlendSoftness3 * _23428);
	                _17171 = _17142 + (_Globals_.g_fBurnishingGrime3 * _23428);
	                _17172 = _17143 + (_Globals_.g_fGrimeRoughnessBrightness3 * _23428);
	                _17173 = _17145 + (_Globals_.g_fBurnishingCloth3 * _23428);
	                _17174 = _17146 + (_Globals_.g_fBurnishingMetalness3 * _23428);
	                _17175 = _17147 + (float(_Globals_.g_bDamageBevelBlendToSubstrate3 != 0) * _23428);
	                _17176 = _17148 + (_Globals_.g_fDamageBevelCloth3 * _23428);
	                _17177 = _17149 + (_Globals_.g_fDamageBevelMetalness3 * _23428);
	                _17178 = _17150 + (_Globals_.g_fDamageBevelAnisotropy3 * _23428);
	                _17179 = _17151 + (_Globals_.g_fDamageBevelRoughnessBrightness3 * _23428);
	                _17180 = _17153 + (_Globals_.g_vSubstrateGrimeMinMax3 * _23428);
	                _17181 = _17154 + (_Globals_.g_vSurfaceGrimeMinMax3 * _23428);
	                _17182 = _17158 + (_Globals_.g_vSubstrateBurnishingMinMax3 * _23428);
	                _17183 = _17159 + (_Globals_.g_vSurfaceBurnishingMinMax3 * _23428);
	                _17184 = vec4(_17160.xyz + (textureGrad(sampler2D(g_tGrime3, g_sTrilinearWrap), _13377.xy, vec2(_12075, _11098), vec2(_12114, _15533)).xyz * _23428), _17160.w + (_Globals_.g_fGrimeTranslucency3 * _23428));
	                _17185 = _17161 + (textureGrad(sampler2D(g_tDamage3, g_sTrilinearWrap), _13374.xy, vec2(_12071, _11094), vec2(_12111, _15530)).x * _23428);
	                _17186 = _17162.xyzw + (textureGrad(sampler2D(g_tSubstrateProperties3, g_sTrilinearWrap), input_9.xy, _16494, _19536).xyzw * _23428);
	                _17187 = _17163.xyzw + (textureGrad(sampler2D(g_tSubstrate3, g_sTrilinearWrap), input_9.xy, _16494, _19536).xyzw * _23428);
	                _17188 = _17164.xyzw + (textureGrad(sampler2D(g_tSurfaceProperties3, g_sTrilinearWrap), input_9.xy, _16494, _19536).xyzw * _23428);
	                _17189 = _17165.xyzw + (textureGrad(sampler2D(g_tSurface3, g_sTrilinearWrap), input_9.xy, _16494, _19536).xyzw * _23428);
	                _16865 = _16864 + (_Globals_.g_vDamageMinMax3 * _23428);
	            }
	            else
	            {
	                _13142 = _13141;
	                _16307 = _16306;
	                _17166 = _17137;
	                _17167 = _17138;
	                _17168 = _17139;
	                _17169 = _17140;
	                _17170 = _17141;
	                _17171 = _17142;
	                _17172 = _17143;
	                _17173 = _17145;
	                _17174 = _17146;
	                _17175 = _17147;
	                _17176 = _17148;
	                _17177 = _17149;
	                _17178 = _17150;
	                _17179 = _17151;
	                _17180 = _17153;
	                _17181 = _17154;
	                _17182 = _17158;
	                _17183 = _17159;
	                _17184 = _17160;
	                _17185 = _17161;
	                _17186 = _17162;
	                _17187 = _17163;
	                _17188 = _17164;
	                _17189 = _17165;
	                _16865 = _16864;
	            }
	            vec4 _6616;
	            bool _13694;
	            float _17207;
	            float _17208;
	            vec4 _17210;
	            vec4 _17211;
	            vec4 _17212;
	            if (_17157)
	            {
	                vec2 _16496 = vec2(_18074, _24607);
	                vec2 _19539 = vec2(_9869, _13119);
	                _13143 = _17183 + (_Globals_.g_vSurfaceBurnishingMinMax4 * _23429);
	                _16308 = _17181 + (_Globals_.g_vSurfaceGrimeMinMax4 * _23429);
	                _17190 = _17182 + (_Globals_.g_vSubstrateBurnishingMinMax4 * _23429);
	                _17191 = _17180 + (_Globals_.g_vSubstrateGrimeMinMax4 * _23429);
	                _17192 = _17185 + (textureGrad(sampler2D(g_tDamage4, g_sTrilinearWrap), _13435.xy, vec2(_12072, _11095), vec2(_12073, _13120)).x * _23429);
	                _17193 = vec4(_17184.xyz + (textureGrad(sampler2D(g_tGrime4, g_sTrilinearWrap), _13436.xy, vec2(_12076, _11099), vec2(_15263, _6641)).xyz * _23429), _17184.w + (_Globals_.g_fGrimeTranslucency4 * _23429));
	                _17194 = _16865 + (_Globals_.g_vDamageMinMax4 * _23429);
	                _17195 = _17172 + (_Globals_.g_fGrimeRoughnessBrightness4 * _23429);
	                _17196 = _17176 + (_Globals_.g_fDamageBevelCloth4 * _23429);
	                _17197 = _17175 + (float(_Globals_.g_bDamageBevelBlendToSubstrate4 != 0) * _23429);
	                _17198 = _17174 + (_Globals_.g_fBurnishingMetalness4 * _23429);
	                _17199 = _17173 + (_Globals_.g_fBurnishingCloth4 * _23429);
	                _17200 = _17171 + (_Globals_.g_fBurnishingGrime4 * _23429);
	                _17201 = _Globals_.g_fBurnishingNormalScale4 * _23429;
	                _17202 = _Globals_.g_fSurfaceBurnishingRoughnessBrightness4 * _23429;
	                _17203 = _Globals_.g_fSubstrateBurnishingRoughnessBrightness4 * _23429;
	                _17204 = _17169 + (_Globals_.g_fDamageHeightBlendSoftness4 * _23429);
	                _17205 = _17170 + (_Globals_.g_fDamageBevelBlendSoftness4 * _23429);
	                _17206 = _17168 + (_Globals_.g_fDamageBevelEmboss4 * _23429);
	                _17207 = _17178 + (_Globals_.g_fDamageBevelAnisotropy4 * _23429);
	                _17208 = _17179 + (_Globals_.g_fDamageBevelRoughnessBrightness4 * _23429);
	                _17209 = _17177 + (_Globals_.g_fDamageBevelMetalness4 * _23429);
	                _17210 = _17186.xyzw + (textureGrad(sampler2D(g_tSubstrateProperties4, g_sTrilinearWrap), input_9.zw, _16496, _19539).xyzw * _23429);
	                _17211 = _17187.xyzw + (textureGrad(sampler2D(g_tSubstrate4, g_sTrilinearWrap), input_9.zw, _16496, _19539).xyzw * _23429);
	                _17212 = _17188.xyzw + (textureGrad(sampler2D(g_tSurfaceProperties4, g_sTrilinearWrap), input_9.zw, _16496, _19539).xyzw * _23429);
	                _13694 = _Globals_.g_bDamageBevelUseTintMask4 != 0;
	                _6616 = _17189.xyzw + (textureGrad(sampler2D(g_tSurface4, g_sTrilinearWrap), input_9.zw, _16496, _19539).xyzw * _23429);
	            }
	            else
	            {
	                _13143 = _17183;
	                _16308 = _17181;
	                _17190 = _17182;
	                _17191 = _17180;
	                _17192 = _17185;
	                _17193 = _17184;
	                _17194 = _16865;
	                _17195 = _17172;
	                _17196 = _17176;
	                _17197 = _17175;
	                _17198 = _17174;
	                _17199 = _17173;
	                _17200 = _17171;
	                _17201 = _13142;
	                _17202 = _16307;
	                _17203 = _17166;
	                _17204 = _17169;
	                _17205 = _17170;
	                _17206 = _17168;
	                _17207 = _17178;
	                _17208 = _17179;
	                _17209 = _17177;
	                _17210 = _17186;
	                _17211 = _17187;
	                _17212 = _17188;
	                _13694 = _17167;
	                _6616 = _17189;
	            }
	            _14876 = _Globals_.g_fPatternPaintRespectsTintMask != 0;
	            if (_14876)
	            {
	                _21710 = _6616.w;
	            }
	            else
	            {
	                _21710 = max(_6616.w, 0.0);
	            }
	            mat4 _19935 = mat4((((_Globals_.g_mSurfaceBurnishingColorAdjust1[0] * _9306) + (_Globals_.g_mSurfaceBurnishingColorAdjust2[0] * _23427)) + (_Globals_.g_mSurfaceBurnishingColorAdjust3[0] * _23428)) + (_Globals_.g_mSurfaceBurnishingColorAdjust4[0] * _23429), (((_Globals_.g_mSurfaceBurnishingColorAdjust1[1] * _9306) + (_Globals_.g_mSurfaceBurnishingColorAdjust2[1] * _23427)) + (_Globals_.g_mSurfaceBurnishingColorAdjust3[1] * _23428)) + (_Globals_.g_mSurfaceBurnishingColorAdjust4[1] * _23429), (((_Globals_.g_mSurfaceBurnishingColorAdjust1[2] * _9306) + (_Globals_.g_mSurfaceBurnishingColorAdjust2[2] * _23427)) + (_Globals_.g_mSurfaceBurnishingColorAdjust3[2] * _23428)) + (_Globals_.g_mSurfaceBurnishingColorAdjust4[2] * _23429), (((_Globals_.g_mSurfaceBurnishingColorAdjust1[3] * _9306) + (_Globals_.g_mSurfaceBurnishingColorAdjust2[3] * _23427)) + (_Globals_.g_mSurfaceBurnishingColorAdjust3[3] * _23428)) + (_Globals_.g_mSurfaceBurnishingColorAdjust4[3] * _23429));
	            _13559 = _17212.x;
	            _16973 = _17212.y;
	            _8530 = _17212.z * (1.0 - _16973);
	            _22892 = _17212.w;
	            vec4 _24833 = vec4(_6616.xyz, 1.0);
	            _14273 = mix(_6616.xyz, (vec4((_24833 * mat4((((_Globals_.g_mSurfaceColorAdjust1[0] * _9306) + (_Globals_.g_mSurfaceColorAdjust2[0] * _23427)) + (_Globals_.g_mSurfaceColorAdjust3[0] * _23428)) + (_Globals_.g_mSurfaceColorAdjust4[0] * _23429), (((_Globals_.g_mSurfaceColorAdjust1[1] * _9306) + (_Globals_.g_mSurfaceColorAdjust2[1] * _23427)) + (_Globals_.g_mSurfaceColorAdjust3[1] * _23428)) + (_Globals_.g_mSurfaceColorAdjust4[1] * _23429), (((_Globals_.g_mSurfaceColorAdjust1[2] * _9306) + (_Globals_.g_mSurfaceColorAdjust2[2] * _23427)) + (_Globals_.g_mSurfaceColorAdjust3[2] * _23428)) + (_Globals_.g_mSurfaceColorAdjust4[2] * _23429), (((_Globals_.g_mSurfaceColorAdjust1[3] * _9306) + (_Globals_.g_mSurfaceColorAdjust2[3] * _23427)) + (_Globals_.g_mSurfaceColorAdjust3[3] * _23428)) + (_Globals_.g_mSurfaceColorAdjust4[3] * _23429))).xyz, _3).xyz * 1.0).xyz, vec3(_21710));
	            _23992 = vec3((_24833 * _19935).xyz);
	            float _21711;
	            if (_14876)
	            {
	                _21711 = _17211.w;
	            }
	            else
	            {
	                _21711 = max(_17211.w, 0.0);
	            }
	            vec3 _11572;
	            _16297 = _17210.x;
	            _6536 = _17210.y;
	            _8531 = _17210.z * (1.0 - _6536);
	            _22893 = _17210.w;
	            vec4 _24834 = vec4(_17211.xyz, 1.0);
	            do
	            {
	                _11572 = (vec4((_24834 * mat4((((_Globals_.g_mSubstrateColorAdjust1[0] * _9306) + (_Globals_.g_mSubstrateColorAdjust2[0] * _23427)) + (_Globals_.g_mSubstrateColorAdjust3[0] * _23428)) + (_Globals_.g_mSubstrateColorAdjust4[0] * _23429), (((_Globals_.g_mSubstrateColorAdjust1[1] * _9306) + (_Globals_.g_mSubstrateColorAdjust2[1] * _23427)) + (_Globals_.g_mSubstrateColorAdjust3[1] * _23428)) + (_Globals_.g_mSubstrateColorAdjust4[1] * _23429), (((_Globals_.g_mSubstrateColorAdjust1[2] * _9306) + (_Globals_.g_mSubstrateColorAdjust2[2] * _23427)) + (_Globals_.g_mSubstrateColorAdjust3[2] * _23428)) + (_Globals_.g_mSubstrateColorAdjust4[2] * _23429), (((_Globals_.g_mSubstrateColorAdjust1[3] * _9306) + (_Globals_.g_mSubstrateColorAdjust2[3] * _23427)) + (_Globals_.g_mSubstrateColorAdjust3[3] * _23428)) + (_Globals_.g_mSubstrateColorAdjust4[3] * _23429))).xyz, _3).xyz * 1.0).xyz;
	                break;
	            } while(false);
	            vec3 _11573;
	            _18503 = mix(_17211.xyz, _11572, vec3(_21711));
	            _12900 = vec3((_24834 * mat4((((_Globals_.g_mSubstrateBurnishingColorAdjust1[0] * _9306) + (_Globals_.g_mSubstrateBurnishingColorAdjust2[0] * _23427)) + (_Globals_.g_mSubstrateBurnishingColorAdjust3[0] * _23428)) + (_Globals_.g_mSubstrateBurnishingColorAdjust4[0] * _23429), (((_Globals_.g_mSubstrateBurnishingColorAdjust1[1] * _9306) + (_Globals_.g_mSubstrateBurnishingColorAdjust2[1] * _23427)) + (_Globals_.g_mSubstrateBurnishingColorAdjust3[1] * _23428)) + (_Globals_.g_mSubstrateBurnishingColorAdjust4[1] * _23429), (((_Globals_.g_mSubstrateBurnishingColorAdjust1[2] * _9306) + (_Globals_.g_mSubstrateBurnishingColorAdjust2[2] * _23427)) + (_Globals_.g_mSubstrateBurnishingColorAdjust3[2] * _23428)) + (_Globals_.g_mSubstrateBurnishingColorAdjust4[2] * _23429), (((_Globals_.g_mSubstrateBurnishingColorAdjust1[3] * _9306) + (_Globals_.g_mSubstrateBurnishingColorAdjust2[3] * _23427)) + (_Globals_.g_mSubstrateBurnishingColorAdjust3[3] * _23428)) + (_Globals_.g_mSubstrateBurnishingColorAdjust4[3] * _23429))).xyz);
	            do
	            {
	                _11573 = (vec4((_24833 * mat4((((_Globals_.g_mDamageColorAdjust1[0] * _9306) + (_Globals_.g_mDamageColorAdjust2[0] * _23427)) + (_Globals_.g_mDamageColorAdjust3[0] * _23428)) + (_Globals_.g_mDamageColorAdjust4[0] * _23429), (((_Globals_.g_mDamageColorAdjust1[1] * _9306) + (_Globals_.g_mDamageColorAdjust2[1] * _23427)) + (_Globals_.g_mDamageColorAdjust3[1] * _23428)) + (_Globals_.g_mDamageColorAdjust4[1] * _23429), (((_Globals_.g_mDamageColorAdjust1[2] * _9306) + (_Globals_.g_mDamageColorAdjust2[2] * _23427)) + (_Globals_.g_mDamageColorAdjust3[2] * _23428)) + (_Globals_.g_mDamageColorAdjust4[2] * _23429), (((_Globals_.g_mDamageColorAdjust1[3] * _9306) + (_Globals_.g_mDamageColorAdjust2[3] * _23427)) + (_Globals_.g_mDamageColorAdjust3[3] * _23428)) + (_Globals_.g_mDamageColorAdjust4[3] * _23429))).xyz, _3).xyz * 1.0).xyz;
	                break;
	            } while(false);
	            _10658 = mix(_14273.xyz, _11573, vec3(_13694 ? _21710 : 1.0));
	            _7078 = vec4((vec4(vec4(_10658.xyz, 1.0).xyz, 1.0) * _19935).xyz, 1.0).xyz;
	            vec2 _23650 = _23299.xz * _17208;
	            _9596 = _23650;
	            _9596.y = mix(_23650.x, _23650.y, _17207);
	        }
	        bool _12914;
	        if (_14875)
	        {
	            _12914 = _Globals_.g_bPatternPaintLayer != 0;
	        }
	        else
	        {
	            _12914 = false;
	        }
	        vec3 _13149;
	        float _16316;
	        float _16480;
	        float _17328;
	        float _17329;
	        vec3 _17330;
	        vec2 _17331;
	        vec3 _17332;
	        float _17333;
	        float _17334;
	        SPIRV_CROSS_BRANCH
	        if (_12914)
	        {
	            float _24063 = _24878.w * (_14876 ? _21710 : 1.0);
	            vec3 _12121 = vec3(_24063);
	            vec3 _10574 = mix(_14273, _24878.xyz, _12121);
	            float _13148;
	            vec3 _16315;
	            float _16479;
	            vec3 _17325;
	            float _17326;
	            float _17327;
	            SPIRV_CROSS_BRANCH
	            if (_14874)
	            {
	                float _9808 = saturate(_9716 - _Globals_.g_fPatternTranslucencyThreshold) * _24063;
	                vec3 _23298 = _12292 + (_20700.xyz * _9716);
	                vec3 _23794 = normalize(((_20826.xyz * (-0.0)).xyz + (_24090 * 1.0)).xyz).xyz;
	                vec3 _10312 = normalize(mix(_23794, _23794 + normalize(cross(dFdyFine(_23298), dFdxFine(_23298))).xyz, vec3(_Globals_.g_fPatternEmboss * _24063))).xyz;
	                float _6702 = dot(_10312, _20826.xyz);
	                vec3 _22887 = vec3(dot(_10312, input_5.xyz), _6702, _4).xyz;
	                _22887.y = _6702 * (-1.0);
	                vec2 _15752 = mix(_14854, normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))), _12121).xy + _22887.xy;
	                vec3 _20488;
	                _20488.x = _15752.x;
	                _20488.y = _15752.y;
	                _13148 = _22892 + ((_Globals_.g_fPatternEmboss < 0.0) ? 0.0 : _9808);
	                _16315 = _20488;
	                _17325 = mix(_10574, _24878.xyz, _12121);
	                _17326 = mix(_17204, 0.0, _9808);
	                _17327 = mix(_17205, 0.00999999977648258209228515625, _9808);
	                _16479 = mix(_17206, max(0.0, _Globals_.g_fPatternEmboss), _9808);
	            }
	            else
	            {
	                _13148 = _22892;
	                _16315 = _14854;
	                _17325 = _10658;
	                _17326 = _17204;
	                _17327 = _17205;
	                _16479 = _17206;
	            }
	            _13149 = _10574;
	            _16316 = _13148;
	            _17328 = mix(_16973, _20706.x, _24063);
	            _17329 = mix(_8530, _Globals_.g_fPatternCloth, _24063);
	            _17330 = _16315;
	            _17331 = mix(_23299.xz, vec2(_20706.y), vec2(_24063));
	            _17332 = _17325;
	            _17333 = _17326;
	            _17334 = _17327;
	            _16480 = _16479;
	        }
	        else
	        {
	            _13149 = _14273;
	            _16316 = _22892;
	            _17328 = _16973;
	            _17329 = _8530;
	            _17330 = _14854;
	            _17331 = _23299.xz;
	            _17332 = _10658;
	            _17333 = _17204;
	            _17334 = _17205;
	            _16480 = _17206;
	        }
	        _13150 = _13149;
	        _16317 = _23992;
	        _17335 = _13559;
	        _17336 = _16316;
	        _17337 = _17328;
	        _17338 = _17329;
	        _17339 = _17330;
	        _17340 = _17331;
	        _17342 = _13143;
	        _17343 = _16308;
	        _17344 = _18503;
	        _17345 = _12900;
	        _17346 = _16297;
	        _17347 = _22893;
	        _17354 = _8531;
	        _17355 = _6536;
	        _17356 = _17190;
	        _17357 = _17191;
	        _17358 = _17332;
	        _17359 = _7078;
	        _17360 = _17192;
	        _17361 = _17333;
	        _17362 = _9596;
	        _17363 = _17193;
	        _17364 = _17194;
	        _17365 = _17195;
	        _17366 = _17334;
	        _17367 = _17209;
	        _17368 = _17196;
	        _17369 = _17197;
	        _17370 = _17198;
	        _17371 = _16480;
	        _17372 = _17199;
	        _17373 = _17200;
	        _17374 = _17201;
	        _13998 = _17202;
	        _23300 = _17203;
	        break;
	    } while(false);
	    vec4 _19374 = texture(sampler2D(g_tObjectProperties, g_sAniso), input_2.xy);
	    float _14499 = _17336 - _17347;
	    float _23339 = ((((2.0 - ((_Globals_.g_fWearProgress * (_17364.y - _17364.x)) + _17364.x)) - _17360) - _19374.y) - _17336) + _14499;
	    float _17421 = smoothstep(-_17361, _17361, (_23339 * _14499) / _17361);
	    float _6540 = max(min(_17336, saturate(_23339)), _17347);
	    float _15773 = _23339 / _17366;
	    float _10873 = smoothstep(1.0 + _17366, 1.0 - _17366, _15773);
	    float _22419 = saturate(_15773);
	    float _8519 = saturate((_Globals_.g_fWearProgress - 1.0) + _19374.z) * (_6540 + _Globals_.g_fWearProgress);
	    float _10058 = smoothstep(_17356.x, _17356.y, _8519);
	    float _7769 = saturate(_8519);
	    float _20239 = _19374.x * mix(mix(_17346, _17335, _17421) * saturate(1.0 - ((((saturate((_6540 + 0.00999999977648258209228515625) / _17361) * (1.0 - saturate((_6540 - 0.00999999977648258209228515625) / _17361))) * _17421) * _17336) * 0.75)), 1.0, _10058);
	    vec3 _9818 = mix(_17344, _17345, vec3(_10058));
	    vec3 _12925 = vec3(smoothstep(_17342.x, _17342.y, _8519));
	    vec4 _19375 = texture(sampler2D(g_tNormal, g_sAniso), input_2.xy);
	    float _16000 = _19375.x;
	    float _19720 = _19375.y;
	    float _16786 = (_16000 + _19720) - 1.00392162799835205078125;
	    float _11179 = _16000 - _19720;
	    vec3 _19308 = normalize(vec3(vec2(_16786, _11179), (1.0 - abs(_16786)) - abs(_11179)));
	    float _20108 = mix(1.0, _17374, _7769);
	    vec2 _22350 = vec2(_17421);
	    vec2 _23011 = _19308.xy + (mix(_23430, _17339.xy, _22350) * _20108);
	    vec3 _12524;
	    if (_20058)
	    {
	        _12524 = -_14435;
	    }
	    else
	    {
	        _12524 = _14435;
	    }
	    vec3 _12052 = _20700.xyz;
	    vec3 _23301 = _12292 + (_12052 * _15773);
	    vec3 _10113 = dFdxFine(_23301);
	    vec3 _19987 = dFdyFine(_23301);
	    vec3 _23795 = normalize((((input_5.xyz * _23011.x).xyz + (_12524.xyz * (-_23011.y))).xyz + (_24090 * _19308.z)).xyz).xyz;
	    vec3 _24283 = normalize(mix(_23795, _23795 + normalize(cross(_19987, _10113)).xyz, vec3((((smoothstep(-_17366, _17366, _15773) * _10873) * _20108) * _17371) * _14499)));
	    vec2 _18006 = mix(_13192.xz, mix(_17340.xy, _17362.xy, vec2(_10873)), _22350).xy * mix(1.0, mix(_23300, _13998, _22419), _7769);
	    float _11266 = (_6540 * _20239) * (_Globals_.g_fWearProgress * 2.0);
	    float _19211 = mix(smoothstep(_17357.x, _17357.y, _11266), smoothstep(_17343.x, _17343.y, _11266), mix(_17421, 1.0 - _10873, _17369)) * (1.0 - min(_18006.x, _18006.y));
	    float _13429 = mix(_19211, max(_19211, _17373), _7769) * _17363.w;
	    vec2 _15248 = mix(_18006.xy, _18006.xx * _17365, vec2(_13429));
	    float _9119 = mix(mix(_17355, mix(_17337, _17367, _10873), _17421), _17370, _7769) * (1.0 - _13429);
	    float _22811 = 1.0 - _9119;
	    float _7397 = mix(mix(_17354, mix(_17338, _17368, _10873), _17421), _17372, _7769) * _22811;
	    vec3 _9327 = mix(mix(_9818, mix(mix(_13150, _16317, _12925), mix(mix(_17358, _17359, _12925), _9818, vec3(_17369 * (1.0 - _22419))), vec3(_10873)), vec3(_17421)).xyz, _17363.xyz, vec3(_13429)).xyz;
	    vec3 _8357 = vec3(_Globals_.g_flReflectance);
	    bool _14878 = _Globals_.g_bClothShading != 0;
	    vec3 _19648;
	    SPIRV_CROSS_BRANCH
	    if (_14878)
	    {
	        _19648 = mix(_8357.xyz, saturate(sqrt(_9327) * _Globals_.g_flSheenScale), vec3(_7397));
	    }
	    else
	    {
	        _19648 = _8357;
	    }
	    vec3 _12351 = mix(_19648.xyz, _9327, vec3(_9119));
	    vec3 _15460 = mix(vec3(1.0), _24283, bvec3(all(bvec3(true))));
	    vec2 _15595 = _15248.xy / _15248.yx;
	    float _10921 = _15595.y;
	    float _18219 = _15595.x;
	    vec3 _13505 = _15460.xyz;
	    vec3 _10949 = normalize(cross(_12524.xyz, _13505));
	    vec3 _20096 = normalize(cross(_13505, input_5.xyz));
	    vec3 _22222 = _20700.xyz;
	    vec3 _20136 = dFdx(_22222);
	    vec3 _9175 = dFdy(_22222);
	    vec3 _10347 = _20136.xyz;
	    vec3 _12422 = _9175.xyz;
	    vec2 _11004 = max(_15248.xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12422, _12422))), 0.333000004291534423828125)));
	    vec3 _10170 = -_20700;
	    vec3 _24735 = _24283.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    vec3 _18708 = vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _23875));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    float _21720;
	    if (_24465.x)
	    {
	        vec2 _10570 = ((floor(_18180.xy * PerViewConstantBufferCsgo_t._m6) * PerViewConstantBufferCsgo_t._m5.xy) + (PerViewConstantBufferCsgo_t._m5.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10570).xyzw - _18180.zzzz;
	        float _18579 = _18418.w;
	        float _12015 = _18418.z;
	        bool _12288 = abs(_12015) < _18579;
	        vec2 _23168;
	        if (_12288)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m5.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _21014 = _12288 ? _12015 : _18579;
	        float _15372 = _18418.x;
	        bool _12289 = abs(_15372) < _21014;
	        vec2 _23169;
	        if (_12289)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m5.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10017 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m7.x * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.y * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.z * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.w * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m6._m0[0].xyz, _12052), dot(PerViewLightingConstantBufferGpu_t._m6._m0[1].xyz, _12052), dot(PerViewLightingConstantBufferGpu_t._m6._m0[2].xyz, _12052), dot(PerViewLightingConstantBufferGpu_t._m6._m0[3].xyz, _12052)).xyzw, vec4(0.0)) * normalize(saturate(((_10017 - vec4(max(max(_10017.x, _10017.y), max(_10017.z, _10017.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0)));
	        _21720 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m8.x)) * (PerViewLightingConstantBufferGpu_t._m8.x + dot(_13232, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10570 + mix(_23169, PerViewConstantBufferCsgo_t._m5.xy, bvec2(abs(_18418.y) < (_12289 ? _15372 : _21014))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21720 = 1.0;
	    }
	    float _21721;
	    if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).w)
	    {
	        _21721 = _21720 * textureLod(sampler2D(g_tSsao, g_sUserConfig), (_18180.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _21721 = _21720;
	    }
	    float _21722;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m18 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13151;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m18))
	            {
	                _13151 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18348 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m25._m0[_13039];
	            float _12779 = _18348.x;
	            if (max(abs(_12779), abs(_18348.y)) < PerViewLightingConstantBufferGpu_t._m20[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18348.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - saturate((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m22)) + vec2(PerViewLightingConstantBufferGpu_t._m21));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m26._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_13039].xy;
	                vec3 _20489 = _19470;
	                _20489.x = _20561.x;
	                _20489.y = _20561.y;
	                _13151 = saturate(_22193.x * _22193.y);
	                _14975 = _20489;
	                _10191 = _13039;
	                break;
	            }
	            _23989 = _13039 + 1;
	            _13039 = _23989;
	            continue;
	        }
	        float _19363;
	        if (_10191 >= 0)
	        {
	            vec2 _7045;
	            vec2 _7046;
	            vec2 _7735;
	            float _8969;
	            float _8970;
	            float _15997;
	            float _17375;
	            vec2 _18870;
	            vec4 _20581;
	            vec4 _22023;
	            float _23727;
	            do
	            {
	                float _21472 = saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m19);
	                _20581 = PerViewLightingConstantBufferGpu_t._m0;
	                _22023 = PerViewLightingConstantBufferGpu_t._m1;
	                _17375 = PerViewLightingConstantBufferGpu_t._m2.z;
	                _15997 = PerViewLightingConstantBufferGpu_t._m3.z;
	                _18870 = vec2(_17375, _15997);
	                _8969 = PerViewLightingConstantBufferGpu_t._m2.y;
	                _7045 = vec2(_8969, _15997);
	                _8970 = PerViewLightingConstantBufferGpu_t._m3.y;
	                _7046 = vec2(_17375, _8970);
	                _7735 = vec2(_8969, _8970);
	                float _15310 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _18870).xy, _21472), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7045).xy, _21472), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7046).xy, _21472), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7735).xy, _21472), 0.0)).xyzw, vec4(0.25));
	                bool _12915;
	                if (_15310 == 0.0)
	                {
	                    _12915 = true;
	                }
	                else
	                {
	                    _12915 = _15310 == 1.0;
	                }
	                if (_12915)
	                {
	                    _23727 = _15310;
	                    break;
	                }
	                _23727 = ((_15310 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_17375, 0.0)).xy, _21472), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_8969, 0.0)).xy, _21472), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _8970)).xy, _21472), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _15997)).xy, _21472), 0.0)).xyzw, _22023.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, _21472), 0.0) * _22023.y);
	                break;
	            } while(false);
	            float _12502;
	            SPIRV_CROSS_BRANCH
	            if (_13151 < 1.0)
	            {
	                float _7990;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m18 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_0.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m25._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m26._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_15335].xy;
	                    vec3 _20490;
	                    _20490.x = _20562.x;
	                    _20490.y = _20562.y;
	                    float _12501;
	                    do
	                    {
	                        float _20322 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m19);
	                        float _15311 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20490.xy + _18870).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20490.xy + _7045).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20490.xy + _7046).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20490.xy + _7735).xy, _20322), 0.0)).xyzw, vec4(0.25));
	                        bool _12916;
	                        if (_15311 == 0.0)
	                        {
	                            _12916 = true;
	                        }
	                        else
	                        {
	                            _12916 = _15311 == 1.0;
	                        }
	                        if (_12916)
	                        {
	                            _12501 = _15311;
	                            break;
	                        }
	                        _12501 = ((_15311 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20490.xy + vec2(_17375, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20490.xy + vec2(_8969, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20490.xy + vec2(0.0, _8970)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20490.xy + vec2(0.0, _15997)).xy, _20322), 0.0)).xyzw, _22023.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20490.xy, _20322), 0.0) * _22023.y);
	                        break;
	                    } while(false);
	                    _7990 = _12501;
	                }
	                else
	                {
	                    _7990 = 1.0;
	                }
	                _12502 = mix(_7990, _23727, _13151);
	            }
	            else
	            {
	                _12502 = _23727;
	            }
	            _19363 = _12502;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _13279 = mix(_19363, 1.0, saturate((distance(_12292.xyz, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m24) + PerViewLightingConstantBufferGpu_t._m23));
	        float _12503;
	        if (_24465.y)
	        {
	            _12503 = min(_13279, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_18180.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12503 = _13279;
	        }
	        _21722 = _12503;
	    }
	    else
	    {
	        _21722 = 1.0;
	    }
	    vec3 _9717;
	    vec3 _24892;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _24735) * _21722) > 0.0)
	    {
	        float _11797 = max(0.0, dot(_24283.xyz, PerViewLightingConstantBufferGpu_t._m16.xyz));
	        vec2 _9842 = max(_11004, vec2(PerViewLightingConstantBufferGpu_t._m16.w));
	        vec3 _21889 = (-normalize(_12292.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz;
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m16.xyz + _21889).xyz;
	        vec3 _17701 = mix(_15460, _24735, bvec3(all(equal(_15460, vec3(1.0))))).xyz;
	        float _7800 = dot(_12281, _17701);
	        float _25073 = max(0.0, dot(_17701, _21889));
	        vec3 _22315 = _12351.xyz;
	        vec2 _15877 = _9842.xy;
	        vec2 _21239 = _15877 * _15877;
	        vec3 _14557 = (vec3(dot(_12281, _10949.xyz), dot(_12281, _20096.xyz), _7800) / vec3(_21239.xy, 1.0)).xyz;
	        float _17622 = dot(_14557, _14557);
	        float _11847 = max(_9842.x, _9842.y) + 1.0;
	        float _6835 = _11847 * (_11847 * 0.125);
	        float _19568 = 1.0 - _6835;
	        float _18393 = 1.0 / ((_17622 * ((_17622 * _21239.x) * _21239.y)) * ((4.0 * ((_11797 * _19568) + _6835)) * ((_25073 * _19568) + _6835)));
	        float _11621;
	        SPIRV_CROSS_BRANCH
	        if (_14878)
	        {
	            float _9251 = dot(_9842.xy, vec2(0.5));
	            float _20829 = max(_9251 * _9251, 9.9999997473787516355514526367188e-06);
	            float _21401 = saturate(_25073 + 0.001000000047497451305389404296875);
	            _11621 = mix(_18393, ((((2.0 + (1.0 / _20829)) * pow(1.0 - (_7800 * _7800), 0.5 / _20829)) / ((_11797 + _21401) - (_11797 * _21401))) * 0.124999918043613433837890625) * _11797, _7397);
	        }
	        else
	        {
	            _11621 = _18393;
	        }
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m17.xyz * _21722).xyz;
	        _9717 = PerViewLightingConstantBufferGpu_t._m9.xyz + (vec3(_11797).xyz * _16808);
	        _24892 = (((_22315 + ((vec3(1.0) - _22315) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _12281))), 5.0))) * _11621).xyz * _11797).xyz * _16808;
	    }
	    else
	    {
	        _9717 = PerViewLightingConstantBufferGpu_t._m9.xyz;
	        _24892 = vec3(0.0);
	    }
	    bvec4 _24467 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20061 = _24467.x;
	    vec4 _19364;
	    if (_20061)
	    {
	        vec4 _18621 = vec4(_12292.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m4;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6652;
	        _6652.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m1.x) * 0.5, 0.0, PerViewConstantBuffer_t._m1.x - 1.0);
	        _6652.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m1.y) * 0.5, 0.0, PerViewConstantBuffer_t._m1.y - 1.0);
	        _6652.w = _20176;
	        _19364 = _6652;
	    }
	    else
	    {
	        _19364 = _18180;
	    }
	    uvec2 _7709 = uvec2(PerViewLightingConstantBufferGpu_t._m12.x);
	    uvec2 _12084 = uvec2(_19364.xy - PerViewConstantBuffer_t._m0.xy) >> _7709;
	    uint _10875 = PerViewLightingConstantBufferGpu_t._m10.y + (((_12084.y * PerViewLightingConstantBufferGpu_t._m12.y) + _12084.x) * PerViewLightingConstantBufferGpu_t._m10.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m10.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m10.z);
	    vec3 _13152;
	    vec3 _16324;
	    _13152 = _9717;
	    _16324 = _24892;
	    uint _21580;
	    vec3 _13153;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m10.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10875 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13153 = _16324;
	        _16325 = _13152;
	        uint _20344;
	        vec3 _13212;
	        vec3 _15676;
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
	                vec4 _24896 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_0.xyz, 1.0);
	                vec3 _10521 = _24896.xyz / vec3(_24896.w);
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
	                bool _12917;
	                if (!_7424)
	                {
	                    _12917 = true;
	                }
	                else
	                {
	                    _12917 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_0.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12917)
	                {
	                    _13212 = _13153;
	                    _15676 = _16325;
	                    break;
	                }
	                float _23613 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17383 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17383 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16294 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23613 * g_BarnLights_1._m0[_12608]._m5.z) + (_17383 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = smoothstep(0.0, 1.0, _21775 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21775) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11180;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10019 = g_BarnLights_1._m0[_12608]._m2.xyz - input_0.xyz;
	                    float _18351 = dot(_10019, _10019);
	                    float _17647 = sqrt(_18351);
	                    vec3 _21019 = _10019 - _16294;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10019 + _16294) - _21019;
	                        float _25105 = dot(-_21019, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _21019;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _21019 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11180 = _10019 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18351, g_BarnLights_1._m0[_12608]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23613 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17383 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11180 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24419 = !_20061;
	                }
	                else
	                {
	                    _24419 = false;
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
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15017 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
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
	                    vec3 _12505;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11180).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23614 = _17795.xyz;
	                        vec3 _12176 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23614 * _15156)) + cross(_23614, _20479);
	                        vec3 _14156 = vec3(vec2(atan(_12176.y, -_12176.x) * 0.15915493667125701904296875, acos(_12176.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14156.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20492 = _14156;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12505 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20492.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12505 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20491.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12505;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13153;
	                    _15676 = _16325;
	                    break;
	                }
	                vec3 _22671;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23715 = _21642;
	                        _23715.x = _6281.x;
	                        _23715.y = _6281.y;
	                        _19629 = _23715;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m19);
	                        vec2 _14616 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy;
	                        float _15312 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0)).xyzw, vec4(0.25));
	                        bool _12918;
	                        if (_15312 == 0.0)
	                        {
	                            _12918 = true;
	                        }
	                        else
	                        {
	                            _12918 = _15312 == 1.0;
	                        }
	                        if (_12918)
	                        {
	                            _24972 = _15312;
	                            break;
	                        }
	                        _24972 = ((_15312 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14616, _11455), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19878 = _21548.xyz * mix(1.0, _24972, g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_19878.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13153;
	                        _15676 = _16325;
	                        break;
	                    }
	                    _22671 = _19878;
	                }
	                else
	                {
	                    _22671 = _21548;
	                }
	                float _11798 = max(0.0, dot(_24283.xyz, _11180.xyz));
	                vec2 _9843 = max(_11004, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _21890 = (-normalize(_12292.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz;
	                vec3 _12290 = normalize(_11180.xyz + _21890).xyz;
	                vec3 _17702 = mix(_15460, _24735, bvec3(all(equal(_15460, vec3(1.0))))).xyz;
	                float _7801 = dot(_12290, _17702);
	                float _25074 = max(0.0, dot(_17702, _21890));
	                vec3 _22316 = _12351.xyz;
	                vec2 _15878 = _9843.xy;
	                vec2 _21240 = _15878 * _15878;
	                vec3 _14559 = (vec3(dot(_12290, _10949.xyz), dot(_12290, _20096.xyz), _7801) / vec3(_21240.xy, 1.0)).xyz;
	                float _17623 = dot(_14559, _14559);
	                float _11848 = max(_9843.x, _9843.y) + 1.0;
	                float _6836 = _11848 * (_11848 * 0.125);
	                float _19569 = 1.0 - _6836;
	                float _18395 = 1.0 / ((_17623 * ((_17623 * _21240.x) * _21240.y)) * ((4.0 * ((_11798 * _19569) + _6836)) * ((_25074 * _19569) + _6836)));
	                float _11622;
	                SPIRV_CROSS_BRANCH
	                if (_14878)
	                {
	                    float _9254 = dot(_9843.xy, vec2(0.5));
	                    float _20830 = max(_9254 * _9254, 9.9999997473787516355514526367188e-06);
	                    float _21402 = saturate(_25074 + 0.001000000047497451305389404296875);
	                    _11622 = mix(_18395, ((((2.0 + (1.0 / _20830)) * pow(1.0 - (_7801 * _7801), 0.5 / _20830)) / ((_11798 + _21402) - (_11798 * _21402))) * 0.124999918043613433837890625) * _11798, _7397);
	                }
	                else
	                {
	                    _11622 = _18395;
	                }
	                _13212 = _13153.xyz + ((((_22316 + ((vec3(1.0) - _22316) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(_11180.xyz, _12290))), 5.0))) * _11622).xyz * _11798).xyz * _22671.xyz);
	                _15676 = _16325.xyz + (vec3(_11798).xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13153 = _13212;
	            _16325 = _15676;
	            _17018 = _20344;
	            continue;
	        }
	        _21580 = _17017 + 1u;
	        _13152 = _16325;
	        _16324 = _13153;
	        _17017 = _21580;
	        continue;
	    }
	    vec3 _19128 = _12292.xyz;
	    vec3 _10145 = normalize(_19128 - PerViewConstantBuffer_t._m3.xyz);
	    vec3 _19257 = -_10145;
	    float _17382 = _11004.x + _11004.y;
	    float _19582 = _17382 * _17382;
	    vec3 _22447 = vec3(1.0) + (_12351 * ((0.125 * (_19582 * _19582)) * saturate(dot(_15460, _19257))));
	    vec3 _10288;
	    SPIRV_CROSS_BRANCH
	    if (_14878)
	    {
	        _10288 = mix(_22447, vec3(1.0), vec3(_7397));
	    }
	    else
	    {
	        _10288 = _22447;
	    }
	    float _17751 = dot(_11004.xy, vec2(0.5));
	    vec3 _16992 = _19257.xyz;
	    vec3 _23064 = mix(_10949.xyz, _20096.xyz, vec3(step(_10921, _18219))).xyz;
	    vec3 _11082 = normalize(mix(_15460.xyz, normalize(cross(cross(_16992, _23064).xyz, _23064)).xyz, vec3((1.0 - min(_18219, _10921)) * 0.5)));
	    vec3 _19630;
	    SPIRV_CROSS_BRANCH
	    if (_14878)
	    {
	        _19630 = mix(_11082, _15460, vec3(_7397));
	    }
	    else
	    {
	        _19630 = _11082;
	    }
	    float _23616 = PerViewLightingConstantBufferGpu_t._m14.y * sqrt(_17751);
	    float _17389 = _17751 * _17751;
	    float _20712 = saturate(1.0 - _17389);
	    vec3 _25271 = normalize(mix(_19630, reflect(_10145.xyz, _19630.xyz).xyz, vec3(_20712 * (sqrt(_20712) + _17389))));
	    uvec2 _6814 = uvec2(_18180.xy - PerViewConstantBuffer_t._m0.xy) >> _7709;
	    uint _19949 = PerViewLightingConstantBufferGpu_t._m11.y + (((_6814.y * PerViewLightingConstantBufferGpu_t._m12.y) + _6814.x) * PerViewLightingConstantBufferGpu_t._m11.z);
	    uint _23394 = PerViewLightingConstantBufferGpu_t._m11.x + (uint(clamp(_6864 * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m11.z);
	    vec4 _13154;
	    float _16320;
	    vec3 _17390;
	    _13154 = vec4(0.0);
	    _16320 = 0.00999999977648258209228515625;
	    _17390 = vec3(0.0);
	    uint _8896;
	    vec4 _13158;
	    vec3 _14891;
	    float _16322;
	    bool _18379;
	    uint _17019 = 0u;
	    bool _17391 = false;
	    for (;;)
	    {
	        bool _12926;
	        if (_17019 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12926 = !_17391;
	        }
	        else
	        {
	            _12926 = false;
	        }
	        if (!_12926)
	        {
	            break;
	        }
	        uint _14476 = subgroupOr(g_CullBits_1._m0[_19949 + _17019] & g_CullBits_1._m0[_23394 + _17019]);
	        vec3 _13155;
	        vec4 _16321;
	        _13155 = _17390;
	        _16321 = _13154;
	        uint _10159;
	        vec3 _13157;
	        vec4 _16382;
	        float _16481;
	        uint _17020 = _14476;
	        float _17393 = _16320;
	        for (;;)
	        {
	            if (!(_17020 != 0u))
	            {
	                _13158 = _16321;
	                _16322 = _17393;
	                _14891 = _13155;
	                _18379 = _17391;
	                break;
	            }
	            uint _18181 = uint(findLSB(_17020));
	            int _12609 = int(_18181 + (_17019 * 32u));
	            _10159 = _17020 & (_17020 - 1u);
	            vec3 _24589 = PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0 * vec4(_19128, 1.0);
	            vec3 _7749 = _24589.xyz;
	            vec3 _8793 = saturate((_7749 - PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1) * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m4.xyz);
	            vec3 _19651 = saturate((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3 - _7749) * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m4.xyz);
	            float _17395 = min(min(_8793.x, min(_8793.y, _8793.z)), min(_19651.x, min(_19651.y, _19651.z)));
	            if (_17395 == 0.0)
	            {
	                _13157 = _13155;
	                _16382 = _16321;
	                _16481 = _17393;
	                _13155 = _13157;
	                _16321 = _16382;
	                _17393 = _16481;
	                _17020 = _10159;
	                continue;
	            }
	            vec3 _24234 = _24589.xyz;
	            vec3 _7712 = (PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0 * vec4(_25271.xyz, 0.0)).xyz;
	            vec3 _11299 = max(((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3.xyz - _24234) / _7712).xyz, ((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1.xyz - _24234) / _7712).xyz);
	            float _11076 = ((_17395 * _17395) * (((-2.0) * _17395) + 3.0)) * (1.0 - _17393);
	            float _13733 = _17393 + _11076;
	            vec3 _15431 = _13155 + ((textureLod(samplerCubeArray(g_tEnvironmentMap, g_sTrilinearWrap), vec4(mix(_24234 + (_7712 * abs(min(_11299.x, min(_11299.y, _11299.z)))), _7712, vec3(_17751)).xyz, float(PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m2)), _23616).xyz * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m5) * _11076);
	            vec4 _7460 = _16321 + (PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m6 * _11076);
	            if (_13733 > 0.9900000095367431640625)
	            {
	                _13158 = _7460;
	                _16322 = _13733;
	                _14891 = _15431;
	                _18379 = true;
	                break;
	            }
	            _13157 = _15431;
	            _16382 = _7460;
	            _16481 = _13733;
	            _13155 = _13157;
	            _16321 = _16382;
	            _17393 = _16481;
	            _17020 = _10159;
	            continue;
	        }
	        _8896 = _17019 + 1u;
	        _13154 = _13158;
	        _16320 = _16322;
	        _17390 = _14891;
	        _17391 = _18379;
	        _17019 = _8896;
	        continue;
	    }
	    float _20784 = max(0.0, dot(_16992, _13505));
	    vec4 _11487 = textureLod(sampler2DArray(g_tBRDFLookup, g_sBilinearClamp), vec3((vec2(_17751, sqrt(1.0 - _20784)) * 0.984375) + vec2(0.0078125), 1.0).xyz, 0.0);
	    vec3 _19001 = mix(_11487.xxx, _11487.yyy, _12351);
	    float _10020;
	    vec3 _23472;
	    SPIRV_CROSS_BRANCH
	    if (_14878)
	    {
	        float _7173 = dot(normalize(_13505 + _16992).xyz, _13505);
	        float _22187 = max(_17389, 9.9999997473787516355514526367188e-06);
	        float _21363 = saturate(_20784 + 0.001000000047497451305389404296875);
	        _10020 = 1.0 - _7397;
	        _23472 = mix(_19001, _12351 * ((((2.0 + (1.0 / _22187)) * pow(1.0 - (_7173 * _7173), 0.5 / _22187)) / ((1.0 + _21363) - _21363)) * 0.124999918043613433837890625), vec3(_7397));
	    }
	    else
	    {
	        _10020 = 1.0;
	        _23472 = _19001;
	    }
	    float _8850 = 1.0 - _11487.y;
	    vec3 _15517 = _12351 + ((vec3(1.0) - _12351) * vec3(0.0476190485060214996337890625));
	    vec3 _20883 = ((_23472 * _15517) / (vec3(1.0) - (_15517 * _8850))) * _8850;
	    vec3 _13440 = vec3(_21721 * _20239).xyz;
	    vec3 _22686 = (_13152.xyz + ((_18708 * mix(vec3(1.0), vec3(1.0) - (_23472 + _20883), vec3(_10020))).xyz * _13440).xyz) * (_9327 * _22811).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_3.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15753 = _11203.xyz + ((_16324 * _10288).xyz * _13440).xyz;
	    vec4 _20493 = _11203;
	    _20493.x = _15753.x;
	    _20493.y = _15753.y;
	    _20493.z = _15753.z;
	    vec3 _15733 = _20493.xyz + ((((_17390 / vec3(_16320)).xyz * min(dot(_18708.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_19630.xyz, 1.0), (_13154 / vec4(_16320)).xyzw), max((_17751 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz * (_23472 + (_20883 * _10020))).xyz * _13440).xyz;
	    vec4 _13888 = _20493;
	    _13888.x = _15733.x;
	    _13888.y = _15733.y;
	    _13888.z = _15733.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _12292.xyz - PerViewConstantBuffer_t._m3.xyz;
	        vec3 _9057 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12928;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m10.x)
	            {
	                _12928 = (_12292.z * PerViewConstantBufferCsgo_t._m10.z) < PerViewConstantBufferCsgo_t._m10.y;
	            }
	            else
	            {
	                _12928 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12928)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m7.xy + (PerViewConstantBufferCsgo_t._m7.zw * vec2(length(_21493), _12292.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m8.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m8.y)) * PerViewConstantBufferCsgo_t._m9.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m9.xyz, _12872).xyz, vec3(_12872));
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
	            bool _12930;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m14.x)
	            {
	                _12930 = (PerViewConstantBufferCsgo_t._m14.z * _12292.z) < PerViewConstantBufferCsgo_t._m14.y;
	            }
	            else
	            {
	                _12930 = false;
	            }
	            if (_12930)
	            {
	                float _14602 = saturate(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m11.y) + PerViewConstantBufferCsgo_t._m11.x), PerViewConstantBufferCsgo_t._m11.w)) * saturate(pow(max(0.0, (_12292.z * PerViewConstantBufferCsgo_t._m12.y) + PerViewConstantBufferCsgo_t._m12.x), PerViewConstantBufferCsgo_t._m12.z));
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m14.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((PerViewConstantBufferCsgo_t._m13 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m12.w * saturate(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m11.z))) * PerViewConstantBufferCsgo_t._m15.x).xyz, _8892).xyz, vec3(_8892));
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
	
	
	
	IntAttribute(MaterialLayerCount, 4);
	StringAttribute(MaterialLayerRefType, csgo_textile_layer);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	// Variant parameters
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	
	IntAttribute(MaterialLayerCount, 4);
	StringAttribute(MaterialLayerRefType, csgo_textile_layer);
	
}
