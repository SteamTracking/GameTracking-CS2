//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Solid/stripes/checkerboard for tools";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
	ToolsUtil();
}

FEATURES
{
	Feature( F_ALPHA_TEST, 0..1, "" );
	Feature( F_PHONG, 0..1, "" );
	Feature( F_UNLIT, 0..1, "" );
	Feature( F_TRANSLUCENT, 0..1, "" );
	Feature( F_NO_ZTEST, 0..1, "" );
	Feature( F_NO_CULLING, 0..1, "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                          
	float4 vColor        : COLOR0         < Semantic( Color ); >;                                 
	float4 vNormalOs     : NORMAL0        < Semantic( Normal ); >;                                
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	DynamicCombo( D_DEPTH_BIAS, 0..1 );
	DynamicCombo( D_SNAP_TO_SCREEN_PIXELS, 0..1 );
	
	bool g_bIgnoreTintAlpha < Attribute("IgnoreTintAlpha"); UiType(CheckBox); >;
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
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    int _Globals_1_g_bIgnoreTintAlpha : packoffset(c0.z);
	};
	
	
	static float4 gl_Position;
	static uint nInstanceIdx;
	static uint4 vBlendIndices;
	static float3 vPositionOs;
	static float3 vNormalOs;
	static float4 vColor;
	static float3 output_0;
	static float4 output_1;
	static float4 output_2;
	static float3 output_3;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float4 vColor : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    uint4 vBlendIndices : TEXCOORD3;
	    uint nInstanceIdx : TEXCOORD4;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    float3 output_3 : TEXCOORD3;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _21785;
	    if (((g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u) == 1u)
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    }
	    float3x4 _9558 = asfloat(uint3x4(g_transformBuffer.Load4(_21785 * 48 + 0), g_transformBuffer.Load4(_21785 * 48 + 16), g_transformBuffer.Load4(_21785 * 48 + 32)));
	    float3 _23051 = mul(_9558, float4(vPositionOs.xyz, 1.0f));
	    float4 _17895 = mul(PerViewConstantBuffer_t_1_m0, (float4(_23051.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float4 _13069 = vColor;
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
	    float _19167;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _19167 = _17828.z;
	    }
	    else
	    {
	        _19167 = _7676.z;
	    }
	    _23812.x = _21354;
	    _23812.y = _21355;
	    _23812.z = _19167;
	    float4 _22247;
	    if (_Globals_1_g_bIgnoreTintAlpha != 0)
	    {
	        float3 _15408 = _13069.xyz * abs(_23812.xyz);
	        float4 _23714 = _13069;
	        _23714.x = _15408.x;
	        _23714.y = _15408.y;
	        _23714.z = _15408.z;
	        _22247 = _23714;
	    }
	    else
	    {
	        _22247 = _13069 * abs(_23812);
	    }
	    output_0 = normalize(mul(_9558, float4(vNormalOs.xyz, 0.0f)));
	    output_1 = _22247;
	    output_2 = _17895;
	    output_3 = _23051;
	    _17895.y = -_17895.y;
	    gl_Position = _17895;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    nInstanceIdx = stage_input.nInstanceIdx;
	    vBlendIndices = stage_input.vBlendIndices;
	    vPositionOs = stage_input.vPositionOs;
	    vNormalOs = stage_input.vNormalOs;
	    vColor = stage_input.vColor;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_PHONG, F_PHONG );
	StaticCombo( S_UNLIT, F_UNLIT );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_NO_ZTEST, F_NO_ZTEST );
	StaticCombo( S_NO_CULLING, F_NO_CULLING );
	DynamicCombo( D_NO_ZTEST, 0..1 );
	
	RenderState(StencilRef, 1);
	float g_flAlphaTestReference < Default(0.3); Range(0.01, 0.99); UiType(Slider); >;
	float g_flPatternType < Attribute("PatternType"); UiType(Slider); >;
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float2 _2;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flPatternType : packoffset(c0.w);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c21);
	};
	
	
	static float4 input_1;
	static float4 input_2;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    bool _11267;
	    do
	    {
	        bool _17421 = _Globals_1_g_flPatternType == 1.0f;
	        float _19321;
	        if (_17421)
	        {
	            _19321 = 6.0f;
	        }
	        else
	        {
	            _19321 = (_Globals_1_g_flPatternType == 2.0f) ? 4.0f : 0.0f;
	        }
	        float _8821 = (input_2.x / input_2.w) / PerViewConstantBuffer_t_1_m0.x;
	        float2 _22624;
	        _22624.x = _8821;
	        float2 _20366;
	        if (_8821 < 0.0f)
	        {
	            float2 _10180 = _22624;
	            _10180.x = (_8821 * (-1.0f)) + _19321;
	            _20366 = _10180;
	        }
	        else
	        {
	            _20366 = _22624;
	        }
	        float _20881 = (input_2.y / input_2.w) / PerViewConstantBuffer_t_1_m0.y;
	        float2 _22625 = _20366;
	        _22625.y = _20881;
	        float2 _12885;
	        if (_20881 < 0.0f)
	        {
	            float2 _10181 = _22625;
	            _10181.y = (_20881 * (-1.0f)) + _19321;
	            _12885 = _10181;
	        }
	        else
	        {
	            _12885 = _22625;
	        }
	        if (_17421)
	        {
	            float2 _9303 = _12885;
	            _9303.y = 0.0f;
	            _11267 = fmod(length(_9303), _19321 * 2.0f) > _19321;
	            break;
	        }
	        else
	        {
	            if (_Globals_1_g_flPatternType == 2.0f)
	            {
	                float _10166 = _19321 * 2.0f;
	                bool _21205 = fmod(_12885.x, _10166) > _19321;
	                bool _15931 = fmod(_12885.y, _10166) > _19321;
	                bool _16648 = _21205 ? _15931 : false;
	                bool _12502;
	                if (!_16648)
	                {
	                    bool _12501;
	                    if (!_21205)
	                    {
	                        _12501 = !_15931;
	                    }
	                    else
	                    {
	                        _12501 = false;
	                    }
	                    _12502 = _12501;
	                }
	                else
	                {
	                    _12502 = _16648;
	                }
	                _11267 = _12502;
	                break;
	            }
	            else
	            {
	                _11267 = false;
	                break;
	            }
	            break; // unreachable workaround
	        }
	        break; // unreachable workaround
	    } while(false);
	    if (_11267)
	    {
	        discard;
	    }
	    output_0 = input_1;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
