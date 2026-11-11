//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Environment shader with blended layers";
	DevShader = false;
	Version = 9;
	
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
	Feature( F_BLEND_BY_FACING_DIRECTION_2, 0..1, "Layer 2" );
	Feature( F_ENABLE_LAYER_3, 0..1, "Layer 3" );
	Feature( F_BLEND_BY_FACING_DIRECTION_3, 0..1, "Layer 3" );
	Feature( F_BLEND_EFFECTS_2, 0..1, "Layer 2" );
	Feature( F_BORDER_ROUGHNESS_2, 0..1, "Layer 2" );
	Feature( F_BORDER_BLEND_MODE_2, 0..3 (0="Multiply", 1="Replace", 2="Mod2x", 3="Colorize"), "Layer 2" );
	Feature( F_BLEND_EFFECTS_3, 0..1, "Layer 3" );
	Feature( F_BORDER_ROUGHNESS_3, 0..1, "Layer 3" );
	Feature( F_BORDER_BLEND_MODE_3, 0..3 (0="Multiply", 1="Replace", 2="Mod2x", 3="Colorize"), "Layer 3" );
	Feature( F_DETAIL_NORMAL, 0..1, "Detail" );
	Feature( F_WETNESS, 0..1, "Wetness" );
	Feature( F_USE_NEW_BLENDING, 0..1, "Blending" );
	Feature( F_SHARED_COLOR_OVERLAY, 0..1, "Color Effects" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_DEPTH_BIAS, 0..1, "Z-Buffering" );
	Feature( F_OCCLUSION_CULLING_BOUNDS_SCALE, 0..1, "Z-Buffering" );
	Feature( F_PIXEL_DEPTH_OFFSET, 0..1, "Pixel Depth Offset" );
	Feature( F_PARALLAX_OCCLUSION, 0..1, "Parallax Occlusion" );
	Feature( F_ENABLE_VISUALIZATIONS, 0..1, "Visualizations" );
	Feature( F_VISUALIZATION_MODE, 0..4 (0="Show Blending", 1="Show Final Heights", 2="Show Vertex Painting", 3="Show Detail Prop Masks", 4="Show Parallax Grid"), "Visualizations" );
	Feature( F_BLEND_EFFECTS, 0..0, "F_BLEND_EFFECTS_2" );
	Feature( F_BORDER_ROUGHNESS, 0..0, "F_BORDER_ROUGHNESS_2" );
	Feature( F_BORDER_BLEND_MODE, 0..0, "F_BORDER_BLEND_MODE_2" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Requires( F_BLEND_BY_FACING_DIRECTION_3, F_ENABLE_LAYER_3 ), "Blend by Facing Direction 3 requires Enable Layer 3" );
	FeatureRule( Requires( F_BORDER_ROUGHNESS_2, F_BLEND_EFFECTS_2 ), "Border Roughness requires Blend Effects" );
	FeatureRule( Requires( F_BORDER_BLEND_MODE_2, F_BLEND_EFFECTS_2 ), "Border Roughness requires Blend Effects" );
	FeatureRule( Requires( F_BLEND_EFFECTS_3, F_ENABLE_LAYER_3 ), "Blend Effects for Layer 3 requries Enable Layer 3" );
	FeatureRule( Requires( F_BORDER_ROUGHNESS_3, F_BLEND_EFFECTS_3 ), "Border Roughness 3 requires Blend Effects 3" );
	FeatureRule( Requires( F_BORDER_BLEND_MODE_3, F_BLEND_EFFECTS_3 ), "Border Roughness 3 requires Blend Effects 3" );
	FeatureRule( Allow1( F_DISABLE_Z_BUFFERING, F_DEPTH_BIAS ), "Z Bias and Disable Z Buffering are not compatible" );
	FeatureRule( Allow1( F_PIXEL_DEPTH_OFFSET, F_ALPHA_TEST ), "Pixel Depth Offset is not compatible with alpha test" );
	FeatureRule( Requires( F_VISUALIZATION_MODE, F_ENABLE_VISUALIZATIONS ), "Enable Visualization Mode" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_MODE_DEPTH=0, D_CS_VERTEX_ANIMATION=1, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;        
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;               
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;            // S_MODE_DEPTH=0, D_CS_VERTEX_ANIMATION=1, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST=1
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_MODE_DEPTH=0, D_CS_VERTEX_ANIMATION=1, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST=1
	float4 vColorBlendValues          : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;    // S_MODE_DEPTH=0, D_CS_VERTEX_ANIMATION=1, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST=1
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_PIXEL_DEPTH_OFFSET, F_PIXEL_DEPTH_OFFSET );
	StaticCombo( S_SHARED_COLOR_OVERLAY, F_SHARED_COLOR_OVERLAY );
	StaticCombo( S_ENABLE_LAYER_3, F_ENABLE_LAYER_3 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
	StaticComboRule( Allow1( S_PIXEL_DEPTH_OFFSET, S_ALPHA_TEST ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	bool g_bTexCoord2ScaleByModel < UiType(CheckBox); Expression(g_nScaleTexCoord2UByModelScaleAxis!=0 || g_nScaleTexCoord2VByModelScaleAxis!=0); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression(g_nScaleTexCoordUByModelScaleAxis!=0 || g_nScaleTexCoordVByModelScaleAxis!=0); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vDetailTexCoordXform0_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale1.x,-v2*g_vDetailTexCoordScale1.y,0,g_vDetailTexCoordCenter1.x+g_vDetailTexCoordOffset1.x+v2*g_vDetailTexCoordCenter1.y-v1*g_vDetailTexCoordCenter1.x)); >;
	float4 g_vDetailTexCoordXform0_2 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale2.x,-v2*g_vDetailTexCoordScale2.y,0,g_vDetailTexCoordCenter2.x+g_vDetailTexCoordOffset2.x+v2*g_vDetailTexCoordCenter2.y-v1*g_vDetailTexCoordCenter2.x)); >;
	float4 g_vDetailTexCoordXform0_3 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation3*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale3.x,-v2*g_vDetailTexCoordScale3.y,0,g_vDetailTexCoordCenter3.x+g_vDetailTexCoordOffset3.x+v2*g_vDetailTexCoordCenter3.y-v1*g_vDetailTexCoordCenter3.x)); >;
	float4 g_vDetailTexCoordXform1_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale1.x,v1*g_vDetailTexCoordScale1.y,0,g_vDetailTexCoordCenter1.y+g_vDetailTexCoordOffset1.y-(v2*g_vDetailTexCoordCenter1.x+v1*g_vDetailTexCoordCenter1.y))); >;
	float4 g_vDetailTexCoordXform1_2 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale2.x,v1*g_vDetailTexCoordScale2.y,0,g_vDetailTexCoordCenter2.y+g_vDetailTexCoordOffset2.y-(v2*g_vDetailTexCoordCenter2.x+v1*g_vDetailTexCoordCenter2.y))); >;
	float4 g_vDetailTexCoordXform1_3 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation3*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale3.x,v1*g_vDetailTexCoordScale3.y,0,g_vDetailTexCoordCenter3.y+g_vDetailTexCoordOffset3.y-(v2*g_vDetailTexCoordCenter3.x+v1*g_vDetailTexCoordCenter3.y))); >;
	float4 g_vOverlayTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flOverlayTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vOverlayTexCoordScale.x,-v2*g_vOverlayTexCoordScale.y,0,g_vOverlayTexCoordCenter.x+g_vOverlayTexCoordOffset.x+v2*g_vOverlayTexCoordCenter.y-v1*g_vOverlayTexCoordCenter.x)); >;
	float4 g_vOverlayTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flOverlayTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vOverlayTexCoordScale.x,v1*g_vOverlayTexCoordScale.y,0,g_vOverlayTexCoordCenter.y+g_vOverlayTexCoordOffset.y-(v2*g_vOverlayTexCoordCenter.x+v1*g_vOverlayTexCoordCenter.y))); >;
	float4 g_vTexCoord2ScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoord2UByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoord2UByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoord2UByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoord2UByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoord2ScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoord2VByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoord2VByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoord2VByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoord2VByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordUByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==2) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==3) ? 1 : 0,(g_nScaleTexCoordVByModelScaleAxis==0) ? 1 : 0)); >;
	float4 g_vTexCoordXform0_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale1.x,-v2*g_vTexCoordScale1.y,0,g_vTexCoordCenter1.x+g_vTexCoordOffset1.x+v2*g_vTexCoordCenter1.y-v1*g_vTexCoordCenter1.x)); >;
	float4 g_vTexCoordXform0_2 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale2.x,-v2*g_vTexCoordScale2.y,0,g_vTexCoordCenter2.x+g_vTexCoordOffset2.x+v2*g_vTexCoordCenter2.y-v1*g_vTexCoordCenter2.x)); >;
	float4 g_vTexCoordXform0_3 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation3*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale3.x,-v2*g_vTexCoordScale3.y,0,g_vTexCoordCenter3.x+g_vTexCoordOffset3.x+v2*g_vTexCoordCenter3.y-v1*g_vTexCoordCenter3.x)); >;
	float4 g_vTexCoordXform1_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale1.x,v1*g_vTexCoordScale1.y,0,g_vTexCoordCenter1.y+g_vTexCoordOffset1.y-(v2*g_vTexCoordCenter1.x+v1*g_vTexCoordCenter1.y))); >;
	float4 g_vTexCoordXform1_2 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale2.x,v1*g_vTexCoordScale2.y,0,g_vTexCoordCenter2.y+g_vTexCoordOffset2.y-(v2*g_vTexCoordCenter2.x+v1*g_vTexCoordCenter2.y))); >;
	float4 g_vTexCoordXform1_3 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation3*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale3.x,v1*g_vTexCoordScale3.y,0,g_vTexCoordCenter3.y+g_vTexCoordOffset3.y-(v2*g_vTexCoordCenter3.x+v1*g_vTexCoordCenter3.y))); >;
	
	// Material1
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	float2 g_vTexCoordCenter2 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float g_flTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/3"); UiVisibility(1); >;
	float2 g_vTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vTexCoordOffset2 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vDetailTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/9"); UiVisibility(1); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	
	// Material2
	int g_nUVSet2 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet2 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/2"); >;
	float2 g_vDetailTexCoordCenter2 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material2/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material2/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material2/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset2 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material2/Detail Texture Transform/9"); UiVisibility(1); >;
	
	// Material3
	int g_nUVSet3 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter3 < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Material3/Texture Transform,35/1"); UiVisibility(1); >;
	int g_nDetailUVSet3 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Texture Transform,35/2"); >;
	float g_flTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Texture Transform,35/3"); UiVisibility(1); >;
	float2 g_vTexCoordOffset3 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material3/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vDetailTexCoordCenter3 < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Material3/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset3 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material3/Detail Texture Transform/9"); UiVisibility(1); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nColorOverlayUVSet < Default(2); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Color/Overlay/40"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	int g_nScaleTexCoord2UByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.u * model.x,2=UV2.u * model.y,3=UV2.u * model.z"); UiType(Enum); UiGroup("Color/100"); UiVisibility(1); >;
	int g_nScaleTexCoord2VByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.v * model.x,2=UV2.v * model.y,3=UV2.v * model.z"); UiType(Enum); UiGroup("Color/110"); UiVisibility(1); >;
	float2 g_vOverlayTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/Overlay/200"); >;
	float2 g_vOverlayTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/Overlay/210"); >;
	float g_flOverlayTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/Overlay/220"); >;
	float2 g_vOverlayTexCoordOffset < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Color/Overlay/230"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vTexCoordXform0_1) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _1224
	{
	    mat4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _1224 PerViewConstantBuffer_t;
	
	struct _1596
	{
	    int g_nUVSet1;
	    vec4 g_vTexCoordXform0_1;
	    vec4 g_vTexCoordXform1_1;
	    int g_nUVSet2;
	    vec4 g_vTexCoordXform0_2;
	    vec4 g_vTexCoordXform1_2;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	};
	
	layout(set = 0) uniform _1596 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec2 vTexCoord2;
	layout(location = 3) in vec3 vNormalOs;
	layout(location = 4) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 5) in uvec4 vBlendIndices;
	layout(location = 6) in uint nInstanceIdx;
	layout(location = 7) in vec4 vBlendColorTint;
	layout(location = 8) in vec4 vColorBlendValues;
	layout(location = 0) out vec4 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out vec4 output_4;
	layout(location = 5) centroid out vec4 output_5;
	layout(location = 6) centroid out vec3 output_6;
	layout(location = 7) out vec4 output_7;
	layout(location = 8) flat out uint output_8;
	
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
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * g_transformBuffer_1._m0[_21785]._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9337 = vTexCoord.xyxy;
	    _9337.z = vTexCoord2.x;
	    _9337.w = vTexCoord2.y;
	    vec4 _21710;
	    if (_Globals_.g_nUVSet1 > 0)
	    {
	        vec4 _11399 = vec4(mix(_9337.xy, _9337.zw, bvec2(_Globals_.g_nUVSet1 == 2)), vTexCoord2);
	        vec2 _9573 = _11399.xy;
	        vec4 _16823 = _11399;
	        _16823.x = dot(_9573, _Globals_.g_vTexCoordXform0_1.xy) + _Globals_.g_vTexCoordXform0_1.w;
	        _16823.y = dot(_9573, _Globals_.g_vTexCoordXform1_1.xy) + _Globals_.g_vTexCoordXform1_1.w;
	        _21710 = _16823;
	    }
	    else
	    {
	        _21710 = _9337;
	    }
	    vec4 _18606;
	    if (_Globals_.g_nUVSet2 > 0)
	    {
	        vec2 _17583 = mix(_9337.xy, _9337.zw, bvec2(_Globals_.g_nUVSet2 == 2));
	        vec4 _7849 = _21710;
	        _7849.z = _17583.x;
	        _7849.w = _17583.y;
	        vec4 _16824 = _7849;
	        _16824.z = dot(_7849.zw, _Globals_.g_vTexCoordXform0_2.xy) + _Globals_.g_vTexCoordXform0_2.w;
	        _16824.w = dot(_7849.zw, _Globals_.g_vTexCoordXform1_2.xy) + _Globals_.g_vTexCoordXform1_2.w;
	        _18606 = _16824;
	    }
	    else
	    {
	        _18606 = _21710;
	    }
	    vec4 _11323 = vec4(_Globals_.g_vColorTint, _23812.w * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _14119 = _11323.xyz * mix(vec3(1.0), vBlendColorTint.xyz, vec3(vBlendColorTint.w));
	    vec4 _23714 = _11323;
	    _23714.x = _14119.x;
	    _23714.y = _14119.y;
	    _23714.z = _14119.z;
	    output_0 = vColorBlendValues;
	    output_1 = vec4(_21354, _21355, _17978, _Globals_.g_flModelTintAmount * (1.0 - min(_21354, min(_21355, _17978))));
	    output_2 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_3 = _11179;
	    output_4 = _18606;
	    output_5 = _23714;
	    output_6 = _11179;
	    output_7 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * g_transformBuffer_1._m0[_21785]._m0), vTangentUOs_flTangentVSign.w);
	    output_8 = g_instanceBuffer_1._m0[nInstanceIdx]._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	IntAttribute(TexCoord2ScaleByModelU, g_nScaleTexCoord2UByModelScaleAxis-1);
	IntAttribute(TexCoord2ScaleByModelV, g_nScaleTexCoord2VByModelScaleAxis-1);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(VertexpaintUIPuddles, (F_WETNESS==1) ? 1 : 0);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	BoolAttribute(SupportsMaterialLayerSampling, true);
	
	#if (S_SHARED_COLOR_OVERLAY == 1)
		BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nUVSet3>0 && (g_vTexCoordScale3.x!=1 || g_vTexCoordScale3.y!=1 || g_flTexCoordRotation3!=0) || g_nColorOverlayUVSet>0 && (g_vOverlayTexCoordScale.x!=1 || g_vOverlayTexCoordScale.y!=1 || g_flOverlayTexCoordRotation!=0)) ? 1 : 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
	#endif
	#if (S_ENABLE_LAYER_3 == 0)
		BoolAttribute(VertexPaintUI2Layer, true);
		BoolAttribute(VertexPaintUI3Layer, false);
	#endif
	#if (S_SHARED_COLOR_OVERLAY == 0)
		BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nUVSet3>0 && (g_vTexCoordScale3.x!=1 || g_vTexCoordScale3.y!=1 || g_flTexCoordRotation3!=0)) ? 1 : 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
	#endif
	
	// Variant Attributes
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0)) ? 1 : 0);
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nColorOverlayUVSet>0 && (g_vOverlayTexCoordScale.x!=1 || g_vOverlayTexCoordScale.y!=1 || g_flOverlayTexCoordRotation!=0)) ? 1 : 0);
}

