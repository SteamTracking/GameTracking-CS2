//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Simple shader to use as a starting point for writing new shaders";
	DevShader = true;
	Version = 0;
	
	// Platform: VULKAN_SM_50
	// Programs: gs, ps, vs
}

MODES
{
	Default();
	Depth(S_MODE_DEPTH);
	CsgoForward(S_VERY_SIMPLE_LIGHTING);
	DotaForward(S_VERY_SIMPLE_LIGHTING);
	Forward(S_VERY_SIMPLE_LIGHTING);
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
	ToolsVis(S_VERY_SIMPLE_LIGHTING);
}

FEATURES
{
	Feature( F_VERTEX_COLORS, 0..1, "" );
	Feature( F_DISABLE_DEPTHTEST, 0..1, "" );
	Feature( F_TRIANGLE_EDGES, 0..1, "" );
	Feature( F_WIREFRAME, 0..1, "" );
	Feature( F_TRANSLUCENT, 0..1, "" );
	FeatureRule( Allow1( F_TRIANGLE_EDGES, F_WIREFRAME ), "Triangle edges and wireframe a mutually exclusive." );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vColor       : COLOR0     < Semantic( Color ); >;                                       // S_VERTEX_COLORS=1
	float3 vPositionOs  : POSITION0  < Semantic( PosXyz ); >;                                     
	float2 nInstanceIdx : TEXCOORD13 < Semantic( InstanceTransformUv ); >;                        
};

