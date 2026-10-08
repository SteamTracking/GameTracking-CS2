//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader used by the SFM's CDmeHSLGrainFXClip";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor      : COLOR0     < Semantic( Color ); >;                                       
	float3 vPositionSs : POSITION0  < Semantic( PosXyz ); >;                                      
};

VS
{
	StaticCombo( S_TOOLS_ENABLED, 0, Sys( 1 ) );
	
	float4 g_vViewport < Source(Viewport); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float _3;
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float4 _Globals_1_g_vViewport : packoffset(c0);
	};
	
	
	static float4 gl_Position;
	static float2 vPositionSs;
	static float4 vColor;
	static float4 output_0;
	
	struct VS_INPUT
	{
	    float2 vPositionSs : TEXCOORD0;
	    float4 vColor : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float2 _15639 = (((vPositionSs.xy - _Globals_1_g_vViewport.xy) * 2.0f) / _Globals_1_g_vViewport.zw) - 1.0f.xx;
	    float4 _14779 = float4(_15639.x, _3, 1.0f, 1.0f);
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
	    output_0 = float4(_21354, _21355, _19302, vColor.w);
	    _14779.y = _15639.y;
	    gl_Position = _14779;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    vColor = stage_input.vColor;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(ui, true);
	
}

PS
{
	StaticCombo( S_TOOLS_ENABLED, 0, Sys( 1 ) );
	
	float g_flGrainSize < UiType(Slider); Expression(grainSize); >;
	float g_flHueNoiseScale < UiType(Slider); Expression(huenoisescale); >;
	float g_flSatNoiseScale < UiType(Slider); Expression(satnoisescale); >;
	float g_flTimeOffset < UiType(Slider); Expression(timeOffset); >;
	float g_flValNoiseScale < UiType(Slider); Expression(valnoisescale); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20.z);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flHueNoiseScale : packoffset(c0);
	    float _Globals_1_g_flSatNoiseScale : packoffset(c0.y);
	    float _Globals_1_g_flValNoiseScale : packoffset(c0.z);
	    float _Globals_1_g_flGrainSize : packoffset(c0.w);
	    float _Globals_1_g_flTimeOffset : packoffset(c1);
	};
	
	
	static float4 gl_FragCoord;
	static float4 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD0;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float2 _4935 = (gl_FragCoord.xy + (float2(34567.0f, 43210.0f) * frac(_Globals_1_g_flTimeOffset))) / floor(_Globals_1_g_flGrainSize * max(PerViewConstantBuffer_t_1_m0.x, PerViewConstantBuffer_t_1_m0.y)).xx;
	    float2 _16254 = floor(_4935);
	    float2 _4057 = _4935 - _16254;
	    float2 _5435 = _16254 + 1.0f.xx;
	    float _10196 = _4057.x;
	    float _8572 = lerp(lerp(frac(sin(dot((floor((_16254.xy * 7.0f) + 0.5f.xx) * _Globals_1_g_flGrainSize).xy, float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f), frac(sin(dot((floor((float2(_5435.x, _16254.y) * 7.0f) + 0.5f.xx) * _Globals_1_g_flGrainSize).xy, float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f), _10196), lerp(frac(sin(dot((floor((float2(_16254.x, _5435.y) * 7.0f) + 0.5f.xx) * _Globals_1_g_flGrainSize).xy, float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f), frac(sin(dot((floor((_5435.xy * 7.0f) + 0.5f.xx) * _Globals_1_g_flGrainSize).xy, float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f), _10196), _4057.y) * _Globals_1_g_flValNoiseScale;
	    float3 _22743;
	    if (_Globals_1_g_flSatNoiseScale != 0.0f)
	    {
	        float _12281 = _Globals_1_g_flHueNoiseScale * 6.0f;
	        float _23729 = floor(_12281);
	        float _15688 = _8572 * (1.0f - _Globals_1_g_flSatNoiseScale);
	        float _17993 = _12281 - _23729;
	        float _10560 = _8572 * (1.0f - (_Globals_1_g_flSatNoiseScale * _17993));
	        float _23319 = _8572 * (1.0f - (_Globals_1_g_flSatNoiseScale * (1.0f - _17993)));
	        float3 _12505;
	        if (_23729 == 0.0f)
	        {
	            _12505 = float3(_8572, _23319, _15688);
	        }
	        else
	        {
	            float3 _12504;
	            if (_23729 == 1.0f)
	            {
	                _12504 = float3(_10560, _8572, _15688);
	            }
	            else
	            {
	                float3 _12503;
	                if (_23729 == 2.0f)
	                {
	                    _12503 = float3(_15688, _8572, _23319);
	                }
	                else
	                {
	                    float3 _12502;
	                    if (_23729 == 3.0f)
	                    {
	                        _12502 = float3(_15688, _10560, _8572);
	                    }
	                    else
	                    {
	                        float3 _12501;
	                        if (_23729 == 4.0f)
	                        {
	                            _12501 = float3(_23319, _15688, _8572);
	                        }
	                        else
	                        {
	                            _12501 = float3(_8572, _15688, _10560);
	                        }
	                        _12502 = _12501;
	                    }
	                    _12503 = _12502;
	                }
	                _12504 = _12503;
	            }
	            _12505 = _12504;
	        }
	        _22743 = _12505;
	    }
	    else
	    {
	        _22743 = float3(_Globals_1_g_flHueNoiseScale, _Globals_1_g_flSatNoiseScale, _8572).zzz;
	    }
	    output_0 = float4(input_0.xyz * _22743.xyz, input_0.w);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
