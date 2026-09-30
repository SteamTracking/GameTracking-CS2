// MPropertyFriendlyName = "VMix Shoebox Reverb Node v2"
// MPropertyDescription = "A simple reverb that approximates the reflections of a box-shaped room."
// MHasKV3TransferPolymorphicClassname
class CMixBoxverb2 : public CMixPropertyBase
{
	// MPropertyDescription = "The reverb can be parameterized either by a delay range (min/max delay in milliseconds) OR by a delay size for each dimension of a box (width/height/depth).<br>If you set width, height, or depth to anything other than zero, these min/max fields will not be used."
	// MPropertyFriendlyName = "Max Size (milliseconds)"
	// MPropertyAttributeRange = "0.0 1000.0"
	float32 m_flSizeMax; // = 100
	// MPropertyDescription = "The reverb can be parameterized either by a delay range (min/max delay in milliseconds) OR by a delay size for each dimension of a box (width/height/depth).<br>If you set width, height, or depth to anything other than zero, these min/max fields will not be used."
	// MPropertyFriendlyName = "Min Size (milliseconds)"
	// MPropertyAttributeRange = "0.0 1000.0"
	float32 m_flSizeMin;
	// MPropertyDescription = "The complexity is how many delays are spread along the total delay length.  Max is 12.  More delays will give your space more reflections (more geometric complexity)."
	// MPropertyFriendlyName = "Complexity"
	// MPropertyAttributeRange = "1.01 12.0"
	float32 m_flComplexity; // = 4
	// MPropertyDescription = "This is a percentage of the delay length to modulate. 100 means you will modulate between 0 and the max delay.  10 means the delay will modulate between 90 and 100 percent of max delay."
	// MPropertyFriendlyName = "Mod Depth (milliseconds)"
	// MPropertyAttributeRange = "0.0 100"
	float32 m_flModDepth;
	// MPropertyDescription = "This is the rate at which the delay length changes.  1 means change the delay every delaytime milliseconds.  2 means change the delay after 2*delaytime milliseconds."
	// MPropertyFriendlyName = "Mod Rate (# of delay intervals before mod)"
	// MPropertyAttributeRange = "0.0 10.0"
	float32 m_flModRate;
	// MPropertyDescription = "If true the filter is applied to the signal before output.  If false the filter is applied while feeding back into each delay line."
	// MPropertyFriendlyName = "Parallalelize Filter"
	bool m_bParallel;
	// MPropertyDescription = "Configure the filter to apply to the delay output.  Usually this should be a lowpass filter."
	// MPropertyFriendlyName = "Filter Type"
	// MPropertyGroupName = "Filter"
	VMixFilterDesc_t m_filterType; // = { "m_bEnabled": true, "m_flCutoffFreq": 1000, "m_flQ": 0.707107, "m_fldbGain": 0, "m_nFilterSlope": "FILTER_SLOPE_12dB", "m_nFilterType": "FILTER_LOWPASS" }
	// MPropertyDescription = "If width, height, or depth is set min/max size will be ignored.  These dimensions are the size of the room in milliseconds to first reflection."
	// MPropertyFriendlyName = "Width (milliseconds)"
	// MPropertyAttributeRange = "0 1000.0"
	float32 m_flWidth; // = 20
	// MPropertyDescription = "If width, height, or depth is set min/max size will be ignored.  These dimensions are the size of the room in milliseconds to first reflection."
	// MPropertyFriendlyName = "Height (milliseconds)"
	// MPropertyAttributeRange = "0 1000.0"
	float32 m_flHeight; // = 23
	// MPropertyDescription = "If width, height, or depth is set min/max size will be ignored.  These dimensions are the size of the room in milliseconds to first reflection."
	// MPropertyFriendlyName = "Depth (milliseconds)"
	// MPropertyAttributeRange = "0 1000.0"
	float32 m_flDepth; // = 27
	// MPropertyDescription = "How much of the signal to send to the delay lines.  How loud the reflections are."
	// MPropertyFriendlyName = "Feedback Scale"
	// MPropertyAttributeRange = "0 1"
	float32 m_flFeedbackScale; // = 0.15
	// MPropertyDescription = "Additional amp on the width dimension reflections.  Note negative numbers mean this feedback bypasses the filter (predelay)."
	// MPropertyFriendlyName = "Width Reflectivity"
	// MPropertyAttributeRange = "-1.0 1.0"
	float32 m_flFeedbackWidth;
	// MPropertyDescription = "Additional amp on the height dimension reflections.  Note negative numbers mean this feedback bypasses the filter (predelay)."
	// MPropertyFriendlyName = "Height Reflectivity"
	// MPropertyAttributeRange = "-1.0 1.0"
	float32 m_flFeedbackHeight;
	// MPropertyDescription = "Additional amp on the depth dimension reflections.  Note negative numbers mean this feedback bypasses the filter (predelay)."
	// MPropertyFriendlyName = "Depth  Reflectivity"
	// MPropertyAttributeRange = "-1.0 1.0"
	float32 m_flFeedbackDepth;
	// MPropertyFriendlyName = "Dry/Wet"
	float32 m_flWetMix;
	// MPropertyDescription = "Amplification at output in dB for tuning, applied after Wet/Dry mix"
	// MPropertyFriendlyName = "Output Gain (dB)"
	// MPropertyAttributeRange = "-24.0 -0.1"
	float32 m_flOutputGain;
	// MPropertyDescription = "If zero there are no extra taps.  If non-zero there will be 3 extra taps and this value will adjust their relative phase."
	// MPropertyFriendlyName = "Extra Tap Scale"
	// MPropertyAttributeRange = "0 0.333"
	float32 m_flTaps;
};