VS
{
	StaticCombo( S_VERTEX_COLORS, F_VERTEX_COLORS );
	
	// Color
	float g_flAlpha < Default(1); UiType(Slider); UiGroup("Color"); >;
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color"); >;
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	[[layer_constant]] StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// WireframeEmit
	float3 g_vWireframeEmit < UiType(Color); UiGroup("WireframeEmit"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 1 (name: g_vWireframeEmit) cannot be expressed with either HLSL packing layout or packoffset.
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
	
	struct _1075
	{
	    vec3 g_vColorTint;
	    vec3 g_vWireframeEmit;
	    float g_flAlpha;
	};
	
	layout(set = 0) uniform _1075 _Globals_;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1119 _m0[];
	} g_transformBuffer_1;
	
	layout(location = 1) in uint nInstanceIdx;
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec3 output_2;
	
	void main()
	{
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
	    float _19302;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _19302 = _17828.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    float _25150 = _23812.w;
	    vec3 _22743;
	    if (((g_instanceBuffer_1._m0[nInstanceIdx]._m5 >> uint(16)) & 15u) > 0u)
	    {
	        _22743 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0[0].z);
	    }
	    else
	    {
	        _22743 = vec3(1.0);
	    }
	    output_0 = vec4(vPositionOs.xyz * _22743.xyz, 1.0) * g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0;
	    output_1 = vec4(vec4(_21354, _21355, _19302, _25150).xyz * _Globals_.g_vColorTint.xyz, _25150 * _Globals_.g_flAlpha);
	    output_2 = _Globals_.g_vWireframeEmit;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

GS
{
	
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported shader stage.
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
	layout(triangles) in;
	layout(max_vertices = 3, triangle_strip) out;
	
	struct _1224
	{
	    mat4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 2) uniform _1224 PerViewConstantBuffer_t;
	
	layout(location = 0) in vec3 input_0[3];
	layout(location = 1) in vec4 input_1[3];
	layout(location = 2) in vec3 input_2[3];
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) out vec3 output_3;
	
	void main()
	{
	    vec3 _15752 = normalize(cross(input_0[1] - input_0[0], input_0[2] - input_0[0]));
	    int _7155;
	    int _13039 = 0;
	    SPIRV_CROSS_UNROLL
	    for (;;)
	    {
	        if (!(_13039 < 3))
	        {
	            break;
	        }
	        vec4 _17895 = (vec4(input_0[_13039].xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	        output_0 = _15752;
	        output_1 = input_0[_13039];
	        output_2 = input_1[_13039];
	        output_3 = input_2[_13039];
	        _17895.y = -_17895.y;
	        gl_Position = _17895;
	        EmitVertex();
	        _7155 = _13039 + 1;
	        _13039 = _7155;
	        continue;
	    }
	    EndPrimitive();
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_WIREFRAME, F_WIREFRAME );
	StaticCombo( S_TRIANGLE_EDGES, F_TRIANGLE_EDGES );
	StaticCombo( S_DISABLE_DEPTHTEST, F_DISABLE_DEPTHTEST );
	StaticCombo( S_VERY_SIMPLE_LIGHTING, 0..1 );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticComboRule( Allow1( S_TRANSLUCENT, S_MODE_TOOLS_WIREFRAME, S_MODE_DEPTH ) );
	StaticComboRule( Allow1( S_TRIANGLE_EDGES, S_WIREFRAME ) );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	
	RenderState(BlendEnable, F_TRANSLUCENT ? true : false);
	RenderState(ColorWriteEnable0, R|G|B);
	RenderState(DepthFunc, F_DISABLE_DEPTHTEST ? Always : LessEqual);
	RenderState(DepthWriteEnable, F_TRANSLUCENT ? false : true);
	[[layer_constant]] ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	[[layer_constant]] ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	
	// IsSelected
	float g_flIsSelected < Attribute("IsSelected"); UiType(Slider); UiGroup("IsSelected"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source, HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _3;
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float PerViewConstantBuffer_t_1_m0 : packoffset(c18);
	    float3 PerViewConstantBuffer_t_1_m1 : packoffset(c26);
	    float3 PerViewConstantBuffer_t_1_m2 : packoffset(c31);
	    float PerViewConstantBuffer_t_1_m3 : packoffset(c31.w);
	    float PerViewConstantBuffer_t_1_m4 : packoffset(c32);
	    float PerViewConstantBuffer_t_1_m5 : packoffset(c32.y);
	    float PerViewConstantBuffer_t_1_m6 : packoffset(c32.z);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flIsSelected : packoffset(c0.y);
	};
	
	
	static float4 gl_FragCoord;
	static float4 input_2;
	static float3 input_0;
	static float3 input_1;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _21122 = ((saturate(dot(normalize(1.0f.xxx).xyz, normalize(input_0.xyz).xyz)) * 0.89999997615814208984375f).xxx + 0.100000001490116119384765625f.xxx).xyz * input_2.xyz;
	    float4 _23714;
	    _23714.x = _21122.x;
	    _23714.y = _21122.y;
	    _23714.z = _21122.z;
	    float3 _19800 = lerp(_23714.xyz, PerViewConstantBuffer_t_1_m2.xyz, saturate(min(PerViewConstantBuffer_t_1_m5, pow(saturate((distance(input_1.xyz, PerViewConstantBuffer_t_1_m1.xyz) * PerViewConstantBuffer_t_1_m4) + PerViewConstantBuffer_t_1_m3), PerViewConstantBuffer_t_1_m6))).xxx);
	    float4 _17842;
	    _17842.x = _19800.x;
	    _17842.y = _19800.y;
	    _17842.z = _19800.z;
	    float4 _17971 = float4(_17842.xyz * PerViewConstantBuffer_t_1_m0, input_2.w);
	    float4 _6805;
	    do
	    {
	        if (_Globals_1_g_flIsSelected > 0.03125f)
	        {
	            if (fmod((gl_FragCoord.x - 0.5f) + float(int(fmod(gl_FragCoord.y - 0.5f, 2.0f))), 2.0f) < 1.0f)
	            {
	                float _15961 = _Globals_1_g_flIsSelected * 0.5f;
	                _6805 = (float4(1.0f, 1.0f, 0.75f, 1.0f) * _15961) + (_17971 * (1.0f - _15961));
	                break;
	            }
	        }
	        _6805 = _17971;
	        break;
	    } while(false);
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_2 = stage_input.input_2;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(translucent, F_TRANSLUCENT ? 1 : 0);
	
}