PS
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_PIXEL_DEPTH_OFFSET, F_PIXEL_DEPTH_OFFSET );
	StaticCombo( S_SHARED_COLOR_OVERLAY, F_SHARED_COLOR_OVERLAY );
	StaticCombo( S_ENABLE_LAYER_3, F_ENABLE_LAYER_3 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_USE_NEW_BLENDING, F_USE_NEW_BLENDING );
	StaticCombo( S_ENABLE_VISUALIZATIONS, F_ENABLE_VISUALIZATIONS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_BLEND_EFFECTS_2, F_BLEND_EFFECTS_2 );
	StaticCombo( S_BLEND_EFFECTS_3, F_BLEND_EFFECTS_3 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_PARALLAX_OCCLUSION, F_PARALLAX_OCCLUSION );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Requires( S_BLEND_EFFECTS_3, S_ENABLE_LAYER_3 ) );
	StaticComboRule( Allow1( S_PIXEL_DEPTH_OFFSET, S_ALPHA_TEST ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_ALPHA_TEST_PREPASS, 0..1 );
	DynamicCombo( D_PARALLAX_OCCLUSION, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_SPECULAR_CUBE_MAP_STATIC ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	DynamicComboRule( Requires( D_ALPHA_TEST_PREPASS, S_ALPHA_TEST ) );
	DynamicComboRule( Requires( D_PARALLAX_OCCLUSION, S_PARALLAX_OCCLUSION ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_PARALLAX_OCCLUSION ) );
	
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nColorOverlayUVSet==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0 || g_nColorOverlayUVSet==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nDetailUVSet1==0 || g_nDetailUVSet2==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nDetailUVSet1==0 || g_nDetailUVSet2==0 || g_nColorOverlayUVSet==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0 || g_nDetailUVSet1==0 || g_nDetailUVSet2==0 || g_nDetailUVSet3==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0 || g_nDetailUVSet1==0 || g_nDetailUVSet2==0 || g_nDetailUVSet3==0 || g_nColorOverlayUVSet==0); >;
	bool bBlendByFacingDirection2 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_2); >;
	bool bBlendByFacingDirection3 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_3); >;
	[[layer_constant]] StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	[[layer_constant]] StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bAdjustBaseColor1 < UiType(CheckBox); Expression(g_nColorCorrectionMode1==1); >;
	bool g_bAdjustBaseColor2 < UiType(CheckBox); Expression(g_nColorCorrectionMode2==1); >;
	bool g_bAdjustBaseColor3 < UiType(CheckBox); Expression(g_nColorCorrectionMode3==1); >;
	bool g_bBorderBlendColorize2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==3); >;
	bool g_bBorderBlendColorize3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==3); >;
	bool g_bBorderBlendMod2x2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==2); >;
	bool g_bBorderBlendMod2x3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==2); >;
	bool g_bBorderBlendMultiply2 < UiType(CheckBox); Expression(!F_BORDER_BLEND_MODE_2); >;
	bool g_bBorderBlendMultiply3 < UiType(CheckBox); Expression(!F_BORDER_BLEND_MODE_3); >;
	bool g_bBorderBlendReplace2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==1); >;
	bool g_bBorderBlendReplace3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==1); >;
	bool g_bBorderRoughness2 < UiType(CheckBox); Expression(F_BORDER_ROUGHNESS_2); >;
	bool g_bBorderRoughness3 < UiType(CheckBox); Expression(F_BORDER_ROUGHNESS_3); >;
	bool g_bColorOverlayLayer1 < UiType(CheckBox); Expression(g_nColorOverlayMode==0 || g_nColorOverlayMode==1); >;
	bool g_bColorOverlayLayer2 < UiType(CheckBox); Expression(g_nColorOverlayMode==0 || g_nColorOverlayMode==2); >;
	bool g_bColorOverlayLayer3 < UiType(CheckBox); Expression(g_nColorOverlayMode==0 || g_nColorOverlayMode==3); >;
	bool g_bColorOverlayMaskLayer1 < UiType(CheckBox); Expression(g_nColorOverlayTintMask==0 || g_nColorOverlayTintMask==1); >;
	bool g_bColorOverlayMaskLayer2 < UiType(CheckBox); Expression(g_nColorOverlayTintMask==0 || g_nColorOverlayTintMask==2); >;
	bool g_bColorOverlayMaskLayer3 < UiType(CheckBox); Expression(g_nColorOverlayTintMask==0 || g_nColorOverlayTintMask==3); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bMaskVertexColor1 < UiType(CheckBox); Expression(g_nVertexColorMode1==0); >;
	bool g_bMaskVertexColor2 < UiType(CheckBox); Expression(g_nVertexColorMode2==0); >;
	bool g_bMaskVertexColor3 < UiType(CheckBox); Expression(g_nVertexColorMode3==0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	bool g_bVertexColorEnabled1 < UiType(CheckBox); Expression(g_nVertexColorMode1!=2); >;
	bool g_bVertexColorEnabled2 < UiType(CheckBox); Expression(g_nVertexColorMode2!=2); >;
	bool g_bVertexColorEnabled3 < UiType(CheckBox); Expression(g_nVertexColorMode3!=2); >;
	bool g_bWetness < UiType(CheckBox); Expression((F_WETNESS==1) ? 1 : 0); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint2,1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint3,1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	int g_nVisualization < UiType(Slider); Expression(F_VISUALIZATION_MODE); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor2 < Channel(RGB, ArtistDefined(TextureColor2), Srgb); Channel(A, Box(TextureAmbientOcclusion2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor3 < Channel(RGB, ArtistDefined(TextureColor3), Srgb); Channel(A, Box(TextureAmbientOcclusion3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight2 < Channel(R, Box(TextureHeight2), Linear); Channel(G, Box(TextureTintMask2), Linear); Channel(A, Box(TextureMetalness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight3 < Channel(R, Box(TextureHeight3), Linear); Channel(G, Box(TextureTintMask3), Linear); Channel(A, Box(TextureMetalness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal1 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal1, TextureRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal2 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal2, TextureRoughness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal3 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal3, TextureRoughness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormalDetail2 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail2), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormalDetail3 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail3), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tSharedColorOverlay < Channel(RGB, ArtistDefined(TextureSharedColorOverlay), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	float3 g_vBiplanarTexCoordScale < UiType(VectorText); Expression(1/64*float3(-1,1,-1)); >;
	float4 g_vDetailNormalXform_1 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vDetailNormalXform_2 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vDetailNormalXform_3 < UiType(VectorText); Expression(v0 = g_flDetailTexCoordRotation3*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float3 g_vFlatOverlayColor < Default3(1, 0, 1); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vNormalXform_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalXform_2 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalXform_3 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation3*3.1415927/180;
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
	float2 g_vTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float g_flTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/3"); UiVisibility(1); >;
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
	float g_flDetailPropMaskBias1 < Range(0, 10); UiType(Slider); UiGroup("Material1/Detail Props,90/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flSnowGlintStrength1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Snow,100/20"); UiVisibility(g_bSnowLayer1); >;
	float3 g_vAmbientOcclusionLevels1 < Default3(0, 0.5, 1); Range(-1, 1); Attribute("0=Option 1,1=Option 2,2=Option 3"); UiType(VectorText); UiGroup("Material1/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	float g_flDetailPropPuddleReduction1 < UiType(Slider); UiGroup("Material1/Detail Props,90/30"); >;
	float g_flHeightMapZeroPoint1 < Default(0.5); UiType(Slider); UiGroup("Material1/Height/30"); >;
	CreateInputTexture2D(TextureNormalDetail1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	float g_fDetailTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Detail/45"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	int g_nVertexColorMode1 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material1/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength1 < Default(1); UiType(Slider); UiGroup("Material1/Lighting/61"); >;
	float g_flPDOScale1 < Default(1); Range(-3, 3); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/80"); >;
	float g_flPDOOffset1 < Range(-1, 1); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/90"); >;
	float g_flPDOContactAoDistance1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/91"); >;
	float g_flPDOContactAoStrength1 < Default(0.3); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/92"); >;
	float g_flPDOSoftIntersectionWidth1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Pixel Depth Offset,31/93"); >;
	bool g_bSnowLayer1 < UiType(CheckBox); UiGroup("Material1/Snow,100"); >;
	
	// Material2
	CreateInputTexture2D(TextureColor2, Srgb, 8, "", "_color", "Material2/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask2, Linear, 8, "", "_mask", "Material2/Tint Mask,15/0", Default4(1, 1, 1, 0));
	float g_flColorReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/0"); >;
	int g_nUVSet2 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet2 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/2"); >;
	float g_fTintMaskBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Tint Mask/5"); >;
	float2 g_vDetailTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material2/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material2/Detail Texture Transform/8"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight2, Linear, 8, "", "_height", "Material2/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness2, Linear, 8, "Inverse", "_rough", "Material2/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast2 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material2/Tint Mask/10"); >;
	float g_flColorOverlay2 < UiType(Slider); UiGroup("Material2/Selective Blending/10"); >;
	float g_flDetailPropMaskSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Detail Props,90/10"); >;
	float g_flParallaxStrength2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Parallax Occlusion,32/10"); >;
	float3 g_vFacingDirection2 < Default3(0, 0, 1); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material2/Facing Direction/10"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float3 g_vTextureColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2,0/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Lighting/12"); >;
	float g_fTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Lighting/13"); >;
	bool g_bMetalness2 < Default(1); UiType(CheckBox); UiGroup("Material2/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/20"); >;
	float g_flDetailPropMaskBias2 < Range(0, 10); UiType(Slider); UiGroup("Material2/Detail Props,90/20"); >;
	float g_flFacingDirectionMaskSpread2 < Default(0.5); UiType(Slider); UiGroup("Material2/Facing Direction/20"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flHeightMapScale2 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flNormalReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/20"); >;
	float g_flSnowGlintStrength2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Snow,100/20"); UiVisibility(g_bSnowLayer2); >;
	float3 g_vAmbientOcclusionLevels2 < Default3(0, 0.5, 1); Range(-1, 1); UiType(VectorText); UiGroup("Material2/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness2, Linear, 8, "", "_metal", "Material2/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/30"); >;
	float g_flDetailPropPuddleReduction2 < UiType(Slider); UiGroup("Material2/Detail Props,90/30"); >;
	float g_flHeightMapZeroPoint2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/30"); >;
	float g_flNormalCombine2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Selective Blending/30"); >;
	float g_vFacingDirectionMaskNormalMapStrength2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Facing Direction/30"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	CreateInputTexture2D(TextureNormalDetail2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Color Correction/40"); >;
	float g_flBlendSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Height,30/40"); >;
	float g_flRoughnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/40"); >;
	float g_vFacingDirectionMaskSoftness2 < Default(0.1); UiType(Slider); UiGroup("Material2/Facing Direction/40"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flUnderlyingHeightMapInfluence2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height,30/41"); >;
	float g_fDetailTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Detail/45"); >;
	float g_flRoughnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/45"); >;
	int g_nColorCorrectionMode2 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material2/Color Correction/45"); >;
	float g_flMetalnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/50"); >;
	float g_flMetalnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/55"); >;
	bool g_bModelTint2 < Default(1); UiType(CheckBox); UiGroup("Material2/Color Correction/60"); >;
	float g_flAOReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/60"); >;
	int g_nVertexColorMode2 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material2/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength2 < Default(1); UiType(Slider); UiGroup("Material2/Lighting/62"); >;
	float g_flAOCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/70"); >;
	float g_flMaskWithHeight2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Height/70"); >;
	float g_flPDOScale2 < Default(1); Range(-3, 3); UiType(Slider); UiGroup("Material2/Pixel Depth Offset,31/80"); >;
	float g_flPDOOffset2 < Range(-1, 1); UiType(Slider); UiGroup("Material2/Pixel Depth Offset,31/90"); >;
	float g_flPDOContactAoDistance2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material2/Pixel Depth Offset,31/91"); >;
	float g_flPDOContactAoStrength2 < Default(0.3); UiType(Slider); UiGroup("Material2/Pixel Depth Offset,31/92"); >;
	float g_flPDOSoftIntersectionWidth2 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material2/Pixel Depth Offset,31/93"); >;
	bool g_bSnowLayer2 < UiType(CheckBox); UiGroup("Material2/Snow,100"); >;
	
	// Material3
	CreateInputTexture2D(TextureColor3, Srgb, 8, "", "_color", "Material3/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask3, Linear, 8, "", "_mask", "Material3/Tint Mask,15/0", Default4(1, 1, 1, 0));
	float g_flColorReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/0"); >;
	int g_nUVSet3 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet3 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Texture Transform,35/2"); >;
	float g_flTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Texture Transform,35/3"); UiVisibility(1); >;
	float g_fTintMaskBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Tint Mask/5"); >;
	float2 g_vDetailTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Detail Texture Transform/8"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight3, Linear, 8, "", "_height", "Material3/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness3, Linear, 8, "Inverse", "_rough", "Material3/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast3 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material3/Tint Mask/10"); >;
	float g_flColorOverlay3 < UiType(Slider); UiGroup("Material3/Selective Blending/10"); >;
	float g_flDetailPropMaskSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Detail Props,90/10"); >;
	float g_flParallaxStrength3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Parallax Occlusion,32/10"); >;
	float3 g_vFacingDirection3 < Default3(0, 0, 1); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material3/Facing Direction/10"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float3 g_vTextureColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3,2/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Lighting/12"); >;
	float g_fTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Lighting/13"); >;
	bool g_bMetalness3 < Default(1); UiType(CheckBox); UiGroup("Material3/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/20"); >;
	float g_flDetailPropMaskBias3 < Range(0, 10); UiType(Slider); UiGroup("Material3/Detail Props,90/20"); >;
	float g_flFacingDirectionMaskSpread3 < Default(0.5); UiType(Slider); UiGroup("Material3/Facing Direction/20"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flHeightMapScale3 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flNormalReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/20"); >;
	float g_flSnowGlintStrength3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Snow,100/20"); UiVisibility(g_bSnowLayer3); >;
	float3 g_vAmbientOcclusionLevels3 < Default3(0, 0.5, 1); Range(-1, 1); UiType(VectorText); UiGroup("Material3/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness3, Linear, 8, "", "_metal", "Material3/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/30"); >;
	float g_flDetailPropPuddleReduction3 < UiType(Slider); UiGroup("Material3/Detail Props,90/30"); >;
	float g_flHeightMapZeroPoint3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/30"); >;
	float g_flNormalCombine3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Selective Blending/30"); >;
	float g_vFacingDirectionMaskNormalMapStrength3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Facing Direction/30"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	CreateInputTexture2D(TextureNormalDetail3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Color Correction/40"); >;
	float g_flBlendSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Height,30/40"); >;
	float g_flRoughnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/40"); >;
	float g_vFacingDirectionMaskSoftness3 < Default(0.1); UiType(Slider); UiGroup("Material3/Facing Direction/40"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flUnderlyingHeightMapInfluence3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height,30/41"); >;
	float g_fDetailTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Detail/45"); >;
	float g_flRoughnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/45"); >;
	int g_nColorCorrectionMode3 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material3/Color Correction/45"); >;
	float g_flMetalnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/50"); >;
	float g_flMetalnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/55"); >;
	float g_flAOReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/60"); >;
	int g_nVertexColorMode3 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material3/Color Correction/60"); >;
	bool g_bModelTint3 < Default(1); UiType(CheckBox); UiGroup("Material3/Color Correction/61"); >;
	float g_flWetnessDarkeningStrength3 < Default(1); UiType(Slider); UiGroup("Material3/Lighting/63"); >;
	float g_flAOCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/70"); >;
	float g_flMaskWithHeight3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Height/70"); >;
	float g_flPDOScale3 < Default(1); Range(-3, 3); UiType(Slider); UiGroup("Material3/Pixel Depth Offset,31/80"); >;
	float g_flPDOOffset3 < Range(-1, 1); UiType(Slider); UiGroup("Material3/Pixel Depth Offset,31/90"); >;
	float g_flPDOContactAoDistance3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material3/Pixel Depth Offset,31/91"); >;
	float g_flPDOContactAoStrength3 < Default(0.3); UiType(Slider); UiGroup("Material3/Pixel Depth Offset,31/92"); >;
	float g_flPDOSoftIntersectionWidth3 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material3/Pixel Depth Offset,31/93"); >;
	bool g_bSnowLayer3 < UiType(CheckBox); UiGroup("Material3/Snow,100"); >;
	
	// Color
	CreateInputTexture2D(TextureSharedColorOverlay, Linear, 8, "", "_color", "Color/Overlay/0", Default4(1, 1, 1, 0));
	int g_nColorOverlayUVSet < Default(2); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Color/Overlay/40"); >;
	int g_nColorOverlayMode < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=All Layers,1=Layer1,2=Layer2,3=Layer3"); UiType(Enum); UiGroup("Color/Overlay/50"); >;
	int g_nColorOverlayTintMask < Range4(0, 0, 0, 0, 4, 4, 4, 4); UiOptions("0=Mask All,1=Mask Layer1,2=Mask Layer2,3=Mask Layer3,4=Unmasked"); UiType(Enum); UiGroup("Color/Overlay/55"); >;
	float3 g_vColorOverlayLayerStrengths < Default3(1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/60"); >;
	float3 g_vColorOverlayTintMaskStrengths < Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/65"); >;
	float g_flOverlayDarknessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/100"); >;
	int g_nScaleTexCoord2UByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.u * model.x,2=UV2.u * model.y,3=UV2.u * model.z"); UiType(Enum); UiGroup("Color/100"); UiVisibility(1); >;
	float g_flOverlayBrightnessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/110"); >;
	int g_nScaleTexCoord2VByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.v * model.x,2=UV2.v * model.y,3=UV2.v * model.z"); UiType(Enum); UiGroup("Color/110"); UiVisibility(1); >;
	float g_flBlendSoftnessDistanceModifierStrength < Default(1); UiType(Slider); UiGroup("Color/120"); >;
	float2 g_vOverlayTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/Overlay/210"); >;
	float g_flOverlayTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/Overlay/220"); >;
	
	// Blend Effects
	float g_flBorderSpread2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects,8/Border Layer 2,0/10"); >;
	float g_flBorderSpread3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 3,10/10"); >;
	float g_flBorderSoftness2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/20"); >;
	float g_flBorderSoftness3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/20"); >;
	float g_flBorderOffset2 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/30"); >;
	float g_flBorderOffset3 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/30"); >;
	float g_fBorderRoughness2 < Default(0.5); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/35"); UiVisibility(F_BORDER_ROUGHNESS_2); >;
	float g_fBorderRoughness3 < Default(0.5); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/35"); UiVisibility(F_BORDER_ROUGHNESS_3); >;
	float3 g_vBorderTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Effects/Border Layer 2/40"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vBorderTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Effects/Border Layer 3/40"); Expression(SrgbGammaToLinear(this)); >;
	bool g_bBorderTintMask3 < UiType(CheckBox); UiGroup("Blend Effects/Border Layer 3/41"); >;
	float2 g_vBorderLayerAmount2 < Default(1); UiType(VectorText); UiGroup("Blend Effects/Border Layer 2/41"); >;
	float2 g_vBorderLayerAmount3 < Default(1); UiType(VectorText); UiGroup("Blend Effects/Border Layer 3/41"); >;
	bool g_bBorderTintMask2 < UiType(CheckBox); UiGroup("Blend Effects/Border Layer 2/42"); >;
	float g_flBevelSpread2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2,5/50"); >;
	float g_flBevelSpread3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3,15/50"); >;
	float g_flBevelSoftness2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2/60"); >;
	float g_flBevelSoftness3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3/60"); >;
	float g_flBevelOffset2 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2/65"); >;
	float g_flBevelOffset3 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3/65"); >;
	float g_flBevelStrength2 < Range(-1, 1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2/70"); Expression(this*.01); >;
	float g_flBevelStrength3 < Range(-1, 1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3/70"); Expression(this*.01); >;
	float g_flBevelCurve2 < Range(-1, 1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 2/80"); >;
	float g_flBevelCurve3 < Range(-1, 1); UiType(Slider); UiGroup("Blend Effects/Bevel Layer 3/80"); >;
	float2 g_vBevelLayerAmount2 < Default2(1, 1); UiType(VectorText); UiGroup("Blend Effects/Bevel Layer 2/90"); >;
	float2 g_vBevelLayerAmount3 < Default2(1, 1); UiType(VectorText); UiGroup("Blend Effects/Bevel Layer 3/90"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Wetness
	bool g_bWetnessUseHeightmapAdjustments < UiType(CheckBox); UiGroup("Wetness/2"); UiVisibility(F_WETNESS ? 1 : 0); >;
	bool g_bPuddlesOnVerticalSurfaces < UiType(CheckBox); UiGroup("Wetness,9/3"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_flWetnessUnderlyingHeightMapInfluence < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/3"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_flHorizontalSurfaceTolerance < Default(32); Range(0, 100); UiType(Slider); UiGroup("Wetness/4"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleStrength < Default(1); UiType(Slider); UiGroup("Wetness/5"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleHeight < Default(0.5); UiType(Slider); UiGroup("Wetness/6"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float3 g_vPuddleSedimentColor < Default3(0.62, 0.56, 0.5); UiType(Color); UiGroup("Wetness/10"); Expression(SrgbGammaToLinear(this)); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleSedimentHeight < Default(0.9); Range(0, 2); UiType(Slider); UiGroup("Wetness/15"); Expression(this*2-1); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleSedimentOpacity < Default(0.25); UiType(Slider); UiGroup("Wetness/16"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleRoughness < Default(0.02); UiType(Slider); UiGroup("Wetness/17"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleBlendSoftness < Default(0.08); UiType(Slider); UiGroup("Wetness/18"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetEdgeStrength < Default(0.5); UiType(Slider); UiGroup("Wetness/20"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetEdgeSpread < Default(0.2); UiType(Slider); UiGroup("Wetness/25"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetEdgeSoftness < Default(0.2); UiType(Slider); UiGroup("Wetness/26"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetnessStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/30"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fRainStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/35"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fRippleStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/40"); UiVisibility(F_WETNESS ? 1 : 0); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
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
	#if (S_PARALLAX_OCCLUSION == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_SHADER_QUALITY == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_BLEND_EFFECTS_2 == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_BLEND_EFFECTS_3 == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nColorOverlayUVSet==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0 || g_nColorOverlayUVSet==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nDetailUVSet1==0 || g_nDetailUVSet2==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nDetailUVSet1==0 || g_nDetailUVSet2==0 || g_nColorOverlayUVSet==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0 || g_nDetailUVSet1==0 || g_nDetailUVSet2==0 || g_nDetailUVSet3==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0 || g_nDetailUVSet1==0 || g_nDetailUVSet2==0 || g_nDetailUVSet3==0 || g_nColorOverlayUVSet==0); >;
	float g_flHeightMapScale1 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height/20"); >;
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
	
	const vec3 _1498[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _311[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
	struct _139
	{
	    vec4 _m0[3];
	};
	
	struct _349
	{
	    vec4 _m0[4];
	};
	
	struct _2940
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
	vec2 _10;
	
	struct _799
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
	    float g_flBlendSoftness2;
	    int g_bSnowLayer2;
	    float g_flSnowGlintStrength2;
	    int g_nUVSet2;
	    vec2 g_vTexCoordScale2;
	    vec4 g_vNormalXform_2;
	    float g_flWetnessDarkeningStrength2;
	    uint g_tNormal1;
	    uint g_tHeight1;
	    float g_fTintMaskContrast1;
	    float g_fTintMaskBrightness1;
	    vec3 g_vAmbientOcclusionLevels1;
	    int g_bAdjustBaseColor1;
	    float g_flHeightMapScale1;
	    float g_flHeightMapZeroPoint1;
	    int g_bVertexColorEnabled1;
	    int g_bMaskVertexColor1;
	    float g_fTextureRoughnessContrast1;
	    float g_fTextureRoughnessBrightness1;
	    float g_fTextureNormalContrast1;
	    int g_bMetalness1;
	    int g_bModelTint1;
	    mat4 g_mTextureColorAdjust1;
	    mat4 g_mTextureAdjust1;
	    float g_flBlendSoftnessDistanceModifierStrength;
	    float g_flColorReplace2;
	    float g_flColorOverlay2;
	    float g_flNormalReplace2;
	    float g_flNormalCombine2;
	    float g_flRoughnessReplace2;
	    float g_flRoughnessCombine2;
	    float g_flMetalnessReplace2;
	    float g_flMetalnessCombine2;
	    float g_flAOReplace2;
	    float g_flAOCombine2;
	    float g_fTextureRoughnessContrast2;
	    float g_fTextureRoughnessBrightness2;
	    float g_fTextureNormalContrast2;
	    int g_bMetalness2;
	    float g_fTintMaskContrast2;
	    float g_fTintMaskBrightness2;
	    uint g_tColor2;
	    uint g_tNormal2;
	    uint g_tHeight2;
	    vec3 g_vAmbientOcclusionLevels2;
	    int g_bAdjustBaseColor2;
	    mat4 g_mTextureColorAdjust2;
	    mat4 g_mTextureAdjust2;
	    float g_flHeightMapScale2;
	    float g_flHeightMapZeroPoint2;
	    float g_flMaskWithHeight2;
	    vec3 g_vFacingDirection2;
	    float g_flFacingDirectionMaskSpread2;
	    float g_vFacingDirectionMaskNormalMapStrength2;
	    float g_vFacingDirectionMaskSoftness2;
	    int g_bVertexColorEnabled2;
	    int g_bMaskVertexColor2;
	    int g_bModelTint2;
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
	    int bBlendByFacingDirection2;
	    int g_bWetness;
	    int bBiplanarUsedAny;
	};
	
	layout(set = 1) uniform _799 _Globals_;
	
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
	
	struct _1152
	{
	    _139 _m0;
	    _349 _m1;
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
	    _2940 _m18;
	    _349 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _1152 PerViewLightingConstantBufferGpu_t;
	
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
	    float _10136 = saturate((input_0.x * 1.10000002384185791015625) - 0.0500000007450580596923828125);
	    float _20519 = saturate((input_0.y * 1.10000002384185791015625) - 0.0500000007450580596923828125);
	    vec3 _18843 = normalize(vec3(saturate((1.0 - _10136) - _20519), _10136, _20519));
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
	    vec2 _6616;
	    ivec2 _13136;
	    vec2 _13694;
	    ivec2 _16305;
	    vec2 _17114;
	    vec2 _17115;
	    vec2 _17116;
	    vec2 _17117;
	    vec2 _17118;
	    if (_Globals_.bBiplanarUsedAny != 0)
	    {
	        vec3 _10577 = abs(_24347);
	        vec3 _16100 = _10577;
	        float _17349 = _10577.x;
	        float _8043 = _10577.y;
	        bool _12886;
	        if (_17349 > _8043)
	        {
	            _12886 = _17349 > _10577.z;
	        }
	        else
	        {
	            _12886 = false;
	        }
	        ivec3 _23727;
	        if (_12886)
	        {
	            _23727 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            _23727 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_8043 > _10577.z));
	        }
	        bool _12887;
	        if (_17349 < _8043)
	        {
	            _12887 = _17349 < _10577.z;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        ivec3 _11775;
	        if (_12887)
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
	        vec3 _16418 = _18781;
	        vec3 _16419 = dFdxFine(_18781);
	        vec3 _16446 = dFdyFine(_18781);
	        _13136 = _19321;
	        _16305 = _19322;
	        _17114 = vec2(_16418[_19321.x], _16418[_19321.y]);
	        _17115 = vec2(_16418[_19322.x], _16418[_19322.y]);
	        _17116 = vec2(_16419[_19321.x], _16419[_19321.y]);
	        _17117 = vec2(_16446[_19321.x], _16446[_19321.y]);
	        _17118 = vec2(_16419[_19322.x], _16419[_19322.y]);
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
	    bool _17559 = _Globals_.g_nUVSet1 > 1;
	    vec2 _21710;
	    if (_17559)
	    {
	        _21710 = input_4.xy;
	    }
	    else
	    {
	        _21710 = vec2(0.0);
	    }
	    bool _17560 = _Globals_.g_nUVSet2 > 1;
	    vec2 _22864;
	    if (_17560)
	    {
	        _22864 = input_4.zw;
	    }
	    else
	    {
	        _22864 = _21710;
	    }
	    vec3 _22993 = _10061 - PerViewConstantBuffer_t._m4.xyz;
	    bool _12888;
	    if (_14874)
	    {
	        _12888 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12888 = false;
	    }
	    bool _18545;
	    if (_12888)
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
	    vec3 _9521 = input_7.xyz * _12157;
	    vec3 _15323 = (cross(input_3, input_7.xyz) * ((input_7.w > 0.0) ? 1.0 : (-1.0))) * _12157;
	    vec3 _8889;
	    if (_18545)
	    {
	        _8889 = _11587 * (-1.0);
	    }
	    else
	    {
	        _8889 = _11587;
	    }
	    vec3 _10020;
	    vec3 _22186;
	    if (_17560 ? true : _17559)
	    {
	        vec2 _16592 = dFdxFine(_22864);
	        vec2 _18145 = dFdyFine(_22864);
	        float _17522 = _18145.y;
	        float _15279 = dot(_16592, vec2(_17522, -_18145.x));
	        float _17298 = (_15279 < 0.0) ? (-1.0) : 1.0;
	        vec2 _24530 = vec2(_17522, -_16592.y) * _17298;
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
	        _10020 = _9082;
	        _22186 = cross(_8889, _9082) * (_17298 * float((dot(_20949, cross(_8889, _7147)) < 0.0) ? (-1) : 1));
	    }
	    else
	    {
	        _10020 = vec3(0.0);
	        _22186 = vec3(0.0);
	    }
	    vec3 _18905;
	    _18905.x = input_4.x;
	    _18905.y = input_4.y;
	    bool _23685 = _Globals_.g_nUVSet1 == 0;
	    vec4 _9716;
	    vec3 _24878;
	    if (_23685)
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
	    if (_23685)
	    {
	        _19323 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17114 * _Globals_.g_vTexCoordScale1.xy).xy, (_17116 * _Globals_.g_vTexCoordScale1.xy).xy, (_17117 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17115 * _Globals_.g_vTexCoordScale1.xy).xy, (_17118 * _Globals_.g_vTexCoordScale1.xy).xy, (_13694 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.y);
	    }
	    else
	    {
	        _19323 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy).xyzw;
	    }
	    vec2 _6383 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy);
	    float _16356 = _6383.x;
	    float _19275 = fwidth(_19323.x * _Globals_.g_flHeightMapScale1);
	    float _15317 = ((((_16356 * _16356) * (0.012500000186264514923095703125 + _19275)) * 0.0199999995529651641845703125) * _Globals_.g_flBlendSoftnessDistanceModifierStrength) * _18843.x;
	    float _8284 = max(min(input_0.w + _Globals_.g_flBlendSoftness2, 1.0), 9.9999997473787516355514526367188e-05) + _15317;
	    bool _14876 = _Globals_.g_bWetnessUseHeightmapAdjustments != 0;
	    float _11237;
	    SPIRV_CROSS_BRANCH
	    if (_14876)
	    {
	        _11237 = max(0.0, ((_19323.x + 0.5) - _Globals_.g_flHeightMapZeroPoint1) * _Globals_.g_flHeightMapScale1);
	    }
	    else
	    {
	        _11237 = _19323.x;
	    }
	    float _17767 = _Globals_.g_flHeightMapZeroPoint1 + (_15317 * 0.5);
	    float _6379 = _Globals_.g_flHeightMapScale1 + _8284;
	    float _20609 = (_19323.x - _17767) * _6379;
	    float _13138;
	    vec3 _13189;
	    vec4 _22995;
	    if (_23685)
	    {
	        vec2 _21820 = (_17114 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _17053 = (_17116 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _8903 = (_17117 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec4 _23806 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _21820, _17053, _8903) * _6616.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _21820, _17053, _8903);
	        float _18178 = _12167.z * _6616.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _21631 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _6616.x;
	        vec3 _24466 = (_1498[_13136.x] * _21631.x) + (_311[_13136.y] * _21631.y);
	        float _13137;
	        vec3 _13753;
	        vec4 _14101;
	        if (_6616.y > 0.0)
	        {
	            vec2 _17048 = (_17115 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10018 = (_17118 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8904 = (_13694 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _17048, _10018, _8904);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _21632 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _6616.y;
	            _13137 = _18178 + (_12168.z * _6616.y);
	            _14101 = _23806 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _17048, _10018, _8904) * _6616.y);
	            _13753 = _24466 + ((_1498[_16305.x] * _21632.x) + (_311[_16305.y] * _21632.y));
	        }
	        else
	        {
	            _13137 = _18178;
	            _14101 = _23806;
	            _13753 = _24466;
	        }
	        _13138 = _13137;
	        _13189 = normalize(_13753 + _24347);
	        _22995 = _14101;
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
	        bvec3 _20662 = bvec3(_17559);
	        vec3 _10844 = abs(_19582.xyz);
	        vec2 _16475 = (-vec2(_7796, (-1.0) * _19701)) / vec2(max(_10844.z, 0.0078125 * max(_10844.x, _10844.y)));
	        _13138 = _11179.z;
	        _13189 = normalize(_8889 - ((mix(_9521, _10020, _20662) * _16475.x) + (mix(_15323, _22186, _20662) * _16475.y)));
	        _22995 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw).xyzw;
	    }
	    float _7812 = saturate(((_Globals_.g_fTextureRoughnessContrast1 * (_13138 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness1);
	    vec4 _23230 = vec4(_22995.xyz, 1.0);
	    float _10048 = saturate(mix(_Globals_.g_vAmbientOcclusionLevels1.x, _Globals_.g_vAmbientOcclusionLevels1.z, pow(_22995.w, _Globals_.g_vAmbientOcclusionLevels1.y)));
	    float _9068 = _19323.w * float(_Globals_.g_bMetalness1 != 0);
	    float _24803 = saturate(((_Globals_.g_fTintMaskContrast1 * (_19323.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness1);
	    vec3 _25191 = mix(mix(_22995, vec4((_23230 * _Globals_.g_mTextureAdjust1).xyz, _22995.w), bvec4(_Globals_.g_bAdjustBaseColor1 != 0)).xyz, vec4((_23230 * _Globals_.g_mTextureColorAdjust1).xyz, _4).xyz, vec3(_24803));
	    vec4 _17842;
	    _17842.x = _25191.x;
	    _17842.y = _25191.y;
	    _17842.z = _25191.z;
	    float _24323 = dot(_17842.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(input_1.xyz, vec3(0.001000000047497451305389404296875)));
	    float _21159 = dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    float _24175 = max(input_1.x, max(input_1.y, input_1.z));
	    vec3 _24174 = normalize(mix(_24347, _13189, vec3(_Globals_.g_fTextureNormalContrast1))).xyz;
	    vec3 _23405 = vec4(saturate(mix(_17842.xyz, (_9577 * min(_24323 / _21159, (3.0 * _24323) * _24175)).xyz, vec3((input_1.w * _24803) * float(_Globals_.g_bModelTint1 != 0)))).xyz, _7).xyz;
	    vec2 _22927;
	    _22927.x = _7812;
	    float _7406 = float(_Globals_.g_bSnowLayer1 != 0);
	    bool _12889;
	    if (_Globals_.g_flColorOverlay2 == 0.0)
	    {
	        _12889 = _Globals_.g_flColorReplace2 == 0.0;
	    }
	    else
	    {
	        _12889 = false;
	    }
	    bool _12890;
	    if (_12889)
	    {
	        _12890 = _Globals_.g_flAOCombine2 == 0.0;
	    }
	    else
	    {
	        _12890 = false;
	    }
	    bool _21711;
	    if (_12890)
	    {
	        _21711 = _Globals_.g_flAOReplace2 == 0.0;
	    }
	    else
	    {
	        _21711 = false;
	    }
	    bool _12891;
	    if (_Globals_.g_flNormalCombine2 == 0.0)
	    {
	        _12891 = _Globals_.g_flNormalReplace2 == 0.0;
	    }
	    else
	    {
	        _12891 = false;
	    }
	    bool _12892;
	    if (_12891)
	    {
	        _12892 = _Globals_.g_flRoughnessCombine2 == 0.0;
	    }
	    else
	    {
	        _12892 = false;
	    }
	    bool _21712;
	    if (_12892)
	    {
	        _21712 = _Globals_.g_flRoughnessReplace2 == 0.0;
	    }
	    else
	    {
	        _21712 = false;
	    }
	    vec3 _18906;
	    _18906.x = input_4.z;
	    _18906.y = input_4.w;
	    bool _23686 = _Globals_.g_nUVSet2 == 0;
	    vec4 _9717;
	    vec3 _24879;
	    if (_23686)
	    {
	        _9717 = vec4(0.0);
	        _24879 = _18906;
	    }
	    else
	    {
	        vec4 _8626 = vec4(dFdx(_18906.xy), dFdy(_18906.xy));
	        vec2 _20313 = _18906.xy + vec2(length(_8626) * 1.0000000133514319600180897396058e-10);
	        vec3 _20489;
	        _20489.x = _20313.x;
	        _20489.y = _20313.y;
	        _9717 = _8626;
	        _24879 = _20489;
	    }
	    vec4 _19324;
	    if (_23686)
	    {
	        _19324 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17114 * _Globals_.g_vTexCoordScale2.xy).xy, (_17116 * _Globals_.g_vTexCoordScale2.xy).xy, (_17117 * _Globals_.g_vTexCoordScale2.xy).xy) * _6616.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17115 * _Globals_.g_vTexCoordScale2.xy).xy, (_17118 * _Globals_.g_vTexCoordScale2.xy).xy, (_13694 * _Globals_.g_vTexCoordScale2.xy).xy) * _6616.y);
	    }
	    else
	    {
	        _19324 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24879.xy).xyzw;
	    }
	    vec2 _6384 = textureQueryLod(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24879.xy);
	    float _16357 = _6384.x;
	    float _19276 = fwidth(_19324.x * _Globals_.g_flHeightMapScale2);
	    float _19817 = _15317 + (((((_16357 * _16357) * (0.012500000186264514923095703125 + _19276)) * 0.0199999995529651641845703125) * _Globals_.g_flBlendSoftnessDistanceModifierStrength) * _18843.y);
	    float _6913 = _8284 + _19817;
	    float _11241;
	    SPIRV_CROSS_BRANCH
	    if (_14876)
	    {
	        _11241 = max(0.0, ((_19324.x + 0.5) - _Globals_.g_flHeightMapZeroPoint2) * _Globals_.g_flHeightMapScale2);
	    }
	    else
	    {
	        _11241 = _19324.x;
	    }
	    float _17768 = _Globals_.g_flHeightMapZeroPoint2 + (_19817 * 0.5);
	    float _6380 = _Globals_.g_flHeightMapScale2 + _6913;
	    float _12197 = _6380 - (_6913 * 2.0);
	    float _11621;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.bBlendByFacingDirection2 != 0)
	    {
	        _11621 = _10136 * saturate((((dot(_Globals_.g_vFacingDirection2.xyz, mix(_24347.xyz, _24174, vec3(_Globals_.g_vFacingDirectionMaskNormalMapStrength2)).xyz) - 1.0) + (_Globals_.g_flFacingDirectionMaskSpread2 * 2.0)) / (_Globals_.g_vFacingDirectionMaskSoftness2 * 2.0)) + 0.5);
	    }
	    else
	    {
	        _11621 = _10136;
	    }
	    float _6994 = ((_19324.x - _17768) * ((_12197 == 0.0) ? 9.9999997473787516355514526367188e-05 : _12197)) + mix((((-_17767) * _6379) - ((1.0 - _17768) * _6380)) - _6913, ((1.0 - _17767) * _6379) - ((-_17768) * _6380), _11621);
	    vec3 _16290;
	    _16290.x = _20609;
	    _16290.y = _6994;
	    vec2 _9007 = max((_16290.xy - vec2(max(_20609, _6994))) + vec2(_6913), vec2(0.0));
	    float _6253 = saturate(((_9007 / vec2((_9007.x + 9.9999997473787516355514526367188e-05) + _9007.y)).y * mix(0.5, _19324.x, _Globals_.g_flMaskWithHeight2)) * 2.0);
	    bool _19615 = _6253 > 0.0500000007450580596923828125;
	    float _13141;
	    vec4 _16306;
	    float _16863;
	    vec3 _17119;
	    float _17120;
	    float _17152;
	    SPIRV_CROSS_BRANCH
	    if (_19615)
	    {
	        float _13140;
	        vec3 _13190;
	        vec4 _22996;
	        if (_23686)
	        {
	            vec2 _19981 = _17114 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _21754 = _17116 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22336 = _17117 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22337 = _17115 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _22994 = _17118 * _Globals_.g_vTexCoordScale2.xy;
	            vec2 _18440 = _13694 * _Globals_.g_vTexCoordScale2.xy;
	            bool _23211 = !_21711;
	            vec4 _7425;
	            if (_23211)
	            {
	                _7425 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _19981.xy, _21754.xy, _22336.xy) * _6616.x;
	            }
	            else
	            {
	                _7425 = vec4(0.0);
	            }
	            bool _24030 = !_21712;
	            vec3 _10024;
	            float _24485;
	            if (_24030)
	            {
	                vec4 _11182 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _19981.xy, _21754.xy, _22336.xy);
	                float _15457 = _11182.x;
	                float _24535 = _11182.y;
	                float _16787 = (_15457 + _24535) - 1.00392162799835205078125;
	                float _11183 = _15457 - _24535;
	                vec3 _21633 = normalize(vec3(vec2(_16787, _11183), (1.0 - abs(_16787)) - abs(_11183))).xyz * _6616.x;
	                _10024 = (_1498[_13136.x] * _21633.x) + (_311[_13136.y] * _21633.y);
	                _24485 = _11182.z * _6616.x;
	            }
	            else
	            {
	                _10024 = _24347;
	                _24485 = 0.0;
	            }
	            float _13139;
	            vec3 _13754;
	            vec4 _14102;
	            if (_6616.y > 0.0)
	            {
	                vec4 _12893;
	                if (_23211)
	                {
	                    _12893 = _7425 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _22337.xy, _22994.xy, _18440.xy) * _6616.y);
	                }
	                else
	                {
	                    _12893 = _7425;
	                }
	                float _13213;
	                vec3 _15671;
	                if (_24030)
	                {
	                    vec4 _12169 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _22337.xy, _22994.xy, _18440.xy);
	                    float _13492 = _12169.x;
	                    float _21309 = _12169.y;
	                    float _16788 = (_13492 + _21309) - 1.00392162799835205078125;
	                    float _11184 = _13492 - _21309;
	                    vec3 _21634 = normalize(vec3(vec2(_16788, _11184), (1.0 - abs(_16788)) - abs(_11184))).xyz * _6616.y;
	                    _13213 = _24485 + (_12169.z * _6616.y);
	                    _15671 = _10024 + ((_1498[_16305.x] * _21634.x) + (_311[_16305.y] * _21634.y));
	                }
	                else
	                {
	                    _13213 = _24485;
	                    _15671 = _10024;
	                }
	                _13139 = _13213;
	                _14102 = _12893;
	                _13754 = _15671;
	            }
	            else
	            {
	                _13139 = _24485;
	                _14102 = _7425;
	                _13754 = _10024;
	            }
	            _13140 = _13139;
	            _13190 = normalize(_13754 + _24347);
	            _22996 = _14102;
	        }
	        else
	        {
	            vec4 _7424;
	            if (!_21711)
	            {
	                _7424 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24879.xy, _9717.xy, _9717.zw).xyzw;
	            }
	            else
	            {
	                _7424 = vec4(0.0);
	            }
	            float _13212;
	            vec3 _15670;
	            if (!_21712)
	            {
	                vec4 _11180 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal2], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24879.xy, _9717.xy, _9717.zw);
	                float _6494 = _11180.x;
	                float _14882 = _11180.y;
	                float _16786 = (_6494 + _14882) - 1.00392162799835205078125;
	                float _11181 = _6494 - _14882;
	                vec3 _15163 = normalize(vec3(vec2(_16786, _11181), (1.0 - abs(_16786)) - abs(_11181)));
	                vec2 _20891 = _15163.xy;
	                float _7797 = dot(_20891, _Globals_.g_vNormalXform_2.xy);
	                float _19702 = dot(_20891, _Globals_.g_vNormalXform_2.zw);
	                vec3 _19583 = _15163;
	                _19583.x = _7797;
	                _19583.y = _19702;
	                bvec3 _20663 = bvec3(_17560);
	                vec3 _10845 = abs(_19583.xyz);
	                vec2 _16476 = (-vec2(_7797, (-1.0) * _19702)) / vec2(max(_10845.z, 0.0078125 * max(_10845.x, _10845.y)));
	                _13212 = _11180.z;
	                _15670 = normalize(_8889 - ((mix(_9521, _10020, _20663) * _16476.x) + (mix(_15323, _22186, _20663) * _16476.y)));
	            }
	            else
	            {
	                _13212 = 0.0;
	                _15670 = vec3(0.0);
	            }
	            _13140 = _13212;
	            _13190 = _15670;
	            _22996 = _7424;
	        }
	        vec3 _9718;
	        float _24880;
	        if (!_21712)
	        {
	            _9718 = normalize(mix(_24347, _13190, vec3(_Globals_.g_fTextureNormalContrast2)));
	            _24880 = saturate(((_Globals_.g_fTextureRoughnessContrast2 * (_13140 - 0.5)) + 0.5) * _Globals_.g_fTextureRoughnessBrightness2);
	        }
	        else
	        {
	            _9718 = _13190;
	            _24880 = _13140;
	        }
	        vec4 _21847 = vec4(_22996.xyz, 1.0);
	        float _24804 = saturate(((_Globals_.g_fTintMaskContrast2 * (_19324.y - 0.5)) + 0.5) * _Globals_.g_fTintMaskBrightness2);
	        vec3 _25192 = mix(mix(_22996, vec4((_21847 * _Globals_.g_mTextureAdjust2).xyz, _22996.w), bvec4(_Globals_.g_bAdjustBaseColor2 != 0)).xyz, vec4((_21847 * _Globals_.g_mTextureColorAdjust2).xyz, _4).xyz, vec3(_24804));
	        vec4 _17843;
	        _17843.x = _25192.x;
	        _17843.y = _25192.y;
	        _17843.z = _25192.z;
	        float _16721 = dot(_17843.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        _13141 = _24804;
	        _16306 = vec4(saturate(mix(_17843.xyz, (_9577 * min(_16721 / _21159, (3.0 * _16721) * _24175)).xyz, vec3((input_1.w * _24804) * float(_Globals_.g_bModelTint2 != 0)))).xyz, _7);
	        _17119 = _9718;
	        _17120 = saturate(mix(_Globals_.g_vAmbientOcclusionLevels2.x, _Globals_.g_vAmbientOcclusionLevels2.z, pow(_22996.w, _Globals_.g_vAmbientOcclusionLevels2.y)));
	        _17152 = _19324.w * float(_Globals_.g_bMetalness2 != 0);
	        _16863 = _24880;
	    }
	    else
	    {
	        _13141 = _19324.y;
	        _16306 = vec4(0.0);
	        _17119 = vec3(0.0);
	        _17120 = 0.0;
	        _17152 = _19324.w;
	        _16863 = 0.0;
	    }
	    float _13142;
	    vec3 _13381;
	    vec2 _14948;
	    float _16307;
	    float _17121;
	    vec3 _17124;
	    float _17125;
	    SPIRV_CROSS_BRANCH
	    if (_19615)
	    {
	        vec3 _10593;
	        float _11673;
	        if (!_21711)
	        {
	            vec3 _18442 = _16306.xyz * 12.9200000762939453125;
	            vec3 _7485 = (pow(_16306.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	            float _21354;
	            if (_16306.x <= 0.003130800090730190277099609375)
	            {
	                _21354 = _18442.x;
	            }
	            else
	            {
	                _21354 = _7485.x;
	            }
	            float _21355;
	            if (_16306.y <= 0.003130800090730190277099609375)
	            {
	                _21355 = _18442.y;
	            }
	            else
	            {
	                _21355 = _7485.y;
	            }
	            float _20653;
	            if (_16306.z <= 0.003130800090730190277099609375)
	            {
	                _20653 = _18442.z;
	            }
	            else
	            {
	                _20653 = _7485.z;
	            }
	            _11673 = mix(_10048 * mix(1.0, _17120, _6253 * _Globals_.g_flAOCombine2), _17120, _6253 * _Globals_.g_flAOReplace2);
	            _10593 = mix(_23405 * mix(vec3(1.0), vec3(_21354, _21355, _20653) * 2.0, vec3(_6253 * _Globals_.g_flColorOverlay2)), _16306.xyz, vec3(_6253 * _Globals_.g_flColorReplace2));
	        }
	        else
	        {
	            _11673 = _10048;
	            _10593 = _23405;
	        }
	        vec3 _11008;
	        vec2 _14482;
	        if (!_21712)
	        {
	            vec2 _12792;
	            _12792.x = mix(_7812 * (1.0 + ((((_16863 - _7812) * 2.0) * _6253) * _Globals_.g_flRoughnessCombine2)), _16863, _6253 * _Globals_.g_flRoughnessReplace2);
	            _11008 = mix(mix(_24174, normalize(mix(_24347, (_24174 + _17119.xyz) * vec3(0.5), vec3(2.0))), vec3(_6253 * _Globals_.g_flNormalCombine2)), _17119.xyz, vec3((_6253 * saturate((_6994 + _17768) - _20609)) * _Globals_.g_flNormalReplace2));
	            _14482 = _12792;
	        }
	        else
	        {
	            _11008 = _24174;
	            _14482 = _22927;
	        }
	        _13142 = mix(_9068 * mix(1.0, _17152 * 2.0, _6253 * _Globals_.g_flMetalnessCombine2), _17152, _6253 * _Globals_.g_flMetalnessReplace2);
	        _16307 = mix(_7406, float(_Globals_.g_bSnowLayer2 != 0), _6253);
	        _17121 = _11673;
	        _17124 = _11008;
	        _17125 = mix(_11237, _11241, _6253);
	        _14948 = _14482;
	        _13381 = _10593;
	    }
	    else
	    {
	        _13142 = _9068;
	        _16307 = _7406;
	        _17121 = _10048;
	        _17124 = _24174;
	        _17125 = _11237;
	        _14948 = _22927;
	        _13381 = _23405;
	    }
	    float _13984 = saturate(1.0 - _6253);
	    vec3 _14081 = _13381 * mix(vec3(1.0), input_5.xyz, vec3(saturate(saturate(((float(_Globals_.g_bMaskVertexColor1 == 0) * _13984) + (float(_Globals_.g_bMaskVertexColor2 == 0) * _6253)) + ((_24803 * _13984) + (_13141 * _6253))) * ((float(_Globals_.g_bVertexColorEnabled1 != 0) * _13984) + (float(_Globals_.g_bVertexColorEnabled2 != 0) * _6253)))));
	    vec2 _23398 = vec2(_14948.x);
	    bool _12896;
	    if (_Globals_.g_bWetness != 0)
	    {
	        _12896 = (_Globals_.g_fPuddleStrength + _Globals_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _12896 = false;
	    }
	    bool _12897;
	    if (_12896)
	    {
	        _12897 = input_0.z > 0.0;
	    }
	    else
	    {
	        _12897 = false;
	    }
	    vec3 _6618;
	    vec3 _13145;
	    vec3 _13695;
	    float _16308;
	    float _17127;
	    float _17128;
	    vec2 _17129;
	    SPIRV_CROSS_BRANCH
	    if (_12897)
	    {
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_0.z, saturate(PerViewConstantBufferCsgo_t._m11)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m12 - 0.5) * 2.0));
	        float _20426 = saturate(_23204 - 0.75);
	        float _8286 = _23204 + (4.0 * (_20426 * _20426));
	        float _16777 = _8286 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8286 * 20.0);
	        vec4 _9719;
	        float _24883;
	        SPIRV_CROSS_BRANCH
	        if (_Globals_.g_bPuddlesOnVerticalSurfaces != 0)
	        {
	            vec4 _9186 = vec4(0.0, 0.0, 1.0, 0.0);
	            _9186.x = _24347.x;
	            _9186.y = _24347.y;
	            _9186.z = _21302;
	            _9719 = _9186;
	            _24883 = max(0.0, _16777);
	        }
	        else
	        {
	            _9719 = vec4(0.0, 0.0, 1.0, 0.0);
	            _24883 = max(0.0, (_8286 * _14498) - _Globals_.g_fWetEdgeSpread);
	        }
	        float _16799 = max(0.001000000047497451305389404296875, _Globals_.g_fPuddleBlendSoftness);
	        float _14611 = smoothstep(_24883 + _16799, _24883 - (input_0.w + (_16799 * 2.0)), _17125) * _11964;
	        float _19808 = max((smoothstep(_23204, _16777 - (0.20000000298023223876953125 * _8286), _17125) * _Globals_.g_fWetEdgeStrength) * _11964, _14611) * _Globals_.g_fPuddleStrength;
	        float _17924 = (_23204 - 1.0) - _17125;
	        float _10334 = (saturate(_17924 + _Globals_.g_fPuddleSedimentHeight) * _Globals_.g_fPuddleSedimentOpacity) * _14611;
	        float _13706 = saturate(((saturate((((_8286 * 2.0) - (mix(0.5, _19372.w, saturate(_14498 * 20.0)) * 0.5)) - (_17125 * 0.5)) + 0.25) * _Globals_.g_fWetnessStrength) * _11964) + _14611);
	        float _13144;
	        float _13151;
	        vec4 _23607;
	        SPIRV_CROSS_BRANCH
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m9;
	            vec3 _6617;
	            vec4 _12898;
	            float _13143;
	            SPIRV_CROSS_BRANCH
	            if (_12497 > 0.0)
	            {
	                vec3 _18756 = normalize(vec3(-1.0, 0.20000000298023223876953125, 0.0));
	                float _9927 = PerViewConstantBufferCsgo_t._m10 * 6.283185482025146484375;
	                float _22373 = sin(_9927);
	                float _20617 = cos(_9927);
	                vec2 _23932 = _18756.xy * mat2(vec2(_20617, -_22373), vec2(_22373, _20617));
	                vec3 _22900 = _18756;
	                _22900.x = _23932.x;
	                _22900.y = _23932.y;
	                vec3 _21326 = -cross(_22900, _24347);
	                vec3 _13887 = _10061.xyz;
	                float _9965 = dot(_13887, _21326);
	                float _12056 = 1.0 - input_0.z;
	                vec2 _20274 = ((vec2(dot(_13887, _22900)) + (vec2(0.100000001490116119384765625, -0.100000001490116119384765625) * _9965)) + (vec2(8.0, 5.0) * _10061.z)) + vec2((_12056 * _12056) * (-80.0));
	                vec2 _15991 = vec2(_20274.x, _9965) * vec2(0.0199999995529651641845703125, 0.010999999940395355224609375);
	                vec4 _20877 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                vec2 _18922 = (_20877.xy * 2.0) - vec2(1.0);
	                float _22216 = saturate(length(fwidth(_15991)) * 10.0);
	                vec2 _15297 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_0.z) * mix(1.0, 0.300000011920928955078125, _22216);
	                vec2 _13712 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _15297);
	                _19601.y = dot(_13712, _15297);
	                vec2 _16046 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _20878 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_16046 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                vec2 _17104 = (((_20878.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_0.z;
	                _17104.y = _17104.y * 0.5;
	                float _9251 = saturate(length(fwidth(_16046)) * 10.0);
	                vec2 _13561 = _17104 * mix(1.0, 0.300000011920928955078125, _9251);
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _13561), dot(_13712, _13561));
	                vec4 _20490 = _19601;
	                _20490.x = _13330.x;
	                _20490.y = _13330.y;
	                _20490.w = input_0.z * (_20877.z + _20878.z);
	                vec3 _20491;
	                _20491.x = _10061.x;
	                _20491.y = _10061.y;
	                _13143 = _12497 * (0.039999999105930328369140625 * (_22216 + _9251));
	                _12898 = _9719 + ((_20490 * _14498) * _12497);
	                _6617 = _20491;
	            }
	            else
	            {
	                _13143 = 0.0;
	                _12898 = _9719;
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
	                int _18441;
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
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m0 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, saturate(fwidth(_20173) * 20.0)))) * ((saturate((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((saturate((sin((((_20213 + _18429) + 4.0) + (sin(_17125 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0) * _20213) / _18120) * 28.0));
	                    _18441 = _16208 + 1;
	                    _13155 = _25251;
	                    _16208 = _18441;
	                    continue;
	                }
	                vec3 _9348 = _13155 * _14498;
	                vec2 _15752 = _12898.xy + _9348.xy;
	                vec4 _20492 = _12898;
	                _20492.x = _15752.x;
	                _20492.y = _15752.y;
	                _9982 = _9348.z;
	                _21594 = _20492;
	            }
	            else
	            {
	                _9982 = 0.0;
	                _21594 = _12898;
	            }
	            vec3 _10508 = normalize(_21594.xyz);
	            vec4 _16886 = _21594;
	            _16886.x = _10508.x;
	            _16886.y = _10508.y;
	            _16886.z = _10508.z;
	            _13144 = _9982;
	            _13151 = _13143;
	            _23607 = _16886;
	        }
	        else
	        {
	            _13144 = 0.0;
	            _13151 = 0.0;
	            _23607 = _9719;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _23311 = vec3(_19808 * _10334);
	        vec3 _13713 = normalize(mix(_17124.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_14081, pow(_14081, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, saturate((pow(_14081, vec3(0.25)) * (_9038 * _14948.x)) * 8.0) * mix(_Globals_.g_flWetnessDarkeningStrength1, _Globals_.g_flWetnessDarkeningStrength2, _6253 * _Globals_.g_flColorReplace2));
	        _13145 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _17121, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, _23311), vec3(1.0 + _13144), vec3(_13144 * 0.100000001490116119384765625));
	        _16308 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _17127 = mix(_17121, 1.0, _19808);
	        _17128 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17129 = saturate(mix(_23398.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13713.xyz)) * 0.5)));
	        _13695 = _13713;
	        _6618 = mix(_17124, _23607.xyz, _23311);
	    }
	    else
	    {
	        _13145 = _14081;
	        _16308 = 0.0;
	        _17127 = _17121;
	        _17128 = _Globals_.g_flReflectance;
	        _17129 = _23398;
	        _13695 = vec3(1.0);
	        _6618 = _17124;
	    }
	    float _11750 = mix(_7406 * _Globals_.g_flSnowGlintStrength1, float(_Globals_.g_bSnowLayer2 != 0) * _Globals_.g_flSnowGlintStrength2, _6253);
	    bool _10474 = _16307 > 0.0;
	    vec3 _21018 = _10061.xyz;
	    vec3 _14997 = fwidth(_21018);
	    float _24419 = length(_14997);
	    bool _11564 = _11750 > 0.0;
	    float _12727;
	    float _13146;
	    float _16309;
	    vec3 _17131;
	    vec2 _17132;
	    vec3 _18774;
	    SPIRV_CROSS_BRANCH
	    if (_11564)
	    {
	        float _22968 = _11750 * (_Globals_.g_flSnowGlintIntensity * 0.75);
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
	        vec3 _18231;
	        if (all(equal(_13695, vec3(1.0))))
	        {
	            _18231 = _6618.xyz;
	        }
	        else
	        {
	            _18231 = _13695.xyz;
	        }
	        _13146 = _16301;
	        _16309 = _24419;
	        _17131 = _8392;
	        _17132 = mix(_17129.xy, vec2(mix(0.300000011920928955078125, 0.5, float(_16275 >> uint(16)) * 1.525902189314365386962890625e-05)), vec2(_12383));
	        _12727 = mix(_17128, min(0.300000011920928955078125 * (max(_16301, 1.0) * _22968), 0.89999997615814208984375), _12383);
	        _18774 = normalize(mix(_18231, _8392, vec3(_12383)));
	    }
	    else
	    {
	        _13146 = 0.0;
	        _16309 = 1.0;
	        _17131 = vec3(0.0, 0.0, 1.0);
	        _17132 = _17129;
	        _12727 = _17128;
	        _18774 = _13695;
	    }
	    float _10796 = max(_17127, 0.0);
	    vec3 _9451 = mix(vec3(_12727).xyz, _13145.xyz, vec3(_13142));
	    vec3 _17892 = mix(_18774, _6618, bvec3(all(equal(_18774, vec3(1.0)))));
	    vec3 _10562 = _24347.xyz;
	    vec3 _11099 = dFdx(_10562);
	    vec3 _9175 = dFdy(_10562);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21819 = max(_17132.xy, vec2(pow(saturate(max(dot(_10347, _10347), dot(_12420, _12420))), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec4 _23875 = vec4(_6618.xyz, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21714;
	    if (_24464.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m15) * PerViewConstantBufferCsgo_t._m14.xy) + (PerViewConstantBufferCsgo_t._m14.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12022 = _18418.z;
	        bool _12285 = abs(_12022) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m14.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12022 : _18579;
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
	        _21714 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m3], g_bindless_Sampler[_Globals_.g_sPointClamp]), (_11087 + mix(_23169, PerViewConstantBufferCsgo_t._m14.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21714 = 1.0;
	    }
	    float _8634 = dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _6618.xyz);
	    float _12320;
	    SPIRV_CROSS_BRANCH
	    if (_8634 > (_10474 ? (-0.25) : 0.0))
	    {
	        float _12503;
	        SPIRV_CROSS_BRANCH
	        if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	        {
	            int _23989;
	            int _10191;
	            float _13147;
	            vec3 _14975;
	            int _13039 = 0;
	            for (;;)
	            {
	                if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	                {
	                    _13147 = 1.0;
	                    _14975 = vec3(0.0);
	                    _10191 = -1;
	                    break;
	                }
	                vec4 _18322 = vec4(input_2.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_13039];
	                float _12779 = _18322.x;
	                if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	                {
	                    vec3 _19470 = vec3(_12779, _18322.yz);
	                    vec2 _24805 = _19470.xy;
	                    vec2 _22193 = vec2(1.0) - saturate((abs(_24805) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14));
	                    vec2 _20561 = (_24805 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                    vec3 _20493 = _19470;
	                    _20493.x = _20561.x;
	                    _20493.y = _20561.y;
	                    _13147 = saturate(_22193.x * _22193.y);
	                    _14975 = _20493;
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
	                if (_13147 < 1.0)
	                {
	                    float _7934;
	                    if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                    {
	                        int _15335 = _10191 + 1;
	                        vec4 _19671 = vec4(input_2.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_15335];
	                        vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                        vec3 _20494;
	                        _20494.x = _20562.x;
	                        _20494.y = _20562.y;
	                        _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20494.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                    }
	                    else
	                    {
	                        _7934 = 1.0;
	                    }
	                    _12501 = mix(_7934, _18270, _13147);
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
	            float _13279 = mix(_7258, 1.0, saturate((distance(_21018, PerViewConstantBuffer_t._m4) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16));
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
	    vec3 _9720;
	    vec3 _24884;
	    SPIRV_CROSS_BRANCH
	    if ((_8634 * _12320) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _6618.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_6618.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_16308 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m9.xyz);
	            float _8124 = saturate(_16308);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * saturate((_8780 + 0.20000000298023223876953125) * 4.0)) * saturate(mix(dot(mix(_6618.xyz, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m9.xyz), 1.0, _8124))), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_21819, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _12320).xyz;
	        _9720 = ((_9451.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24884 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18223.xyz * _16808);
	    }
	    else
	    {
	        _9720 = vec3(0.0);
	        _24884 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    vec4 _19363;
	    if (_20059)
	    {
	        vec4 _18621 = vec4(_21018, 1.0).xyzw * PerViewConstantBufferCsgo_t._m13;
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
	    vec3 _13148;
	    vec3 _16324;
	    _13148 = _9720;
	    _16324 = _24884;
	    uint _21567;
	    vec3 _13152;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13152 = _13148;
	        _16325 = _16324;
	        uint _20344;
	        vec3 _13214;
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
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_2.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7426;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7426 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7426 = false;
	                }
	                bool _12899;
	                if (!_7426)
	                {
	                    _12899 = true;
	                }
	                else
	                {
	                    _12899 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12899)
	                {
	                    _13214 = _13152;
	                    _15676 = _16325;
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
	                vec3 _11186;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10027 = g_BarnLights_1._m0[_12608]._m2.xyz - input_2.xyz;
	                    float _18345 = dot(_10027, _10027);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10027 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10027 + _16268) - _12302;
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
	                    _11186 = _10027 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * saturate(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * saturate(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))));
	                }
	                else
	                {
	                    _11186 = g_BarnLights_1._m0[_12608]._m2.xyz;
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
	                            float _11474 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15018 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11474, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11474, _15266) + pow(_15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
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
	                        vec4 _19009 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19009.xyz;
	                        vec3 _23629 = vec4((-_11186).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19009.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14082 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14082.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20497 = _14082;
	                        _20497.x = _20564.x;
	                        _20497.y = _20564.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _20497.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20496 = _13791;
	                        _20496.x = _20563.x;
	                        _20496.y = _20563.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _20496.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13214 = _13152;
	                    _15676 = _16325;
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
	                        _13214 = _13152;
	                        _15676 = _16325;
	                        break;
	                    }
	                    _21549 = _20482;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15461 = mix(_17892, _6618.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_6618.xyz, _11186.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18226;
	                if (_16308 > 0.0)
	                {
	                    float _8781 = dot(_15461, _11186.xyz);
	                    float _8125 = saturate(_16308);
	                    _18226 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * saturate((_8781 + 0.20000000298023223876953125) * 4.0)) * saturate(mix(dot(mix(_6618.xyz, _15461, vec3(10.0)), _11186.xyz), 1.0, _8125))), vec3(_8125));
	                }
	                else
	                {
	                    _18226 = _17875;
	                }
	                vec2 _17302 = max(_21819, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11186.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, _15461.xyz);
	                float _19211 = max(0.0, dot(_11186.xyz, _12282));
	                float _9851 = _17302.x;
	                float _25212 = _9851 * _9851;
	                float _19096 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19096 - 1.0)) + 1.0;
	                _13214 = _13152.xyz + (((_9451.xyz * (_19096 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15676 = _16325.xyz + (_18226.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13152 = _13214;
	            _16325 = _15676;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13148 = _13152;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21819.xy, vec2(0.5));
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
	    vec3 _20418 = vec3(_21714 * _10796).xyz;
	    vec3 _20015 = _8745 * _20418;
	    vec3 _19476 = _13148.xyz * _20418;
	    vec3 _12902;
	    SPIRV_CROSS_BRANCH
	    if (_11564)
	    {
	        float _19823 = 1.0 - saturate(dot(_6618.xyz, _12240));
	        float _10374 = _19823 * _19823;
	        float _12410 = radians(5.0 * mix(1.0, 3.0, _10374 * _10374));
	        float _13467 = _12410 * _12410;
	        float _15075 = (1.0 - (_13467 * 0.5)) + ((_13467 * _13467) * 0.0416666679084300994873046875);
	        float _15046 = max(1.0 - _15075, 9.9999999747524270787835121154785e-07);
	        float _20967 = 1.0 / max(_16309, 9.9999999747524270787835121154785e-07);
	        float _9867 = _13146 * pow(saturate(_20967), 1.0);
	        _12902 = _19476.xyz + (((pow(PerViewLightingConstantBufferGpu_t._m10.xyz, vec3(2.0)) * ((((((smoothstep(0.89999997615814208984375, 1.0, saturate((dot(_17131, normalize(PerViewLightingConstantBufferGpu_t._m9.xyz - _17138)) - _15075) / _15046)) * _9867) * smoothstep(1.0, 2.0, _20967)) * 20000.0) * _Globals_.g_flSnowGlintSparkle) * _12320) * saturate(_8634))) + (_20015.xyz * (1.5 * ((smoothstep(0.0, 0.300000011920928955078125, saturate((dot(_17131, normalize(vec3(0.0, 0.0, 1.0) - _17138)) - _15075) / _15046)) * _9867) * _Globals_.g_flSnowGlintIntensity)))) * _11750);
	    }
	    else
	    {
	        _12902 = _19476;
	    }
	    vec3 _9983;
	    vec3 _22798;
	    SPIRV_CROSS_BRANCH
	    if (_10474)
	    {
	        float _17864 = saturate(_8634);
	        float _10543 = saturate((_8634 + 0.25) * 0.800000011920928955078125) * 0.800000011920928955078125;
	        _9983 = mix(_20015, mix(pow(_20015, vec3(1.39999997615814208984375, 0.60000002384185791015625, 0.449999988079071044921875)), _20015, vec3(saturate(_10796 * 0.75))), vec3(_16307));
	        _22798 = _16324 + ((PerViewLightingConstantBufferGpu_t._m10.xyz * (_12320 * _16307)) * (((vec3(min(_10543, _17864)) + (vec3(0.60000002384185791015625, 1.0, 4.0) * max(_10543 - _17864, 0.0))) * mix(1.0, (0.63999998569488525390625 * pow(1.36000001430511474609375 + (1.2000000476837158203125 * dot(_12240, PerViewLightingConstantBufferGpu_t._m9.xyz)), -1.5)) * (1.32679998874664306640625 + (_17864 * (2.138000011444091796875 + (_17864 * (1.677700042724609375 + (_17864 * (-0.361699998378753662109375))))))), 0.300000011920928955078125)) - vec3(_17864)));
	    }
	    else
	    {
	        _9983 = _20015;
	        _22798 = _16324;
	    }
	    vec3 _22686 = (_22798.xyz + _9983.xyz) * (_13145.xyz * (1.0 - _13142)).xyz;
	    float _12932 = _22686.x;
	    vec4 _11204 = vec4(_12932, _22686.yz, input_5.w);
	    _11204.x = _12932;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    vec3 _15754 = _11204.xyz + _12902.xyz;
	    vec4 _20498 = _11204;
	    _20498.x = _15754.x;
	    _20498.y = _15754.y;
	    _20498.z = _15754.z;
	    vec3 _15734 = _20498.xyz + ((((mix(_11427.xxx, _11427.yyy, _9451) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m6], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _20418).xyz;
	    vec4 _13889 = _20498;
	    _13889.x = _15734.x;
	    _13889.y = _15734.y;
	    _13889.z = _15734.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _23187 = _21018 - PerViewConstantBuffer_t._m4.xyz;
	        vec3 _9057 = _23187.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _23187.xyz;
	            bool _12903;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m19.x)
	            {
	                _12903 = (_10061.z * PerViewConstantBufferCsgo_t._m19.z) < PerViewConstantBufferCsgo_t._m19.y;
	            }
	            else
	            {
	                _12903 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12903)
	            {
	                vec2 _9342 = saturate(PerViewConstantBufferCsgo_t._m16.xy + (PerViewConstantBufferCsgo_t._m16.zw * vec2(length(_21493), _10061.z)));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m17.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m17.y)) * PerViewConstantBufferCsgo_t._m18.w;
	                _19340 = mix(_13889.xyz, vec4(PerViewConstantBufferCsgo_t._m18.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13889.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13889;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12904;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m23.x)
	            {
	                _12904 = (PerViewConstantBufferCsgo_t._m23.z * _10061.z) < PerViewConstantBufferCsgo_t._m23.y;
	            }
	            else
	            {
	                _12904 = false;
	            }
	            if (_12904)
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
	        _6805 = _13889;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	IntAttribute(TexCoord2ScaleByModelU, g_nScaleTexCoord2UByModelScaleAxis-1);
	IntAttribute(TexCoord2ScaleByModelV, g_nScaleTexCoord2VByModelScaleAxis-1);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	FloatAttribute(_dummyMakeVisiblePropMaskBias1, g_flDetailPropMaskBias1);
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction1, g_flDetailPropPuddleReduction1);
	FloatAttribute(_dummyMakeVisiblePropMaskBias2, g_flDetailPropMaskBias2);
	FloatAttribute(_dummyMakeVisiblePropMaskSoftness2, g_flDetailPropMaskSoftness2);
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction2, g_flDetailPropPuddleReduction2);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	FloatAttribute(OcclusionCullingBoundsScale, F_OCCLUSION_CULLING_BOUNDS_SCALE ? g_flOcclusionCullingBoundsScale : F_DEPTH_BIAS ? 1.3 : 1);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor1);
	TextureAttribute(RepresentativeTexture, g_tColor1);
	
	#if (S_BLEND_EFFECTS_3 == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_ENABLE_LAYER_3 == 0)
		IntAttribute(MaterialLayerCount, 2);
	#endif
	#if (S_BLEND_EFFECTS_3 == 1)
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_ALPHA_TEST == 0)
		IntAttribute(DepthPassBatchID, F_RENDER_BACKFACES ? 0 : 1);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		IntAttribute(DepthPassBatchID, F_RENDER_BACKFACES ? 0 : 1);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_SHARED_COLOR_OVERLAY == 0)
		BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nUVSet3>0 && (g_vTexCoordScale3.x!=1 || g_vTexCoordScale3.y!=1 || g_flTexCoordRotation3!=0)) ? 1 : 0);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_SHARED_COLOR_OVERLAY == 1)
		BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nUVSet3>0 && (g_vTexCoordScale3.x!=1 || g_vTexCoordScale3.y!=1 || g_flTexCoordRotation3!=0) || g_nColorOverlayUVSet>0 && (g_vOverlayTexCoordScale.x!=1 || g_vOverlayTexCoordScale.y!=1 || g_flOverlayTexCoordRotation!=0)) ? 1 : 0);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 0)
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
		IntAttribute(MaterialLayerCount, 3);
	#endif
	
	// Variant Attributes
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0)) ? 1 : 0);
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nColorOverlayUVSet>0 && (g_vOverlayTexCoordScale.x!=1 || g_vOverlayTexCoordScale.y!=1 || g_flOverlayTexCoordRotation!=0)) ? 1 : 0);
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? NotEqual : Always);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, F_DEPTH_BIAS ? -64 : 0);
	RenderState(DepthBiasClamp, F_DEPTH_BIAS ? -.0005 : 0);
	RenderState(DepthClipEnable, false);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? false : true);
	RenderState(DepthFunc, Equal);
	RenderState(DepthWriteEnable, false);
	RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING || F_DEPTH_BIAS) ? false : true);
	RenderState(SlopeScaleDepthBias, F_DEPTH_BIAS ? -2 : 0);
	RenderState(StencilEnable, true);
	RenderState(StencilFunc, NotEqual);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	#if (S_PIXEL_DEPTH_OFFSET == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_MODE_DEPTH == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING || F_DEPTH_BIAS) ? false : true);
	#endif
	#if (S_MODE_DEPTH == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING || F_DEPTH_BIAS) ? false : true);
	#endif
	
	// Variant parameters
	RenderState(DepthWriteEnable, false);
	
	BoolAttribute(BindlessResources, true);
	
}

