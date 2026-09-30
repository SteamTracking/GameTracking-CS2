//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "customweapon texture compositing shader.";
	DevShader = false;
	Version = 7;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
}

FEATURES
{
	Feature( F_ROUGHNESS_MODE, 0..1, "Composite Mode" );
	Feature( F_OVERRIDE_NORMAL, 0..1, "Style" );
	Feature( F_USE_ALL_MASKS, 0..1, "Style" );
	Feature( F_ROUGHNESS_TEXTURE, 0..1, "Style" );
	Feature( F_PEARLESCENCE_MASK, 0..1, "Style" );
	Feature( F_ROUGHNESS_PER_COLOR, 0..1, "Style" );
	Feature( F_METALNESS_TEXTURE, 0..1, "Style" );
	Feature( F_PAINT_STYLE, 0..8 (0="Solid", 1="Hydrographic", 2="Spraypaint", 3="Anodized", 4="Anodized Multicolored", 5="Anodized Airbrushed", 6="Custom Texture", 7="Patina / Antiqued", 8="Gunsmith"), "Style" );
	Feature( F_OVERLAY_TEXTURE, 0..1, "Overlay" );
	Feature( F_OVERLAY_BLEND_MODE, 0..4 (0="Normal", 1="Color", 2="Multiply", 3="Add", 4="Layer"), "Overlay" );
	Feature( F_OVERLAY_MASK, 0..8 (0="None", 1="Paint Mask 0", 2="Paint Mask R", 3="Paint Mask G", 4="Paint Mask B", 5="Paint Mask RGB", 6="Paint", 7="Pattern", 8="Dedicated"), "Overlay" );
	Feature( F_SEPARATE_CHANNEL_INPUTS, 0..1 (0="Pre-packed Source1 Input", 1="Separate Channels"), "Composite Mode" );
	Feature( F_SPRAYPAINT_HALFTONE, 0..1, "Style" );
	Feature( F_CASE_HARDENING, 0..1, "Style" );
	Feature( F_CASE_HARDENING_TRILINEAR, 0..1, "Style" );
	Feature( F_PATINA_AGE, 0..1, "Style" );
	FeatureRule( Allow1( F_ROUGHNESS_TEXTURE, F_ROUGHNESS_PER_COLOR ), "Roughness Texture and Roughness Per Color are not compatible" );
	FeatureRule( Requires( F_USE_ALL_MASKS, F_PAINT_STYLE==2 ), "Use all masks requires Spraypaint style" );
	FeatureRule( Requires( F_ROUGHNESS_PER_COLOR, F_PAINT_STYLE==0, F_PAINT_STYLE==1, F_PAINT_STYLE==2 ), "Roughness Per Color requires paint style of Solid, Hydrographic or Spraypaint" );
	FeatureRule( Requires( F_OVERLAY_BLEND_MODE, F_OVERLAY_TEXTURE ), "Overlay Blend Mode requires Overlay Texture" );
	FeatureRule( Requires( F_OVERLAY_MASK==1, F_PAINT_STYLE==0, F_PAINT_STYLE==1, F_PAINT_STYLE==2, F_PAINT_STYLE==3, F_PAINT_STYLE==4, F_PAINT_STYLE==5 ), "Overlay Texture requires paint style of Solid, Hydrographic, Spraypaint, Anodized, Anodized Multicolored, or Anodized Airbrushed" );
	FeatureRule( Requires( F_OVERLAY_MASK==2, F_PAINT_STYLE==0, F_PAINT_STYLE==1, F_PAINT_STYLE==2, F_PAINT_STYLE==3, F_PAINT_STYLE==4, F_PAINT_STYLE==5 ), "Overlay Texture requires paint style of Solid, Hydrographic, Spraypaint, Anodized, Anodized Multicolored, or Anodized Airbrushed" );
	FeatureRule( Requires( F_OVERLAY_MASK==3, F_PAINT_STYLE==0, F_PAINT_STYLE==1, F_PAINT_STYLE==2, F_PAINT_STYLE==3, F_PAINT_STYLE==4, F_PAINT_STYLE==5 ), "Overlay Texture requires paint style of Solid, Hydrographic, Spraypaint, Anodized, Anodized Multicolored, or Anodized Airbrushed" );
	FeatureRule( Requires( F_OVERLAY_MASK==4, F_PAINT_STYLE==0, F_PAINT_STYLE==1, F_PAINT_STYLE==2, F_PAINT_STYLE==3, F_PAINT_STYLE==4, F_PAINT_STYLE==5 ), "Overlay Texture requires paint style of Solid, Hydrographic, Spraypaint, Anodized, Anodized Multicolored, or Anodized Airbrushed" );
	FeatureRule( Requires( F_OVERLAY_MASK==5, F_PAINT_STYLE==0, F_PAINT_STYLE==1, F_PAINT_STYLE==2, F_PAINT_STYLE==3, F_PAINT_STYLE==4, F_PAINT_STYLE==5 ), "Overlay Texture requires paint style of Solid, Hydrographic, Spraypaint, Anodized, Anodized Multicolored, or Anodized Airbrushed" );
	FeatureRule( Requires( F_OVERLAY_MASK==6, F_PAINT_STYLE==0, F_PAINT_STYLE==1, F_PAINT_STYLE==2, F_PAINT_STYLE==3, F_PAINT_STYLE==4, F_PAINT_STYLE==5 ), "Overlay Texture requires paint style of Solid, Hydrographic, Spraypaint, Anodized, Anodized Multicolored, or Anodized Airbrushed" );
	FeatureRule( Requires( F_OVERLAY_MASK==7, F_PAINT_STYLE==1, F_PAINT_STYLE==2, F_PAINT_STYLE==4, F_PAINT_STYLE==5 ), "Overlay Texture requires paint style of Hydrographic, Spraypaint, Anodized Multicolored, or Anodized Airbrushed" );
	FeatureRule( Requires( F_OVERLAY_MASK==8, F_PAINT_STYLE==6, F_PAINT_STYLE==7, F_PAINT_STYLE==8 ), "Overlay Texture requires paint style of Custom Texture, Patina / Antiqued, or Gunsmith" );
	FeatureRule( Requires( F_SPRAYPAINT_HALFTONE, F_PAINT_STYLE==2, F_PAINT_STYLE==5 ), "Spraypaint Halftone requires Spraypaint style" );
	FeatureRule( Requires( F_CASE_HARDENING, F_PAINT_STYLE==0, F_PAINT_STYLE==7, F_PAINT_STYLE==8 ), "Case Hardening requires Patina / Antiqued, Gunsmith or Solid" );
	FeatureRule( Requires( F_CASE_HARDENING_TRILINEAR, F_CASE_HARDENING ), "Case Hardening Trilinear requires Case Hardening" );
	FeatureRule( Allow1( F_PATINA_AGE, F_CASE_HARDENING ), "Patina Age and Case Hardening are not compatible" );
	FeatureRule( Requires( F_PATINA_AGE, F_PAINT_STYLE==7, F_PAINT_STYLE==8 ), "Patina Age requires Patina / Antiqued or Gunsmith" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor      : COLOR0     < Semantic( Color ); >;                                       
	float3 vPositionSs : POSITION0  < Semantic( PosXyz ); >;                                      
	float2 vTexCoord   : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                              
};

VS
{
	StaticCombo( S_PAINT_STYLE, F_PAINT_STYLE );
	StaticCombo( S_OVERLAY_TEXTURE, F_OVERLAY_TEXTURE );
	
	// Paint Inputs
	bool g_bIgnoreWeaponSizeScale < UiType(CheckBox); UiGroup("Paint Inputs/Options,0/10"); >;
	float g_flGrungeTexCoordScale < Default(1); Range(0.001, 16); UiType(Slider); UiGroup("Paint Inputs/Grunge,30/11"); >;
	float g_flOverlayTexCoordScale < Default(1); Range(0.001, 16); UiType(Slider); UiGroup("Paint Inputs/Overlay,11/11"); UiVisibility(F_OVERLAY_TEXTURE); >;
	float g_flWearTexCoordScale < Default(1); Range(0.001, 16); UiType(Slider); UiGroup("Paint Inputs/Wear,20/11"); >;
	float g_flGrungeTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Paint Inputs/Grunge,30/12"); >;
	float g_flOverlayTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Paint Inputs/Overlay/12"); UiVisibility(F_OVERLAY_TEXTURE); >;
	float g_flWearTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Paint Inputs/Wear,20/12"); >;
	float2 g_vGrungeTexCoordOffset < Range2(-4, -4, 4, 4); UiType(VectorText); UiGroup("Paint Inputs/Grunge,30/13"); >;
	float2 g_vOverlayTexCoordOffset < Range2(-4, -4, 4, 4); UiType(VectorText); UiGroup("Paint Inputs/Overlay/13"); UiVisibility(F_OVERLAY_TEXTURE); >;
	float2 g_vWearTexCoordOffset < Range2(-4, -4, 4, 4); UiType(VectorText); UiGroup("Paint Inputs/Wear,20/13"); >;
	float g_flPatternTexCoordScale < Default(1); Range(0.001, 64); UiType(Slider); UiGroup("Paint Inputs/Pattern,10/15"); >;
	bool g_bOverlayUsesPatternUVs < UiType(CheckBox); UiGroup("Paint Inputs/Overlay/16"); Expression(this || g_bOverlayUsesUniqueUVs); UiVisibility(F_OVERLAY_TEXTURE); >;
	float g_flPatternTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Paint Inputs/Pattern,10/16"); >;
	bool g_bOverlayUsesUniqueUVs < UiType(CheckBox); UiGroup("Paint Inputs/Overlay/17"); UiVisibility(F_OVERLAY_TEXTURE); >;
	float2 g_vPatternTexCoordOffset < Range2(-4, -4, 4, 4); UiType(VectorText); UiGroup("Paint Inputs/Pattern,10/17"); >;
	
	// Composite Inputs
	float g_flWeaponLength1 < Default(36); Range(0, 64); UiType(Slider); UiGroup("Composite Inputs/Metadata Inputs,10/10"); >;
	float g_flUvScale1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Composite Inputs/Metadata Inputs,10/20"); >;
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4 g_vGrungeTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flGrungeTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flGrungeTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vGrungeTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vGrungeTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flGrungeTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flGrungeTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vGrungeTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vGrungeTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flGrungeTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flGrungeTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vGrungeTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vGrungeTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flGrungeTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flGrungeTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vGrungeTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vOverlayTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flOverlayTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flOverlayTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vOverlayTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vOverlayTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flOverlayTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flOverlayTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vOverlayTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vOverlayTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flOverlayTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flOverlayTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vOverlayTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vOverlayTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flOverlayTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flOverlayTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vOverlayTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vViewport < Source(Viewport); UiType(VectorText); >;
	float4 g_vWearTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flWearTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flWearTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vWearTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vWearTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flWearTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flWearTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vWearTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vWearTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flWearTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flWearTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vWearTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vWearTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flWearTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flWearTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vWearTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	
	
	// Variant parameters
	float4 g_vGrungeTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flGrungeTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flGrungeTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vGrungeTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vGrungeTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flGrungeTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flGrungeTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vGrungeTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vGrungeTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flGrungeTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flGrungeTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vGrungeTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vGrungeTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flGrungeTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flGrungeTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vGrungeTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vOverlayTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flOverlayTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flOverlayTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vOverlayTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vOverlayTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flOverlayTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flOverlayTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vOverlayTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vOverlayTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flOverlayTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flOverlayTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vOverlayTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vOverlayTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flOverlayTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flOverlayTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vOverlayTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vWearTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flWearTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flWearTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vWearTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vWearTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flWearTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flWearTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vWearTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vWearTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flWearTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flWearTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vWearTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vWearTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flWearTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flWearTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vWearTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vPatternTexCoordXform0) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	float _3;
	
	struct _2303
	{
	    vec4 g_vPatternTexCoordXform0;
	    vec4 g_vPatternTexCoordXform1;
	    vec4 g_vWearTexCoordXform0;
	    vec4 g_vWearTexCoordXform1;
	    vec4 g_vGrungeTexCoordXform0;
	    vec4 g_vGrungeTexCoordXform1;
	    int g_bOverlayUsesUniqueUVs;
	    int g_bOverlayUsesPatternUVs;
	    vec4 g_vOverlayTexCoordXform0;
	    vec4 g_vOverlayTexCoordXform1;
	    vec4 g_vViewport;
	};
	
	layout(set = 0) uniform _2303 _Globals_;
	
	layout(location = 0) in vec2 vPositionSs;
	layout(location = 1) in vec4 vColor;
	layout(location = 2) in vec2 vTexCoord;
	layout(location = 0) out vec4 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) out vec2 output_3;
	
	void main()
	{
	    vec2 _15639 = (((vPositionSs.xy - _Globals_.g_vViewport.xy) * 2.0) / _Globals_.g_vViewport.zw) - vec2(1.0);
	    vec4 _14779 = vec4(_15639.x, _3, 1.0, 1.0);
	    vec3 _24030 = vColor.xyz * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((vColor.xyz * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (vColor.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _24030.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (vColor.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _24030.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (vColor.z <= 0.040449999272823333740234375)
	    {
	        _19302 = _24030.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    float _24844 = dot(vTexCoord.xy, _Globals_.g_vPatternTexCoordXform0.xy) + _Globals_.g_vPatternTexCoordXform0.w;
	    float _22325 = dot(vTexCoord.xy, _Globals_.g_vPatternTexCoordXform1.xy) + _Globals_.g_vPatternTexCoordXform1.w;
	    vec2 _22247;
	    if (_Globals_.g_bOverlayUsesPatternUVs != 0)
	    {
	        vec2 _12501;
	        if (_Globals_.g_bOverlayUsesUniqueUVs != 0)
	        {
	            _12501 = vec2(dot(vTexCoord.xy, _Globals_.g_vOverlayTexCoordXform0.xy) + _Globals_.g_vOverlayTexCoordXform0.w, dot(vTexCoord.xy, _Globals_.g_vOverlayTexCoordXform1.xy) + _Globals_.g_vOverlayTexCoordXform1.w);
	        }
	        else
	        {
	            _12501 = vec2(_24844, _22325);
	        }
	        _22247 = _12501;
	    }
	    else
	    {
	        _22247 = vTexCoord;
	    }
	    output_0 = vec4(_21354, _21355, _19302, vColor.w);
	    output_1 = vec4(vTexCoord, _24844, _22325);
	    output_2 = vec4(dot(vTexCoord.xy, _Globals_.g_vWearTexCoordXform0.xy) + _Globals_.g_vWearTexCoordXform0.w, dot(vTexCoord.xy, _Globals_.g_vWearTexCoordXform1.xy) + _Globals_.g_vWearTexCoordXform1.w, dot(vTexCoord.xy, _Globals_.g_vGrungeTexCoordXform0.xy) + _Globals_.g_vGrungeTexCoordXform0.w, dot(vTexCoord.xy, _Globals_.g_vGrungeTexCoordXform1.xy) + _Globals_.g_vGrungeTexCoordXform1.w);
	    output_3 = _22247;
	    _14779.y = _15639.y;
	    gl_Position = _14779;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	IntAttribute(MaterialLayerCount, 1);
	StringAttribute(MaterialLayerRefType, csgo_composite_inputs);
	BoolAttribute(ui, true);
	BoolAttribute(ScreenSpaceVertices, true);
	
}

PS
{
	StaticCombo( S_PAINT_STYLE, F_PAINT_STYLE );
	StaticCombo( S_OVERRIDE_NORMAL, F_OVERRIDE_NORMAL );
	StaticCombo( S_USE_ALL_MASKS, F_USE_ALL_MASKS );
	StaticCombo( S_ROUGHNESS_TEXTURE, F_ROUGHNESS_TEXTURE );
	StaticCombo( S_PEARLESCENCE_MASK, F_PEARLESCENCE_MASK );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_SEPARATE_CHANNEL_INPUTS, F_SEPARATE_CHANNEL_INPUTS );
	StaticCombo( S_OVERLAY_TEXTURE, F_OVERLAY_TEXTURE );
	StaticCombo( S_CASE_HARDENING, F_CASE_HARDENING );
	StaticCombo( S_CASE_HARDENING_TRILINEAR, F_CASE_HARDENING_TRILINEAR );
	StaticCombo( S_PATINA_AGE, F_PATINA_AGE );
	StaticComboRule( Requires( S_USE_ALL_MASKS, S_PAINT_STYLE==2 ) );
	StaticComboRule( Requires( S_CASE_HARDENING, S_PAINT_STYLE==0, S_PAINT_STYLE==7, S_PAINT_STYLE==8 ) );
	StaticComboRule( Requires( S_CASE_HARDENING_TRILINEAR, S_CASE_HARDENING ) );
	StaticComboRule( Allow1( S_PATINA_AGE, S_CASE_HARDENING ) );
	StaticComboRule( Requires( S_PATINA_AGE, S_PAINT_STYLE==7, S_PAINT_STYLE==8 ) );
	
	bool bRoughnessMode < UiType(CheckBox); Expression(F_ROUGHNESS_MODE); >;
	bool bSpraypaintHalftone < UiType(CheckBox); Expression(F_SPRAYPAINT_HALFTONE); >;
	bool g_bRoughnessPerColor < UiType(CheckBox); Expression(F_ROUGHNESS_PER_COLOR); >;
	float g_fColorBoostFactor < UiType(Slider); Expression(64-1); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tAmbientOcclusion < Channel(RGBA, None(TextureAmbientOcclusion1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tAmbientOcclusion < Channel(R, None(TextureCavity1), Srgb); Channel(G, None(TextureAmbientOcclusion1), Srgb); Channel(A, None(TextureNoPaint1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tCaseHardeningColorRamp < Channel(RGBA, None(TextureCaseHardeningColorRamp), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGBA, ArtistDefined(TextureColor1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tGlitterNormal < Channel(RG, None(TextureGlitterNormal), Linear); Channel(A, None(TextureGlitterMask), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture2D g_tGrunge < Channel(RGBA, None(TextureGrunge), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tMasks < Channel(RGB, None(TextureMasks1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tOverlay < Channel(RGBA, None(TextureOverlay), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tOverlayMask < Channel(R, None(TextureOverlayMask), Srgb); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tPaintMetalness < Channel(R, None(TexturePaintMetalness), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tPaintRoughness < Channel(R, None(TexturePaintRoughness), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tPatinaAgeColorRamp < Channel(RGBA, None(TexturePatinaAgeColorRamp), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tPatinaAgeMask < Channel(R, None(TexturePatinaAgeMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tPattern < Channel(RGBA, None(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tPattern < Channel(RGBA, None(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tPearlescenceMask < Channel(R, None(TexturePearlescenceMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tPosition < Channel(RGBA, None(TexturePosition1), Linear); OutputFormat(RGBA16161616F); SrgbRead(false); >;
	Texture2D g_tSurface < Channel(RGB, None(TextureSurface1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tWear < Channel(R, None(TextureWear), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	float3 g_vAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.045,.4,1.15).x,-1.4427*log(max(.0001,1-float3(-.045,.4,1.15).y)),2-float3(-.045,.4,1.15).z)); >;
	float3 g_vDarkMetallicAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.1,.4,1.08).x,-1.4427*log(max(.0001,1-float3(-.1,.4,1.08).y)),2-float3(-.1,.4,1.08).z)); >;
	float3 g_vMetallicAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.45,.4,1.08).x,-1.4427*log(max(.0001,1-float3(-.45,.4,1.08).y)),2-float3(-.45,.4,1.08).z)); >;
	float3 g_vMetallicPaintAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.08,.6,1).x,-1.4427*log(max(.0001,1-float3(-.08,.6,1).y)),2-float3(-.08,.6,1).z)); >;
	float3 g_vPaintAlbedoLevels < UiType(VectorText); Expression(float3(-float3(-.045,.6,1).x,-1.4427*log(max(.0001,1-float3(-.045,.6,1).y)),2-float3(-.045,.6,1).z)); >;
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneA0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneA0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneA1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneA1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneB0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneB0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneB1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneB1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneC0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneC0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneC1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneC1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	float3 g_vSprayBiasBlend < UiType(VectorText); Expression(float3(g_bBiasSpray ? 1 : 0,g_vSprayBlend.x,g_vSprayBlend.y)); >;
	int nOverlayBlendMode < UiType(Slider); Expression(F_OVERLAY_BLEND_MODE); >;
	int nOverlayMaskMode < UiType(Slider); Expression(F_OVERLAY_MASK); >;
	
	// Composite Inputs
	CreateInputTexture2D(TextureAmbientOcclusion1, Srgb, 8, "", "_ao", "Composite Inputs/Texture Inputs,0/10", Default4(1, 1, 1, 1));
	float g_flWeaponLength1 < Default(36); Range(0, 64); UiType(Slider); UiGroup("Composite Inputs/Metadata Inputs,10/10"); >;
	CreateInputTexture2D(TextureCavity1, Srgb, 8, "", "_cavity", "Composite Inputs/Texture Inputs,0/11", Default4(0.5, 0.5, 0.5, 1));
	CreateInputTexture2D(TextureNoPaint1, Srgb, 8, "", "_nopaint", "Composite Inputs/Texture Inputs,0/13", Default4(0, 0, 0, 1));
	CreateInputTexture2D(TextureMasks1, Linear, 8, "", "_masks", "Composite Inputs/Texture Inputs,0/20", Default4(1, 1, 1, 1));
	float g_flUvScale1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Composite Inputs/Metadata Inputs,10/20"); >;
	CreateInputTexture2D(TextureSurface1, Linear, 8, "", "_surface", "Composite Inputs/Texture Inputs,0/30", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TexturePosition1, Linear, 16, "", "_pos", "Composite Inputs/Texture Inputs,0/40", Default4(1, 1, 1, 1));
	
	// Paint Inputs
	CreateInputTexture2D(TextureGlitterMask, Linear, 8, "", "_mask", "Paint Inputs/Glitter", "materials/default/stickers/squares_glitter_mask.tga");
	float g_flPaintRoughness < Default(0.6); UiType(Slider); UiGroup("Paint Inputs/Lighting/0"); UiVisibility(!F_ROUGHNESS_PER_COLOR); >;
	float g_flPaintRoughness < Default(0.2); UiType(Slider); UiGroup("Paint Inputs/Lighting/0"); UiVisibility(!F_ROUGHNESS_PER_COLOR); >;
	float4 g_vPaintRoughness < Default4(0.6, 0.6, 0.6, 0.6); UiType(VectorText); UiGroup("Paint Inputs/Lighting/0"); UiVisibility(F_ROUGHNESS_PER_COLOR); >;
	CreateInputTexture2D(TextureOverlay, Srgb, 8, "", "", "Paint Inputs/Overlay/1", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TexturePaintRoughness, Linear, 8, "", "_rough", "Paint Inputs/Lighting/1", Default4(0.5, 0.5, 0.5, 0));
	float g_fOverlayRoughness < UiType(Slider); UiGroup("Paint Inputs/Lighting/1"); >;
	CreateInputTexture2D(TextureOverlayMask, Srgb, 8, "", "_mask", "Paint Inputs/Overlay/2", Default4(1, 1, 1, 1));
	bool g_bRoughnessUsesPatternUVs < Default(1); UiType(CheckBox); UiGroup("Paint Inputs/Lighting/2"); >;
	CreateInputTexture2D(TextureGrunge, Srgb, 8, "", "_grunge", "Paint Inputs/Grunge,30/10", "materials/models/weapons/customization/shared/gun_grunge.psd");
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Paint Inputs/Normal,15/10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TexturePattern, Linear, 8, "", "", "Paint Inputs/Pattern,10/10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureWear, Linear, 8, "", "_wear", "Paint Inputs/Wear,20/10", "materials/models/weapons/customization/shared/paint_wear.psd");
	bool g_bIgnoreWeaponSizeScale < UiType(CheckBox); UiGroup("Paint Inputs/Options,0/10"); >;
	float g_flPearlescentScale < Range(-120, 120); UiType(Slider); UiGroup("Paint Inputs/Lighting,60/10"); >;
	float3 g_vColor0 < Default3(0.5, 0.5, 0.5); UiType(Color); UiGroup("Paint Inputs/Colors,0/10"); Expression(SrgbGammaToLinear(this)); >;
	bool g_bPearlescentOnMetallicOnly < UiType(CheckBox); UiGroup("Paint Inputs/Lighting/11"); >;
	float g_fWearSoftness < UiType(Slider); UiGroup("Paint Inputs/Wear/11"); >;
	CreateInputTexture2D(TexturePearlescenceMask, Linear, 8, "", "_mask", "Paint Inputs/Lighting/12", Default4(1, 1, 1, 0));
	bool g_bPearlescenceMaskUsesPatternUVs < Default(1); UiType(CheckBox); UiGroup("Paint Inputs/Lighting/13"); >;
	float g_fOverlayPearlescentMask < UiType(Slider); UiGroup("Paint Inputs/Lighting/13"); >;
	int g_nPatternTextureHorizontalSampling < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Paint Inputs/Pattern,10/13"); >;
	int g_nPatternTextureVerticalSampling < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Paint Inputs/Pattern,10/13"); >;
	CreateInputTexture2D(TexturePaintMetalness, Linear, 8, "", "_mask", "Paint Inputs/Lighting/14", Default4(0, 0, 0, 0));
	bool g_bMetalnessUsesPatternUVs < UiType(CheckBox); UiGroup("Paint Inputs/Lighting/15"); >;
	float g_flPatternTexCoordScale < Default(1); Range(0.001, 64); UiType(Slider); UiGroup("Paint Inputs/Pattern,10/15"); >;
	float g_flPatternTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Paint Inputs/Pattern,10/16"); >;
	float2 g_vPatternTexCoordOffset < Range2(-4, -4, 4, 4); UiType(VectorText); UiGroup("Paint Inputs/Pattern,10/17"); >;
	CreateInputTexture2D(TextureCaseHardeningColorRamp, Srgb, 8, "", "_color", "Paint Inputs/Pattern/18", Default4(1, 1, 1, 1));
	float2 g_vSprayBlend < Default2(1, 1); UiType(VectorText); UiGroup("Paint Inputs/Pattern,10/18"); >;
	bool g_bBiasSpray < UiType(CheckBox); UiGroup("Paint Inputs/Pattern,10/19"); >;
	float g_fHalftoneCavityCutoff < Default(1); UiType(Slider); UiGroup("Paint Inputs/Pattern/20"); >;
	float g_flCaseHardeningPatternInfluence < Default(0.5); UiType(Slider); UiGroup("Paint Inputs/Pattern/20"); >;
	float g_flPaintMetalness < UiType(Slider); UiGroup("Paint Inputs/Lighting/20"); >;
	float3 g_vColor1 < Default3(0.59, 0.59, 0.59); UiType(Color); UiGroup("Paint Inputs/Colors,0/20"); Expression(SrgbGammaToLinear(this)); >;
	bool g_bHalftoneInCavity < Default(1); UiType(CheckBox); UiGroup("Paint Inputs/Pattern/21"); >;
	float g_flCaseHardeningGeometricInfluence < Default(1); UiType(Slider); UiGroup("Paint Inputs/Pattern/21"); >;
	float4 g_vPaintMetalness < UiType(VectorText); UiGroup("Paint Inputs/Lighting/21"); >;
	float g_fOverlayMetalness < UiType(Slider); UiGroup("Paint Inputs/Lighting/22"); >;
	float g_fOverlayStrength < Default(1); UiType(Slider); UiGroup("Paint Inputs/Overlay/22"); >;
	float g_flCaseHardeningRampOffset < UiType(Slider); UiGroup("Paint Inputs/Pattern/22"); >;
	float3 g_vHalftonePatternLevels < Default2(0, 0.5); Range2(-10, 0, 10, 1); UiType(VectorText); UiGroup("Paint Inputs/Pattern/22"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	float g_fOverlayMaterialStrength < Default(1); UiType(Slider); UiGroup("Paint Inputs/Overlay/23"); >;
	float4 g_vCaseHardening < Default(0); UiType(VectorText); UiGroup("Paint Inputs/Pattern/23"); >;
	float2 g_vHalftoneThresholds < Default(0); UiType(VectorText); UiGroup("Paint Inputs/Pattern/23"); >;
	float g_fOverlayBrightness < Default(1); Range(0, 2); UiType(Slider); UiGroup("Paint Inputs/Overlay/24"); >;
	float g_flHalftoneRotationOffsetA < Range(-360, 360); UiType(Slider); UiGroup("Paint Inputs/Pattern/24"); >;
	float g_fOverlayDurability < UiType(Slider); UiGroup("Paint Inputs/Overlay/25"); Expression(1-this); >;
	float g_flHalftoneRotationOffsetB < Default(4); Range(-360, 360); UiType(Slider); UiGroup("Paint Inputs/Pattern/25"); >;
	float g_flHalftoneRotationOffsetC < Default(-4); Range(-360, 360); UiType(Slider); UiGroup("Paint Inputs/Pattern/26"); >;
	CreateInputTexture2D(TexturePatinaAgeColorRamp, Srgb, 8, "", "_color", "Paint Inputs/Pattern/30", "materials/default/default_tint_color.tga");
	float3 g_vColor2 < Default3(0.38, 0.38, 0.38); UiType(Color); UiGroup("Paint Inputs/Colors,0/30"); Expression(SrgbGammaToLinear(this)); >;
	CreateInputTexture2D(TexturePatinaAgeMask, Linear, 8, "", "_mask", "Paint Inputs/Pattern/31", "materials/default/default_black_mask.tga");
	float g_flPatinaAgeStart < UiType(Slider); UiGroup("Paint Inputs/Pattern/32"); >;
	float g_flPatinaColorize < Default(1); UiType(Slider); UiGroup("Paint Inputs/Pattern/33"); >;
	float3 g_vColor3 < Default3(0.42, 0.42, 0.42); UiType(Color); UiGroup("Paint Inputs/Colors,0/40"); Expression(SrgbGammaToLinear(this)); >;
	CreateInputTexture2D(TextureGlitterNormal, Linear, 8, "NormalizeNormals", "_normal", "Paint Inputs/Glitter,50", "materials/default/stickers/squares_glitter_normal.tga");
	float g_flColorBrightness < Default(1); Range(1, 100); UiType(Slider); UiGroup("Paint Inputs/Colors,0/50"); >;
	float g_flWearAmount < UiType(Slider); UiGroup("Paint Inputs/60"); >;
	float4 g_vPaintDurability < UiType(VectorText); UiGroup("Paint Inputs/Colors/60"); Expression(1-this); >;
	int g_nColorAdjustmentMode < Default(1); UiOptions("0=Metallic Paint,1==All Paint"); UiType(Enum); UiGroup("Paint Inputs/Colors,0/70"); >;
	
	// Color
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Color/11", Default4(1, 1, 1, 1));
	
	// Lighting
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/11", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/11", Default4(0.5, 0.5, 0.5, 0));
	
	#if (S_PAINT_STYLE == 1)
		Texture2D g_tPattern < Channel(RGBA, None(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	#if (S_PAINT_STYLE == 2)
		Texture2D g_tPattern < Channel(RGBA, None(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(false); >;
		float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneA0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneA1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneB0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneB1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneC0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneC1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	#endif
	#if (S_PAINT_STYLE == 4)
		Texture2D g_tPattern < Channel(RGBA, None(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(false); >;
		float g_flPaintRoughness < Default(0.2); UiType(Slider); UiGroup("Paint Inputs/Lighting/0"); UiVisibility(!F_ROUGHNESS_PER_COLOR); >;
	#endif
	#if (S_PAINT_STYLE == 5)
		Texture2D g_tPattern < Channel(RGBA, None(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(false); >;
		float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneA0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneA1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneB0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneB1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneC0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneC1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float g_flPaintRoughness < Default(0.2); UiType(Slider); UiGroup("Paint Inputs/Lighting/0"); UiVisibility(!F_ROUGHNESS_PER_COLOR); >;
	#endif
	#if (S_USE_ALL_MASKS == 1)
		Texture2D g_tPattern < Channel(RGBA, None(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(false); >;
		float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneA0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneA1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneB0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneB1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneC0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneC1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flWeaponLength1/36)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	#endif
	#if (S_SEPARATE_CHANNEL_INPUTS == 1)
		Texture2D g_tAmbientOcclusion < Channel(R, None(TextureCavity1), Srgb); Channel(G, None(TextureAmbientOcclusion1), Srgb); Channel(A, None(TextureNoPaint1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_CASE_HARDENING_TRILINEAR == 1)
		float4 g_vPatternTexCoordXform0 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXform1 < UiType(VectorText); Expression(v0 = floor((g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneA0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneA1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetA+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneB0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
		float4 g_vPatternTexCoordXformHalftoneB1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetB+g_flPatternTexCoordRotation+.005)*100)/100;
			v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
			v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
			v3 = v0*3.1415927/180;
			v4 = cos(v3);
			v5 = sin(v3);
			v6 = .5/((v1!=0) ? v1 : 1);
			v7 = cos(-v3);
			v8 = sin(-v3);
			v9 = v6*v7-v6*v8;
			v10 = v9*v8+v6*v7;
			float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	#endif
	#if (S_PATINA_AGE == 1)
		Texture2D g_tPattern < Channel(RGBA, None(TexturePattern), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Variant parameters
	float g_flPaintRoughness < Default(0.6); UiType(Slider); UiGroup("Paint Inputs/Lighting/0"); UiVisibility(!F_ROUGHNESS_PER_COLOR); >;
	Texture2D g_tAmbientOcclusion < Channel(RGBA, None(TextureAmbientOcclusion1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	float4 g_vPatternTexCoordXformHalftoneC0 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.x+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v4*v1,-v5*v1,0,v1*v4*v9+v1*-v5*v10+(v2-.5))); >;
	float4 g_vPatternTexCoordXformHalftoneC1 < UiType(VectorText); Expression(v0 = floor((g_flHalftoneRotationOffsetC+g_flPatternTexCoordRotation+.005)*100)/100;
		v1 = floor((g_flPatternTexCoordScale*(g_bIgnoreWeaponSizeScale || g_flUvScale1)+.005)*100)/100;
		v2 = floor((g_vPatternTexCoordOffset.y+.005)*100)/100;
		v3 = v0*3.1415927/180;
		v4 = cos(v3);
		v5 = sin(v3);
		v6 = .5/((v1!=0) ? v1 : 1);
		v7 = cos(-v3);
		v8 = sin(-v3);
		v9 = v6*v7-v6*v8;
		v10 = v9*v8+v6*v7;
		float4(v5*v1,v4*v1,0,v1*v5*v9+v1*v4*v10+(v2-.5))); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 4 (name: g_vColor2) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _2733
	{
	    int bRoughnessMode;
	    float g_fWearSoftness;
	    vec3 g_vColor0;
	    vec3 g_vColor1;
	    vec3 g_vColor2;
	    vec3 g_vColor3;
	    vec4 g_vPaintDurability;
	    float g_flPaintRoughness;
	    int g_bRoughnessPerColor;
	    vec4 g_vPaintRoughness;
	    float g_flPearlescentScale;
	    vec4 g_vPaintMetalness;
	    float g_flWearAmount;
	    vec3 g_vPaintAlbedoLevels;
	    vec3 g_vMetallicPaintAlbedoLevels;
	};
	
	layout(set = 1) uniform _2733 _Globals_;
	
	layout(set = 1, binding = 30) uniform texture2D g_tAmbientOcclusion;
	layout(set = 1, binding = 23) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 31) uniform texture2D g_tMasks;
	layout(set = 1, binding = 38) uniform texture2D g_tWear;
	layout(set = 1, binding = 22) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 39) uniform texture2D g_tGrunge;
	layout(set = 1, binding = 35) uniform texture2D g_tMetalness;
	layout(set = 1, binding = 34) uniform texture2D g_tColor;
	layout(set = 1, binding = 36) uniform texture2D g_tGlitterNormal;
	
	layout(location = 1) in vec4 input_1;
	layout(location = 2) in vec4 input_2;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _18992 = texture(sampler2D(g_tAmbientOcclusion, g_sTrilinearClamp), input_1.xy);
	    float _4306 = _18992.x;
	    vec4 _18993 = texture(sampler2D(g_tMasks, g_sTrilinearClamp), input_1.xy);
	    vec4 _20360 = texture(sampler2D(g_tWear, g_sTrilinearWrap), input_2.xy);
	    float _7656 = _18993.x;
	    float _11437 = _18993.y;
	    float _12425 = _18993.z;
	    float _10779 = mix(mix(mix(_Globals_.g_vPaintDurability.x, _Globals_.g_vPaintDurability.y, _7656), _Globals_.g_vPaintDurability.z, _11437), _Globals_.g_vPaintDurability.w, _12425);
	    float _4693 = _Globals_.g_fWearSoftness * _10779;
	    float _22167 = smoothstep(0.579999983310699462890625 - _4693, 0.680000007152557373046875 + _4693, ((_18992.w + (_20360.x * _4306)) * ((_Globals_.g_flWearAmount * 6.0) + 1.0)) * _10779);
	    vec4 _9437 = texture(sampler2D(g_tGrunge, g_sTrilinearWrap), input_2.zw);
	    vec4 _16529 = mix(vec4(1.0), _9437, vec4((pow(1.0 - _4306, 4.0) * 0.25) + (0.75 * _Globals_.g_flWearAmount)));
	    float _7177 = mix(mix(mix(_Globals_.g_vPaintMetalness.x, _Globals_.g_vPaintMetalness.y, _7656), _Globals_.g_vPaintMetalness.z, _11437), _Globals_.g_vPaintMetalness.w, _12425);
	    vec4 _7078;
	    if (_Globals_.bRoughnessMode != 0)
	    {
	        vec4 _19391 = texture(sampler2D(g_tMetalness, g_sTrilinearClamp), input_1.xy);
	        _19391.x = _19391.x;
	        float _20271;
	        SPIRV_CROSS_BRANCH
	        if (_Globals_.g_bRoughnessPerColor != 0)
	        {
	            _20271 = mix(mix(mix(_Globals_.g_vPaintRoughness.x, _Globals_.g_vPaintRoughness.y, _7656), _Globals_.g_vPaintRoughness.z, _11437), _Globals_.g_vPaintRoughness.w, _12425);
	        }
	        else
	        {
	            _20271 = _Globals_.g_flPaintRoughness;
	        }
	        vec4 _14119 = mix(vec4(min(1.0, _20271 + ((((1.0 - _16529.w) * _Globals_.g_flWearAmount) * _Globals_.g_flWearAmount) * 0.5)), _7177, 0.0, 1.0), _19391, vec4(_22167));
	        float _10938 = 1.0 - _22167;
	        vec4 _13018 = _14119;
	        _13018.z = _10938;
	        vec3 _18043 = _13018.xyz * vec3(0.077399380505084991455078125);
	        vec3 _7676 = pow((_13018.xyz * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	        float _21354;
	        if (_14119.x <= 0.040449999272823333740234375)
	        {
	            _21354 = _18043.x;
	        }
	        else
	        {
	            _21354 = _7676.x;
	        }
	        float _23035;
	        if (_14119.y <= 0.040449999272823333740234375)
	        {
	            _23035 = _18043.y;
	        }
	        else
	        {
	            _23035 = _7676.y;
	        }
	        float _19513;
	        if (_10938 <= 0.040449999272823333740234375)
	        {
	            _19513 = _18043.z;
	        }
	        else
	        {
	            _19513 = _7676.z;
	        }
	        vec4 _17156 = vec4(_21354, _23035, _10938, min(1.0, _Globals_.g_flPearlescentScale));
	        _17156.z = _19513;
	        _7078 = _17156;
	    }
	    else
	    {
	        _7078 = vec4(input_1.xy, 0.0, 1.0);
	    }
	    vec4 _22401;
	    if (_Globals_.bRoughnessMode == 0)
	    {
	        vec3 _13063 = mix(mix(mix(_Globals_.g_vColor0, _Globals_.g_vColor1, vec3(_7656)), _Globals_.g_vColor2, vec3(_11437)), _Globals_.g_vColor3, vec3(_12425));
	        vec3 _21103 = _13063.xyz * _16529.xyz;
	        vec3 _21271 = normalize(max(vec3(0.0003000000142492353916168212890625), _21103.xyz));
	        vec3 _23898 = mix(_Globals_.g_vPaintAlbedoLevels.xyz, _Globals_.g_vMetallicPaintAlbedoLevels.xyz, vec3(_7177));
	        vec3 _25172 = mix(mix(_21103, ((_21271.xyz * mix(min(_23898.x, dot(_13063.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _23898.z, saturate(pow(max(_21103.x, max(_21103.y, _21103.z)), _23898.y)))) / vec3(max(_21271.x, max(_21271.y, _21271.z)))).xyz, vec3(_Globals_.g_flWearAmount)), texture(sampler2D(g_tColor, g_sTrilinearClamp), input_1.xy).xyz, vec3(_22167));
	        _22401 = vec4(_25172, 1.0);
	    }
	    else
	    {
	        _22401 = _7078;
	    }
	    vec4 _3300 = texture(sampler2D(g_tGlitterNormal, g_sTrilinearWrap), input_1.xy);
	    vec4 _6805;
	    if (_3300.w < 0.0)
	    {
	        vec4 _23135 = _22401;
	        _23135.x = _3300.x;
	        _23135.y = _3300.y;
	        _23135.z = _3300.z;
	        _6805 = _23135;
	    }
	    else
	    {
	        _6805 = _22401;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	IntAttribute(MaterialLayerCount, 1);
	StringAttribute(MaterialLayerRefType, csgo_composite_inputs);
	
}
