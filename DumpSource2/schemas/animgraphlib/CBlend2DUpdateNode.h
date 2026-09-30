// MHasKV3TransferPolymorphicClassname
class CBlend2DUpdateNode : public CAnimUpdateNodeBase
{
	CUtlVector< BlendItem_t > m_items;
	CUtlVector< TagSpan_t > m_tags;
	CParamSpanUpdater m_paramSpans;
	CUtlVector< int32 > m_nodeItemIndices;
	CAnimInputDamping m_damping; // = { "_class": "CAnimInputDamping", "m_fFallingSpeedScale": 1, "m_fSpeedScale": 1, "m_speedFunction": "NoDamping" }
	AnimValueSource m_blendSourceX; // = "MoveHeading"
	CAnimParamHandle m_paramX; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	AnimValueSource m_blendSourceY; // = "MoveHeading"
	CAnimParamHandle m_paramY; // = { "m_index": 255, "m_type": "ANIMPARAM_UNKNOWN" }
	Blend2DMode m_eBlendMode; // = "Blend2DMode_General"
	float32 m_playbackSpeed;
	bool m_bLoop;
	bool m_bLockBlendOnReset;
	bool m_bLockWhenWaning;
	bool m_bAnimEventsAndTagsOnMostWeightedOnly;
};