RTX
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_PIXEL_DEPTH_OFFSET, F_PIXEL_DEPTH_OFFSET );
	StaticCombo( S_SHARED_COLOR_OVERLAY, F_SHARED_COLOR_OVERLAY );
	StaticCombo( S_ENABLE_LAYER_3, F_ENABLE_LAYER_3 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_USE_NEW_BLENDING, F_USE_NEW_BLENDING );
	StaticCombo( S_ENABLE_VISUALIZATIONS, F_ENABLE_VISUALIZATIONS );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_BLEND_EFFECTS_2, F_BLEND_EFFECTS_2 );
	StaticCombo( S_BLEND_EFFECTS_3, F_BLEND_EFFECTS_3 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_DETAIL_NORMAL ) );
	StaticComboRule( Allow0( S_MODE_DEPTH ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Requires( S_BLEND_EFFECTS_3, S_ENABLE_LAYER_3 ) );
	StaticComboRule( Allow1( S_PIXEL_DEPTH_OFFSET, S_ALPHA_TEST ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nColorOverlayUVSet==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0 || g_nColorOverlayUVSet==0); >;
	bool bBlendByFacingDirection2 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_2); >;
	bool bBlendByFacingDirection3 < UiType(CheckBox); Expression(F_BLEND_BY_FACING_DIRECTION_3); >;
	bool g_bAdjustBaseColor1 < UiType(CheckBox); Expression(g_nColorCorrectionMode1==1); >;
	bool g_bAdjustBaseColor2 < UiType(CheckBox); Expression(g_nColorCorrectionMode2==1); >;
	bool g_bAdjustBaseColor3 < UiType(CheckBox); Expression(g_nColorCorrectionMode3==1); >;
	bool g_bBorderBlendColorize2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==3); >;
	bool g_bBorderBlendColorize3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==3); >;
	bool g_bBorderBlendMod2x2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==2); >;
	bool g_bBorderBlendMod2x3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==2); >;
	bool g_bBorderBlendMultiply2 < UiType(CheckBox); Expression(!F_BORDER_BLEND_MODE_2); >;
	bool g_bBorderBlendMultiply3 < UiType(CheckBox); Expression(!F_BORDER_BLEND_MODE_3); >;
	bool g_bBorderBlendReplace2 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_2==1); >;
	bool g_bBorderBlendReplace3 < UiType(CheckBox); Expression(F_BORDER_BLEND_MODE_3==1); >;
	bool g_bBorderRoughness2 < UiType(CheckBox); Expression(F_BORDER_ROUGHNESS_2); >;
	bool g_bBorderRoughness3 < UiType(CheckBox); Expression(F_BORDER_ROUGHNESS_3); >;
	bool g_bColorOverlayLayer1 < UiType(CheckBox); Expression(g_nColorOverlayMode==0 || g_nColorOverlayMode==1); >;
	bool g_bColorOverlayLayer2 < UiType(CheckBox); Expression(g_nColorOverlayMode==0 || g_nColorOverlayMode==2); >;
	bool g_bColorOverlayLayer3 < UiType(CheckBox); Expression(g_nColorOverlayMode==0 || g_nColorOverlayMode==3); >;
	bool g_bColorOverlayMaskLayer1 < UiType(CheckBox); Expression(g_nColorOverlayTintMask==0 || g_nColorOverlayTintMask==1); >;
	bool g_bColorOverlayMaskLayer2 < UiType(CheckBox); Expression(g_nColorOverlayTintMask==0 || g_nColorOverlayTintMask==2); >;
	bool g_bColorOverlayMaskLayer3 < UiType(CheckBox); Expression(g_nColorOverlayTintMask==0 || g_nColorOverlayTintMask==3); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS ? 1 : 0); >;
	bool g_bMaskVertexColor1 < UiType(CheckBox); Expression(g_nVertexColorMode1==0); >;
	bool g_bMaskVertexColor2 < UiType(CheckBox); Expression(g_nVertexColorMode2==0); >;
	bool g_bMaskVertexColor3 < UiType(CheckBox); Expression(g_nVertexColorMode3==0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES ? 1 : 0) ? 1 : 0); >;
	bool g_bVertexColorEnabled1 < UiType(CheckBox); Expression(g_nVertexColorMode1!=2); >;
	bool g_bVertexColorEnabled2 < UiType(CheckBox); Expression(g_nVertexColorMode2!=2); >;
	bool g_bVertexColorEnabled3 < UiType(CheckBox); Expression(g_nVertexColorMode3!=2); >;
	bool g_bWetness < UiType(CheckBox); Expression((F_WETNESS==1) ? 1 : 0); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust2 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint2,1),MatrixColorCorrect2(float3(g_fTextureColorContrast2,g_fTextureColorSaturation2,g_fTextureColorBrightness2),TextureAverageColor(g_tColor2)))); >;
	float4x4 g_mTextureColorAdjust3 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint3,1),MatrixColorCorrect2(float3(g_fTextureColorContrast3,g_fTextureColorSaturation3,g_fTextureColorBrightness3),TextureAverageColor(g_tColor3)))); >;
	int g_nVisualization < UiType(Slider); Expression(F_VISUALIZATION_MODE); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor2 < Channel(RGB, ArtistDefined(TextureColor2), Srgb); Channel(A, Box(TextureAmbientOcclusion2), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor3 < Channel(RGB, ArtistDefined(TextureColor3), Srgb); Channel(A, Box(TextureAmbientOcclusion3), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight2 < Channel(R, Box(TextureHeight2), Linear); Channel(G, Box(TextureTintMask2), Linear); Channel(A, Box(TextureMetalness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight3 < Channel(R, Box(TextureHeight3), Linear); Channel(G, Box(TextureTintMask3), Linear); Channel(A, Box(TextureMetalness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal1 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal1, TextureRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal2 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal2, TextureRoughness2), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal3 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal3, TextureRoughness3), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSharedColorOverlay < Channel(RGB, ArtistDefined(TextureSharedColorOverlay), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	float4 g_vNormalXform_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalXform_2 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalXform_3 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation3*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vOverlayTexCoordXform0 < UiType(VectorText); Expression(v0 = g_flOverlayTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vOverlayTexCoordScale.x,-v2*g_vOverlayTexCoordScale.y,0,g_vOverlayTexCoordCenter.x+g_vOverlayTexCoordOffset.x+v2*g_vOverlayTexCoordCenter.y-v1*g_vOverlayTexCoordCenter.x)); >;
	float4 g_vOverlayTexCoordXform1 < UiType(VectorText); Expression(v0 = g_flOverlayTexCoordRotation*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vOverlayTexCoordScale.x,v1*g_vOverlayTexCoordScale.y,0,g_vOverlayTexCoordCenter.y+g_vOverlayTexCoordOffset.y-(v2*g_vOverlayTexCoordCenter.x+v1*g_vOverlayTexCoordCenter.y))); >;
	float4 g_vTexCoordXform0_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale1.x,-v2*g_vTexCoordScale1.y,0,g_vTexCoordCenter1.x+g_vTexCoordOffset1.x+v2*g_vTexCoordCenter1.y-v1*g_vTexCoordCenter1.x)); >;
	float4 g_vTexCoordXform0_2 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale2.x,-v2*g_vTexCoordScale2.y,0,g_vTexCoordCenter2.x+g_vTexCoordOffset2.x+v2*g_vTexCoordCenter2.y-v1*g_vTexCoordCenter2.x)); >;
	float4 g_vTexCoordXform0_3 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation3*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale3.x,-v2*g_vTexCoordScale3.y,0,g_vTexCoordCenter3.x+g_vTexCoordOffset3.x+v2*g_vTexCoordCenter3.y-v1*g_vTexCoordCenter3.x)); >;
	float4 g_vTexCoordXform1_1 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation1*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale1.x,v1*g_vTexCoordScale1.y,0,g_vTexCoordCenter1.y+g_vTexCoordOffset1.y-(v2*g_vTexCoordCenter1.x+v1*g_vTexCoordCenter1.y))); >;
	float4 g_vTexCoordXform1_2 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation2*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale2.x,v1*g_vTexCoordScale2.y,0,g_vTexCoordCenter2.y+g_vTexCoordOffset2.y-(v2*g_vTexCoordCenter2.x+v1*g_vTexCoordCenter2.y))); >;
	float4 g_vTexCoordXform1_3 < UiType(VectorText); Expression(v0 = g_flTexCoordRotation3*3.1415927/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale3.x,v1*g_vTexCoordScale3.y,0,g_vTexCoordCenter3.y+g_vTexCoordOffset3.y-(v2*g_vTexCoordCenter3.x+v1*g_vTexCoordCenter3.y))); >;
	
	// Material1
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Material1,0/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask1, Linear, 8, "", "_mask", "Material1/Tint Mask,15/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureTranslucency1, Linear, 8, "", "_trans", "Material1/Translucent,15/0", Default4(1, 1, 1, 0));
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	float2 g_vTexCoordCenter2 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float g_flTexCoordRotation2 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/3"); UiVisibility(1); >;
	float2 g_vTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vTexCoordOffset2 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float g_fTintMaskBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Tint Mask/5"); >;
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
	float g_flDetailPropMaskBias1 < Range(0, 10); UiType(Slider); UiGroup("Material1/Detail Props,90/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float3 g_vAmbientOcclusionLevels1 < Default3(0, 0.5, 1); Range(-1, 1); Attribute("0=Option 1,1=Option 2,2=Option 3"); UiType(VectorText); UiGroup("Material1/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	float g_flDetailPropPuddleReduction1 < UiType(Slider); UiGroup("Material1/Detail Props,90/30"); >;
	float g_flHeightMapZeroPoint1 < Default(0.5); UiType(Slider); UiGroup("Material1/Height/30"); >;
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	int g_nVertexColorMode1 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material1/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength1 < Default(1); UiType(Slider); UiGroup("Material1/Lighting/61"); >;
	
	// Material2
	CreateInputTexture2D(TextureColor2, Srgb, 8, "", "_color", "Material2/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal2, Linear, 8, "NormalizeNormals", "_normal", "Material2/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask2, Linear, 8, "", "_mask", "Material2/Tint Mask,15/0", Default4(1, 1, 1, 0));
	float g_flColorReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/0"); >;
	int g_nUVSet2 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material2/Texture Coordinates,34/1"); >;
	float g_fTintMaskBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Tint Mask/5"); >;
	CreateInputTexture2D(TextureHeight2, Linear, 8, "", "_height", "Material2/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness2, Linear, 8, "Inverse", "_rough", "Material2/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast2 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material2/Tint Mask/10"); >;
	float g_flColorOverlay2 < UiType(Slider); UiGroup("Material2/Selective Blending/10"); >;
	float g_flDetailPropMaskSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Detail Props,90/10"); >;
	float3 g_vFacingDirection2 < Default3(0, 0, 1); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material2/Facing Direction/10"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float3 g_vTextureColorTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Material2/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2,0/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Lighting/12"); >;
	float g_fTextureNormalContrast2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Lighting/13"); >;
	bool g_bMetalness2 < Default(1); UiType(CheckBox); UiGroup("Material2/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion2, Linear, 8, "", "_ao", "Material2/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/20"); >;
	float g_flDetailPropMaskBias2 < Range(0, 10); UiType(Slider); UiGroup("Material2/Detail Props,90/20"); >;
	float g_flFacingDirectionMaskSpread2 < Default(0.5); UiType(Slider); UiGroup("Material2/Facing Direction/20"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flHeightMapScale2 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flNormalReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/20"); >;
	float3 g_vAmbientOcclusionLevels2 < Default3(0, 0.5, 1); Range(-1, 1); UiType(VectorText); UiGroup("Material2/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness2, Linear, 8, "", "_metal", "Material2/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Color Correction/30"); >;
	float g_flDetailPropPuddleReduction2 < UiType(Slider); UiGroup("Material2/Detail Props,90/30"); >;
	float g_flHeightMapZeroPoint2 < Default(0.5); UiType(Slider); UiGroup("Material2/Height/30"); >;
	float g_flNormalCombine2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Selective Blending/30"); >;
	float g_vFacingDirectionMaskNormalMapStrength2 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material2/Facing Direction/30"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_fTextureColorBrightness2 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material2/Color Correction/40"); >;
	float g_flBlendSoftness2 < Default(0.01); UiType(Slider); UiGroup("Material2/Height,30/40"); >;
	float g_flRoughnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/40"); >;
	float g_vFacingDirectionMaskSoftness2 < Default(0.1); UiType(Slider); UiGroup("Material2/Facing Direction/40"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_2>0); >;
	float g_flUnderlyingHeightMapInfluence2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height,30/41"); >;
	float g_flRoughnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/45"); >;
	int g_nColorCorrectionMode2 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material2/Color Correction/45"); >;
	float g_flMetalnessReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/50"); >;
	float g_flMetalnessCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/55"); >;
	bool g_bModelTint2 < Default(1); UiType(CheckBox); UiGroup("Material2/Color Correction/60"); >;
	float g_flAOReplace2 < Default(1); UiType(Slider); UiGroup("Material2/Selective Blending/60"); >;
	int g_nVertexColorMode2 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material2/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength2 < Default(1); UiType(Slider); UiGroup("Material2/Lighting/62"); >;
	float g_flAOCombine2 < UiType(Slider); UiGroup("Material2/Selective Blending/70"); >;
	float g_flMaskWithHeight2 < Range(0, 8); UiType(Slider); UiGroup("Material2/Height/70"); >;
	
	// Material3
	CreateInputTexture2D(TextureColor3, Srgb, 8, "", "_color", "Material3/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal3, Linear, 8, "NormalizeNormals", "_normal", "Material3/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask3, Linear, 8, "", "_mask", "Material3/Tint Mask,15/0", Default4(1, 1, 1, 0));
	float g_flColorReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/0"); >;
	int g_nUVSet3 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material3/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter3 < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Material3/Texture Transform,35/1"); UiVisibility(1); >;
	float2 g_vTexCoordScale3 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material3/Texture Transform,35/2"); >;
	float g_flTexCoordRotation3 < Range(-360, 360); UiType(Slider); UiGroup("Material3/Texture Transform,35/3"); UiVisibility(1); >;
	float2 g_vTexCoordOffset3 < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Material3/Texture Transform,35/4"); UiVisibility(1); >;
	float g_fTintMaskBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Tint Mask/5"); >;
	CreateInputTexture2D(TextureHeight3, Linear, 8, "", "_height", "Material3/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness3, Linear, 8, "Inverse", "_rough", "Material3/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast3 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material3/Tint Mask/10"); >;
	float g_flColorOverlay3 < UiType(Slider); UiGroup("Material3/Selective Blending/10"); >;
	float g_flDetailPropMaskSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Detail Props,90/10"); >;
	float3 g_vFacingDirection3 < Default3(0, 0, 1); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Material3/Facing Direction/10"); Expression(normalize(float3(this.x,this.y,this.z+((this.z==0) ? .0001 : 0)))); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float3 g_vTextureColorTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Material3/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3,2/Lighting,20/11"); >;
	float g_fTextureRoughnessBrightness3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Lighting/12"); >;
	float g_fTextureNormalContrast3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Lighting/13"); >;
	bool g_bMetalness3 < Default(1); UiType(CheckBox); UiGroup("Material3/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion3, Linear, 8, "", "_ao", "Material3/Lighting/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/20"); >;
	float g_flDetailPropMaskBias3 < Range(0, 10); UiType(Slider); UiGroup("Material3/Detail Props,90/20"); >;
	float g_flFacingDirectionMaskSpread3 < Default(0.5); UiType(Slider); UiGroup("Material3/Facing Direction/20"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flHeightMapScale3 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flNormalReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/20"); >;
	float3 g_vAmbientOcclusionLevels3 < Default3(0, 0.5, 1); Range(-1, 1); UiType(VectorText); UiGroup("Material3/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness3, Linear, 8, "", "_metal", "Material3/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Color Correction/30"); >;
	float g_flDetailPropPuddleReduction3 < UiType(Slider); UiGroup("Material3/Detail Props,90/30"); >;
	float g_flHeightMapZeroPoint3 < Default(0.5); UiType(Slider); UiGroup("Material3/Height/30"); >;
	float g_flNormalCombine3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Selective Blending/30"); >;
	float g_vFacingDirectionMaskNormalMapStrength3 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material3/Facing Direction/30"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_fTextureColorBrightness3 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material3/Color Correction/40"); >;
	float g_flBlendSoftness3 < Default(0.01); UiType(Slider); UiGroup("Material3/Height,30/40"); >;
	float g_flRoughnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/40"); >;
	float g_vFacingDirectionMaskSoftness3 < Default(0.1); UiType(Slider); UiGroup("Material3/Facing Direction/40"); UiVisibility(F_BLEND_BY_FACING_DIRECTION_3>0); >;
	float g_flUnderlyingHeightMapInfluence3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height,30/41"); >;
	float g_flRoughnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/45"); >;
	int g_nColorCorrectionMode3 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material3/Color Correction/45"); >;
	float g_flMetalnessReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/50"); >;
	float g_flMetalnessCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/55"); >;
	float g_flAOReplace3 < Default(1); UiType(Slider); UiGroup("Material3/Selective Blending/60"); >;
	int g_nVertexColorMode3 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material3/Color Correction/60"); >;
	bool g_bModelTint3 < Default(1); UiType(CheckBox); UiGroup("Material3/Color Correction/61"); >;
	float g_flWetnessDarkeningStrength3 < Default(1); UiType(Slider); UiGroup("Material3/Lighting/63"); >;
	float g_flAOCombine3 < UiType(Slider); UiGroup("Material3/Selective Blending/70"); >;
	float g_flMaskWithHeight3 < Range(0, 8); UiType(Slider); UiGroup("Material3/Height/70"); >;
	
	// Color
	CreateInputTexture2D(TextureSharedColorOverlay, Linear, 8, "", "_color", "Color/Overlay/0", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nColorOverlayUVSet < Default(2); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Color/Overlay/40"); >;
	int g_nColorOverlayMode < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=All Layers,1=Layer1,2=Layer2,3=Layer3"); UiType(Enum); UiGroup("Color/Overlay/50"); >;
	int g_nColorOverlayTintMask < Range4(0, 0, 0, 0, 4, 4, 4, 4); UiOptions("0=Mask All,1=Mask Layer1,2=Mask Layer2,3=Mask Layer3,4=Unmasked"); UiType(Enum); UiGroup("Color/Overlay/55"); >;
	float3 g_vColorOverlayLayerStrengths < Default3(1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/60"); >;
	float3 g_vColorOverlayTintMaskStrengths < Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Color/Overlay/65"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	float g_flOverlayDarknessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/100"); >;
	int g_nScaleTexCoord2UByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.u * model.x,2=UV2.u * model.y,3=UV2.u * model.z"); UiType(Enum); UiGroup("Color/100"); UiVisibility(1); >;
	float g_flOverlayBrightnessContrast < Default(1); Range(0.2, 2); UiType(Slider); UiGroup("Color/Overlay/110"); >;
	int g_nScaleTexCoord2VByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV2.v * model.x,2=UV2.v * model.y,3=UV2.v * model.z"); UiType(Enum); UiGroup("Color/110"); UiVisibility(1); >;
	float2 g_vOverlayTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/Overlay/200"); >;
	float2 g_vOverlayTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/Overlay/210"); >;
	float g_flOverlayTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/Overlay/220"); >;
	float2 g_vOverlayTexCoordOffset < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Color/Overlay/230"); >;
	
	// Blend Effects
	float g_flBorderSpread2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects,8/Border Layer 2,0/10"); >;
	float g_flBorderSpread3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 3,10/10"); >;
	float g_flBorderSoftness2 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/20"); >;
	float g_flBorderSoftness3 < Default(0.1); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/20"); >;
	float g_flBorderOffset2 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/30"); >;
	float g_flBorderOffset3 < Range(-4, 4); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/30"); >;
	float g_fBorderRoughness2 < Default(0.5); UiType(Slider); UiGroup("Blend Effects/Border Layer 2/35"); UiVisibility(F_BORDER_ROUGHNESS_2); >;
	float g_fBorderRoughness3 < Default(0.5); UiType(Slider); UiGroup("Blend Effects/Border Layer 3/35"); UiVisibility(F_BORDER_ROUGHNESS_3); >;
	float3 g_vBorderTint2 < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Effects/Border Layer 2/40"); Expression(SrgbGammaToLinear(this)); >;
	float3 g_vBorderTint3 < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Effects/Border Layer 3/40"); Expression(SrgbGammaToLinear(this)); >;
	bool g_bBorderTintMask3 < UiType(CheckBox); UiGroup("Blend Effects/Border Layer 3/41"); >;
	float2 g_vBorderLayerAmount2 < Default(1); UiType(VectorText); UiGroup("Blend Effects/Border Layer 2/41"); >;
	float2 g_vBorderLayerAmount3 < Default(1); UiType(VectorText); UiGroup("Blend Effects/Border Layer 3/41"); >;
	bool g_bBorderTintMask2 < UiType(CheckBox); UiGroup("Blend Effects/Border Layer 2/42"); >;
	
	// Wetness
	bool g_bWetnessUseHeightmapAdjustments < UiType(CheckBox); UiGroup("Wetness/2"); UiVisibility(F_WETNESS ? 1 : 0); >;
	bool g_bPuddlesOnVerticalSurfaces < UiType(CheckBox); UiGroup("Wetness,9/3"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_flWetnessUnderlyingHeightMapInfluence < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/3"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_flHorizontalSurfaceTolerance < Default(32); Range(0, 100); UiType(Slider); UiGroup("Wetness/4"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleStrength < Default(1); UiType(Slider); UiGroup("Wetness/5"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleHeight < Default(0.5); UiType(Slider); UiGroup("Wetness/6"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float3 g_vPuddleSedimentColor < Default3(0.62, 0.56, 0.5); UiType(Color); UiGroup("Wetness/10"); Expression(SrgbGammaToLinear(this)); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleSedimentHeight < Default(0.9); Range(0, 2); UiType(Slider); UiGroup("Wetness/15"); Expression(this*2-1); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleSedimentOpacity < Default(0.25); UiType(Slider); UiGroup("Wetness/16"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleRoughness < Default(0.02); UiType(Slider); UiGroup("Wetness/17"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fPuddleBlendSoftness < Default(0.08); UiType(Slider); UiGroup("Wetness/18"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetEdgeStrength < Default(0.5); UiType(Slider); UiGroup("Wetness/20"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetEdgeSpread < Default(0.2); UiType(Slider); UiGroup("Wetness/25"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetEdgeSoftness < Default(0.2); UiType(Slider); UiGroup("Wetness/26"); UiVisibility(F_WETNESS ? 1 : 0); >;
	float g_fWetnessStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/30"); UiVisibility(F_WETNESS ? 1 : 0); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
		Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_USE_NEW_BLENDING == 1)
		float g_flHeightMapScale1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Height/20"); >;
		float g_flHeightMapScale2 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material2/Height/20"); >;
	#endif
	
	// Variant parameters
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nColorOverlayUVSet==0); >;
	bool bBiplanarUsedAny < UiType(CheckBox); Expression(g_nUVSet1==0 || g_nUVSet2==0 || g_nUVSet3==0 || g_nColorOverlayUVSet==0); >;
	float g_flHeightMapScale1 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float g_flHeightMapScale2 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material2/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material3/Height/20"); >;
	float g_flHeightMapScale3 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material3/Height/20"); >;
	
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
	    vec3 g_vBiplanarTexCoordScale;
	    float g_flDetailPropMaskBias1;
	    float g_flDetailPropPuddleReduction1;
	    bool g_bSnowLayer1;
	    float g_flSnowGlintStrength1;
	    int g_nUVSet1;
	    vec2 g_vTexCoordScale1;
	    vec2 g_vTexCoordCenter1;
	    float g_flTexCoordRotation1;
	    float _g_fl_AutoPad0_;
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
	    float _g_fl_AutoPad1_;
	    vec2 g_vDetailTexCoordOffset1;
	    vec4 g_vDetailTexCoordXform0_1;
	    vec4 g_vDetailTexCoordXform1_1;
	    vec4 g_vDetailNormalXform_1;
	    int g_nDupeOfLayer2;
	    float g_flBlendSoftness2;
	    float g_flUnderlyingHeightMapInfluence2;
	    bool g_bSnowLayer2;
	    float g_flSnowGlintStrength2;
	    int g_nUVSet2;
	    vec2 g_vTexCoordScale2;
	    vec2 g_vTexCoordCenter2;
	    float g_flTexCoordRotation2;
	    float _g_fl_AutoPad2_;
	    vec2 g_vTexCoordOffset2;
	    float _g_fl_AutoPad3_;
	    float _g_fl_AutoPad4_;
	    vec4 g_vTexCoordXform0_2;
	    vec4 g_vTexCoordXform1_2;
	    vec4 g_vNormalXform_2;
	    float g_flWetnessDarkeningStrength2;
	    int g_nDetailUVSet2;
	    vec2 g_vDetailTexCoordScale2;
	    vec2 g_vDetailTexCoordCenter2;
	    float g_flDetailTexCoordRotation2;
	    float _g_fl_AutoPad5_;
	    vec2 g_vDetailTexCoordOffset2;
	    float _g_fl_AutoPad6_;
	    float _g_fl_AutoPad7_;
	    vec4 g_vDetailTexCoordXform0_2;
	    vec4 g_vDetailTexCoordXform1_2;
	    vec4 g_vDetailNormalXform_2;
	    float g_flDetailPropMaskSoftness2;
	    float g_flDetailPropMaskBias2;
	    float g_flDetailPropPuddleReduction2;
	    uint g_tNormal1;
	    uint g_tHeight1;
	    uint g_tNormalDetail1;
	    float g_fDetailTextureNormalContrast1;
	    float g_fTintMaskContrast1;
	    float g_fTintMaskBrightness1;
	    float _g_fl_AutoPad8_;
	    float _g_fl_AutoPad9_;
	    float _g_fl_AutoPad10_;
	    vec3 g_vAmbientOcclusionLevels1;
	    float _g_fl_AutoPad11_;
	    vec3 g_vTextureColorTint1;
	    float g_fTextureColorContrast1;
	    float g_fTextureColorSaturation1;
	    float g_fTextureColorBrightness1;
	    int g_nColorCorrectionMode1;
	    bool g_bAdjustBaseColor1;
	    float g_flHeightMapScale1;
	    float g_flHeightMapZeroPoint1;
	    int g_nVertexColorMode1;
	    bool g_bVertexColorEnabled1;
	    bool g_bMaskVertexColor1;
	    float g_fTextureRoughnessContrast1;
	    float g_fTextureRoughnessBrightness1;
	    float g_fTextureNormalContrast1;
	    bool g_bMetalness1;
	    bool g_bModelTint1;
	    float _g_fl_AutoPad12_;
	    float _g_fl_AutoPad13_;
	    mat4 g_mTextureColorAdjust1;
	    mat4 g_mTextureAdjust1;
	    float g_flBlendSoftnessDistanceModifierStrength;
	    float g_flColorReplace2;
	    float g_flColorOverlay2;
	    float g_flNormalReplace2;
	    float g_flNormalCombine2;
	    float g_flRoughnessReplace2;
	    float g_flRoughnessCombine2;
	    float g_flMetalnessReplace2;
	    float g_flMetalnessCombine2;
	    float g_flAOReplace2;
	    float g_flAOCombine2;
	    float g_fTextureRoughnessContrast2;
	    float g_fTextureRoughnessBrightness2;
	    float g_fTextureNormalContrast2;
	    bool g_bMetalness2;
	    float g_fTintMaskContrast2;
	    float g_fTintMaskBrightness2;
	    uint g_tColor2;
	    uint g_tNormal2;
	    uint g_tHeight2;
	    vec3 g_vAmbientOcclusionLevels2;
	    float _g_fl_AutoPad14_;
	    vec3 g_vTextureColorTint2;
	    float g_fTextureColorContrast2;
	    float g_fTextureColorSaturation2;
	    float g_fTextureColorBrightness2;
	    int g_nColorCorrectionMode2;
	    bool g_bAdjustBaseColor2;
	    mat4 g_mTextureColorAdjust2;
	    mat4 g_mTextureAdjust2;
	    float g_flHeightMapScale2;
	    float g_flHeightMapZeroPoint2;
	    float g_flMaskWithHeight2;
	    float g_flPDOScale2;
	    float g_flPDOOffset2;
	    float g_flPDOContactAoDistance2;
	    float g_flPDOContactAoStrength2;
	    float g_flPDOSoftIntersectionWidth2;
	    float g_flParallaxStrength2;
	    float _g_fl_AutoPad15_;
	    float _g_fl_AutoPad16_;
	    float _g_fl_AutoPad17_;
	    vec3 g_vFacingDirection2;
	    float g_flFacingDirectionMaskSpread2;
	    float g_vFacingDirectionMaskNormalMapStrength2;
	    float g_vFacingDirectionMaskSoftness2;
	    int g_nVertexColorMode2;
	    bool g_bVertexColorEnabled2;
	    bool g_bMaskVertexColor2;
	    bool g_bModelTint2;
	    uint g_tNormalDetail2;
	    float g_fDetailTextureNormalContrast2;
	    bool g_bPuddlesOnVerticalSurfaces;
	    bool g_bWetnessUseHeightmapAdjustments;
	    float g_flWetnessUnderlyingHeightMapInfluence;
	    float g_flHorizontalSurfaceTolerance;
	    float g_fPuddleStrength;
	    float g_fPuddleHeight;
	    float _g_fl_AutoPad18_;
	    float _g_fl_AutoPad19_;
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
	    int g_nScaleTexCoord2UByModelScaleAxis;
	    int g_nScaleTexCoord2VByModelScaleAxis;
	    bool g_bTexCoord2ScaleByModel;
	    vec4 g_vTexCoord2ScaleByModelU;
	    vec4 g_vTexCoord2ScaleByModelV;
	    vec2 g_vDetailTexCoordScale;
	    float g_flDetailTexCoordRotation;
	    float _g_fl_AutoPad20_;
	    vec2 g_vDetailTexCoordOffset;
	    float _g_fl_AutoPad21_;
	    float _g_fl_AutoPad22_;
	    vec4 g_vDetailTexCoordXform;
	    float g_flDetailNormalStrength;
	    float _g_fl_AutoPad23_;
	    float _g_fl_AutoPad24_;
	    float _g_fl_AutoPad25_;
	    vec4 g_vDetailNormalStrengthOffsetScale;
	    vec2 g_vTexCoordCenter;
	    vec2 g_vTexCoordScale;
	    float g_flTexCoordRotation;
	    float _g_fl_AutoPad26_;
	    vec2 g_vTexCoordOffset;
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    int g_nScaleTexCoordUByModelScaleAxis;
	    int g_nScaleTexCoordVByModelScaleAxis;
	    bool g_bTexCoordScaleByModel;
	    float _g_fl_AutoPad27_;
	    float _g_fl_AutoPad28_;
	    float _g_fl_AutoPad29_;
	    vec4 g_vTexCoordScaleByModelU;
	    vec4 g_vTexCoordScaleByModelV;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    bool g_bUseSecondaryUvForDetailTexture;
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
	    bool g_bBorderRoughness2;
	    bool g_bBorderBlendMultiply2;
	    bool g_bBorderBlendReplace2;
	    bool g_bBorderBlendMod2x2;
	    bool g_bBorderBlendColorize2;
	    bool g_bBorderRoughness3;
	    bool g_bBorderBlendMultiply3;
	    bool g_bBorderBlendReplace3;
	    bool g_bBorderBlendMod2x3;
	    bool g_bBorderBlendColorize3;
	    bool bBlendByFacingDirection2;
	    bool bBlendByFacingDirection3;
	    bool g_bWetness;
	    bool bBiplanarUsedAny;
	    float _g_fl_AutoPad30_;
	    float _g_fl_AutoPad31_;
	    float _g_fl_AutoPad32_;
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
	
	const vec3 _957[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _961[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
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
	
	vec4 _1045;
	float _1046;
	vec3 _1047;
	
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
	    uint _1091 = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _RTX_MATERIAL_DATA_ _3095 = _RTX_MATERIAL_DATA_(vec3(g_MaterialData_1._member0[_1091 / 4u], g_MaterialData_1._member0[(_1091 + 4u) / 4u], g_MaterialData_1._member0[(_1091 + 8u) / 4u]), g_MaterialData_1._member0[(_1091 + 12u) / 4u], g_MaterialData_1._member0[(_1091 + 16u) / 4u], g_MaterialData_3._member0[(_1091 + 20u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 24u) / 4u], g_MaterialData_5._member0[(_1091 + 28u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 32u) / 4u], g_MaterialData_1._member0[(_1091 + 36u) / 4u]), vec2(g_MaterialData_1._member0[(_1091 + 40u) / 4u], g_MaterialData_1._member0[(_1091 + 44u) / 4u]), g_MaterialData_1._member0[(_1091 + 48u) / 4u], g_MaterialData_1._member0[(_1091 + 52u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 56u) / 4u], g_MaterialData_1._member0[(_1091 + 60u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 64u) / 4u], g_MaterialData_1._member0[(_1091 + 68u) / 4u], g_MaterialData_1._member0[(_1091 + 72u) / 4u], g_MaterialData_1._member0[(_1091 + 76u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 80u) / 4u], g_MaterialData_1._member0[(_1091 + 84u) / 4u], g_MaterialData_1._member0[(_1091 + 88u) / 4u], g_MaterialData_1._member0[(_1091 + 92u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 96u) / 4u], g_MaterialData_1._member0[(_1091 + 100u) / 4u], g_MaterialData_1._member0[(_1091 + 104u) / 4u], g_MaterialData_1._member0[(_1091 + 108u) / 4u]), g_MaterialData_1._member0[(_1091 + 112u) / 4u], g_MaterialData_1._member0[(_1091 + 116u) / 4u], g_MaterialData_1._member0[(_1091 + 120u) / 4u], g_MaterialData_1._member0[(_1091 + 124u) / 4u], g_MaterialData_1._member0[(_1091 + 128u) / 4u], g_MaterialData_1._member0[(_1091 + 132u) / 4u], g_MaterialData_1._member0[(_1091 + 136u) / 4u], g_MaterialData_5._member0[(_1091 + 140u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 144u) / 4u], g_MaterialData_1._member0[(_1091 + 148u) / 4u]), vec2(g_MaterialData_1._member0[(_1091 + 152u) / 4u], g_MaterialData_1._member0[(_1091 + 156u) / 4u]), g_MaterialData_1._member0[(_1091 + 160u) / 4u], g_MaterialData_1._member0[(_1091 + 164u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 168u) / 4u], g_MaterialData_1._member0[(_1091 + 172u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 176u) / 4u], g_MaterialData_1._member0[(_1091 + 180u) / 4u], g_MaterialData_1._member0[(_1091 + 184u) / 4u], g_MaterialData_1._member0[(_1091 + 188u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 192u) / 4u], g_MaterialData_1._member0[(_1091 + 196u) / 4u], g_MaterialData_1._member0[(_1091 + 200u) / 4u], g_MaterialData_1._member0[(_1091 + 204u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 208u) / 4u], g_MaterialData_1._member0[(_1091 + 212u) / 4u], g_MaterialData_1._member0[(_1091 + 216u) / 4u], g_MaterialData_1._member0[(_1091 + 220u) / 4u]), g_MaterialData_5._member0[(_1091 + 224u) / 4u], g_MaterialData_1._member0[(_1091 + 228u) / 4u], g_MaterialData_1._member0[(_1091 + 232u) / 4u], g_MaterialData_3._member0[(_1091 + 236u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 240u) / 4u], g_MaterialData_5._member0[(_1091 + 244u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 248u) / 4u], g_MaterialData_1._member0[(_1091 + 252u) / 4u]), vec2(g_MaterialData_1._member0[(_1091 + 256u) / 4u], g_MaterialData_1._member0[(_1091 + 260u) / 4u]), g_MaterialData_1._member0[(_1091 + 264u) / 4u], g_MaterialData_1._member0[(_1091 + 268u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 272u) / 4u], g_MaterialData_1._member0[(_1091 + 276u) / 4u]), g_MaterialData_1._member0[(_1091 + 280u) / 4u], g_MaterialData_1._member0[(_1091 + 284u) / 4u], vec4(g_MaterialData_1._member0[(_1091 + 288u) / 4u], g_MaterialData_1._member0[(_1091 + 292u) / 4u], g_MaterialData_1._member0[(_1091 + 296u) / 4u], g_MaterialData_1._member0[(_1091 + 300u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 304u) / 4u], g_MaterialData_1._member0[(_1091 + 308u) / 4u], g_MaterialData_1._member0[(_1091 + 312u) / 4u], g_MaterialData_1._member0[(_1091 + 316u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 320u) / 4u], g_MaterialData_1._member0[(_1091 + 324u) / 4u], g_MaterialData_1._member0[(_1091 + 328u) / 4u], g_MaterialData_1._member0[(_1091 + 332u) / 4u]), g_MaterialData_1._member0[(_1091 + 336u) / 4u], g_MaterialData_5._member0[(_1091 + 340u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 344u) / 4u], g_MaterialData_1._member0[(_1091 + 348u) / 4u]), vec2(g_MaterialData_1._member0[(_1091 + 352u) / 4u], g_MaterialData_1._member0[(_1091 + 356u) / 4u]), g_MaterialData_1._member0[(_1091 + 360u) / 4u], g_MaterialData_1._member0[(_1091 + 364u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 368u) / 4u], g_MaterialData_1._member0[(_1091 + 372u) / 4u]), g_MaterialData_1._member0[(_1091 + 376u) / 4u], g_MaterialData_1._member0[(_1091 + 380u) / 4u], vec4(g_MaterialData_1._member0[(_1091 + 384u) / 4u], g_MaterialData_1._member0[(_1091 + 388u) / 4u], g_MaterialData_1._member0[(_1091 + 392u) / 4u], g_MaterialData_1._member0[(_1091 + 396u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 400u) / 4u], g_MaterialData_1._member0[(_1091 + 404u) / 4u], g_MaterialData_1._member0[(_1091 + 408u) / 4u], g_MaterialData_1._member0[(_1091 + 412u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 416u) / 4u], g_MaterialData_1._member0[(_1091 + 420u) / 4u], g_MaterialData_1._member0[(_1091 + 424u) / 4u], g_MaterialData_1._member0[(_1091 + 428u) / 4u]), g_MaterialData_1._member0[(_1091 + 432u) / 4u], g_MaterialData_1._member0[(_1091 + 436u) / 4u], g_MaterialData_1._member0[(_1091 + 440u) / 4u], g_MaterialData_7._member0[(_1091 + 444u) / 4u], g_MaterialData_7._member0[(_1091 + 448u) / 4u], g_MaterialData_7._member0[(_1091 + 452u) / 4u], g_MaterialData_1._member0[(_1091 + 456u) / 4u], g_MaterialData_1._member0[(_1091 + 460u) / 4u], g_MaterialData_1._member0[(_1091 + 464u) / 4u], g_MaterialData_1._member0[(_1091 + 468u) / 4u], g_MaterialData_1._member0[(_1091 + 472u) / 4u], g_MaterialData_1._member0[(_1091 + 476u) / 4u], vec3(g_MaterialData_1._member0[(_1091 + 480u) / 4u], g_MaterialData_1._member0[(_1091 + 484u) / 4u], g_MaterialData_1._member0[(_1091 + 488u) / 4u]), g_MaterialData_1._member0[(_1091 + 492u) / 4u], vec3(g_MaterialData_1._member0[(_1091 + 496u) / 4u], g_MaterialData_1._member0[(_1091 + 500u) / 4u], g_MaterialData_1._member0[(_1091 + 504u) / 4u]), g_MaterialData_1._member0[(_1091 + 508u) / 4u], g_MaterialData_1._member0[(_1091 + 512u) / 4u], g_MaterialData_1._member0[(_1091 + 516u) / 4u], g_MaterialData_5._member0[(_1091 + 520u) / 4u], g_MaterialData_3._member0[(_1091 + 524u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 528u) / 4u], g_MaterialData_1._member0[(_1091 + 532u) / 4u], g_MaterialData_5._member0[(_1091 + 536u) / 4u], g_MaterialData_3._member0[(_1091 + 540u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 544u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 548u) / 4u], g_MaterialData_1._member0[(_1091 + 552u) / 4u], g_MaterialData_1._member0[(_1091 + 556u) / 4u], g_MaterialData_3._member0[(_1091 + 560u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 564u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 568u) / 4u], g_MaterialData_1._member0[(_1091 + 572u) / 4u], mat4(vec4(g_MaterialData_1._member0[(_1091 + 576u) / 4u], g_MaterialData_1._member0[(_1091 + 592u) / 4u], g_MaterialData_1._member0[(_1091 + 608u) / 4u], g_MaterialData_1._member0[(_1091 + 624u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 580u) / 4u], g_MaterialData_1._member0[(_1091 + 596u) / 4u], g_MaterialData_1._member0[(_1091 + 612u) / 4u], g_MaterialData_1._member0[(_1091 + 628u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 584u) / 4u], g_MaterialData_1._member0[(_1091 + 600u) / 4u], g_MaterialData_1._member0[(_1091 + 616u) / 4u], g_MaterialData_1._member0[(_1091 + 632u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 588u) / 4u], g_MaterialData_1._member0[(_1091 + 604u) / 4u], g_MaterialData_1._member0[(_1091 + 620u) / 4u], g_MaterialData_1._member0[(_1091 + 636u) / 4u])), mat4(vec4(g_MaterialData_1._member0[(_1091 + 640u) / 4u], g_MaterialData_1._member0[(_1091 + 656u) / 4u], g_MaterialData_1._member0[(_1091 + 672u) / 4u], g_MaterialData_1._member0[(_1091 + 688u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 644u) / 4u], g_MaterialData_1._member0[(_1091 + 660u) / 4u], g_MaterialData_1._member0[(_1091 + 676u) / 4u], g_MaterialData_1._member0[(_1091 + 692u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 648u) / 4u], g_MaterialData_1._member0[(_1091 + 664u) / 4u], g_MaterialData_1._member0[(_1091 + 680u) / 4u], g_MaterialData_1._member0[(_1091 + 696u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 652u) / 4u], g_MaterialData_1._member0[(_1091 + 668u) / 4u], g_MaterialData_1._member0[(_1091 + 684u) / 4u], g_MaterialData_1._member0[(_1091 + 700u) / 4u])), g_MaterialData_1._member0[(_1091 + 704u) / 4u], g_MaterialData_1._member0[(_1091 + 708u) / 4u], g_MaterialData_1._member0[(_1091 + 712u) / 4u], g_MaterialData_1._member0[(_1091 + 716u) / 4u], g_MaterialData_1._member0[(_1091 + 720u) / 4u], g_MaterialData_1._member0[(_1091 + 724u) / 4u], g_MaterialData_1._member0[(_1091 + 728u) / 4u], g_MaterialData_1._member0[(_1091 + 732u) / 4u], g_MaterialData_1._member0[(_1091 + 736u) / 4u], g_MaterialData_1._member0[(_1091 + 740u) / 4u], g_MaterialData_1._member0[(_1091 + 744u) / 4u], g_MaterialData_1._member0[(_1091 + 748u) / 4u], g_MaterialData_1._member0[(_1091 + 752u) / 4u], g_MaterialData_1._member0[(_1091 + 756u) / 4u], g_MaterialData_3._member0[(_1091 + 760u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 764u) / 4u], g_MaterialData_1._member0[(_1091 + 768u) / 4u], g_MaterialData_7._member0[(_1091 + 772u) / 4u], g_MaterialData_7._member0[(_1091 + 776u) / 4u], g_MaterialData_7._member0[(_1091 + 780u) / 4u], vec3(g_MaterialData_1._member0[(_1091 + 784u) / 4u], g_MaterialData_1._member0[(_1091 + 788u) / 4u], g_MaterialData_1._member0[(_1091 + 792u) / 4u]), g_MaterialData_1._member0[(_1091 + 796u) / 4u], vec3(g_MaterialData_1._member0[(_1091 + 800u) / 4u], g_MaterialData_1._member0[(_1091 + 804u) / 4u], g_MaterialData_1._member0[(_1091 + 808u) / 4u]), g_MaterialData_1._member0[(_1091 + 812u) / 4u], g_MaterialData_1._member0[(_1091 + 816u) / 4u], g_MaterialData_1._member0[(_1091 + 820u) / 4u], g_MaterialData_5._member0[(_1091 + 824u) / 4u], g_MaterialData_3._member0[(_1091 + 828u) / 4u] != 0, mat4(vec4(g_MaterialData_1._member0[(_1091 + 832u) / 4u], g_MaterialData_1._member0[(_1091 + 848u) / 4u], g_MaterialData_1._member0[(_1091 + 864u) / 4u], g_MaterialData_1._member0[(_1091 + 880u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 836u) / 4u], g_MaterialData_1._member0[(_1091 + 852u) / 4u], g_MaterialData_1._member0[(_1091 + 868u) / 4u], g_MaterialData_1._member0[(_1091 + 884u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 840u) / 4u], g_MaterialData_1._member0[(_1091 + 856u) / 4u], g_MaterialData_1._member0[(_1091 + 872u) / 4u], g_MaterialData_1._member0[(_1091 + 888u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 844u) / 4u], g_MaterialData_1._member0[(_1091 + 860u) / 4u], g_MaterialData_1._member0[(_1091 + 876u) / 4u], g_MaterialData_1._member0[(_1091 + 892u) / 4u])), mat4(vec4(g_MaterialData_1._member0[(_1091 + 896u) / 4u], g_MaterialData_1._member0[(_1091 + 912u) / 4u], g_MaterialData_1._member0[(_1091 + 928u) / 4u], g_MaterialData_1._member0[(_1091 + 944u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 900u) / 4u], g_MaterialData_1._member0[(_1091 + 916u) / 4u], g_MaterialData_1._member0[(_1091 + 932u) / 4u], g_MaterialData_1._member0[(_1091 + 948u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 904u) / 4u], g_MaterialData_1._member0[(_1091 + 920u) / 4u], g_MaterialData_1._member0[(_1091 + 936u) / 4u], g_MaterialData_1._member0[(_1091 + 952u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 908u) / 4u], g_MaterialData_1._member0[(_1091 + 924u) / 4u], g_MaterialData_1._member0[(_1091 + 940u) / 4u], g_MaterialData_1._member0[(_1091 + 956u) / 4u])), g_MaterialData_1._member0[(_1091 + 960u) / 4u], g_MaterialData_1._member0[(_1091 + 964u) / 4u], g_MaterialData_1._member0[(_1091 + 968u) / 4u], g_MaterialData_1._member0[(_1091 + 972u) / 4u], g_MaterialData_1._member0[(_1091 + 976u) / 4u], g_MaterialData_1._member0[(_1091 + 980u) / 4u], g_MaterialData_1._member0[(_1091 + 984u) / 4u], g_MaterialData_1._member0[(_1091 + 988u) / 4u], g_MaterialData_1._member0[(_1091 + 992u) / 4u], g_MaterialData_1._member0[(_1091 + 996u) / 4u], g_MaterialData_1._member0[(_1091 + 1000u) / 4u], g_MaterialData_1._member0[(_1091 + 1004u) / 4u], vec3(g_MaterialData_1._member0[(_1091 + 1008u) / 4u], g_MaterialData_1._member0[(_1091 + 1012u) / 4u], g_MaterialData_1._member0[(_1091 + 1016u) / 4u]), g_MaterialData_1._member0[(_1091 + 1020u) / 4u], g_MaterialData_1._member0[(_1091 + 1024u) / 4u], g_MaterialData_1._member0[(_1091 + 1028u) / 4u], g_MaterialData_5._member0[(_1091 + 1032u) / 4u], g_MaterialData_3._member0[(_1091 + 1036u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1040u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1044u) / 4u] != 0, g_MaterialData_7._member0[(_1091 + 1048u) / 4u], g_MaterialData_1._member0[(_1091 + 1052u) / 4u], g_MaterialData_3._member0[(_1091 + 1056u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1060u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 1064u) / 4u], g_MaterialData_1._member0[(_1091 + 1068u) / 4u], g_MaterialData_1._member0[(_1091 + 1072u) / 4u], g_MaterialData_1._member0[(_1091 + 1076u) / 4u], g_MaterialData_1._member0[(_1091 + 1080u) / 4u], g_MaterialData_1._member0[(_1091 + 1084u) / 4u], vec3(g_MaterialData_1._member0[(_1091 + 1088u) / 4u], g_MaterialData_1._member0[(_1091 + 1092u) / 4u], g_MaterialData_1._member0[(_1091 + 1096u) / 4u]), g_MaterialData_1._member0[(_1091 + 1100u) / 4u], g_MaterialData_1._member0[(_1091 + 1104u) / 4u], g_MaterialData_1._member0[(_1091 + 1108u) / 4u], g_MaterialData_1._member0[(_1091 + 1112u) / 4u], g_MaterialData_1._member0[(_1091 + 1116u) / 4u], g_MaterialData_1._member0[(_1091 + 1120u) / 4u], g_MaterialData_1._member0[(_1091 + 1124u) / 4u], g_MaterialData_1._member0[(_1091 + 1128u) / 4u], g_MaterialData_1._member0[(_1091 + 1132u) / 4u], g_MaterialData_1._member0[(_1091 + 1136u) / 4u], g_MaterialData_1._member0[(_1091 + 1140u) / 4u], g_MaterialData_1._member0[(_1091 + 1144u) / 4u], g_MaterialData_1._member0[(_1091 + 1148u) / 4u], g_MaterialData_1._member0[(_1091 + 1152u) / 4u], g_MaterialData_5._member0[(_1091 + 1156u) / 4u], g_MaterialData_5._member0[(_1091 + 1160u) / 4u], g_MaterialData_3._member0[(_1091 + 1164u) / 4u] != 0, vec4(g_MaterialData_1._member0[(_1091 + 1168u) / 4u], g_MaterialData_1._member0[(_1091 + 1172u) / 4u], g_MaterialData_1._member0[(_1091 + 1176u) / 4u], g_MaterialData_1._member0[(_1091 + 1180u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 1184u) / 4u], g_MaterialData_1._member0[(_1091 + 1188u) / 4u], g_MaterialData_1._member0[(_1091 + 1192u) / 4u], g_MaterialData_1._member0[(_1091 + 1196u) / 4u]), vec2(g_MaterialData_1._member0[(_1091 + 1200u) / 4u], g_MaterialData_1._member0[(_1091 + 1204u) / 4u]), g_MaterialData_1._member0[(_1091 + 1208u) / 4u], g_MaterialData_1._member0[(_1091 + 1212u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 1216u) / 4u], g_MaterialData_1._member0[(_1091 + 1220u) / 4u]), g_MaterialData_1._member0[(_1091 + 1224u) / 4u], g_MaterialData_1._member0[(_1091 + 1228u) / 4u], vec4(g_MaterialData_1._member0[(_1091 + 1232u) / 4u], g_MaterialData_1._member0[(_1091 + 1236u) / 4u], g_MaterialData_1._member0[(_1091 + 1240u) / 4u], g_MaterialData_1._member0[(_1091 + 1244u) / 4u]), g_MaterialData_1._member0[(_1091 + 1248u) / 4u], g_MaterialData_1._member0[(_1091 + 1252u) / 4u], g_MaterialData_1._member0[(_1091 + 1256u) / 4u], g_MaterialData_1._member0[(_1091 + 1260u) / 4u], vec4(g_MaterialData_1._member0[(_1091 + 1264u) / 4u], g_MaterialData_1._member0[(_1091 + 1268u) / 4u], g_MaterialData_1._member0[(_1091 + 1272u) / 4u], g_MaterialData_1._member0[(_1091 + 1276u) / 4u]), vec2(g_MaterialData_1._member0[(_1091 + 1280u) / 4u], g_MaterialData_1._member0[(_1091 + 1284u) / 4u]), vec2(g_MaterialData_1._member0[(_1091 + 1288u) / 4u], g_MaterialData_1._member0[(_1091 + 1292u) / 4u]), g_MaterialData_1._member0[(_1091 + 1296u) / 4u], g_MaterialData_1._member0[(_1091 + 1300u) / 4u], vec2(g_MaterialData_1._member0[(_1091 + 1304u) / 4u], g_MaterialData_1._member0[(_1091 + 1308u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 1312u) / 4u], g_MaterialData_1._member0[(_1091 + 1316u) / 4u], g_MaterialData_1._member0[(_1091 + 1320u) / 4u], g_MaterialData_1._member0[(_1091 + 1324u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 1328u) / 4u], g_MaterialData_1._member0[(_1091 + 1332u) / 4u], g_MaterialData_1._member0[(_1091 + 1336u) / 4u], g_MaterialData_1._member0[(_1091 + 1340u) / 4u]), vec2(g_MaterialData_1._member0[(_1091 + 1344u) / 4u], g_MaterialData_1._member0[(_1091 + 1348u) / 4u]), g_MaterialData_5._member0[(_1091 + 1352u) / 4u], g_MaterialData_5._member0[(_1091 + 1356u) / 4u], g_MaterialData_3._member0[(_1091 + 1360u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 1364u) / 4u], g_MaterialData_1._member0[(_1091 + 1368u) / 4u], g_MaterialData_1._member0[(_1091 + 1372u) / 4u], vec4(g_MaterialData_1._member0[(_1091 + 1376u) / 4u], g_MaterialData_1._member0[(_1091 + 1380u) / 4u], g_MaterialData_1._member0[(_1091 + 1384u) / 4u], g_MaterialData_1._member0[(_1091 + 1388u) / 4u]), vec4(g_MaterialData_1._member0[(_1091 + 1392u) / 4u], g_MaterialData_1._member0[(_1091 + 1396u) / 4u], g_MaterialData_1._member0[(_1091 + 1400u) / 4u], g_MaterialData_1._member0[(_1091 + 1404u) / 4u]), vec3(g_MaterialData_1._member0[(_1091 + 1408u) / 4u], g_MaterialData_1._member0[(_1091 + 1412u) / 4u], g_MaterialData_1._member0[(_1091 + 1416u) / 4u]), g_MaterialData_1._member0[(_1091 + 1420u) / 4u], g_MaterialData_3._member0[(_1091 + 1424u) / 4u] != 0, g_MaterialData_7._member0[(_1091 + 1428u) / 4u], g_MaterialData_7._member0[(_1091 + 1432u) / 4u], g_MaterialData_7._member0[(_1091 + 1436u) / 4u], g_MaterialData_7._member0[(_1091 + 1440u) / 4u], g_MaterialData_7._member0[(_1091 + 1444u) / 4u], g_MaterialData_7._member0[(_1091 + 1448u) / 4u], g_MaterialData_5._member0[(_1091 + 1452u) / 4u], g_MaterialData_5._member0[(_1091 + 1456u) / 4u], g_MaterialData_7._member0[(_1091 + 1460u) / 4u], g_MaterialData_7._member0[(_1091 + 1464u) / 4u], g_MaterialData_7._member0[(_1091 + 1468u) / 4u], g_MaterialData_3._member0[(_1091 + 1472u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1476u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1480u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 1484u) / 4u], g_MaterialData_7._member0[(_1091 + 1488u) / 4u], g_MaterialData_1._member0[(_1091 + 1492u) / 4u], g_MaterialData_1._member0[(_1091 + 1496u) / 4u], g_MaterialData_3._member0[(_1091 + 1500u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1504u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1508u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1512u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1516u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1520u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1524u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1528u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1532u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1536u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1540u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1544u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1548u) / 4u] != 0, g_MaterialData_3._member0[(_1091 + 1552u) / 4u] != 0, g_MaterialData_1._member0[(_1091 + 1556u) / 4u], g_MaterialData_1._member0[(_1091 + 1560u) / 4u], g_MaterialData_1._member0[(_1091 + 1564u) / 4u]);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _3095;
	    uvec3 _1416;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _3137 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _1416 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_3137 / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_3137 + 4u) / 4u], g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[(_3137 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _3116 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _3117 = _3116 & 4294967292u;
	            uint _57 = _3117 / 4u;
	            uint _60 = (_3117 + 4u) / 4u;
	            uint _3121 = (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_57] & 4294901760u) >> uint(16);
	            uint _3122 = g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_60] & 65535u;
	            uvec3 _1417;
	            if (_3116 == _3117)
	            {
	                _1417 = uvec3(g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_57] & 65535u, _3121, _3122);
	            }
	            else
	            {
	                _1417 = uvec3(_3121, _3122, (g_Indices_1[nonuniformEXT(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w)]._member0[_60] & 4294901760u) >> uint(16));
	            }
	            _1416 = _1417;
	            break;
	        }
	        break;
	    } while(false);
	    uint _73 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _3159 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _1416) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _1410[3];
	    uint _3161 = _3159.x;
	    _1410[0] = vec3(g_Vertices_1[nonuniformEXT(_73)]._member0[_3161 / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_3161 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_3161 + 8u) / 4u]);
	    uint _3166 = _3159.y;
	    _1410[1] = vec3(g_Vertices_1[nonuniformEXT(_73)]._member0[_3166 / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_3166 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_3166 + 8u) / 4u]);
	    uint _3171 = _3159.z;
	    _1410[2] = vec3(g_Vertices_1[nonuniformEXT(_73)]._member0[_3171 / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_3171 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_73)]._member0[(_3171 + 8u) / 4u]);
	    int _1411 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_1411 < 3))
	        {
	            break;
	        }
	        vsInput[_1411].vPositionOs = _1410[_1411];
	        _1411++;
	        continue;
	    }
	    vec2 _1412[3];
	    _1412[0] = vec2(0.0);
	    _1412[1] = vec2(0.0);
	    _1412[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _1409 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _102 = uint(_1409[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _3213 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _1407 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1408 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3229 = (uvec3(uint(_1407[_3213])) * _1416) + uvec3(uint(_1408[_3213]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _3343 = _3229.x;
	            _1412[0] = vec2(g_Vertices_1[nonuniformEXT(_102)]._member0[_3343 / 4u], g_Vertices_1[nonuniformEXT(_102)]._member0[(_3343 + 4u) / 4u]);
	            uint _3346 = _3229.y;
	            _1412[1] = vec2(g_Vertices_1[nonuniformEXT(_102)]._member0[_3346 / 4u], g_Vertices_1[nonuniformEXT(_102)]._member0[(_3346 + 4u) / 4u]);
	            uint _3349 = _3229.z;
	            _1412[2] = vec2(g_Vertices_1[nonuniformEXT(_102)]._member0[_3349 / 4u], g_Vertices_1[nonuniformEXT(_102)]._member0[(_3349 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _114 = _3229.x / 4u;
	                _1412[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_102)]._member0[_114], g_Vertices_3[nonuniformEXT(_102)]._member0[_114] >> uint(16)) & uvec2(65535u))));
	                uint _117 = _3229.y / 4u;
	                _1412[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_102)]._member0[_117], g_Vertices_3[nonuniformEXT(_102)]._member0[_117] >> uint(16)) & uvec2(65535u))));
	                uint _120 = _3229.z / 4u;
	                _1412[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_102)]._member0[_120], g_Vertices_3[nonuniformEXT(_102)]._member0[_120] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _104 = _3229.x / 4u;
	                    uint _3242 = g_Vertices_3[nonuniformEXT(_102)]._member0[_104] & 65535u;
	                    int _1406;
	                    if (_3242 > 32767u)
	                    {
	                        _1406 = int(4294901760u | _3242);
	                    }
	                    else
	                    {
	                        _1406 = int(_3242);
	                    }
	                    uint _3255 = (g_Vertices_3[nonuniformEXT(_102)]._member0[_104] & 4294901760u) >> uint(16);
	                    int _1405;
	                    if (_3255 > 32767u)
	                    {
	                        _1405 = int(4294901760u | _3255);
	                    }
	                    else
	                    {
	                        _1405 = int(_3255);
	                    }
	                    _1412[0] = vec2(max(float(_1406) * 3.0518509447574615478515625e-05, -1.0), max(float(_1405) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _107 = _3229.y / 4u;
	                    uint _3269 = g_Vertices_3[nonuniformEXT(_102)]._member0[_107] & 65535u;
	                    int _1404;
	                    if (_3269 > 32767u)
	                    {
	                        _1404 = int(4294901760u | _3269);
	                    }
	                    else
	                    {
	                        _1404 = int(_3269);
	                    }
	                    uint _3282 = (g_Vertices_3[nonuniformEXT(_102)]._member0[_107] & 4294901760u) >> uint(16);
	                    int _1403;
	                    if (_3282 > 32767u)
	                    {
	                        _1403 = int(4294901760u | _3282);
	                    }
	                    else
	                    {
	                        _1403 = int(_3282);
	                    }
	                    _1412[1] = vec2(max(float(_1404) * 3.0518509447574615478515625e-05, -1.0), max(float(_1403) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _110 = _3229.z / 4u;
	                    uint _3296 = g_Vertices_3[nonuniformEXT(_102)]._member0[_110] & 65535u;
	                    int _1402;
	                    if (_3296 > 32767u)
	                    {
	                        _1402 = int(4294901760u | _3296);
	                    }
	                    else
	                    {
	                        _1402 = int(_3296);
	                    }
	                    uint _3309 = (g_Vertices_3[nonuniformEXT(_102)]._member0[_110] & 4294901760u) >> uint(16);
	                    int _1401;
	                    if (_3309 > 32767u)
	                    {
	                        _1401 = int(4294901760u | _3309);
	                    }
	                    else
	                    {
	                        _1401 = int(_3309);
	                    }
	                    _1412[2] = vec2(max(float(_1402) * 3.0518509447574615478515625e-05, -1.0), max(float(_1401) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _1411 = 0;
	    for (;;)
	    {
	        if (!(_1411 < 3))
	        {
	            break;
	        }
	        vsInput[_1411].vTexCoord = _1412[_1411];
	        _1411++;
	        continue;
	    }
	    _1412[0] = vec2(0.0);
	    _1412[1] = vec2(0.0);
	    _1412[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _1400 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _142 = uint(_1400[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _3388 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _1398 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1399 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3404 = (uvec3(uint(_1398[_3388])) * _1416) + uvec3(uint(_1399[_3388]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _3518 = _3404.x;
	            _1412[0] = vec2(g_Vertices_1[nonuniformEXT(_142)]._member0[_3518 / 4u], g_Vertices_1[nonuniformEXT(_142)]._member0[(_3518 + 4u) / 4u]);
	            uint _3521 = _3404.y;
	            _1412[1] = vec2(g_Vertices_1[nonuniformEXT(_142)]._member0[_3521 / 4u], g_Vertices_1[nonuniformEXT(_142)]._member0[(_3521 + 4u) / 4u]);
	            uint _3524 = _3404.z;
	            _1412[2] = vec2(g_Vertices_1[nonuniformEXT(_142)]._member0[_3524 / 4u], g_Vertices_1[nonuniformEXT(_142)]._member0[(_3524 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _154 = _3404.x / 4u;
	                _1412[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_142)]._member0[_154], g_Vertices_3[nonuniformEXT(_142)]._member0[_154] >> uint(16)) & uvec2(65535u))));
	                uint _157 = _3404.y / 4u;
	                _1412[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_142)]._member0[_157], g_Vertices_3[nonuniformEXT(_142)]._member0[_157] >> uint(16)) & uvec2(65535u))));
	                uint _160 = _3404.z / 4u;
	                _1412[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[nonuniformEXT(_142)]._member0[_160], g_Vertices_3[nonuniformEXT(_142)]._member0[_160] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _144 = _3404.x / 4u;
	                    uint _3417 = g_Vertices_3[nonuniformEXT(_142)]._member0[_144] & 65535u;
	                    int _1397;
	                    if (_3417 > 32767u)
	                    {
	                        _1397 = int(4294901760u | _3417);
	                    }
	                    else
	                    {
	                        _1397 = int(_3417);
	                    }
	                    uint _3430 = (g_Vertices_3[nonuniformEXT(_142)]._member0[_144] & 4294901760u) >> uint(16);
	                    int _1396;
	                    if (_3430 > 32767u)
	                    {
	                        _1396 = int(4294901760u | _3430);
	                    }
	                    else
	                    {
	                        _1396 = int(_3430);
	                    }
	                    _1412[0] = vec2(max(float(_1397) * 3.0518509447574615478515625e-05, -1.0), max(float(_1396) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _147 = _3404.y / 4u;
	                    uint _3444 = g_Vertices_3[nonuniformEXT(_142)]._member0[_147] & 65535u;
	                    int _1395;
	                    if (_3444 > 32767u)
	                    {
	                        _1395 = int(4294901760u | _3444);
	                    }
	                    else
	                    {
	                        _1395 = int(_3444);
	                    }
	                    uint _3457 = (g_Vertices_3[nonuniformEXT(_142)]._member0[_147] & 4294901760u) >> uint(16);
	                    int _1394;
	                    if (_3457 > 32767u)
	                    {
	                        _1394 = int(4294901760u | _3457);
	                    }
	                    else
	                    {
	                        _1394 = int(_3457);
	                    }
	                    _1412[1] = vec2(max(float(_1395) * 3.0518509447574615478515625e-05, -1.0), max(float(_1394) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _150 = _3404.z / 4u;
	                    uint _3471 = g_Vertices_3[nonuniformEXT(_142)]._member0[_150] & 65535u;
	                    int _1393;
	                    if (_3471 > 32767u)
	                    {
	                        _1393 = int(4294901760u | _3471);
	                    }
	                    else
	                    {
	                        _1393 = int(_3471);
	                    }
	                    uint _3484 = (g_Vertices_3[nonuniformEXT(_142)]._member0[_150] & 4294901760u) >> uint(16);
	                    int _1392;
	                    if (_3484 > 32767u)
	                    {
	                        _1392 = int(4294901760u | _3484);
	                    }
	                    else
	                    {
	                        _1392 = int(_3484);
	                    }
	                    _1412[2] = vec2(max(float(_1393) * 3.0518509447574615478515625e-05, -1.0), max(float(_1392) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _1411 = 0;
	    for (;;)
	    {
	        if (!(_1411 < 3))
	        {
	            break;
	        }
	        vsInput[_1411].vTexCoord2 = _1412[_1411];
	        _1411++;
	        continue;
	    }
	    vec3 _1413[3];
	    vec4 _1414[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _1378 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _182 = uint(_1378[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _3568 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _1376 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _1377 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _3584 = (uvec3(uint(_1376[_3568])) * _1416) + uvec3(uint(_1377[_3568]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _4085 = _3584.x;
	                _1413[0] = vec3(g_Vertices_1[nonuniformEXT(_182)]._member0[_4085 / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_4085 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_4085 + 8u) / 4u]);
	                uint _4090 = _3584.y;
	                _1413[1] = vec3(g_Vertices_1[nonuniformEXT(_182)]._member0[_4090 / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_4090 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_4090 + 8u) / 4u]);
	                uint _4095 = _3584.z;
	                _1413[2] = vec3(g_Vertices_1[nonuniformEXT(_182)]._member0[_4095 / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_4095 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_182)]._member0[(_4095 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _3839 = _3584.x;
	                    uvec2 _3841 = uvec2(g_Vertices_3[nonuniformEXT(_182)]._member0[_3839 / 4u], g_Vertices_3[nonuniformEXT(_182)]._member0[(_3839 + 4u) / 4u]);
	                    uint _3842 = _3584.y;
	                    uvec2 _1069 = uvec2(g_Vertices_3[nonuniformEXT(_182)]._member0[_3842 / 4u], g_Vertices_3[nonuniformEXT(_182)]._member0[(_3842 + 4u) / 4u]);
	                    uint _3845 = _3584.z;
	                    uvec2 _1068 = uvec2(g_Vertices_3[nonuniformEXT(_182)]._member0[_3845 / 4u], g_Vertices_3[nonuniformEXT(_182)]._member0[(_3845 + 4u) / 4u]);
	                    uint _3851 = _3841.x;
	                    uint _3859 = _3841.y;
	                    vec2 _3869 = ((vec2(float(_3851 & 65535u), float((_3851 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3870 = _3869.x;
	                    float _3875 = (1.0 - abs(_3870)) - abs(_3869.y);
	                    vec3 _3876 = vec3(_3870, _3869.y, _3875);
	                    float _3878 = saturate(-_3875);
	                    vec2 _3884 = _3869 + mix(vec2(_3878), vec2(-_3878), greaterThanEqual(_3869, vec2(0.0)));
	                    _3876.x = _3884.x;
	                    _3876.y = _3884.y;
	                    vec3 _1380 = normalize(_3876);
	                    vec2 _3891 = ((vec2(float((_3859 >> uint(1)) & 32767u), float((_3859 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3892 = _3891.x;
	                    float _3897 = (1.0 - abs(_3892)) - abs(_3891.y);
	                    vec3 _3898 = vec3(_3892, _3891.y, _3897);
	                    float _3900 = saturate(-_3897);
	                    vec2 _3906 = _3891 + mix(vec2(_3900), vec2(-_3900), greaterThanEqual(_3891, vec2(0.0)));
	                    _3898.x = _3906.x;
	                    _3898.y = _3906.y;
	                    vec3 _1379 = normalize(_3898);
	                    float _1366;
	                    if ((_3859 & 1u) != 0u)
	                    {
	                        _1366 = 1.0;
	                    }
	                    else
	                    {
	                        _1366 = -1.0;
	                    }
	                    _1413[0] = _1380;
	                    _1414[0].w = _1366;
	                    _1414[0].x = _1379.x;
	                    _1414[0].y = _1379.y;
	                    _1414[0].z = _1379.z;
	                    vec2 _3948 = ((vec2(float(_1069.x & 65535u), float((_1069.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _3949 = _3948.x;
	                    float _3954 = (1.0 - abs(_3949)) - abs(_3948.y);
	                    vec3 _3955 = vec3(_3949, _3948.y, _3954);
	                    float _3957 = saturate(-_3954);
	                    vec2 _3963 = _3948 + mix(vec2(_3957), vec2(-_3957), greaterThanEqual(_3948, vec2(0.0)));
	                    _3955.x = _3963.x;
	                    _3955.y = _3963.y;
	                    vec3 _1382 = normalize(_3955);
	                    vec2 _3970 = ((vec2(float((_1069.y >> uint(1)) & 32767u), float((_1069.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _3971 = _3970.x;
	                    float _3976 = (1.0 - abs(_3971)) - abs(_3970.y);
	                    vec3 _3977 = vec3(_3971, _3970.y, _3976);
	                    float _3979 = saturate(-_3976);
	                    vec2 _3985 = _3970 + mix(vec2(_3979), vec2(-_3979), greaterThanEqual(_3970, vec2(0.0)));
	                    _3977.x = _3985.x;
	                    _3977.y = _3985.y;
	                    vec3 _1381 = normalize(_3977);
	                    float _1365;
	                    if ((_1069.y & 1u) != 0u)
	                    {
	                        _1365 = 1.0;
	                    }
	                    else
	                    {
	                        _1365 = -1.0;
	                    }
	                    _1413[1] = _1382;
	                    _1414[1].w = _1365;
	                    _1414[1].x = _1381.x;
	                    _1414[1].y = _1381.y;
	                    _1414[1].z = _1381.z;
	                    vec2 _4027 = ((vec2(float(_1068.x & 65535u), float((_1068.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _4028 = _4027.x;
	                    float _4033 = (1.0 - abs(_4028)) - abs(_4027.y);
	                    vec3 _4034 = vec3(_4028, _4027.y, _4033);
	                    float _4036 = saturate(-_4033);
	                    vec2 _4042 = _4027 + mix(vec2(_4036), vec2(-_4036), greaterThanEqual(_4027, vec2(0.0)));
	                    _4034.x = _4042.x;
	                    _4034.y = _4042.y;
	                    vec3 _1384 = normalize(_4034);
	                    vec2 _4049 = ((vec2(float((_1068.y >> uint(1)) & 32767u), float((_1068.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _4050 = _4049.x;
	                    float _4055 = (1.0 - abs(_4050)) - abs(_4049.y);
	                    vec3 _4056 = vec3(_4050, _4049.y, _4055);
	                    float _4058 = saturate(-_4055);
	                    vec2 _4064 = _4049 + mix(vec2(_4058), vec2(-_4058), greaterThanEqual(_4049, vec2(0.0)));
	                    _4056.x = _4064.x;
	                    _4056.y = _4064.y;
	                    vec3 _1383 = normalize(_4056);
	                    float _1364;
	                    if ((_1068.y & 1u) != 0u)
	                    {
	                        _1364 = 1.0;
	                    }
	                    else
	                    {
	                        _1364 = -1.0;
	                    }
	                    _1413[2] = _1384;
	                    _1414[2].w = _1364;
	                    _1414[2].x = _1383.x;
	                    _1414[2].y = _1383.y;
	                    _1414[2].z = _1383.z;
	                    break;
	                }
	                else
	                {
	                    uint _184 = _3584.x / 4u;
	                    vec4 _1386 = _1414[0];
	                    float _3606 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_184] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3609 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_184] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3613 = (1.0 - abs(_3606)) - abs(_3609);
	                    vec3 _3614 = vec3(_3606, _3609, _3613);
	                    float _3616 = saturate(-_3613);
	                    vec2 _3617 = vec2(_3606, _3609);
	                    vec2 _3623 = _3617 + mix(vec2(_3616), vec2(-_3616), greaterThanEqual(_3617, vec2(0.0)));
	                    _3614.x = _3623.x;
	                    _3614.y = _3623.y;
	                    vec3 _3628 = normalize(_3614);
	                    vec3 _1385 = _3628;
	                    float _3629 = _3628.z;
	                    float _1373;
	                    if (_3629 >= 0.0)
	                    {
	                        _1373 = 1.0;
	                    }
	                    else
	                    {
	                        _1373 = -1.0;
	                    }
	                    float _3636 = (-1.0) / (_1373 + _3629);
	                    float _3637 = _3628.x;
	                    vec3 _1374;
	                    vec3 _3645 = _1374;
	                    _3645.x = 1.0 + (((_1373 * _3637) * _3637) * _3636);
	                    _3645.y = _1373 * ((_3637 * _3628.y) * _3636);
	                    _3645.z = (-_1373) * _3637;
	                    _1374 = _3645;
	                    float _3653 = float((g_Vertices_3[nonuniformEXT(_182)]._member0[_184] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3659 = (_3645 * cos(_3653)) + (cross(_3628, _3645) * sin(_3653));
	                    vec4 _3661 = _1386;
	                    _3661.x = _3659.x;
	                    _3661.y = _3659.y;
	                    _3661.z = _3659.z;
	                    _1386 = _3661;
	                    float _1375;
	                    if ((g_Vertices_3[nonuniformEXT(_182)]._member0[_184] & 1u) == 0u)
	                    {
	                        _1375 = -1.0;
	                    }
	                    else
	                    {
	                        _1375 = 1.0;
	                    }
	                    vec4 _3672 = _1386;
	                    _3672.w = _1375;
	                    _1386 = _3672;
	                    _1413[0] = _1385;
	                    _1414[0] = _3672;
	                    uint _187 = _3584.y / 4u;
	                    vec4 _1388 = _1414[1];
	                    float _3688 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_187] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3691 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_187] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3695 = (1.0 - abs(_3688)) - abs(_3691);
	                    vec3 _3696 = vec3(_3688, _3691, _3695);
	                    float _3698 = saturate(-_3695);
	                    vec2 _3699 = vec2(_3688, _3691);
	                    vec2 _3705 = _3699 + mix(vec2(_3698), vec2(-_3698), greaterThanEqual(_3699, vec2(0.0)));
	                    _3696.x = _3705.x;
	                    _3696.y = _3705.y;
	                    vec3 _3710 = normalize(_3696);
	                    vec3 _1387 = _3710;
	                    float _3711 = _3710.z;
	                    float _1370;
	                    if (_3711 >= 0.0)
	                    {
	                        _1370 = 1.0;
	                    }
	                    else
	                    {
	                        _1370 = -1.0;
	                    }
	                    float _3718 = (-1.0) / (_1370 + _3711);
	                    float _3719 = _3710.x;
	                    vec3 _1371;
	                    vec3 _3727 = _1371;
	                    _3727.x = 1.0 + (((_1370 * _3719) * _3719) * _3718);
	                    _3727.y = _1370 * ((_3719 * _3710.y) * _3718);
	                    _3727.z = (-_1370) * _3719;
	                    _1371 = _3727;
	                    float _3735 = float((g_Vertices_3[nonuniformEXT(_182)]._member0[_187] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3741 = (_3727 * cos(_3735)) + (cross(_3710, _3727) * sin(_3735));
	                    vec4 _3743 = _1388;
	                    _3743.x = _3741.x;
	                    _3743.y = _3741.y;
	                    _3743.z = _3741.z;
	                    _1388 = _3743;
	                    float _1372;
	                    if ((g_Vertices_3[nonuniformEXT(_182)]._member0[_187] & 1u) == 0u)
	                    {
	                        _1372 = -1.0;
	                    }
	                    else
	                    {
	                        _1372 = 1.0;
	                    }
	                    vec4 _3754 = _1388;
	                    _3754.w = _1372;
	                    _1388 = _3754;
	                    _1413[1] = _1387;
	                    _1414[1] = _3754;
	                    uint _190 = _3584.z / 4u;
	                    vec4 _1390 = _1414[2];
	                    float _3770 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_190] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3773 = (float((g_Vertices_3[nonuniformEXT(_182)]._member0[_190] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _3777 = (1.0 - abs(_3770)) - abs(_3773);
	                    vec3 _3778 = vec3(_3770, _3773, _3777);
	                    float _3780 = saturate(-_3777);
	                    vec2 _3781 = vec2(_3770, _3773);
	                    vec2 _3787 = _3781 + mix(vec2(_3780), vec2(-_3780), greaterThanEqual(_3781, vec2(0.0)));
	                    _3778.x = _3787.x;
	                    _3778.y = _3787.y;
	                    vec3 _3792 = normalize(_3778);
	                    vec3 _1389 = _3792;
	                    float _3793 = _3792.z;
	                    float _1367;
	                    if (_3793 >= 0.0)
	                    {
	                        _1367 = 1.0;
	                    }
	                    else
	                    {
	                        _1367 = -1.0;
	                    }
	                    float _3800 = (-1.0) / (_1367 + _3793);
	                    float _3801 = _3792.x;
	                    vec3 _1368;
	                    vec3 _3809 = _1368;
	                    _3809.x = 1.0 + (((_1367 * _3801) * _3801) * _3800);
	                    _3809.y = _1367 * ((_3801 * _3792.y) * _3800);
	                    _3809.z = (-_1367) * _3801;
	                    _1368 = _3809;
	                    float _3817 = float((g_Vertices_3[nonuniformEXT(_182)]._member0[_190] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _3823 = (_3809 * cos(_3817)) + (cross(_3792, _3809) * sin(_3817));
	                    vec4 _3825 = _1390;
	                    _3825.x = _3823.x;
	                    _3825.y = _3823.y;
	                    _3825.z = _3823.z;
	                    _1390 = _3825;
	                    float _1369;
	                    if ((g_Vertices_3[nonuniformEXT(_182)]._member0[_190] & 1u) == 0u)
	                    {
	                        _1369 = -1.0;
	                    }
	                    else
	                    {
	                        _1369 = 1.0;
	                    }
	                    vec4 _3836 = _1390;
	                    _3836.w = _1369;
	                    _1390 = _3836;
	                    _1413[2] = _1389;
	                    _1414[2] = _3836;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _1413[0] = vec3(0.0);
	            _1413[1] = vec3(0.0);
	            _1413[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _1391 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _240 = uint(_1391[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _4114 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _1362 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _1363 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _4130 = (uvec3(uint(_1362[_4114])) * _1416) + uvec3(uint(_1363[_4114]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _4132 = _4130.x;
	            _1414[0] = vec4(g_Vertices_1[nonuniformEXT(_240)]._member0[_4132 / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4132 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4132 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4132 + 12u) / 4u]);
	            uint _4138 = _4130.y;
	            _1414[1] = vec4(g_Vertices_1[nonuniformEXT(_240)]._member0[_4138 / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4138 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4138 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4138 + 12u) / 4u]);
	            uint _4144 = _4130.z;
	            _1414[2] = vec4(g_Vertices_1[nonuniformEXT(_240)]._member0[_4144 / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4144 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4144 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_240)]._member0[(_4144 + 12u) / 4u]);
	        }
	        else
	        {
	            _1414[0] = vec4(0.0);
	            _1414[1] = vec4(0.0);
	            _1414[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _1411 = 0;
	    for (;;)
	    {
	        if (!(_1411 < 3))
	        {
	            break;
	        }
	        vsInput[_1411].vNormalOs = _1413[_1411];
	        vsInput[_1411].vTangentUOs_flTangentVSign = _1414[_1411];
	        _1411++;
	        continue;
	    }
	    vec4 _1415[3];
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _1361 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _278 = uint(_1361[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _4191 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _1359 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1360 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _4207 = (uvec3(uint(_1359[_4191])) * _1416) + uvec3(uint(_1360[_4191]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _4249 = _4207.x;
	            _1415[0] = vec4(g_Vertices_1[nonuniformEXT(_278)]._member0[_4249 / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4249 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4249 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4249 + 12u) / 4u]);
	            uint _4255 = _4207.y;
	            _1415[1] = vec4(g_Vertices_1[nonuniformEXT(_278)]._member0[_4255 / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4255 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4255 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4255 + 12u) / 4u]);
	            uint _4261 = _4207.z;
	            _1415[2] = vec4(g_Vertices_1[nonuniformEXT(_278)]._member0[_4261 / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4261 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4261 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_278)]._member0[(_4261 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _280 = _4207.x / 4u;
	            _1415[0] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_278)]._member0[_280] & 255u, (g_Vertices_3[nonuniformEXT(_278)]._member0[_280] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_278)]._member0[_280] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_278)]._member0[_280] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _283 = _4207.y / 4u;
	            _1415[1] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_278)]._member0[_283] & 255u, (g_Vertices_3[nonuniformEXT(_278)]._member0[_283] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_278)]._member0[_283] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_278)]._member0[_283] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _286 = _4207.z / 4u;
	            _1415[2] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_278)]._member0[_286] & 255u, (g_Vertices_3[nonuniformEXT(_278)]._member0[_286] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_278)]._member0[_286] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_278)]._member0[_286] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _1415[0] = vec4(0.0);
	        _1415[1] = vec4(0.0);
	        _1415[2] = vec4(0.0);
	    }
	    _1411 = 0;
	    for (;;)
	    {
	        if (!(_1411 < 3))
	        {
	            break;
	        }
	        vsInput[_1411].vBlendColorTint = _1415[_1411];
	        _1411++;
	        continue;
	    }
	    vec4 _1418[3];
	    _1418[0] = vec4(0.0);
	    _1418[1] = vec4(0.0);
	    _1418[2] = vec4(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _1358 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _326 = uint(_1358[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _4304 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _1356 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _1357 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _4320 = (uvec3(uint(_1356[_4304])) * _1416) + uvec3(uint(_1357[_4304]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _4361 = _4320.x;
	            _1418[0] = vec4(g_Vertices_1[nonuniformEXT(_326)]._member0[_4361 / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4361 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4361 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4361 + 12u) / 4u]);
	            uint _4366 = _4320.y;
	            _1418[1] = vec4(g_Vertices_1[nonuniformEXT(_326)]._member0[_4366 / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4366 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4366 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4366 + 12u) / 4u]);
	            uint _4371 = _4320.z;
	            _1418[2] = vec4(g_Vertices_1[nonuniformEXT(_326)]._member0[_4371 / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4371 + 4u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4371 + 8u) / 4u], g_Vertices_1[nonuniformEXT(_326)]._member0[(_4371 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _328 = _4320.x / 4u;
	                _1418[0] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_326)]._member0[_328] & 255u, (g_Vertices_3[nonuniformEXT(_326)]._member0[_328] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_326)]._member0[_328] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_326)]._member0[_328] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _331 = _4320.y / 4u;
	                _1418[1] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_326)]._member0[_331] & 255u, (g_Vertices_3[nonuniformEXT(_326)]._member0[_331] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_326)]._member0[_331] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_326)]._member0[_331] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _334 = _4320.z / 4u;
	                _1418[2] = vec4(uvec4(g_Vertices_3[nonuniformEXT(_326)]._member0[_334] & 255u, (g_Vertices_3[nonuniformEXT(_326)]._member0[_334] & 65280u) >> uint(8), (g_Vertices_3[nonuniformEXT(_326)]._member0[_334] & 16711680u) >> uint(16), (g_Vertices_3[nonuniformEXT(_326)]._member0[_334] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _1419 = 0;
	    for (;;)
	    {
	        if (!(_1419 < 3))
	        {
	            break;
	        }
	        vsInput[_1419].vColorBlendValues = _1418[_1419];
	        _1419++;
	        continue;
	    }
	    vec2 _1090 = vsInput[0].vTexCoord;
	    vec2 _1089 = vsInput[0].vTexCoord2;
	    vec4 _1088 = vsInput[0].vBlendColorTint;
	    vec4 _1087 = vsInput[0].vColorBlendValues;
	    vec3 _1353 = vsInput[0].vNormalOs;
	    vec4 _1354;
	    vec4 _4405 = _1354;
	    _4405.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _4405.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _4405.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _4405.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _1354 = _4405;
	    vec4 _4428 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _1352 = _4428;
	    vec3 _4429 = _4428.xyz;
	    vec3 _4430 = _4429 * vec3(0.077399380505084991455078125);
	    vec3 _4433 = pow((_4429 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _1349;
	    if (_4428.x <= 0.040449999272823333740234375)
	    {
	        _1349 = _4430.x;
	    }
	    else
	    {
	        _1349 = _4433.x;
	    }
	    float _1350;
	    if (_4428.y <= 0.040449999272823333740234375)
	    {
	        _1350 = _4430.y;
	    }
	    else
	    {
	        _1350 = _4433.y;
	    }
	    float _1351;
	    if (_4428.z <= 0.040449999272823333740234375)
	    {
	        _1351 = _4430.z;
	    }
	    else
	    {
	        _1351 = _4433.z;
	    }
	    vec3 _4458 = vec3(_1349, _1350, _1351);
	    vec4 _4460 = _1352;
	    _4460.x = _4458.x;
	    _4460.y = _4458.y;
	    _4460.z = _4458.z;
	    _1352 = _4460;
	    vec4 _1100;
	    vec4 _4467 = _1100;
	    _4467.x = _4460.x;
	    _4467.y = _4460.y;
	    _4467.z = _4460.z;
	    _4467.w = _4460.w;
	    _1100 = _4467;
	    mat3x4 _4478 = transpose(gl_WorldToObjectEXT);
	    mat3 _1348;
	    mat3 _4481 = _1348;
	    _4481[0] = _4478[0].xyz;
	    _4481[1] = _4478[1].xyz;
	    _4481[2] = _4478[2].xyz;
	    _1348 = _4481;
	    vec3 _4490 = normalize(_4481 * _1353.xyz);
	    vec3 _1101;
	    vec3 _4492 = _1101;
	    _4492.x = _4490.x;
	    _4492.y = _4490.y;
	    _4492.z = _4490.z;
	    _1101 = _4492;
	    mat3x4 _4504 = transpose(gl_WorldToObjectEXT);
	    mat3 _1347;
	    mat3 _4507 = _1347;
	    _4507[0] = _4504[0].xyz;
	    _4507[1] = _4504[1].xyz;
	    _4507[2] = _4504[2].xyz;
	    _1347 = _4507;
	    vec3 _4516 = normalize(_4507 * _1354.xyz);
	    vec4 _1099;
	    vec4 _4518 = _1099;
	    _4518.x = _4516.x;
	    _4518.y = _4516.y;
	    _4518.z = _4516.z;
	    _4518.w = _1354.w;
	    _1099 = _4518;
	    vec4 _4527 = _1090.xyxy;
	    _4527.z = _1089.x;
	    _4527.w = _1089.y;
	    vec4 _1102;
	    vec4 _1103;
	    vec4 _1098 = _1103;
	    vec4 _1097 = _1102;
	    vec3 _1096 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _1095 = _4492;
	    vec4 _1094 = _4527;
	    vec4 _1093 = _4467;
	    vec4 _1092 = _4518;
	    vec2 _1355;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _1355 = _4527.zw;
	        }
	        else
	        {
	            _1355 = _4527.xy;
	        }
	        vec4 _4550 = _1094;
	        _4550.x = _1355.x;
	        _4550.y = _1355.y;
	        vec4 _4569 = _4550;
	        _4569.x = dot(_4550.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _4569.y = dot(_4550.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _1094 = _4569;
	    }
	    if (_g_rtx_material_data_.g_nUVSet2 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet2 == 2)
	        {
	            _1355 = _4527.zw;
	        }
	        else
	        {
	            _1355 = _4527.xy;
	        }
	        vec4 _4585 = _1094;
	        _4585.z = _1355.x;
	        _4585.w = _1355.y;
	        vec4 _4604 = _4585;
	        _4604.z = dot(_4585.zw, _g_rtx_material_data_.g_vTexCoordXform0_2.xy) + _g_rtx_material_data_.g_vTexCoordXform0_2.w;
	        _4604.w = dot(_4585.zw, _g_rtx_material_data_.g_vTexCoordXform1_2.xy) + _g_rtx_material_data_.g_vTexCoordXform1_2.w;
	        _1094 = _4604;
	    }
	    vec4 _4607 = _1093;
	    vec4 _4609 = _1097;
	    _4609.x = _4607.x;
	    _4609.y = _4607.y;
	    _4609.z = _4607.z;
	    _4609.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_4609.x, min(_4609.y, _4609.z)));
	    _1097 = _4609;
	    _4607.x = _g_rtx_material_data_.g_vColorTint.x;
	    _4607.y = _g_rtx_material_data_.g_vColorTint.y;
	    _4607.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _4638 = _4607.xyz * mix(vec3(1.0), _1088.xyz, vec3(_1088.w));
	    vec4 _4640 = _4607;
	    _4640.x = _4638.x;
	    _4640.y = _4638.y;
	    _4640.z = _4638.z;
	    _1093 = _4640;
	    vec4 _4647 = _1098;
	    _4647.x = _1087.x;
	    _4647.y = _1087.y;
	    _4647.z = _1087.z;
	    _4647.w = _1087.w;
	    _1098 = _4647;
	    vec4 _1067 = _4647;
	    vec4 _1066 = _4609;
	    vec3 _1065 = _1096;
	    vec3 _1064 = _1095;
	    vec4 _1063 = _1094;
	    vec4 _1062 = _4640;
	    vec4 _1061 = _1092;
	    vec2 _1086 = vsInput[1].vTexCoord;
	    vec2 _1085 = vsInput[1].vTexCoord2;
	    vec4 _1084 = vsInput[1].vBlendColorTint;
	    vec4 _1083 = vsInput[1].vColorBlendValues;
	    vec3 _1344 = vsInput[1].vNormalOs;
	    vec4 _1345;
	    vec4 _4669 = _1345;
	    _4669.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _4669.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _4669.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _4669.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _1345 = _4669;
	    vec4 _4692 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _1343 = _4692;
	    vec3 _4693 = _4692.xyz;
	    vec3 _4694 = _4693 * vec3(0.077399380505084991455078125);
	    vec3 _4697 = pow((_4693 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _1340;
	    if (_4692.x <= 0.040449999272823333740234375)
	    {
	        _1340 = _4694.x;
	    }
	    else
	    {
	        _1340 = _4697.x;
	    }
	    float _1341;
	    if (_4692.y <= 0.040449999272823333740234375)
	    {
	        _1341 = _4694.y;
	    }
	    else
	    {
	        _1341 = _4697.y;
	    }
	    float _1342;
	    if (_4692.z <= 0.040449999272823333740234375)
	    {
	        _1342 = _4694.z;
	    }
	    else
	    {
	        _1342 = _4697.z;
	    }
	    vec3 _4722 = vec3(_1340, _1341, _1342);
	    vec4 _4724 = _1343;
	    _4724.x = _4722.x;
	    _4724.y = _4722.y;
	    _4724.z = _4722.z;
	    _1343 = _4724;
	    vec4 _1112;
	    vec4 _4731 = _1112;
	    _4731.x = _4724.x;
	    _4731.y = _4724.y;
	    _4731.z = _4724.z;
	    _4731.w = _4724.w;
	    _1112 = _4731;
	    mat3x4 _4742 = transpose(gl_WorldToObjectEXT);
	    mat3 _1339;
	    mat3 _4745 = _1339;
	    _4745[0] = _4742[0].xyz;
	    _4745[1] = _4742[1].xyz;
	    _4745[2] = _4742[2].xyz;
	    _1339 = _4745;
	    vec3 _4754 = normalize(_4745 * _1344.xyz);
	    vec3 _1113;
	    vec3 _4756 = _1113;
	    _4756.x = _4754.x;
	    _4756.y = _4754.y;
	    _4756.z = _4754.z;
	    _1113 = _4756;
	    mat3x4 _4768 = transpose(gl_WorldToObjectEXT);
	    mat3 _1338;
	    mat3 _4771 = _1338;
	    _4771[0] = _4768[0].xyz;
	    _4771[1] = _4768[1].xyz;
	    _4771[2] = _4768[2].xyz;
	    _1338 = _4771;
	    vec3 _4780 = normalize(_4771 * _1345.xyz);
	    vec4 _1111;
	    vec4 _4782 = _1111;
	    _4782.x = _4780.x;
	    _4782.y = _4780.y;
	    _4782.z = _4780.z;
	    _4782.w = _1345.w;
	    _1111 = _4782;
	    vec4 _4791 = _1086.xyxy;
	    _4791.z = _1085.x;
	    _4791.w = _1085.y;
	    vec4 _1114;
	    vec4 _1115;
	    vec4 _1110 = _1115;
	    vec4 _1109 = _1114;
	    vec3 _1108 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _1107 = _4756;
	    vec4 _1106 = _4791;
	    vec4 _1105 = _4731;
	    vec4 _1104 = _4782;
	    vec2 _1346;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _1346 = _4791.zw;
	        }
	        else
	        {
	            _1346 = _4791.xy;
	        }
	        vec4 _4814 = _1106;
	        _4814.x = _1346.x;
	        _4814.y = _1346.y;
	        vec4 _4833 = _4814;
	        _4833.x = dot(_4814.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _4833.y = dot(_4814.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _1106 = _4833;
	    }
	    if (_g_rtx_material_data_.g_nUVSet2 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet2 == 2)
	        {
	            _1346 = _4791.zw;
	        }
	        else
	        {
	            _1346 = _4791.xy;
	        }
	        vec4 _4849 = _1106;
	        _4849.z = _1346.x;
	        _4849.w = _1346.y;
	        vec4 _4868 = _4849;
	        _4868.z = dot(_4849.zw, _g_rtx_material_data_.g_vTexCoordXform0_2.xy) + _g_rtx_material_data_.g_vTexCoordXform0_2.w;
	        _4868.w = dot(_4849.zw, _g_rtx_material_data_.g_vTexCoordXform1_2.xy) + _g_rtx_material_data_.g_vTexCoordXform1_2.w;
	        _1106 = _4868;
	    }
	    vec4 _4871 = _1105;
	    vec4 _4873 = _1109;
	    _4873.x = _4871.x;
	    _4873.y = _4871.y;
	    _4873.z = _4871.z;
	    _4873.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_4873.x, min(_4873.y, _4873.z)));
	    _1109 = _4873;
	    _4871.x = _g_rtx_material_data_.g_vColorTint.x;
	    _4871.y = _g_rtx_material_data_.g_vColorTint.y;
	    _4871.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _4902 = _4871.xyz * mix(vec3(1.0), _1084.xyz, vec3(_1084.w));
	    vec4 _4904 = _4871;
	    _4904.x = _4902.x;
	    _4904.y = _4902.y;
	    _4904.z = _4902.z;
	    _1105 = _4904;
	    vec4 _4911 = _1110;
	    _4911.x = _1083.x;
	    _4911.y = _1083.y;
	    _4911.z = _1083.z;
	    _4911.w = _1083.w;
	    _1110 = _4911;
	    vec4 _1060 = _4911;
	    vec4 _1059 = _4873;
	    vec3 _1058 = _1108;
	    vec3 _1057 = _1107;
	    vec4 _1056 = _1106;
	    vec4 _1055 = _4904;
	    vec4 _1054 = _1104;
	    vec2 _1082 = vsInput[2].vTexCoord;
	    vec2 _1081 = vsInput[2].vTexCoord2;
	    vec4 _1080 = vsInput[2].vBlendColorTint;
	    vec4 _1079 = vsInput[2].vColorBlendValues;
	    vec3 _1335 = vsInput[2].vNormalOs;
	    vec4 _1336;
	    vec4 _4933 = _1336;
	    _4933.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _4933.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _4933.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _4933.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _1336 = _4933;
	    vec4 _4956 = vec4(uvec4(g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 255u, (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _1334 = _4956;
	    vec3 _4957 = _4956.xyz;
	    vec3 _4958 = _4957 * vec3(0.077399380505084991455078125);
	    vec3 _4961 = pow((_4957 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _1331;
	    if (_4956.x <= 0.040449999272823333740234375)
	    {
	        _1331 = _4958.x;
	    }
	    else
	    {
	        _1331 = _4961.x;
	    }
	    float _1332;
	    if (_4956.y <= 0.040449999272823333740234375)
	    {
	        _1332 = _4958.y;
	    }
	    else
	    {
	        _1332 = _4961.y;
	    }
	    float _1333;
	    if (_4956.z <= 0.040449999272823333740234375)
	    {
	        _1333 = _4958.z;
	    }
	    else
	    {
	        _1333 = _4961.z;
	    }
	    vec3 _4986 = vec3(_1331, _1332, _1333);
	    vec4 _4988 = _1334;
	    _4988.x = _4986.x;
	    _4988.y = _4986.y;
	    _4988.z = _4986.z;
	    _1334 = _4988;
	    vec4 _1124;
	    vec4 _4995 = _1124;
	    _4995.x = _4988.x;
	    _4995.y = _4988.y;
	    _4995.z = _4988.z;
	    _4995.w = _4988.w;
	    _1124 = _4995;
	    mat3x4 _5006 = transpose(gl_WorldToObjectEXT);
	    mat3 _1330;
	    mat3 _5009 = _1330;
	    _5009[0] = _5006[0].xyz;
	    _5009[1] = _5006[1].xyz;
	    _5009[2] = _5006[2].xyz;
	    _1330 = _5009;
	    vec3 _5018 = normalize(_5009 * _1335.xyz);
	    vec3 _1125;
	    vec3 _5020 = _1125;
	    _5020.x = _5018.x;
	    _5020.y = _5018.y;
	    _5020.z = _5018.z;
	    _1125 = _5020;
	    mat3x4 _5032 = transpose(gl_WorldToObjectEXT);
	    mat3 _1329;
	    mat3 _5035 = _1329;
	    _5035[0] = _5032[0].xyz;
	    _5035[1] = _5032[1].xyz;
	    _5035[2] = _5032[2].xyz;
	    _1329 = _5035;
	    vec3 _5044 = normalize(_5035 * _1336.xyz);
	    vec4 _1123;
	    vec4 _5046 = _1123;
	    _5046.x = _5044.x;
	    _5046.y = _5044.y;
	    _5046.z = _5044.z;
	    _5046.w = _1336.w;
	    _1123 = _5046;
	    vec4 _5055 = _1082.xyxy;
	    _5055.z = _1081.x;
	    _5055.w = _1081.y;
	    vec4 _1126;
	    vec4 _1127;
	    vec4 _1122 = _1127;
	    vec4 _1121 = _1126;
	    vec3 _1120 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _1119 = _5020;
	    vec4 _1118 = _5055;
	    vec4 _1117 = _4995;
	    vec4 _1116 = _5046;
	    vec2 _1337;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _1337 = _5055.zw;
	        }
	        else
	        {
	            _1337 = _5055.xy;
	        }
	        vec4 _5078 = _1118;
	        _5078.x = _1337.x;
	        _5078.y = _1337.y;
	        vec4 _5097 = _5078;
	        _5097.x = dot(_5078.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _5097.y = dot(_5078.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _1118 = _5097;
	    }
	    if (_g_rtx_material_data_.g_nUVSet2 > 0)
	    {
	        if (_g_rtx_material_data_.g_nUVSet2 == 2)
	        {
	            _1337 = _5055.zw;
	        }
	        else
	        {
	            _1337 = _5055.xy;
	        }
	        vec4 _5113 = _1118;
	        _5113.z = _1337.x;
	        _5113.w = _1337.y;
	        vec4 _5132 = _5113;
	        _5132.z = dot(_5113.zw, _g_rtx_material_data_.g_vTexCoordXform0_2.xy) + _g_rtx_material_data_.g_vTexCoordXform0_2.w;
	        _5132.w = dot(_5113.zw, _g_rtx_material_data_.g_vTexCoordXform1_2.xy) + _g_rtx_material_data_.g_vTexCoordXform1_2.w;
	        _1118 = _5132;
	    }
	    vec4 _5135 = _1117;
	    vec4 _5137 = _1121;
	    _5137.x = _5135.x;
	    _5137.y = _5135.y;
	    _5137.z = _5135.z;
	    _5137.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_5137.x, min(_5137.y, _5137.z)));
	    _1121 = _5137;
	    _5135.x = _g_rtx_material_data_.g_vColorTint.x;
	    _5135.y = _g_rtx_material_data_.g_vColorTint.y;
	    _5135.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _5166 = _5135.xyz * mix(vec3(1.0), _1080.xyz, vec3(_1080.w));
	    vec4 _5168 = _5135;
	    _5168.x = _5166.x;
	    _5168.y = _5166.y;
	    _5168.z = _5166.z;
	    _1117 = _5168;
	    vec4 _5175 = _1122;
	    _5175.x = _1079.x;
	    _5175.y = _1079.y;
	    _5175.z = _1079.z;
	    _5175.w = _1079.w;
	    _1122 = _5175;
	    vec3 _1053 = _1120;
	    vec3 _1052 = _1119;
	    vec3 _5211 = ((_1064 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1057 * attrs.barycentrics.x)) + (_1119 * attrs.barycentrics.y);
	    bool _5217 = gl_HitKindEXT == 254u;
	    vec3 _1128;
	    vec4 _5254 = ((_1067 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1060 * attrs.barycentrics.x)) + (_5175 * attrs.barycentrics.y);
	    vec4 _1078 = _5254;
	    vec4 _1077 = ((_1066 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1059 * attrs.barycentrics.x)) + (_5137 * attrs.barycentrics.y);
	    vec3 _1076 = _5211;
	    vec4 _1075 = ((_1063 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1056 * attrs.barycentrics.x)) + (_1118 * attrs.barycentrics.y);
	    vec4 _1074 = ((_1062 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1055 * attrs.barycentrics.x)) + (_5168 * attrs.barycentrics.y);
	    vec4 _1073 = ((_1061 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1054 * attrs.barycentrics.x)) + (_1116 * attrs.barycentrics.y);
	    bool _1072 = _5217;
	    float _1313 = saturate((_5254.x * 1.10000002384185791015625) - 0.0500000007450580596923828125);
	    vec3 _1192 = _1128;
	    vec3 _1191 = normalize(cross(_1058 - _1065, _1120 - _1065));
	    bool _1190 = _5217;
	    vec3 _1217 = vec3(0.5);
	    vec2 _1216 = vec2(0.5);
	    float _1215 = 0.0;
	    float _1214 = 1.0;
	    vec3 _1213 = vec3(0.0);
	    float _1212 = 0.039999999105930328369140625;
	    vec3 _1211 = vec3(0.0);
	    float _1210 = 0.0;
	    vec3 _1209 = vec3(0.0);
	    vec3 _1207 = vec3(1.0);
	    bool _1206 = false;
	    vec3 _5268 = _5211.xyz;
	    vec3 _1208 = _5268;
	    if (dot(_5268, _5268) >= 1.0099999904632568359375)
	    {
	        _1208 = _1192.xyz;
	    }
	    _1212 = _g_rtx_material_data_.g_flReflectance;
	    _1207 = _1191;
	    bool _1311;
	    if (_g_rtx_material_data_.g_bRenderBackfaceNormals)
	    {
	        _1311 = !_g_rtx_material_data_.g_bDontFlipBackfaceNormals;
	    }
	    else
	    {
	        _1311 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_1311)
	    {
	        float _1312;
	        if (_1190)
	        {
	            _1312 = 1.0;
	        }
	        else
	        {
	            _1312 = -1.0;
	        }
	        _1208 *= _1312;
	        if (_1190)
	        {
	            _1312 = 1.0;
	        }
	        else
	        {
	            _1312 = -1.0;
	        }
	        _1207 *= _1312;
	        _1206 = !_1190;
	    }
	    vec3 _5302 = _1208;
	    vec3 _5303 = normalize(_5302);
	    _1208 = _5303;
	    vec3 _1205 = _5303;
	    vec3 _1204 = _1217;
	    vec2 _1203 = _1216;
	    float _1202 = _1215;
	    float _1201 = _1214;
	    vec3 _1200 = _1213;
	    float _1199 = _1212;
	    vec3 _1198 = _1211;
	    float _1197 = _1210;
	    vec3 _1196 = _1209;
	    vec3 _1195 = _5303;
	    vec3 _1194 = _1207;
	    bool _1193 = _1206;
	    vec2 _1189 = vec2(0.0);
	    vec2 _1188 = vec2(0.0);
	    vec2 _1187 = vec2(0.0);
	    vec2 _1186 = vec2(0.0);
	    vec2 _1185 = vec2(0.0);
	    vec2 _1184 = vec2(0.0);
	    vec2 _1183 = vec2(0.0);
	    ivec2 _1182 = ivec2(0);
	    ivec2 _1181 = ivec2(0);
	    if (_g_rtx_material_data_.bBiplanarUsedAny)
	    {
	        vec3 _5321 = abs(_1195);
	        vec3 _1306 = _5321;
	        float _5322 = _5321.x;
	        float _5323 = _5321.y;
	        bool _1307;
	        if (_5322 > _5323)
	        {
	            _1307 = _5322 > _5321.z;
	        }
	        else
	        {
	            _1307 = false;
	        }
	        ivec3 _1308;
	        if (_1307)
	        {
	            _1308 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5323 > _5321.z)
	            {
	                _1308 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _1308 = ivec3(2, 0, 1);
	            }
	        }
	        if (_5322 < _5323)
	        {
	            _1307 = _5322 < _5321.z;
	        }
	        else
	        {
	            _1307 = false;
	        }
	        ivec3 _1309;
	        if (_1307)
	        {
	            _1309 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_5323 < _5321.z)
	            {
	                _1309 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _1309 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _5357 = (ivec3(3) - _1309) - _1308;
	        ivec2 _1310;
	        if (_1308.x == 1)
	        {
	            _1310 = _1308.zy;
	        }
	        else
	        {
	            _1310 = _1308.yz;
	        }
	        ivec2 _5369 = _1182;
	        _5369.x = _1310.x;
	        _5369.y = _1310.y;
	        _1182 = _5369;
	        int _5373 = _5357.x;
	        if (_5373 == 1)
	        {
	            _1310 = _5357.zy;
	        }
	        else
	        {
	            _1310 = _5357.yz;
	        }
	        ivec2 _5382 = _1181;
	        _5382.x = _1310.x;
	        _5382.y = _1310.y;
	        _1181 = _5382;
	        vec2 _5393 = saturate((vec2(_1306[_1308.x], _1306[_5373]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625));
	        _1183 = _5393 / vec2(_5393.x + _5393.y);
	        vec3 _1297 = _1196 * _g_rtx_material_data_.g_vBiplanarTexCoordScale.xyz;
	        _1189 = vec2(_1297[_1182.x], _1297[_1182.y]);
	        vec3 _1298 = vec3(0.0);
	        vec3 _1299 = vec3(0.0);
	        _1187 = vec2(_1298[_1182.x], _1299[_1182.y]);
	        vec3 _1300 = vec3(0.0);
	        vec3 _1301 = vec3(0.0);
	        _1186 = vec2(_1300[_1182.x], _1301[_1182.y]);
	        _1188 = vec2(_1297[_5382.x], _1297[_5382.y]);
	        vec3 _1302 = vec3(0.0);
	        vec3 _1303 = vec3(0.0);
	        _1185 = vec2(_1302[_5382.x], _1303[_5382.y]);
	        vec3 _1304 = vec3(0.0);
	        vec3 _1305 = vec3(0.0);
	        _1184 = vec2(_1304[_5382.x], _1305[_5382.y]);
	    }
	    bool _1314;
	    if (_g_rtx_material_data_.g_nUVSet2 > 1)
	    {
	        _1314 = true;
	    }
	    else
	    {
	        _1314 = _g_rtx_material_data_.g_nUVSet1 > 1;
	    }
	    bool _1180 = _1072;
	    bool _1295;
	    if (_g_rtx_material_data_.g_bRenderBackfaceNormals)
	    {
	        _1295 = !_g_rtx_material_data_.g_bDontFlipBackfaceNormals;
	    }
	    else
	    {
	        _1295 = false;
	    }
	    if (_1295)
	    {
	        float _1296;
	        if (_1180)
	        {
	            _1296 = 1.0;
	        }
	        else
	        {
	            _1296 = -1.0;
	        }
	        _1295 = _1296 < 0.0;
	    }
	    else
	    {
	        _1295 = false;
	    }
	    vec3 _1221 = vec3(0.0);
	    vec3 _1220 = vec3(0.0);
	    float _1293;
	    if (_1073.w > 0.0)
	    {
	        _1293 = 1.0;
	    }
	    else
	    {
	        _1293 = -1.0;
	    }
	    float _5489 = 1.0 / length(_1076);
	    vec3 _1222 = _1076 * _5489;
	    vec3 _1071 = _1073.xyz * _5489;
	    vec3 _1070 = (cross(_1076, _1073.xyz) * _1293) * _5489;
	    if (_1295)
	    {
	        _1222 *= (-1.0);
	    }
	    vec3 _1219 = _1221 - (_1222 * dot(_1221, _1222));
	    vec3 _1218 = _1220 - (_1222 * dot(_1220, _1222));
	    int _1294;
	    if (dot(_1220, cross(_1222, _1221)) < 0.0)
	    {
	        _1294 = -1;
	    }
	    else
	    {
	        _1294 = 1;
	    }
	    vec3 _1263 = _1222;
	    vec3 _1262 = _1219;
	    vec3 _1261 = _1218;
	    float _1260 = float(_1294);
	    vec3 _1178;
	    vec3 _1179;
	    if (_1314)
	    {
	        float _1292;
	        if (false)
	        {
	            _1292 = -1.0;
	        }
	        else
	        {
	            _1292 = 1.0;
	        }
	        vec2 _5527 = vec2(0.0, -0.0) * _1292;
	        vec3 _1223 = (_1262 * _5527.x) + (_1261 * _5527.y);
	        float _5535 = abs(0.0);
	        if (_5535 > 0.0)
	        {
	            _1223 = normalize(_1223);
	        }
	        _1179 = _1223;
	        _1178 = cross(_1263, _1223) * (_1292 * _1260);
	    }
	    else
	    {
	        _1179 = vec3(0.0);
	        _1178 = vec3(0.0);
	    }
	    float _1315 = 0.0;
	    float _1316 = 0.0;
	    float _1317 = max(min(_1078.w + _g_rtx_material_data_.g_flBlendSoftness2, 1.0), 9.9999997473787516355514526367188e-05);
	    vec3 _1318 = vec3(0.0);
	    float _1319 = _g_rtx_material_data_.g_flHeightMapZeroPoint1;
	    float _1320 = _g_rtx_material_data_.g_flHeightMapScale1;
	    vec2 _1321 = vec2(0.0);
	    vec4 _1177 = vec4(0.0);
	    vec3 _1176 = vec3(0.0);
	    vec4 _1173 = vec4(0.0);
	    float _1172 = 0.0;
	    float _1171 = 0.0;
	    float _1170 = 0.0;
	    float _1169 = 0.0;
	    float _1168 = 0.0;
	    float _1167 = 0.0;
	    float _1166 = 0.0;
	    vec3 _5561 = vec3(0.0);
	    _5561.x = _1075.x;
	    _5561.y = _1075.y;
	    vec3 _1175 = _5561;
	    vec2 _1174 = _g_rtx_material_data_.g_vTexCoordScale1.xy;
	    vec2 _1230 = _1189;
	    vec2 _1229 = _1188;
	    vec2 _1228 = _1187;
	    vec2 _1227 = _1186;
	    vec2 _1226 = _1185;
	    vec2 _1225 = _1184;
	    vec2 _1224 = _1183;
	    vec4 _1291;
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        vec2 _5586 = _1230;
	        vec2 _5587 = _5586 * _1174;
	        _1230 = _5587;
	        vec2 _5588 = _1228;
	        vec2 _5589 = _5588 * _1174;
	        _1228 = _5589;
	        vec2 _5590 = _1227;
	        vec2 _5591 = _5590 * _1174;
	        _1227 = _5591;
	        vec2 _5592 = _1229;
	        vec2 _5593 = _5592 * _1174;
	        _1229 = _5593;
	        vec2 _5594 = _1226;
	        vec2 _5595 = _5594 * _1174;
	        _1226 = _5595;
	        vec2 _5596 = _1225;
	        vec2 _5597 = _5596 * _1174;
	        _1225 = _5597;
	        _1291 = (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _5587.xy, _5589.xy, _5591.xy) * _1224.x) + (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _5593.xy, _5595.xy, _5597.xy) * _1224.y);
	    }
	    else
	    {
	        _1291 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1175.xy, 0.0).xyzw;
	    }
	    _1169 = _1291.x;
	    _1167 = _1291.y;
	    _1168 = _1291.w;
	    _1170 = _1291.x;
	    SPIRV_CROSS_BRANCH
	    if (_g_rtx_material_data_.g_bWetnessUseHeightmapAdjustments)
	    {
	        _1170 = max(0.0, ((_1170 + 0.5) - _1319) * _1320);
	    }
	    float _5636 = _1319;
	    float _5637 = _5636 + (_1315 * 0.5);
	    _1319 = _5637;
	    float _5639 = _1320;
	    float _5640 = _5639 + _1317;
	    _1320 = _5640;
	    vec2 _5643 = _1321;
	    _5643.x = (-_5637) * _5640;
	    _5643.y = (1.0 - _5637) * _5640;
	    _1321 = _5643;
	    if (false)
	    {
	        float _5652 = _1320;
	        float _5653 = _5652 - (_1317 * 2.0);
	        _1320 = _5653;
	        if (_5653 == 0.0)
	        {
	            _1320 = 9.9999997473787516355514526367188e-05;
	        }
	    }
	    _1171 = (_1169 - _1319) * _1320;
	    vec3 _1165 = _1195;
	    vec3 _1164 = _1071;
	    vec3 _1163 = _1070;
	    vec3 _1162 = _1179;
	    vec3 _1161 = _1178;
	    vec2 _1241 = _1189;
	    vec2 _1240 = _1188;
	    vec2 _1239 = _1187;
	    vec2 _1238 = _1186;
	    vec2 _1237 = _1185;
	    vec2 _1236 = _1184;
	    vec2 _1235 = _1183;
	    ivec2 _1234 = _1182;
	    ivec2 _1233 = _1181;
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        _1241 *= _1174;
	        _1239 *= _1174;
	        _1238 *= _1174;
	        _1240 *= _1174;
	        _1237 *= _1174;
	        _1236 *= _1174;
	        _1176 = _1165;
	        if (true)
	        {
	            _1177 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1241.xy, _1239.xy, _1238.xy) * _1235.x;
	        }
	        if (true)
	        {
	            vec4 _5812 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1241.xy, _1239.xy, _1238.xy);
	            _1166 = _5812.z * _1235.x;
	            float _5817 = _5812.x;
	            float _5818 = _5812.y;
	            float _5820 = (_5817 + _5818) - 1.00392162799835205078125;
	            float _5821 = _5817 - _5818;
	            vec3 _5831 = normalize(vec3(vec2(_5820, _5821), (1.0 - abs(_5820)) - abs(_5821))).xyz * _1235.x;
	            vec4 _5833;
	            _5833.x = _5831.x;
	            _5833.y = _5831.y;
	            vec4 _5837 = _5833;
	            _5837.z = _5831.z;
	            _1176 = (_957[_1234.x] * _5833.x) + (_961[_1234.y] * _5833.y);
	        }
	        if (_1235.y > 0.0)
	        {
	            if (true)
	            {
	                _1177 += (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1240.xy, _1237.xy, _1236.xy) * _1235.y);
	            }
	            if (true)
	            {
	                vec4 _5885 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1240.xy, _1237.xy, _1236.xy);
	                _1166 += (_5885.z * _1235.y);
	                float _5892 = _5885.x;
	                float _5893 = _5885.y;
	                float _5895 = (_5892 + _5893) - 1.00392162799835205078125;
	                float _5896 = _5892 - _5893;
	                vec3 _5906 = normalize(vec3(vec2(_5895, _5896), (1.0 - abs(_5895)) - abs(_5896))).xyz * _1235.y;
	                vec4 _5908;
	                _5908.x = _5906.x;
	                _5908.y = _5906.y;
	                vec4 _5912 = _5908;
	                _5912.z = _5906.z;
	                _1176 += ((_957[_1233.x] * _5908.x) + (_961[_1233.y] * _5908.y));
	            }
	        }
	        _1176 = normalize(_1176 + _1165);
	    }
	    else
	    {
	        if (true)
	        {
	            _1177 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1175.xy, _1173.xy, _1173.zw).xyzw;
	        }
	        if (true)
	        {
	            vec4 _5707 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1175.xy, _1173.xy, _1173.zw);
	            vec3 _5708 = _5707.xyz;
	            _1166 = _5707.z;
	            float _5710 = _5707.x;
	            float _5711 = _5707.y;
	            float _5713 = (_5710 + _5711) - 1.00392162799835205078125;
	            float _5714 = _5710 - _5711;
	            vec3 _5721 = normalize(vec3(vec2(_5713, _5714), (1.0 - abs(_5713)) - abs(_5714)));
	            _5708.x = _5721.x;
	            _5708.y = _5721.y;
	            _5708.z = _5721.z;
	            vec3 _5734 = _5708;
	            _5734.x = dot(_5708.xy, _g_rtx_material_data_.g_vNormalXform_1.xy);
	            _5734.y = dot(_5708.xy, _g_rtx_material_data_.g_vNormalXform_1.zw);
	            vec3 _1290 = _5734;
	            vec3 _1231;
	            vec3 _1232;
	            if (_g_rtx_material_data_.g_nUVSet1 > 1)
	            {
	                _1232 = _1162;
	                _1231 = _1161;
	            }
	            else
	            {
	                _1232 = _1164;
	                _1231 = _1163;
	            }
	            vec3 _5746 = abs(_1290.xyz);
	            vec2 _5759 = (-vec2(_1290.x, (-1.0) * _1290.y)) / vec2(max(_5746.z, 0.0078125 * max(_5746.x, _5746.y)));
	            _1176 = normalize(_1263 - ((_1232 * _5759.x) + (_1231 * _5759.y)));
	        }
	    }
	    _1172 = _1177.w;
	    vec3 _1160 = _1195;
	    if (true)
	    {
	        _1176 = normalize(mix(_1160, _1176, vec3(_g_rtx_material_data_.g_fTextureNormalContrast1)));
	        _1166 = saturate(((_g_rtx_material_data_.g_fTextureRoughnessContrast1 * (_1166 - 0.5)) + 0.5) * _g_rtx_material_data_.g_fTextureRoughnessBrightness1);
	    }
	    vec4 _1159 = _1077;
	    vec4 _1285;
	    if (_g_rtx_material_data_.g_bAdjustBaseColor1)
	    {
	        _1285 = vec4((vec4(_1177.xyz, 1.0) * _g_rtx_material_data_.g_mTextureAdjust1).xyz, _1177.w);
	    }
	    else
	    {
	        _1285 = _1177;
	    }
	    vec4 _5976 = _1285;
	    float _5979 = _1172;
	    float _5983 = saturate(mix(_g_rtx_material_data_.g_vAmbientOcclusionLevels1.x, _g_rtx_material_data_.g_vAmbientOcclusionLevels1.z, pow(_5979, _g_rtx_material_data_.g_vAmbientOcclusionLevels1.y)));
	    _1172 = _5983;
	    float _5985 = _1168;
	    float _5986 = _5985 * float(_g_rtx_material_data_.g_bMetalness1);
	    _1168 = _5986;
	    float _5987 = _1167;
	    float _5992 = saturate(((_g_rtx_material_data_.g_fTintMaskContrast1 * (_5987 - 0.5)) + 0.5) * _g_rtx_material_data_.g_fTintMaskBrightness1);
	    _1167 = _5992;
	    vec3 _5996 = mix(_5976.xyz, vec4((vec4(_1177.xyz, 1.0) * _g_rtx_material_data_.g_mTextureColorAdjust1).xyz, _1046).xyz, vec3(_5992));
	    vec4 _5998 = _5976;
	    _5998.x = _5996.x;
	    _5998.y = _5996.y;
	    _5998.z = _5996.z;
	    float _6010 = dot(_5998.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _6013 = normalize(max(_1159.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _6032 = vec4(saturate(mix(_5998.xyz, (_6013 * min(_6010 / dot(_6013.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _6010) * max(_1159.x, max(_1159.y, _1159.z)))).xyz, vec3((_1159.w * _5992) * float(_g_rtx_material_data_.g_bModelTint1)))).xyz, _5998.w);
	    _1177 = _6032;
	    _1205 = _1176.xyz;
	    _1204 = _6032.xyz;
	    _1201 = _5983;
	    vec2 _6038 = _1203;
	    _6038.x = _1166;
	    _1203 = _6038;
	    _1202 = _5986;
	    _1316 = _1170;
	    _1197 = _1171;
	    float _1322 = _g_rtx_material_data_.g_flHeightMapZeroPoint2;
	    float _1323 = _g_rtx_material_data_.g_flHeightMapScale2;
	    vec2 _1324 = vec2(0.0);
	    float _1325 = 0.0;
	    float _1326 = 1.0;
	    if (_g_rtx_material_data_.g_flColorOverlay2 == 0.0)
	    {
	        _1314 = _g_rtx_material_data_.g_flColorReplace2 == 0.0;
	    }
	    else
	    {
	        _1314 = false;
	    }
	    if (_1314)
	    {
	        _1314 = _g_rtx_material_data_.g_flAOCombine2 == 0.0;
	    }
	    else
	    {
	        _1314 = false;
	    }
	    bool _1327;
	    if (_1314)
	    {
	        _1327 = _g_rtx_material_data_.g_flAOReplace2 == 0.0;
	    }
	    else
	    {
	        _1327 = false;
	    }
	    if (_g_rtx_material_data_.g_flNormalCombine2 == 0.0)
	    {
	        _1314 = _g_rtx_material_data_.g_flNormalReplace2 == 0.0;
	    }
	    else
	    {
	        _1314 = false;
	    }
	    if (_1314)
	    {
	        _1314 = _g_rtx_material_data_.g_flRoughnessCombine2 == 0.0;
	    }
	    else
	    {
	        _1314 = false;
	    }
	    bool _1328;
	    if (_1314)
	    {
	        _1328 = _g_rtx_material_data_.g_flRoughnessReplace2 == 0.0;
	    }
	    else
	    {
	        _1328 = false;
	    }
	    vec4 _1158 = vec4(0.0);
	    vec3 _1157 = vec3(0.0);
	    vec3 _1156 = vec3(0.0);
	    vec2 _1155 = vec2(0.0);
	    vec4 _1154 = vec4(0.0);
	    float _1153 = 0.0;
	    float _1152 = 0.0;
	    float _1151 = 0.0;
	    float _1150 = 0.0;
	    float _1149 = 0.0;
	    float _1148 = 0.0;
	    float _1147 = 0.0;
	    vec3 _6095 = _1156;
	    _6095.x = _1075.z;
	    _6095.y = _1075.w;
	    _1156 = _6095;
	    _1155 = _g_rtx_material_data_.g_vTexCoordScale2.xy;
	    vec2 _1248 = _1189;
	    vec2 _1247 = _1188;
	    vec2 _1246 = _1187;
	    vec2 _1245 = _1186;
	    vec2 _1244 = _1185;
	    vec2 _1243 = _1184;
	    vec2 _1242 = _1183;
	    vec4 _1284;
	    if (_g_rtx_material_data_.g_nUVSet2 == 0)
	    {
	        vec2 _6121 = _1248;
	        vec2 _6122 = _6121 * _1155;
	        _1248 = _6122;
	        vec2 _6123 = _1246;
	        vec2 _6124 = _6123 * _1155;
	        _1246 = _6124;
	        vec2 _6125 = _1245;
	        vec2 _6126 = _6125 * _1155;
	        _1245 = _6126;
	        vec2 _6127 = _1247;
	        vec2 _6128 = _6127 * _1155;
	        _1247 = _6128;
	        vec2 _6129 = _1244;
	        vec2 _6130 = _6129 * _1155;
	        _1244 = _6130;
	        vec2 _6131 = _1243;
	        vec2 _6132 = _6131 * _1155;
	        _1243 = _6132;
	        _1284 = (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _6122.xy, _6124.xy, _6126.xy) * _1242.x) + (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _6128.xy, _6130.xy, _6132.xy) * _1242.y);
	    }
	    else
	    {
	        _1284 = textureLod(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1156.xy, 0.0).xyzw;
	    }
	    _1150 = _1284.x;
	    _1148 = _1284.y;
	    _1149 = _1284.w;
	    _1151 = _1284.x;
	    SPIRV_CROSS_BRANCH
	    if (_g_rtx_material_data_.g_bWetnessUseHeightmapAdjustments)
	    {
	        _1151 = max(0.0, ((_1151 + 0.5) - _1322) * _1323);
	    }
	    float _6171 = _1322;
	    float _6172 = _6171 + (_1315 * 0.5);
	    _1322 = _6172;
	    float _6174 = _1323;
	    float _6175 = _6174 + _1317;
	    _1323 = _6175;
	    vec2 _6178 = _1324;
	    _6178.x = (-_6172) * _6175;
	    _6178.y = (1.0 - _6172) * _6175;
	    _1324 = _6178;
	    if (true)
	    {
	        float _6187 = _1323;
	        float _6188 = _6187 - (_1317 * 2.0);
	        _1323 = _6188;
	        if (_6188 == 0.0)
	        {
	            _1323 = 9.9999997473787516355514526367188e-05;
	        }
	    }
	    _1152 = (_1150 - _1322) * _1323;
	    vec3 _1146 = _1205;
	    float _1145 = _1197;
	    vec3 _1144 = _1195;
	    SPIRV_CROSS_BRANCH
	    if (_g_rtx_material_data_.bBlendByFacingDirection2)
	    {
	        _1313 *= saturate((((dot(_g_rtx_material_data_.g_vFacingDirection2.xyz, mix(_1144.xyz, _1146, vec3(_g_rtx_material_data_.g_vFacingDirectionMaskNormalMapStrength2)).xyz) - 1.0) + (_g_rtx_material_data_.g_flFacingDirectionMaskSpread2 * 2.0)) / (_g_rtx_material_data_.g_vFacingDirectionMaskSoftness2 * 2.0)) + 0.5);
	    }
	    float _6239 = _1152 + mix((_1321.x - _1324.y) - _1317, _1321.y - _1324.x, _1313);
	    _1326 = saturate((_6239 + _1322) - _1145);
	    float _6244 = max(_1145, _6239);
	    if (true)
	    {
	        vec3 _6274 = _1318;
	        _6274.x = _1145;
	        _6274.y = _6239;
	        _1318 = _6274;
	        vec2 _6282 = max((_6274.xy - vec2(_6244)) + vec2(_1317), vec2(0.0));
	        _6282.x = _6282.x + 9.9999997473787516355514526367188e-05;
	        _1325 = (_6282 / vec2(_6282.x + _6282.y)).y;
	    }
	    else
	    {
	        if (false)
	        {
	            vec3 _6250 = _1318;
	            _6250.z = _6239;
	            _1318 = _6250;
	            vec3 _6257 = max((_6250.xyz - vec3(_6244)) + vec3(_1317), vec3(0.0));
	            _6257.x = _6257.x + 9.9999997473787516355514526367188e-05;
	            vec3 _6272;
	            _6272.z = (_6257.xyz / vec3((_6257.x + _6257.y) + _6257.z)).z;
	            _1325 = _6272.z;
	        }
	    }
	    float _6292 = _1325;
	    float _6297 = saturate((_6292 * mix(0.5, _1150, _g_rtx_material_data_.g_flMaskWithHeight2)) * 2.0);
	    _1325 = _6297;
	    bool _6298 = _6297 > 0.0500000007450580596923828125;
	    SPIRV_CROSS_BRANCH
	    if (_6298)
	    {
	        vec3 _1143 = _1195;
	        vec3 _1142 = _1071;
	        vec3 _1141 = _1070;
	        vec3 _1140 = _1179;
	        vec3 _1139 = _1178;
	        vec2 _1259 = _1189;
	        vec2 _1258 = _1188;
	        vec2 _1257 = _1187;
	        vec2 _1256 = _1186;
	        vec2 _1255 = _1185;
	        vec2 _1254 = _1184;
	        vec2 _1253 = _1183;
	        ivec2 _1252 = _1182;
	        ivec2 _1251 = _1181;
	        if (_g_rtx_material_data_.g_nUVSet2 == 0)
	        {
	            _1259 *= _1155;
	            _1257 *= _1155;
	            _1256 *= _1155;
	            _1258 *= _1155;
	            _1255 *= _1155;
	            _1254 *= _1155;
	            _1157 = _1143;
	            bool _6427 = !_1327;
	            if (_6427)
	            {
	                _1158 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1259.xy, _1257.xy, _1256.xy) * _1253.x;
	            }
	            bool _6444 = !_1328;
	            if (_6444)
	            {
	                vec4 _6457 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1259.xy, _1257.xy, _1256.xy);
	                _1147 = _6457.z * _1253.x;
	                float _6462 = _6457.x;
	                float _6463 = _6457.y;
	                float _6465 = (_6462 + _6463) - 1.00392162799835205078125;
	                float _6466 = _6462 - _6463;
	                vec3 _6476 = normalize(vec3(vec2(_6465, _6466), (1.0 - abs(_6465)) - abs(_6466))).xyz * _1253.x;
	                vec4 _6478;
	                _6478.x = _6476.x;
	                _6478.y = _6476.y;
	                vec4 _6482 = _6478;
	                _6482.z = _6476.z;
	                _1157 = (_957[_1252.x] * _6478.x) + (_961[_1252.y] * _6478.y);
	            }
	            if (_1253.y > 0.0)
	            {
	                if (_6427)
	                {
	                    _1158 += (textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1258.xy, _1255.xy, _1254.xy) * _1253.y);
	                }
	                if (_6444)
	                {
	                    vec4 _6530 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1258.xy, _1255.xy, _1254.xy);
	                    _1147 += (_6530.z * _1253.y);
	                    float _6537 = _6530.x;
	                    float _6538 = _6530.y;
	                    float _6540 = (_6537 + _6538) - 1.00392162799835205078125;
	                    float _6541 = _6537 - _6538;
	                    vec3 _6551 = normalize(vec3(vec2(_6540, _6541), (1.0 - abs(_6540)) - abs(_6541))).xyz * _1253.y;
	                    vec4 _6553;
	                    _6553.x = _6551.x;
	                    _6553.y = _6551.y;
	                    vec4 _6557 = _6553;
	                    _6557.z = _6551.z;
	                    _1157 += ((_957[_1251.x] * _6553.x) + (_961[_1251.y] * _6553.y));
	                }
	            }
	            _1157 = normalize(_1157 + _1143);
	        }
	        else
	        {
	            if (!_1327)
	            {
	                _1158 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1156.xy, _1154.xy, _1154.zw).xyzw;
	            }
	            if (!_1328)
	            {
	                vec4 _6350 = textureGrad(nonuniformEXT(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal2], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig])), _1156.xy, _1154.xy, _1154.zw);
	                vec3 _6351 = _6350.xyz;
	                _1147 = _6350.z;
	                float _6353 = _6350.x;
	                float _6354 = _6350.y;
	                float _6356 = (_6353 + _6354) - 1.00392162799835205078125;
	                float _6357 = _6353 - _6354;
	                vec3 _6364 = normalize(vec3(vec2(_6356, _6357), (1.0 - abs(_6356)) - abs(_6357)));
	                _6351.x = _6364.x;
	                _6351.y = _6364.y;
	                _6351.z = _6364.z;
	                vec3 _6377 = _6351;
	                _6377.x = dot(_6351.xy, _g_rtx_material_data_.g_vNormalXform_2.xy);
	                _6377.y = dot(_6351.xy, _g_rtx_material_data_.g_vNormalXform_2.zw);
	                vec3 _1283 = _6377;
	                vec3 _1249;
	                vec3 _1250;
	                if (_g_rtx_material_data_.g_nUVSet2 > 1)
	                {
	                    _1250 = _1140;
	                    _1249 = _1139;
	                }
	                else
	                {
	                    _1250 = _1142;
	                    _1249 = _1141;
	                }
	                vec3 _6389 = abs(_1283.xyz);
	                vec2 _6402 = (-vec2(_1283.x, (-1.0) * _1283.y)) / vec2(max(_6389.z, 0.0078125 * max(_6389.x, _6389.y)));
	                _1157 = normalize(_1263 - ((_1250 * _6402.x) + (_1249 * _6402.y)));
	            }
	        }
	        _1153 = _1158.w;
	        vec3 _1138 = _1195;
	        if (!_1328)
	        {
	            _1157 = normalize(mix(_1138, _1157, vec3(_g_rtx_material_data_.g_fTextureNormalContrast2)));
	            _1147 = saturate(((_g_rtx_material_data_.g_fTextureRoughnessContrast2 * (_1147 - 0.5)) + 0.5) * _g_rtx_material_data_.g_fTextureRoughnessBrightness2);
	        }
	        vec4 _1137 = _1077;
	        vec4 _1278;
	        if (_g_rtx_material_data_.g_bAdjustBaseColor2)
	        {
	            _1278 = vec4((vec4(_1158.xyz, 1.0) * _g_rtx_material_data_.g_mTextureAdjust2).xyz, _1158.w);
	        }
	        else
	        {
	            _1278 = _1158;
	        }
	        vec4 _6623 = _1278;
	        _1153 = saturate(mix(_g_rtx_material_data_.g_vAmbientOcclusionLevels2.x, _g_rtx_material_data_.g_vAmbientOcclusionLevels2.z, pow(_1153, _g_rtx_material_data_.g_vAmbientOcclusionLevels2.y)));
	        _1149 *= float(_g_rtx_material_data_.g_bMetalness2);
	        float _6634 = _1148;
	        float _6639 = saturate(((_g_rtx_material_data_.g_fTintMaskContrast2 * (_6634 - 0.5)) + 0.5) * _g_rtx_material_data_.g_fTintMaskBrightness2);
	        _1148 = _6639;
	        vec3 _6643 = mix(_6623.xyz, vec4((vec4(_1158.xyz, 1.0) * _g_rtx_material_data_.g_mTextureColorAdjust2).xyz, _1046).xyz, vec3(_6639));
	        vec4 _6645 = _6623;
	        _6645.x = _6643.x;
	        _6645.y = _6643.y;
	        _6645.z = _6643.z;
	        float _6657 = dot(_6645.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        vec3 _6660 = normalize(max(_1137.xyz, vec3(0.001000000047497451305389404296875)));
	        _1158 = vec4(saturate(mix(_6645.xyz, (_6660 * min(_6657 / dot(_6660.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _6657) * max(_1137.x, max(_1137.y, _1137.z)))).xyz, vec3((_1137.w * _6639) * float(_g_rtx_material_data_.g_bModelTint2)))).xyz, _6645.w);
	    }
	    SPIRV_CROSS_BRANCH
	    if (_6298)
	    {
	        vec4 _1136 = _1158;
	        vec3 _1135 = _1157;
	        float _1134 = _1153;
	        float _1133 = _1152;
	        float _1132 = _1151;
	        float _1131 = _1149;
	        float _1130 = _1147;
	        if (!_1327)
	        {
	            vec3 _6710 = _1136.xyz * 12.9200000762939453125;
	            vec3 _6713 = (pow(_1136.xyz, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
	            float _1275;
	            if (_1136.x <= 0.003130800090730190277099609375)
	            {
	                _1275 = _6710.x;
	            }
	            else
	            {
	                _1275 = _6713.x;
	            }
	            float _1276;
	            if (_1136.y <= 0.003130800090730190277099609375)
	            {
	                _1276 = _6710.y;
	            }
	            else
	            {
	                _1276 = _6713.y;
	            }
	            float _1277;
	            if (_1136.z <= 0.003130800090730190277099609375)
	            {
	                _1277 = _6710.z;
	            }
	            else
	            {
	                _1277 = _6713.z;
	            }
	            _1204 = mix(_1204 * mix(vec3(1.0), vec3(_1275, _1276, _1277) * 2.0, vec3(_1325 * _g_rtx_material_data_.g_flColorOverlay2)), _1136.xyz, vec3(_1325 * _g_rtx_material_data_.g_flColorReplace2));
	            _1201 = mix(_1201 * mix(1.0, _1134, _1325 * _g_rtx_material_data_.g_flAOCombine2), _1134, _1325 * _g_rtx_material_data_.g_flAOReplace2);
	        }
	        if (!_1328)
	        {
	            _1205 = mix(mix(_1205, normalize(mix(_1195, (_1205 + _1135.xyz) * vec3(0.5), vec3(2.0))), vec3(_1325 * _g_rtx_material_data_.g_flNormalCombine2)), _1135.xyz, vec3((_1325 * _1326) * _g_rtx_material_data_.g_flNormalReplace2));
	            vec2 _6774 = _1203;
	            _6774.x = _6774.x * (1.0 + ((((_1130 - _6774.x) * 2.0) * _1325) * _g_rtx_material_data_.g_flRoughnessCombine2));
	            _6774.x = mix(_6774.x, _1130, _1325 * _g_rtx_material_data_.g_flRoughnessReplace2);
	            _1203 = _6774;
	        }
	        _1202 = mix(_1202 * mix(1.0, _1131 * 2.0, _1325 * _g_rtx_material_data_.g_flMetalnessCombine2), _1131, _1325 * _g_rtx_material_data_.g_flMetalnessReplace2);
	        _1316 = mix(_1316, _1132, _1325);
	        _1197 = mix(_1197, _1133, _1325);
	    }
	    float _6805 = saturate(1.0 - _1325);
	    _1204 *= mix(vec3(1.0), _1074.xyz, vec3(saturate(saturate(((float(!_g_rtx_material_data_.g_bMaskVertexColor1) * _6805) + (float(!_g_rtx_material_data_.g_bMaskVertexColor2) * _1325)) + ((_1167 * _6805) + (_1148 * _1325))) * ((float(_g_rtx_material_data_.g_bVertexColorEnabled1) * _6805) + (float(_g_rtx_material_data_.g_bVertexColorEnabled2) * _1325)))));
	    vec2 _6838 = _1203;
	    vec2 _6840 = _6838;
	    _6840.x = _6838.x;
	    _6840.y = _6838.x;
	    _1203 = _6840;
	    vec4 _1129 = _1078;
	    bool _1272;
	    if (_g_rtx_material_data_.g_bWetness)
	    {
	        _1272 = (_g_rtx_material_data_.g_fPuddleStrength + _g_rtx_material_data_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _1272 = false;
	    }
	    if (_1272)
	    {
	        _1272 = _1129.z > 0.0;
	    }
	    else
	    {
	        _1272 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_1272)
	    {
	        vec4 _1273 = vec4(0.0, 0.0, 1.0, 0.0);
	        float _6872 = pow(max(0.0, _1195.z), 32.0);
	        float _6878 = min(min(_1129.z, 1.0), 1.0);
	        float _6880 = saturate(_6878 - 0.75);
	        float _6883 = _6878 + (4.0 * (_6880 * _6880));
	        float _6893 = saturate(_6883 * 20.0);
	        float _1274;
	        SPIRV_CROSS_BRANCH
	        if (_g_rtx_material_data_.g_bPuddlesOnVerticalSurfaces)
	        {
	            vec4 _6910 = _1273;
	            _6910.x = _1195.x;
	            _6910.y = _1195.y;
	            _6910.z = _1195.z;
	            _1273 = _6910;
	            _1274 = max(0.0, _6883 - _g_rtx_material_data_.g_fWetEdgeSpread);
	        }
	        else
	        {
	            _1274 = max(0.0, (_6883 * _6872) - _g_rtx_material_data_.g_fWetEdgeSpread);
	        }
	        float _6918 = max(0.001000000047497451305389404296875, _g_rtx_material_data_.g_fPuddleBlendSoftness);
	        float _6926 = smoothstep(_1274 + _6918, _1274 - (_1129.w + (_6918 * 2.0)), _1316) * _6893;
	        float _6929 = max((smoothstep(_6878, (_6883 - _g_rtx_material_data_.g_fWetEdgeSpread) - (0.20000000298023223876953125 * _6883), _1316) * _g_rtx_material_data_.g_fWetEdgeStrength) * _6893, _6926) * _g_rtx_material_data_.g_fPuddleStrength;
	        float _6931 = (_6878 - 1.0) - _1316;
	        float _6937 = (saturate(_6931 + _g_rtx_material_data_.g_fPuddleSedimentHeight) * _g_rtx_material_data_.g_fPuddleSedimentOpacity) * _6926;
	        _1205 = mix(_1205, _1273.xyz, vec3(_6929 * _6937));
	        float _6957 = max(saturate(((saturate((((_6883 * 2.0) - (mix(0.5, 0.5, saturate(_6872 * 20.0)) * 0.5)) - (_1316 * 0.5)) + 0.25) * _g_rtx_material_data_.g_fWetnessStrength) * _6893) + _6926), _6929);
	        vec2 _6961 = _1203;
	        vec3 _6969 = mix(_1204, pow(_1204, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, saturate((pow(_1204, vec3(0.25)) * (_6957 * _6961.x)) * 8.0) * mix(_g_rtx_material_data_.g_flWetnessDarkeningStrength1, _g_rtx_material_data_.g_flWetnessDarkeningStrength2, _1325 * _g_rtx_material_data_.g_flColorReplace2));
	        _1204 = fma(mix((mix(_6969, _6969 * 0.5, vec3(saturate(_6926 * 1.5))) * mix(1.0, _1201, _6929)) * mix(1.0, 1.0 - _6931, _6937), _g_rtx_material_data_.g_vPuddleSedimentColor, vec3(_6937 * _6929)), vec3(1.0), vec3(0.0));
	        _1201 = mix(_1201, 1.0, _6929);
	        vec2 _6992 = saturate(mix(_6961.xx, vec2(_g_rtx_material_data_.g_fPuddleRoughness), vec2(_6957)));
	        vec2 _6994 = _6961;
	        _6994.x = _6992.x;
	        _6994.y = _6992.y;
	        _1203 = _6994;
	        _1199 = mix(_1199, 0.0350000001490116119384765625, _6957);
	    }
	    _1201 = max(_1201, 0.0);
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _1194;
	    payload.vInterpolatedNormalWs = _1195;
	    vec3 _1270[3] = vec3[](_1065, _1058, _1053);
	    vec3 _1271[3] = vec3[](_1064, _1057, _1052);
	    vec3 _7043 = ((_1270[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1270[1] * attrs.barycentrics.x)) + (_1270[2] * attrs.barycentrics.y);
	    vec3 _1264[3];
	    _1264[0] = _7043 - (_1271[0] * dot(_7043 - _1270[0], _1271[0]));
	    _1264[1] = _7043 - (_1271[1] * dot(_7043 - _1270[1], _1271[1]));
	    _1264[2] = _7043 - (_1271[2] * dot(_7043 - _1270[2], _1271[2]));
	    vec3 _7083 = ((_1264[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1264[1] * attrs.barycentrics.x)) + (_1264[2] * attrs.barycentrics.y);
	    vec3 _1265[3];
	    _1265[0] = cross(_1270[0] - _1270[1], _1194);
	    _1265[1] = cross(_1270[1] - _1270[2], _1194);
	    _1265[2] = cross(_1270[2] - _1270[0], _1194);
	    float _1266 = dot(_7083 - _7043, _1194);
	    vec3 _1267 = _7083;
	    int _1268 = 0;
	    for (;;)
	    {
	        bool _7099_ladder_break = false;
	        do
	        {
	            if (!(_1268 < 3))
	            {
	                _7099_ladder_break = true;
	                break;
	            }
	            if (_1266 > 0.00999999977648258209228515625)
	            {
	                _7099_ladder_break = true;
	                break;
	            }
	            if (dot(_1265[_1268], _1265[_1268]) == 0.0)
	            {
	                break;
	            }
	            _1265[_1268] = normalize(_1265[_1268]);
	            int _1269 = 0;
	            for (;;)
	            {
	                if (!(_1269 < 3))
	                {
	                    break;
	                }
	                vec3 _7137 = _1271[_1269] - (_1265[_1268] * dot(_1265[_1268], _1271[_1269]));
	                _1264[_1269] = _7043 - (_7137 * dot(_7043 - _1270[_1269], _7137));
	                _1269++;
	                continue;
	            }
	            vec3 _7161 = ((_1264[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_1264[1] * attrs.barycentrics.x)) + (_1264[2] * attrs.barycentrics.y);
	            _1266 = dot(_7161 - _7043, _1194);
	            _1267 = _7161;
	            break;
	        } while(false);
	        if (_7099_ladder_break)
	        {
	            break;
	        }
	        _1268++;
	        continue;
	    }
	    if (!(_1266 > 0.00999999977648258209228515625))
	    {
	        _1267 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _1267;
	    payload.bFlippedNormal = _1193;
	    f16vec3 _7174 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_7174, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _7174, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(_1205);
	    payload.material.vAlbedo = f16vec3(_1204);
	    payload.material.vEmissive = f16vec3(_1200);
	    payload.material.flReflectance = float16_t(_1199);
	    payload.material.flMetalness = float16_t(_1202);
	    payload.material.flRoughness = float16_t(dot(_1203, vec2(0.5)));
	    if (any(greaterThan(_1198, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _7200 = f16vec3(_1198);
	        payload.material.vMaterialBits.x = _7200.x;
	        payload.material.vMaterialBits.y = _7200.y;
	        payload.material.vMaterialBits.z = _7200.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	IntAttribute(TexCoord2ScaleByModelU, g_nScaleTexCoord2UByModelScaleAxis-1);
	IntAttribute(TexCoord2ScaleByModelV, g_nScaleTexCoord2VByModelScaleAxis-1);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(VertexpaintUIPuddles, (F_WETNESS==1) ? 1 : 0);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	BoolAttribute(SupportsMaterialLayerSampling, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS ? 1 : 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES ? 1 : 0);
	FloatAttribute(_dummyMakeVisiblePropMaskBias1, g_flDetailPropMaskBias1);
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction1, g_flDetailPropPuddleReduction1);
	FloatAttribute(_dummyMakeVisiblePropMaskBias2, g_flDetailPropMaskBias2);
	FloatAttribute(_dummyMakeVisiblePropMaskSoftness2, g_flDetailPropMaskSoftness2);
	FloatAttribute(_dummyMakeVisiblePropPuddleReduction2, g_flDetailPropPuddleReduction2);
	
	#if (S_BLEND_EFFECTS_3 == 1)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_SHARED_COLOR_OVERLAY == 1)
		BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nUVSet3>0 && (g_vTexCoordScale3.x!=1 || g_vTexCoordScale3.y!=1 || g_flTexCoordRotation3!=0) || g_nColorOverlayUVSet>0 && (g_vOverlayTexCoordScale.x!=1 || g_vOverlayTexCoordScale.y!=1 || g_flOverlayTexCoordRotation!=0)) ? 1 : 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_BLEND_EFFECTS_3 == 0)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ENABLE_LAYER_3 == 0)
		BoolAttribute(VertexPaintUI2Layer, true);
		BoolAttribute(VertexPaintUI3Layer, false);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_DETAIL_NORMAL == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 1)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS ? 1 : 0);
	#endif
	#if (S_ENABLE_LAYER_3 == 1)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_SHARED_COLOR_OVERLAY == 0)
		BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nUVSet3>0 && (g_vTexCoordScale3.x!=1 || g_vTexCoordScale3.y!=1 || g_flTexCoordRotation3!=0)) ? 1 : 0);
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	#if (S_PIXEL_DEPTH_OFFSET == 0)
		BoolAttribute(VertexPaintUI2Layer, false);
		BoolAttribute(VertexPaintUI3Layer, true);
		FloatAttribute(_dummyMakeVisiblePropMaskBias3, g_flDetailPropMaskBias3);
		FloatAttribute(_dummyMakeVisiblePropMaskSoftness3, g_flDetailPropMaskSoftness3);
		FloatAttribute(_dummyMakeVisiblePropPuddleReduction3, g_flDetailPropPuddleReduction3);
	#endif
	
	// Variant Attributes
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0)) ? 1 : 0);
	BoolAttribute(HasTexcoordTransform, (g_nUVSet1>0 && (g_vTexCoordScale1.x!=1 || g_vTexCoordScale1.y!=1 || g_flTexCoordRotation1!=0) || g_nUVSet2>0 && (g_vTexCoordScale2.x!=1 || g_vTexCoordScale2.y!=1 || g_flTexCoordRotation2!=0) || g_nColorOverlayUVSet>0 && (g_vOverlayTexCoordScale.x!=1 || g_vOverlayTexCoordScale.y!=1 || g_flOverlayTexCoordRotation!=0)) ? 1 : 0);
}
